# db/seeds.rb
require "faker"
puts "Clearing data..."

# Xóa bảng liên quan (tránh vi phạm FK)
RolePermission.delete_all
UserRole.delete_all
Permission.delete_all
AccountUser.delete_all
Role.delete_all

ProductImage.delete_all
ProductVariantAttrValue.delete_all
ProductVariant.delete_all
Product.delete_all
Category.delete_all
AttributeValue.delete_all
Attribute.delete_all
Promotion.delete_all
OrderItem.delete_all
Order.delete_all
Payment.delete_all

puts "Seeding data..."

# -------------------------------
# ROLES
# -------------------------------
roles = %w[admin manager support_agent customer].map do |r|
  Role.find_or_create_by!(name: r)
end
role_map = roles.index_by(&:name)

# -------------------------------
# USERS & USER_ROLES
# -------------------------------
puts "Creating Users..."

users_data = [
  { email: "longvulinhhoang@gmail.com", password: "123456", status: :disabled, role: "admin" },
  { email: "manager@example.com", password: "password", status: :disabled, role: "manager" }
]

# Add agents
2.times { |i| users_data << { email: "agent#{i + 1}@example.com", password: "password", status: :active, role: "support_agent" } }

# Add customers
5.times { users_data << { email: Faker::Internet.unique.email, password: "123456", status: :active, role: "customer" } }

users = users_data.map do |u|
  account = AccountUser.find_or_create_by!(email: u[:email]) do |a|
    a.password = u[:password]
    a.status = u[:status]
  end

  # Ensure account saved
  account.save! if account.new_record?

  # Assign role safely
  role = role_map[u[:role]]
  unless UserRole.exists?(user_id: account.id, role_id: role.id)
    UserRole.create!(user_id: account.id, role_id: role.id)
  end

  account
end

# -------------------------------
# PERMISSIONS
# -------------------------------
puts "Creating Permissions..."
subjects_with_soft_delete = %w[products product_variants categories promotions attributes attribute_values]
subjects_without_soft_delete = %w[orders users carts cart_items payments refunds return_requests]

permissions_data = []

%w[index show create update destroy].each do |action|
  (subjects_with_soft_delete + subjects_without_soft_delete).each do |subject|
    permissions_data << { action: action, subject: subject }
  end
end

subjects_with_soft_delete.each { |subject| permissions_data << { action: "restore", subject: subject } }
permissions_data << { action: "authorize", subject: "users" }

permissions = permissions_data.map { |p| Permission.find_or_create_by!(action: p[:action], subject: p[:subject]) }

# -------------------------------
# ROLE_PERMISSIONS
# -------------------------------
puts "Assigning permissions..."
role_permissions_map = {
  "admin" => permissions,
  "manager" => permissions.select { |p| %w[products product_variants categories promotions orders].include?(p.subject) },
  "support_agent" => permissions.select { |p| %w[orders carts cart_items].include?(p.subject) && %w[index show].include?(p.action) },
  "customer" => permissions.select { |p| %w[products orders carts cart_items].include?(p.subject) && %w[index show create].include?(p.action) }
}

role_permissions_map.each do |role_name, perms|
  role = role_map[role_name]
  existing_permission_ids = RolePermission.where(role_id: role.id).pluck(:permission_id)
  new_permission_ids = perms.map(&:id) - existing_permission_ids

  # Bulk insert safely
  new_permission_ids.each do |pid|
    RolePermission.create!(role_id: role.id, permission_id: pid)
  end
end

# -------------------------------
# CATEGORIES
# -------------------------------
puts "Creating Categories..."
categories = 5.times.map do
  Category.find_or_create_by!(name: Faker::Commerce.unique.department(max: 1, fixed_amount: true)) do |c|
    c.slug = Faker::Internet.unique.slug
    c.position = rand(1..10)
  end
end

# -------------------------------
# ATTRIBUTES & ATTRIBUTE VALUES
# -------------------------------
puts "Creating Attributes..."
colors = Attribute.find_or_create_by!(name: "Color") { |a| a.slug = "color" }
sizes = Attribute.find_or_create_by!(name: "Size") { |a| a.slug = "size" }

%w[Red Blue Green Yellow].each { |c| AttributeValue.find_or_create_by!(attribute_id: colors.id, value: c) }
%w[S M L XL].each { |s| AttributeValue.find_or_create_by!(attribute_id: sizes.id, value: s) }

# -------------------------------
# PRODUCTS & VARIANTS
# -------------------------------
puts "Creating Products..."
50.times do
  product = Product.find_or_create_by!(name: Faker::Commerce.unique.product_name) do |p|
    p.slug = Faker::Internet.unique.slug
    p.description = Faker::Lorem.paragraph(sentence_count: 2)
    p.brand = Faker::Company.name
    p.favourite_count = rand(0..1000)
  end

  (categories.sample(rand(1..2)) - product.categories).each { |cat| product.categories << cat }

  1.upto(rand(1..3)) do |i|
    variant = ProductVariant.find_or_create_by!(product_id: product.id, sku: "#{product.name.parameterize}-#{i}") do |v|
      v.name = "#{product.name} Variant #{i}"
      v.origin_price = Faker::Commerce.price(range: 10..100)
      v.price = Faker::Commerce.price(range: 5..90)
      v.stock_qty = rand(0..50)
    end

    attr_id = [colors.id, sizes.id].sample
    value = AttributeValue.where(attribute_id: attr_id).sample
    ProductVariantAttrValue.find_or_create_by!(product_variant_id: variant.id, attribute_id: attr_id, attribute_value_id: value.id)

    1.upto(rand(1..3)) do
      ProductImage.find_or_create_by!(product_id: product.id, url: Faker::Avatar.unique.image(slug: product.name.parameterize, size: "300x300", format: "png")) do |img|
        img.alt = product.name
        img.position = rand(1..5)
      end
    end
  end
end

# -------------------------------
# PROMOTIONS
# -------------------------------
puts "Creating Promotions..."
5.times do
  Promotion.find_or_create_by!(code: Faker::Alphanumeric.unique.alphanumeric(number: 8).upcase) do |promo|
    promo.description = Faker::Marketing.buzzwords
    promo.type = rand(0..2)
    promo.value = Faker::Commerce.price(range: 5..50)
    promo.start_date = Faker::Date.backward(days: 30)
    promo.end_date = Faker::Date.forward(days: 30)
    promo.usage_limit = rand(1..100)
    promo.per_user_limit = rand(1..5)
    promo.min_order_amount = Faker::Commerce.price(range: 50..200)
  end
end

# -------------------------------
# ORDERS & ITEMS & PAYMENTS
# -------------------------------
puts "Creating Orders..."
customer_accounts = users.select { |u| u.roles.include?(role_map["customer"]) }

customer_accounts.each do |user|
  rand(1..3).times do
    order = Order.create!(user_id: user.id, currency: "USD", status: Order.statuses.keys.sample, total_amount: 0)

    product_variants = ProductVariant.all.sample(rand(1..3))
    product_variants.each do |variant|
      quantity = rand(1..5)
      OrderItem.create!(
        order_id: order.id,
        product_variant_id: variant.id,
        name: variant.name,
        sku: variant.sku,
        quantity: quantity,
        unit_price: variant.price,
        product_variant_snapshot: variant.attributes.to_json
      )
      order.total_amount += variant.price * quantity
    end
    order.save!

    Payment.create!(
      order_id: order.id,
      stripe_payment_id: Faker::Alphanumeric.alphanumeric(number: 10),
      stripe_charge_id: Faker::Alphanumeric.alphanumeric(number: 10),
      amount: order.total_amount,
      currency: "USD",
      status: Payment.statuses.keys.sample
    )
  end
end

puts "Seeding completed!"
