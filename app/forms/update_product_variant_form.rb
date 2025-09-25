class UpdateProductVariantForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :product_id,
                :sku,
                :name,
                :origin_price,
                :price,
                :stock_qty,
                :product_variant_attr_values_attributes
  validates :origin_price,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Product variant's origin price must be a number and greater or equal to 0"
            },
            allow_nil: true

  validates :price,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Product variant's price must be a number and greater or equal to 0"
            },
            allow_nil: true

  validates :stock_qty,
            numericality:
              {
                greater_than_or_equal_to: 0,
                message: "Product variant's stock quantity must be a number and greater or equal to 0 "
              },
            allow_nil: true

  # validate :validate_valid_product_variant_attr_values_attributes

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  # def validate_valid_product_variant_attr_values_attributes
  #   return if product_variant_attr_values_attributes.nil?
  #
  #   field_names = {
  #     "product_attribute_id" => "Attribute",
  #     "attribute_value_id" => "Attribute value"
  #   }
  #
  #   product_variant_attr_values_attributes.each do |index, attr_data|
  #     missing_fields = field_names.keys.select { |field| attr_data[field].blank? }
  #
  #     if missing_fields.any?
  #       friendly_names = missing_fields.map { |f| field_names[f] }
  #       errors.add(
  #         :product_variant_attr_values_attributes,
  #         "Variant #{index.to_i + 1} is missing: #{friendly_names.join(', ')}"
  #       )
  #     end
  #   end
  # end

end
