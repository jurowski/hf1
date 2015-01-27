class CreateImpactLeaders < ActiveRecord::Migration
  def self.up
    create_table :impact_leaders do |t|
      t.integer :user_id
      t.string :handle
      t.string :display_name
      t.string :email
      t.string :country
      t.string :state
      t.integer :impact_points
      t.integer :position
      t.boolean :premium
      t.text :latest_boost_text

      t.timestamps
    end
  end

  def self.down
    drop_table :impact_leaders
  end
end
