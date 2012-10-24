class AddBetpayeeidToBets < ActiveRecord::Migration
  def self.up
    add_column :bets, :betpayee_id, :integer
  end

  def self.down
    remove_column :bets, :betpayee_id
  end
end
