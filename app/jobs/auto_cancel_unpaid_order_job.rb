class AutoCancelUnpaidOrderJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find_by(id: order_id)
    unless order
      Rails.logger.error("Order-#{order_id} not found")
      return
    end
    order.update(status: "canceled")
    Rails.logger.info("Order-#{order_id} is cancelled!")
  end
end
