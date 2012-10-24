class AddFireToBet < ActiveRecord::Migration
  def self.up
    add_column :bets, :recipient_type, :string
    add_column :bets, :recipient_email, :string
    add_column :bets, :floor, :integer
    add_column :bets, :user_id, :integer
    add_column :bets, :length_days, :integer
    add_column :bets, :fire_type, :integer
    add_column :bets, :paid_yn, :integer
    add_column :bets, :payment_url, :string
    add_column :bets, :sent_bill_notice_date, :date
  end

  def self.down
    remove_column :bets, :sent_bill_notice_date
    remove_column :bets, :payment_url
    remove_column :bets, :paid_yn
    remove_column :bets, :fire_type
    remove_column :bets, :length_days
    remove_column :bets, :user_id
    remove_column :bets, :floor
    remove_column :bets, :recipient_email
    remove_column :bets, :recipient_type
  end
end
