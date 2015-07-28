require_relative '../../spec_helper'

module InfluxDB::Metrics
  describe Controller do
    include EventHelpers

    subject {
      Controller.new
    }

    let(:payload) {
      {
        controller: 'UsersController',
        action: 'index',
        format: 'html',
        status: 200,
        db_runtime: 232.232,
        view_runtime: 434.23
      }
    }

    describe '#subscribe' do
      it 'subscribes to ActiveSupport::Notifications' do
        subject.subscribe
        instrument channel, payload
        client.last_point.wont_be_nil
      end
    end

    describe '#handle' do
      before do
        id, now = 'fa8bd2a588bac4060673', Time.now
        subject.handle channel, now - 0.7, now, id, payload
      end

      it 'names the series correctly' do
        last_point.series.must_equal 'rails.controller'
      end

      it 'tracks the action' do
        last_point.data[:action].must_equal 'UsersController#index'
      end

      it 'tracks the request duration' do
        last_point.data[:duration].must_equal 700
      end

      it 'tracks the request format' do
        last_point.data[:format].must_equal 'html'
      end

      it 'tracks the status' do
        last_point.data[:status].must_equal 200
      end

      it 'tracks the db runtime' do
        last_point.data[:db].must_equal 233
      end

      it 'tracks the view runtime' do
        last_point.data[:view].must_equal 435
      end
    end
  end
end
