require 'bundler'
Bundler.require

$redis = Redis.new
require './lib/notifire/server.rb'
Notifire::Server.set :views, File.expand_path('../views', __FILE__)