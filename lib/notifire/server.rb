%w(socket web_socket device_socket).each do |file|
  require_relative "sockets/#{file}"
end

module Notifire
  class Server < Sinatra::Base
    set :sockets, []

    get '/' do
      if request.websocket?
        Sockets::WebSocket.manage request
      else
        haml :index
      end
    end

    get '/device' do
      if request.websocket?
        Sockets::DeviceSocket.manage request
      else
        status 404
      end
    end
  end
end