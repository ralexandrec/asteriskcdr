require 'active_support/core_ext/time'
class Cdr < ActiveRecord::Base
  self.table_name = "bit_cdr"
  def calldate
  	self[:calldate].strftime("%d/%m/%Y %H:%M:%S")
  end
  def duration
  	Time.at(self[:duration]).utc.strftime("%H:%M:%S")
  end
end