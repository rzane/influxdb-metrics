require 'socket'
require 'influxdb/metrics/event'

module InfluxDB
  module Metrics
    class Controller < Event
      def subscribe_to
        'process_action.action_controller'
      end

      def handle(_name, start, finish, _id, payload)
        write_point 'controller', info(start, finish, payload)
      rescue => e
        log :debug, "Unable to process action: #{e.message}"
      end

      private

      def info(start, finish, payload)
        {
          hostname: Socket.gethostname,
          action: "#{payload[:controller]}##{payload[:action]}",
          format: request_format(payload[:format]),
          status: payload[:status],
          duration: duration(start, finish),
          view: (payload[:view_runtime] || 0).ceil,
          db: (payload[:db_runtime] || 0).ceil
        }
      end

      def request_format(fmt)
        (fmt.nil? || fmt == '*/*') ? 'all' : fmt
      end
    end
  end
end
