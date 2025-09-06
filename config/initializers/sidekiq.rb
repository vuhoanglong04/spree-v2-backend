Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
  Sidekiq::Cron::Job.create(
    name: 'Sync Product Variants With Stripe',
    cron: '0 0 /3 * *',
    class: 'UpdateProductToStripeJob',
    queue: 'default'
  )
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
end
