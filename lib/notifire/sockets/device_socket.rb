module Notifire
  module Sockets
    class DeviceSocket < Socket
      def type value
        @type = value
        $redis.hset 'device:status', true if type == 'device'
      end

      def self.manage request
        request.websocket do |ws|
          handle = DeviceSocket.new ws
          ws.onopen do
            Notifire::Server.settings.sockets << handle
          end
          ws.onmessage do |msg|
            if msg == 'identify'
              puts "Device connected!"
              $redis.hset 'device:status', 'foo', true
              broadcast 'device_connected', :filter => lambda { |o| o.is_a? WebSocket }
            end
          end
          ws.onclose do
            puts "Device disconnetected!"
            $redis.hset 'device:status', 'foo', false
            broadcast 'device_disconnected', :filter => lambda { |o| o.is_a? WebSocket }
            Notifire::Server.settings.sockets.delete handle
          end
        end
      end
    end
  end
end