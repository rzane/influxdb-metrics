require 'socket'
require 'influxdb/metrics/event'

module InfluxDB
  module Metrics
    class Controller < Event
      def subscribe_to
        'process_action.action_controller'
      end

      def handle(_name, start, finish, _id, payload)
        metric = shared_info(start, finish, payload)
        timing = duration(start, finish)

        view = (payload[:view_runtime] || 0).ceil
        db =  (payload[:db_runtime] || 0).ceil

        write_point 'controller', metric.merge(value: timing)
        write_point 'view', metric.merge(value: view)
        write_point 'db', metric.merge(value: db)
      rescue => e
        log :debug, "Unable to process action: #{e.message}"
      end

      private

      def shared_info(start, finish, payload)
        {
          hostname: Socket.gethostname,
          action: "#{payload[:controller]}##{payload[:action]}",
          format: request_format(payload[:format]),
          status: payload[:status]
        }
      end

      def request_format(fmt)
        (fmt.nil? || fmt == '*/*') ? 'all' : fmt
      end
    end
  end
end
