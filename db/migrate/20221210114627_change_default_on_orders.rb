class ChangeDefaultOnOrders < ActiveRecord::Migration[6.1]
  def change
    change_column_default :orders, :pay,  to: 0
    change_column_default :orders, :status,  to: 0
  end
end
