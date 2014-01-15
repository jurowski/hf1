class AddProgramidToInvites < ActiveRecord::Migration

  def self.up
  	add_column :invites, :purpose_join_program_id, :integer
  end

  def self.down
  	remove_column :invites, :purpose_join_program_id
  end

end
