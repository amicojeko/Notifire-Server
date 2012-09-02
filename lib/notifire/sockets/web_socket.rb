module Notifire
  module Sockets
    class WebSocket < Socket
      def type value
        @type = value
        $redis.hset 'device:status', true if type == 'device'
      end

      def self.manage request
        request.websocket do |ws|
          handle = WebSocket.new ws
          ws.onopen do
            Notifire::Server.sockets << handle
          end
          ws.onclose do
            Notifire::Server.sockets.delete handle
          end
        end
      end
    end
  end
end