require 'rack/cache'
require './application'
use Rack::Cache
run Application