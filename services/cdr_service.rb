require 'axlsx'
class CdrService
  attr_accessor :limit, :offset, :conditions
  def initialize
    Cdr.connection
  end
  def as_json
    cdr_data.as_json
  end
  def to_json
    cdr_data.to_json
  end
  def to_xlsx
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(nome: "Asterisk CDR Report") do |sheet|
      sheet.add_row ['Call Date', 'Source', 'Destination', 'Duration', 'Bill Duration', 'Disposition']
      cdr_data.each{|data|
        sheet.add_row [data.calldate, data.src, data.dst, data.duration, data.billsec, data.disposition]
      }
    end
    p.to_stream.read
  end
  def total_count
    cdr = Cdr
    cdr = cdr.where(conditions) if conditions.present? && conditions[0].present?
    cdr.count
  end
  def prepare_conditions(params)
    #Fix this setting your asterisk to record UTC instead of local time
    Time.zone = 'UTC'
    self.limit = params[:limit]
    self.offset = params[:offset]
    self.conditions = ['1 = 1'];
    if params[:start_date].present?
      self.conditions[0] << " and calldate >= ? "
      #Fix this by setting your asterisk to record UTC instead of local time
      #A quick fix used to make ActiveRecord convert Local Time in UTC giving the same hour
      start_date = Time.parse(params[:start_date])
      start_date = Time.zone.parse(start_date.strftime("%Y-%m-%d %H:%M"))
      self.conditions.push start_date.beginning_of_day
    end
    if params[:end_date].present?
      self.conditions[0] << " and calldate <= ? "
      #Fix this by setting your asterisk to record UTC instead of local time
      #A quick fix used to make ActiveRecord convert Local Time in UTC giving the same hour
      end_date = Time.parse(params[:end_date])
      end_date = Time.zone.parse(end_date.strftime("%Y-%m-%d %H:%M"))
      self.conditions.push end_date.end_of_day
    end
    if params[:src].present?
      self.conditions[0] << " and src like ? "
      self.conditions.push "%#{params[:src]}%"
    end
    if params[:dst].present?
      self.conditions[0] << " and dst like ? "
      self.conditions.push "%#{params[:dst]}%"
    end
  end
  private
  def cdr_data
    cdr = Cdr.all.order(calldate: :desc)
    cdr = cdr.limit(limit) if limit.present?
    cdr = cdr.offset(offset) if offset.present?
    cdr = cdr.where(conditions) if conditions.present? && conditions[0].present?
    cdr
  end
end
