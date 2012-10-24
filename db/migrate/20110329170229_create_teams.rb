class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name
      t.string :category_name
      t.integer :qty_max
      t.integer :qty_current
      t.integer :avg_success_rate
      t.integer :avg_days_in_a_row
      t.integer :avg_met_goal_last_week
      t.integer :qty_checked_in_yesterday
      t.integer :qty_checked_in_last_2_days

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
