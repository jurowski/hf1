class CreateCoaches < ActiveRecord::Migration
  def self.up
    create_table :coaches do |t|
      t.integer :user_id
      t.string :categories
      t.integer :client_count_limit
      t.integer :client_count_active
      t.integer :client_count_cumulative
      t.integer :is_willing_to_work
      t.text :blurb

      t.timestamps
    end
  end

  def self.down
    drop_table :coaches
  end
end
