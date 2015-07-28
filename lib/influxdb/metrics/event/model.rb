require 'influxdb/metrics/event/base'

module InfluxDB
  module Metrics
    module Event
      class Model < Base
        SELECT_DELETE = / FROM "(\w+)"/i
        INSERT = /^INSERT INTO "(\w+)"/i
        UPDATE = /^UPDATE "(\w+)"/i

        def subscribe_to
          'sql.active_record'
        end

        def handle(_name, start, finish, _id, payload)
          metric = info(start, finish, payload)
          write_point 'sql', metric if metric
        rescue => e
          log :debug, "Unable to process sql: #{e.message}"
        end

        private

        def info(start, finish, payload)
          action, table = extract(payload[:sql])
          return if action.nil? || table.nil?

          {
            action: action,
            table: (table && table.downcase),
            duration: duration(start, finish)
          }
        end

        def extract(sql)
          case sql
          when /^SELECT/i then ['select', sql[SELECT_DELETE, 1]]
          when /^INSERT/i then ['insert', sql[INSERT, 1]]
          when /^UPDATE/i then ['update', sql[UPDATE, 1]]
          when /^DELETE/i then ['delete', sql[SELECT_DELETE, 1]]
          end
        end
      end
    end
  end
end
