require 'influxdb'
require 'influxdb/metrics/version'
require 'influxdb/metrics/configuration'
require 'influxdb/metrics/railtie' if defined?(Rails)

module InfluxDB
  module Metrics
    class << self
      def config
        @config ||= Configuration.new
      end
      delegate :client, :subscribe, to: :config

      def configure
        yield config
      end
    end
  end
end
