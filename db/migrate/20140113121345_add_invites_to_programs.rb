class AddInvitesToPrograms < ActiveRecord::Migration


  def self.up
  	add_column :programs, :invite_only, :boolean
  	add_column :programs, :invitation_body, :text
  	add_column :programs, :invitation_subject, :string
  end

  def self.down
  	remove_column :programs, :invite_only
  	remove_column :programs, :invitation_body
  	remove_column :programs, :invitation_subject
  end

end
