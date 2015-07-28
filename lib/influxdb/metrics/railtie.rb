module InfluxDB
  module Metrics
    class Railtie < Rails::Railtie
      config.after_initialize do
        InfluxDB::Metrics.configure do |config|
          config.logger ||= Rails.logger
        end

        InfluxDB::Metrics.subscribe
      end
    end
  end
end
