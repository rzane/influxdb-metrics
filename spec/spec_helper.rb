require 'simplecov'

SimpleCov.start { add_filter 'spec' }

require 'influxdb/metrics'
require 'minitest/spec'
require 'minitest/autorun'

InfluxDB::Metrics.configure do |config|
  config.logger = Logger.new(STDOUT)
end

module InfluxDB::Metrics
  class TestClient
    attr_reader :points

    Point = Struct.new(:series, :data)

    def write_point(series, data = {})
      (@points ||= []) << Point.new(series, data)
    end
  end

  module EventHelpers
    def before_setup
      InfluxDB::Metrics.configure { |c| c.client = client }
      super
    end

    def channel
      subject.subscribe_to
    end

    def client
      @client ||= InfluxDB::Metrics::TestClient.new
    end
    delegate :points, to: :client

    def instrument(*args, &block)
      ActiveSupport::Notifications.instrument(*args, &block)
    end
  end
end
