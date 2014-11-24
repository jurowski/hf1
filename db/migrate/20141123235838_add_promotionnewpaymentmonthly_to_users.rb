class AddPromotionnewpaymentmonthlyToUsers < ActiveRecord::Migration
  def self.up
	add_column :users, :promotion_new_payment_monthly_sent, :date
  end

  def self.down
  	remove_column :users, :promotion_new_payment_monthly_sent
  end
end
