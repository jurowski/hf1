class AddBetidToGoals < ActiveRecord::Migration
  def self.up
    add_column :goals, :bet_id, :integer
  end

  def self.down
    remove_column :goals, :bet_id
  end
end
