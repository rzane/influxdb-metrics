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
        client.points.last.wont_be_nil
      end
    end

    describe '#handle' do
      before do
        id, now = 'fa8bd2a588bac4060673', Time.now
        subject.handle channel, now - 0.7, now, id, payload

        @controller, @view, @db = points.last(3)
      end

      it 'writes three points' do
        points.length.must_equal 3
      end

      it 'names the controller series correctly' do
        @controller.series.must_equal 'rails.controller'
      end

      it 'names the view series correctly' do
        @view.series.must_equal 'rails.view'
      end

      it 'names the db series correctly' do
        @db.series.must_equal 'rails.db'
      end

      it 'tracks the action' do
        @controller.data[:action].must_equal 'UsersController#index'
      end

      it 'tracks the request format' do
        @controller.data[:format].must_equal 'html'
      end

      it 'tracks the status' do
        @controller.data[:status].must_equal 200
      end

      it 'tracks the request duration' do
        @controller.data[:value].must_equal 700
      end

      it 'tracks the db runtime' do
        @db.data[:value].must_equal 233
      end

      it 'tracks the view runtime' do
        @view.data[:value].must_equal 435
      end
    end
  end
end
