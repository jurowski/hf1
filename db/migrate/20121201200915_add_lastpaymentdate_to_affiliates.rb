class AddLastpaymentdateToAffiliates < ActiveRecord::Migration
  def self.up
    add_column :affiliates, :last_payment_date, :date
  end

  def self.down
    remove_column :affiliates, :last_payment_date
  end
end
