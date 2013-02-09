class CreateMessageMotivations < ActiveRecord::Migration
  def self.up
    create_table :message_motivations do |t|
      t.integer :message_id
      t.integer :motivation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :message_motivations
  end
end
