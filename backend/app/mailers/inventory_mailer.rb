class InventoryMailer < ApplicationMailer
  def send_request_mail_to_supplier(branch, suppliers)
    suppliers.each do |supplier|
      @zero_quantity_inventory = Inventory.where(branch_id: branch.id, supplier_id: supplier.id, quantity: 0)
      @supplier = supplier
      @branch = branch
      next if @zero_quantity_inventory.empty?
      next if supplier&.email.blank?

      mail to: @supplier.email, from: @branch.email, subject: "need more inventory"
    end
  end
end
