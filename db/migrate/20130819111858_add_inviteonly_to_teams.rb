class AddInviteonlyToTeams < ActiveRecord::Migration
  def self.up
  	add_column :teams, :invite_only, :boolean
  end

  def self.down
  	remove_column :teams, :invite_only
  end
end
