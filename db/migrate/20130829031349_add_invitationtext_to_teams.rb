class AddInvitationtextToTeams < ActiveRecord::Migration
  def self.up
  	add_column :teams, :invitation_body, :text
  	add_column :teams, :invitation_subject, :string
  end

  def self.down
  	remove_column :teams, :invitation_body
  	remove_column :teams, :invitation_subject
  end
end
