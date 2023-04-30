class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email, unique: true
      t.string :password_digest
      t.string :contact
      t.integer :gender, default: 1
      t.string :address

      t.timestamps
    end
  end
end
