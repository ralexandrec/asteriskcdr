require 'pry'
require 'sinatra/activerecord'
require 'sinatra/config_file'
require "sinatra/streaming"
Dir.glob('./{models,services}/*.rb').each { |file| require file }
class Application < Sinatra::Base
  register Sinatra::ConfigFile
  config_file './config/config.yml'
  set :database_file, 'config/database.yml'
  set :public_folder, 'public'
  TOKEN=settings.token
  DATA_URL=settings.data_url

  include AppLogger
  
  before do
    cache_control :public, :must_revalidate, :max_age => 60
  end

  cdr_service = CdrService.new
  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end
    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [settings.credentials[:user], settings.credentials[:password]]
    end
  end

  get '/data' do
    #Enable external access if you want to use it in Ionic for instance
    #headers 'Access-Control-Allow-Origin'=>'*'
    if params[:token] == TOKEN
      cdr_service.prepare_conditions(params)
      content_type :json
      {data: cdr_service.as_json, total_count: cdr_service.total_count.to_i}.to_json
    end
  end

  get '/data/xlsx' do
    protected!
    cdr_service.prepare_conditions(params)
    content_type 'application/octet-stream'
    attachment("asterisk_cdr_report_#{Time.zone.now.strftime('%d_%m_%Y')}.xlsx")
    cdr_service.to_xlsx
  end

  get '/' do
    protected!
    erb :cdr
  end

end
