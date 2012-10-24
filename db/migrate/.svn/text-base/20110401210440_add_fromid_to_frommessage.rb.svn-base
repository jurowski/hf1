class AddFromidToFrommessage < ActiveRecord::Migration
  def self.up
    add_column :frommessages, :from_id, :integer
    add_column :frommessages, :to_id, :integer
  end

  def self.down
    remove_column :frommessages, :to_id
    remove_column :frommessages, :from_id
  end
end
