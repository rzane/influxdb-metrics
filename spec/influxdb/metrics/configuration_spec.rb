require_relative '../../spec_helper'

module InfluxDB::Metrics
  describe Configuration do
    def self.its_default(meth, &block)
      describe "##{meth}" do
        it 'has a reasonable default' do
          subject.send(meth).instance_eval(&block)
        end
      end
    end

    subject {
      Configuration.new
    }

    its_default(:app_name) { must_equal 'rails' }
    its_default(:username) { must_equal 'root' }
    its_default(:password) { must_equal 'root' }
    its_default(:database) { must_equal 'rails' }
    its_default(:port)     { must_equal 8086 }
    its_default(:async)    { must_equal true }
    its_default(:debug)    { must_equal false }

    its_default(:events) do
      must_equal Configuration::EVENTS.values
    end

    describe '#hosts' do
      it 'is empty by default' do
        subject.hosts.must_equal []
      end

      it 'includes host' do
        subject.host = 'example.com'
        subject.hosts.must_equal ['example.com']
      end

      it 'merges host and hosts' do
        both_hosts = ['example.com', 'example2.com']
        subject.host = 'example.com'
        subject.hosts = both_hosts
        subject.hosts.must_equal both_hosts
      end
    end

    describe '#events=' do
      it 'accepts a symbol' do
        subject.events = :active_record
        subject.events.must_equal [Event::Model]
      end

      it 'accepts an array' do
        subject.events = :active_record, :action_controller
        subject.events.must_equal [Event::Model, Event::Controller]
      end

      it 'raises error for invalid event' do
        -> { subject.events = :blah }.must_raise KeyError
      end
    end

    describe '#subscribe' do
      before do
        subject.events = :action_controller
      end

      it 'returns subscribed' do
        subject.subscribe.must_equal subject.subscribed
      end

      it 'assigns subscribed' do
        subject.subscribe
        subject.subscribed.first.must_be_instance_of Event::Controller
      end
    end
  end
end
