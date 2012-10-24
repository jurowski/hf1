class AddCommentToCheckpoint < ActiveRecord::Migration
  def self.up
    add_column :checkpoints, :comment, :text
  end

  def self.down
    remove_column :checkpoints, :comment
  end
end
