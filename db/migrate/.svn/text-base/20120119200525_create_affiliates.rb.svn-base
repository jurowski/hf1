class CreateAffiliates < ActiveRecord::Migration
  def self.up
    create_table :affiliates do |t|
      t.string :email
      t.string :last_name
      t.string :first_name
      t.string :affiliate_name
      t.string :coupon_code
      t.integer :coupon_discount
      t.integer :affiliate_earnings_rate

      t.timestamps
    end
  end

  def self.down
    drop_table :affiliates
  end
end
