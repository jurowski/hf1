class CreateAchievemints < ActiveRecord::Migration
  def self.up
    create_table :achievemints do |t|
      t.string :name
      t.string :unit
      t.string :extra_param_1
      t.string :extra_param_2
      t.string :extra_param_3
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :achievemints
  end
end
