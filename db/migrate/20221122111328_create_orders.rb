class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|

      t.integer :custemer_id
      t.integer :price #支払い金額
      t.integer :pay  #支払い方法
      t.integer :status
      t.integer :postage
      t.string :postal_code
      t.string :address
      t.string :name

      t.timestamps
    end
  end
end
