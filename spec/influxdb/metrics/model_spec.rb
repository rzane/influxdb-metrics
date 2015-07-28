require_relative '../../spec_helper'

module InfluxDB::Metrics
  describe Model do
    include EventHelpers

    subject {
      Model.new
    }

    let(:payload) {
      { sql: 'SELECT "dogs"."*" FROM "dogs"' }
    }

    describe '#subscribe' do
      it 'subscribes to ActiveSupport::Notifications' do
        subject.subscribe
        instrument channel, payload
        last_point.wont_be_nil
      end
    end

    describe '#handle' do
      before do
        id, now  = 'fa8bd2a588bac4060673', Time.now
        subject.handle channel, now - 0.4, now, id, payload
      end

      it 'names the series correctly' do
        last_point.series.must_equal 'rails.sql'
      end

      it 'tracks table name' do
        last_point.data[:table].must_equal 'dogs'
      end

      it 'tracks sql action' do
        last_point.data[:action].must_equal 'select'
      end

      it 'tracks the duration' do
        last_point.data[:duration].must_equal 400
      end
    end

    # TODO: Don't test a private method
    describe '#extract' do
      def self.it_extracts(action, sql, table = 'dogs')
        it "parses table name for #{action}" do
          parsed = subject.send(:extract, sql)
          parsed.first.must_equal(action.to_s)
          parsed.last.downcase.must_equal(table)
        end
      end

      it_extracts :select, %{SELECT "dogs"."*" FROM "dogs"}
      it_extracts :select, %{SELECT * FROM "DOGS" WHERE "dogs"."name" = 'Fido'}

      it_extracts :insert, %{INSERT INTO "dogs" ("id", "name") VALUES (1, 'Fido')}
      it_extracts :update, %{UPDATE "dogs" SET "name" = 'Fido'}
      it_extracts :delete, %{DELETE FROM "dogs" WHERE "id" > 0}
    end
  end
end
