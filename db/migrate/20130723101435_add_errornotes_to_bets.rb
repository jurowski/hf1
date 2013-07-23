class AddErrornotesToBets < ActiveRecord::Migration
  def self.up
  	add_column :bets, :error_on_notification, :boolean
  end

  def self.down
  	remove_column :bets, :error_on_notification
  end
end
