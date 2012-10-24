class AddFromidToTomessage < ActiveRecord::Migration
  def self.up
    add_column :tomessages, :from_id, :integer
    add_column :tomessages, :to_id, :integer
  end

  def self.down
    remove_column :tomessages, :to_id
    remove_column :tomessages, :from_id
  end
end
