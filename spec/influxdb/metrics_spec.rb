require_relative '../spec_helper'

module InfluxDB
  describe Metrics do
    describe 'config' do
      it 'is a Configuration' do
        Metrics.config.must_be_instance_of Metrics::Configuration
      end
    end

    describe 'configure' do
      it 'yields Configuration' do
        Metrics.configure do |config|
          config.must_be_instance_of Metrics::Configuration
        end
      end
    end
  end
end
