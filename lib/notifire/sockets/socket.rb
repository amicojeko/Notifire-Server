module Notifire
  module Sockets
    class Socket
      attr_reader :ws

      def initialize ws
        @ws = ws
      end

      def sockets
        self.class.sockets
      end

      def self.sockets
        Notifire::Server.settings.sockets
      end

      def send msg
        ws.send msg
      end

      def self.broadcast event, args = {}
        recipients = sockets
        if args[:filter]
          recipients = recipients.select &args[:filter]
        end
        EM.next_tick { recipients.each { |s| s.send event } }
      end

      def broadcast event, args = {}
        self.class.broadcast event, args
      end
    end
  end
end