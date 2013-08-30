class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :from_user_id
      t.string :to_name
      t.string :to_email
      t.integer :to_user_id
      t.integer :purpose_join_team_id
      t.integer :purpose_follow_goal_id
      t.integer :purpose_friend_user_id
      t.date :accepted_on
      t.date :declined_loudly_on
      t.date :declined_silently_on
      t.date :first_sent_on
      t.date :last_resent_on

      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end
