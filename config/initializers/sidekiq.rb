if defined?(Sidekiq)
Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"] }
  Sidekiq::Cron::Job.create(
    name: 'Sync Product Variants With Stripe',
    cron: '0 0 /3 * *',
    class: 'UpdateProductToStripeJob',
    queue: 'default'
  )
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"]  }
end
end
