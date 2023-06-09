class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :total_price
      t.integer :total_quantity
      t.integer :status, default: 0
      t.string :order_code
      t.references :employee
      t.references :inventory
      t.references :branch
      t.references :customer
      t.timestamps
    end
  end
end
