class AddUnreadToTomessage < ActiveRecord::Migration
  def self.up
    add_column :tomessages, :unread, :integer
  end

  def self.down
    remove_column :tomessages, :unread
  end
end
