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
user = AccountUser.create!(
  email: "longvulinhhoang@gmail.com",
  password: "123456",
  status: 1,
  main_role: 1,
  confirmed_at: Time.now
)
user.skip_confirmation!
user.save!

account_users = 15.times.map do |i|
  u = AccountUser.new(
    email: "user#{i + 1}@example.com",
    password: "123456",
    status: 0,
    confirmed_at: Time.now
  )
  u.skip_confirmation!
  u.save!
  u
end

# ---- Roles & Permissions (5 each) ----
roles = %w[admin manager staff customer guest].map do |role|
  Role.create!(name: role.capitalize, description: "#{role} role")
end

subjects = %w[
  category
  product
  product_variant
  user
  order
  promotion
  role
  attribute
]

actions = %w[index show create update destroy restore role]

permissions = subjects.flat_map do |subject|
  actions.map do |action|
    Permission.create!(
      action_name: action,
      subject: subject,
      description: "#{action} #{subject} permission"
    )
  end
end

# Assign permissions to roles (default: 1 each just for demo)
roles.each_with_index do |role, i|
  RolePermission.create!(role_id: role.id, permission_id: permissions[i % permissions.size].id)
end

# ---- Give Admin ALL permissions ----
admin_role = roles.find { |r| r.name.downcase == "admin" }
permissions.each do |perm|
  RolePermission.find_or_create_by!(role_id: admin_role.id, permission_id: perm.id)
end

# ---- Assign Admin role to the first user ----
UserRole.find_or_create_by!(account_user_id: user.id, role_id: admin_role.id)

# ---- Assign roles to the rest of the users ----
account_users.each_with_index do |u, i|
  UserRole.create!(account_user_id: u.id, role_id: roles[i % roles.size].id)
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
  v = ProductVariant.create(
    product_id: product.id,
    sku: "SKU-#{SecureRandom.hex(3)}",
    name: "#{product.name} Variant",
    origin_price: rand(50..200),
    price: rand(30..150),
    stock_qty: rand(10..100)
  )
  v.save
  v
end

# ---- Attributes & Values (5 each) ----
attribute_names = %w[
  Color Size Material Brand Style
  Weight Length Height Width Capacity
]

attributes = attribute_names.map do |attr|
  ProductAttribute.create!(
    name: attr,
    slug: attr.parameterize
  )
end

# ---- Attribute Values (5 each) ----
attribute_values = attributes.flat_map do |attr|
  5.times.map do |i|
    AttributeValue.create!(
      product_attribute_id: attr.id,
      value: "#{attr.name} #{i + 1}"
    )
  end
end

# ---- Assign attribute values to product variants ----
product_variants.each do |variant|
  attr = attributes.sample
  val = attribute_values.select { |v| v.product_attribute_id == attr.id }.sample
  ProductVariantAttrValue.create!(
    product_variant_id: variant.id,
    product_attribute_id: attr.id,
    attribute_value_id: val.id
  )
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

# ---- Orders, Order Items, Payments, Refunds, Return Requests ----
orders = account_users.first(5).map do |user|
  Order.create!(account_user_id: user.id, status: 1, total_amount: 100)
end

orders.each do |order|
  variant = product_variants.sample
  OrderItem.create!(
    order_id: order.id,
    product_variant_id: variant.id,
    name: variant.name,
    sku: variant.sku,
    quantity: 1,
    unit_price: variant.price
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

# ---- Promotions ----
5.times do |i|
  Promotion.create!(
    code: "PROMO#{i + 1}",
    description: "Discount promo #{i + 1}",
    value: rand(5..20),
    start_date: Time.now,
    end_date: Time.now + 30.days
  )
end

puts "✅ Seeding completed!"
