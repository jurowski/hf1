class CreateCoachMotivationTypes < ActiveRecord::Migration
  def self.up
    create_table :coach_motivation_types do |t|
      t.integer :coach_user_id
      t.integer :motivation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :coach_motivation_types
  end
end
