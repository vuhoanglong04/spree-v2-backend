class StripeService
  def self.sync_variant_to_stripe(variant)
    name = "#{variant.name}"
    if variant.attribute_values.pluck(:value)
      name = "#{name} - #{variant.attribute_values.pluck(:value).join('/')}"
    end

    if variant.stripe_product_id.present? && variant.stripe_price_id.present?
      Stripe::Product.update(
        variant.stripe_product_id,
        {
          name: name,
          description: variant.product.description
        }
      )
    else
      create_stripe_product(variant)
    end
  rescue StandardError => e
    Rails.logger.error("Stripe sync failed for Variant##{variant.id}: #{e.message}")
  end

  def self.create_stripe_product(variant)
    name = "#{variant.name}"
    if variant.attribute_values.pluck(:value)
      name = "#{name} - #{variant.attribute_values.pluck(:value).join('/')}"
    end

    stripe_product = Stripe::Product.create(
      name: name,
      description: variant.product.description,
      metadata: {
        product_id: variant.product.id,
        variant_id: variant.id
      }
    )
    stripe_price = Stripe::Price.create(
      unit_amount: (variant.price * 100).to_i,
      currency: "usd",
      product: stripe_product.id
    )
    variant.update_columns(
      stripe_product_id: stripe_product.id,
      stripe_price_id: stripe_price.id
    )
  end
end
