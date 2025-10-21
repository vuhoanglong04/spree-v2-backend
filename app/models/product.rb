class Product < ApplicationRecord
  include RemoveCacheAfterCommitting
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  acts_as_paranoid
  has_many :product_images, -> { order(position: :asc) }, dependent: :destroy
  has_many :product_variants, -> { order(updated_at: :desc) }
  has_many :product_categories
  has_many :categories, through: :product_categories
  accepts_nested_attributes_for :product_categories, allow_destroy: true
  accepts_nested_attributes_for :product_variants, allow_destroy: true
  accepts_nested_attributes_for :product_images, allow_destroy: true

  settings index: { number_of_shards: 2 } do
    mapping dynamic: false do
      indexes :name, type: :text, analyzer: :standard do
        indexes :keyword, type: :keyword
      end
      indexes :slug, type: :text, analyzer: :standard
      indexes :brand, type: :text, analyzer: :standard
      indexes :description, type: :text, analyzer: :standard
      indexes :total_sold, type: :integer
      indexes :favourite_count, type: :integer
      indexes :created_at, type: :date

      indexes :categories, type: :nested do
        indexes :id, type: :integer
      end

      indexes :product_variants, type: :nested do
        indexes :sku, type: :keyword
        indexes :name, type: :text, analyzer: :standard
        indexes :price, type: :float
        indexes :stock_qty, type: :integer
        indexes :attribute_values, type: :nested do
          indexes :id, type: :keyword
          indexes :value, type: :keyword
        end
      end
    end
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      name: name,
      slug: slug,
      brand: brand,
      description: description,
      total_sold: total_sold,
      favourite_count: favourite_count,
      created_at: created_at,
      product_variants: product_variants.map do |variant|
        {
          sku: variant.sku,
          name: variant.name,
          price: variant.price,
          stock_qty: variant.stock_qty,
          attribute_values: variant.attribute_values.map do |av|
            {
              id: av.id,
              value: av.value
            }
          end
        }
      end,
      categories: categories.map do |category|
        {
          id: category.id
        }
      end
    }
  end

end
