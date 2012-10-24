class AddCoachidToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :coach_id, :integer
  end

  def self.down
    remove_column :users, :coach_id
  end
end
