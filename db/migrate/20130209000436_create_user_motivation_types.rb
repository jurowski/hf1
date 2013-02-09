class CreateUserMotivationTypes < ActiveRecord::Migration
  def self.up
    create_table :user_motivation_types do |t|
      t.integer :user_id
      t.integer :motivation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_motivation_types
  end
end
