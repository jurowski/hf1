class CreateCheers < ActiveRecord::Migration
  def self.up
    create_table :cheers do |t|
      t.string :email
      t.integer :goal_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cheers
  end
end
