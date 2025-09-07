class OutOfStockError < StandardError
  attr_reader :errors

  def initialize(message, errors = {})
    super(message)
    @errors = errors
  end
end
