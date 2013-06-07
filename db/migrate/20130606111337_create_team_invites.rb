class CreateTeamInvites < ActiveRecord::Migration
  def self.up
    create_table :team_invites do |t|
      t.integer :team_id
      t.string :email_original
      t.integer :user_id
      t.integer :goal_id
      t.date :first_sent_date
      t.date :remind_until_date
      t.integer :remind_every_n_days
      t.date :last_reminded_date
      t.date :declined_date
      t.date :ignored_date
      t.date :accepted_date

      t.timestamps
    end
  end

  def self.down
    drop_table :team_invites
  end
end
