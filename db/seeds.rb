# db/seeds.rb
require "securerandom"

puts "Seeding database..."

# Clear existing data
[
  AccountUser, UserProfile, Role, Permission, UserRole, RolePermission,
  Category, CategoryClosure, Product, ProductImage, ProductVariant,
  ProductAttribute, AttributeValue, ProductVariantAttrValue,
  Cart, CartItem,
  Order, OrderItem, Payment, Refund, ReturnRequest,
  Promotion
].each(&:delete_all)

# ---- Account Users (15) ----
account_users = 15.times.map do |i|
  user = AccountUser.create(
    email: "user#{i + 1}@example.com",
    password: "123456", # Normally Devise encrypts
    status: 0,
    confirmed_at: Time.now
  )
  user.skip_confirmation!
  user.save
  user
end

# ---- Roles & Permissions (5 each) ----
roles = %w[admin manager staff customer guest].map do |role|
  Role.create!(name: role.capitalize, description: "#{role} role")
end

permissions = %w[read write update delete manage].map do |action|
  Permission.create!(action_name: action, subject: "Product", description: "#{action} permission")
end

# Assign roles to users
account_users.each_with_index do |user, i|
  UserRole.create!(account_user_id: user.id, role_id: roles[i % roles.size].id)
end

# Assign permissions to roles
roles.each_with_index do |role, i|
  RolePermission.create!(role_id: role.id, permission_id: permissions[i % permissions.size].id)
end

# ---- User Profiles (5 only, attach to first 5 users) ----
account_users.first(5).each do |user|
  UserProfile.create!(
    account_user_id: user.id,
    full_name: "User #{user.email}",
    phone: "555-01#{rand(10..99)}"
  )
end

# ---- Categories (5) ----

# Create categories with slug
electronics = Category.create!(name: "Electronics", slug: "electronics")
laptops = Category.create!(name: "Laptops", slug: "laptops", parent_id: electronics.id)
gaming = Category.create!(name: "Gaming", slug: "gaming", parent_id: laptops.id)
phones = Category.create!(name: "Phones", slug: "phones", parent_id: electronics.id)

categories = [electronics, laptops, gaming, phones]

# Helper to insert closure rows
def insert_closure(ancestor, descendant, depth)
  CategoryClosure.create!(
    ancestor: ancestor.id,
    descendant: descendant.id,
    depth: depth
  )
end

# Build closure table
categories.each do |category|
  # Self link
  insert_closure(category, category, 0)

  # Walk up parents
  parent = category.parent_id.present? ? Category.find(category.parent_id) : nil
  depth = 1
  while parent
    insert_closure(parent, category, depth)
    parent = parent.parent_id.present? ? Category.find(parent.parent_id) : nil
    depth += 1
  end
end
# ---- Products (15) ----
# ---- Products with Images (15) ----
products = 15.times.map do |i|
  product = Product.create!(
    name: "Product #{i + 1}",
    slug: "product-#{i + 1}",
    description: "This is the description for product #{i + 1}",
    brand: %w[Nike Sony Apple Samsung Adidas].sample
  )

  # Create 3 images per product
  3.times do |j|
    ProductImage.create!(
      product_id: product.id,
      url: "https://picsum.photos/seed/#{product.slug}-#{j}/600/600",
      alt: "#{product.name} image #{j + 1}",
      position: j + 1
    )
  end

  product
end

# Assign categories to products
categories.each_with_index do |category, i|
  product = products[i] # one-to-one mapping
  break unless product
  ProductCategory.create!(product_id: product.id, category_id: category.id)
end
# ---- Product Variants (5) ----
product_variants = products.first(5).map do |product|
  v = ProductVariant.create!(
    product_id: product.id,
    sku: "SKU-#{SecureRandom.hex(3)}",
    name: "#{product.name} Variant",
    origin_price: rand(50..200),
    price: rand(30..150),
    stock_qty: rand(10..100),
    image_url: "https://picsum.photos/seed/#{product.slug}-variant/600/600"
  )
  v
end

# ---- Orders, Order Items,Promotions, Payments, Refunds, Return Requests ----
puts "Seeding promotions..."

Promotion.delete_all

Promotion.create!([
                    {
                      code: "WELCOME10",
                      description: "Giảm 10% cho đơn hàng đầu tiên",
                      promotion_type: 0, # 0 = percent, 1 = fixed amount (tùy enum bạn định nghĩa)
                      value: 10.0,
                      start_date: Time.current - 1.day,
                      end_date: Time.current + 30.days,
                      usage_limit: 1000,
                      per_user_limit: 1,
                      min_order_amount: 0.0
                    },
                    {
                      code: "FREESHIP50K",
                      description: "Giảm 50K phí vận chuyển cho đơn từ 500K",
                      promotion_type: 1, # fixed amount
                      value: 50.0,
                      start_date: Time.current - 1.day,
                      end_date: Time.current + 60.days,
                      usage_limit: 500,
                      per_user_limit: 2,
                      min_order_amount: 500.0
                    },
                    {
                      code: "BLACKFRIDAY2025",
                      description: "Black Friday - Giảm 200K cho đơn từ 1 triệu",
                      promotion_type: 1,
                      value: 200.0,
                      start_date: Date.new(2025, 11, 28).beginning_of_day,
                      end_date: Date.new(2025, 11, 30).end_of_day,
                      usage_limit: 200,
                      per_user_limit: 1,
                      min_order_amount: 1_000.0
                    },
                    {
                      code: "SUMMER20",
                      description: "Summer Sale - Giảm 20% cho mọi đơn hàng",
                      promotion_type: 0,
                      value: 20.0,
                      start_date: Time.current,
                      end_date: Time.current + 90.days,
                      usage_limit: nil, # không giới hạn
                      per_user_limit: nil,
                      min_order_amount: 0.0
                    }
                  ])

orders = account_users.first(5).map do |user|
  Order.create!(account_user_id: user.id, status: 1, total_amount: 100)
end

orders.each do |order|
  variant = product_variants.sample

  # snapshot variant attributes into JSON
  snapshot = {
    id: variant.id,
    sku: variant.sku,
    name: variant.name,
    price: variant.price,
    image_url: variant.image_url,
    stock_qty: variant.stock_qty
  }.to_json

  OrderItem.create!(
    order_id: order.id,
    product_variant_id: variant.id,
    quantity: 1,
    unit_price: variant.price,
    product_variant_snapshot: snapshot
  )

  payment = Payment.create!(
    order_id: order.id,
    stripe_payment_id: SecureRandom.hex(8),
    amount: order.total_amount,
    status: 1
  )

  Refund.create!(
    payment_id: payment.id,
    stripe_refund_id: SecureRandom.hex(8),
    amount: 10,
    status: 1
  )

  ReturnRequest.create!(
    order_id: order.id,
    order_item_id: order.order_items.first.id,
    quantity: 1,
    reason: "Damaged item",
    status: 0
  )
end

# ---- Attributes & Values (5 each) ----
attributes = %w[Color Size Material Brand Style].map do |attr|
  ProductAttribute.create!(name: attr, slug: attr.downcase)
end

attribute_values = attributes.map do |attr|
  5.times.map { |i| AttributeValue.create!(product_attribute_id: attr.id, value: "#{attr.name} #{i + 1}") }
end.flatten

# Assign attribute values to variants
product_variants.each do |variant|
  attr = attributes.sample
  val = attribute_values.select { |v| v.product_attribute_id == attr.id }.sample
  ProductVariantAttrValue.create!(product_variant_id: variant.id, product_attribute_id: attr.id, attribute_value_id: val.id)
end

# ---- Carts & Cart Items ----
carts = account_users.first(5).map do |user|
  Cart.create!(account_user_id: user.id)
end

carts.each do |cart|
  CartItem.create!(
    cart_id: cart.id,
    product_variant_id: product_variants.sample.id,
    quantity: rand(1..3)
  )
end
puts "✅ Seeding completed!"
