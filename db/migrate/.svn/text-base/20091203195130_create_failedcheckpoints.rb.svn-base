class CreateFailedcheckpoints < ActiveRecord::Migration
  def self.up
    create_table :failedcheckpoints do |t|
      t.integer :user_id
      t.integer :goal_id
      t.integer :checkpoint_id
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :failedcheckpoints
  end
end
