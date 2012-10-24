class AddSyslognoteToCheckpoint < ActiveRecord::Migration
  def self.up
    add_column :checkpoints, :syslognote, :string
  end

  def self.down
    remove_column :checkpoints, :syslognote
  end
end
