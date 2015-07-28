require 'active_support/core_ext/module/delegation'
require 'influxdb/metrics/event/controller'
require 'influxdb/metrics/event/model'

module InfluxDB
  module Metrics
    class Configuration
      EVENTS = {
        action_controller: Event::Controller,
        active_record: Event::Model
      }

      attr_accessor :hosts
      attr_accessor :username
      attr_accessor :password
      attr_accessor :database
      attr_accessor :app_name
      attr_accessor :port
      attr_accessor :debug
      attr_accessor :async

      attr_writer :client

      attr_reader :logger
      attr_reader :events
      attr_reader :subscribed

      def initialize
        @hosts      = []
        @app_name   = 'rails'
        @username   = 'root'
        @password   = 'root'
        @database   = 'rails'
        @port       = 8086
        @async      = true
        @debug      = false
        @events     = EVENTS.values
        @subscribed = []
      end

      def host=(value)
        hosts << value
      end

      # Configure specific subscriptions
      def events=(names)
        @events = [*names].map do |name|
          EVENTS.fetch(name)
        end
      end

      def subscribe
        @subscribed = events.map do |event|
          event.new.tap(&:subscribe)
        end
      end

      def client
        @client ||= InfluxDB::Client.new(database,
          hosts: hosts,
          username: username,
          password: password,
          port: port,
          async: async,
          debug: debug
        )
      end

      def logger=(value)
        InfluxDB::Logging.logger = value if debug
        @logger = value
      end
    end
  end
end
