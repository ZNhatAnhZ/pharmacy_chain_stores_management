class OrderMailer < ApplicationMailer
  def order_complete(order)
    @order = order
    return if @order&.customer&.email.blank?
    mail(to: @order.customer.email, subject: "Đơn hàng của bạn đã được chấp nhận")
  end

  def order_rejected(order)
    @order = order
    return if @order&.customer&.email.blank?
    mail(to: @order.customer.email, subject: "Đơn hàng của bạn đã bị từ chối")
  end
end
