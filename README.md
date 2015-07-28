# Influxdb::Metrics

This gem adds allow your Rails app to report performance metrics for database queries and response times to InfluxDB.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'influxdb-metrics'
```

If you're using the 8.x line of InfluxDB, you'll need this line as well:

```ruby
gem 'influxdb', '~> 0.1.9'
```

And then execute:

    $ bundle

## Motivation

[InfluxDB::Rails](https://github.com/influxdb/influxdb-rails) is a really great project. It allows tracking controller metrics right out of the box. It also includes exception tracking, which is really great if you don't have it setup yet. I use a different service to do exception tracking, so I just want to use InfluxDB for performance metrics.

Also, I wanted to be able to track SQL query performance. That's included.

## Usage

```ruby
InfluxDB::Metrics.configure do |config|
  config.host = 'example.com'
  # or
  config.hosts = ['example1.com', 'example2.com']

  # The following values are defaults:

  # config.app_name = 'rails'
  # config.username = 'root'
  # config.password = 'root'
  # config.database = 'rails'
  # config.port = 8086

  # You can customize which stats get recorded:
  # config.events = :action_controller, :active_record
end
```

## Contributing

1. Fork it ( https://github.com/rzane/influxdb-metrics/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
