class UpdateProductToStripeJob < ApplicationJob
  queue_as :default

  def perform
    ProductVariant.find_in_batches(batch_size: 500) do |variants|
      variants.each do |variant|
        StripeService.sync_variant_to_stripe(variant)
      end
    end
  end
end
