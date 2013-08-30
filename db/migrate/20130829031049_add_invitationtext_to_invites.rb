class AddInvitationtextToInvites < ActiveRecord::Migration
  def self.up
  	add_column :invites, :invitation_body, :text
  	add_column :invites, :invitation_subject, :string
  end

  def self.down
  	remove_column :invites, :invitation_body
  	remove_column :invites, :invitation_subject
  end
end
