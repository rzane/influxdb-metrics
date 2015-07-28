require 'active_support/notifications'

module InfluxDB
  module Metrics
    module Event
      class Base
        def subscribe
          ActiveSupport::Notifications.subscribe(subscribe_to) do |*args|
            handle(*args)
          end
        end

        def subscribe_to
          fail NotImplementedError, 'Must implement #subscribe_to'
        end

        def handle(name, id, start, finish, payload)
          fail NotImplementedError, 'Must implment #handle'
        end

        private

        delegate :config, to: InfluxDB::Metrics
        delegate :client, :logger, to: :config

        def write_point(name, data = {})
          client.write_point("#{config.app_name}.#{name}", data)
        rescue => e
          log :debug, "Unable to write point: #{e.message}"
        end

        def log(level, message)
          logger.send(level, '[InfluxDB::Metrics] ' + message) if logger
        end

        def duration(start, finish)
          ((finish - start) * 1000).ceil
        end
      end
    end
  end
end
