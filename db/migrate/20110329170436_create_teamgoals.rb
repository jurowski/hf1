class CreateTeamgoals < ActiveRecord::Migration
  def self.up
    create_table :teamgoals do |t|
      t.integer :team_id
      t.integer :goal_id
      t.integer :rating
      t.integer :qty_kickoff_votes
      t.integer :active
      t.integer :suspend

      t.timestamps
    end
  end

  def self.down
    drop_table :teamgoals
  end
end
