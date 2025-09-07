class UpdateOrderForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :status
  validates :status,
            presence: true

  def initialize(attributes = {})
    super(attributes)
    validate!
  end
end
