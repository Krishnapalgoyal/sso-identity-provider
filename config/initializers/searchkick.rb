# config/initializers/searchkick.rb

Searchkick.client = Elasticsearch::Client.new(
  url: ENV.fetch('ELASTICSEARCH_URL', 'http://localhost:9200'),
  retry_on_failure: true,
  transport_options: {
    request: { timeout: 250 }
  }
)