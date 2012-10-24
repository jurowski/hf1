class AddCoachfollowToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :coach_follow_next, :date
    add_column :users, :coach_follow_last, :date
  end

  def self.down
    remove_column :users, :coach_follow_last
    remove_column :users, :coach_follow_next
  end
end
