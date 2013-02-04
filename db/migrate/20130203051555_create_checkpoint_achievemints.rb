class CreateCheckpointAchievemints < ActiveRecord::Migration
  def self.up
    create_table :checkpoint_achievemints do |t|
      t.integer :user_id
      t.integer :goal_id
      t.integer :template_goal_id
      t.integer :achievemint_id
      t.integer :checkpoint_id
      t.string :unit_value
      t.string :param_1_value
      t.string :param_2_value
      t.string :param_3_value
      t.string :transmission_status
      t.integer :points_worth

      t.timestamps
    end
  end

  def self.down
    drop_table :checkpoint_achievemints
  end
end
