if defined?(Elasticsearch)
  $elasticsearch = Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
end