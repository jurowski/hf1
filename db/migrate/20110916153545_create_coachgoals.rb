class CreateCoachgoals < ActiveRecord::Migration
  def self.up
    create_table :coachgoals do |t|
      t.integer :coach_id
      t.integer :goal_id
      t.string :goal_name
      t.integer :user_id
      t.string :user_email
      t.string :user_first_name
      t.date :coach_was_paid_out_on_date
      t.decimal :coach_was_paid_out_amount
      t.decimal :amount_client_paid_total
      t.decimal :amount_client_paid_split_to_site
      t.decimal :amount_client_paid_split_to_coach
      t.date :week_1_email_due_date
      t.date :week_1_email_sent_date
      t.date :week_2_email_due_date
      t.date :week_2_email_sent_date
      t.date :week_3_email_due_date
      t.date :week_3_email_sent_date
      t.date :week_4_email_due_date
      t.date :week_4_email_sent_date
      t.integer :is_active

      t.timestamps
    end
  end

  def self.down
    drop_table :coachgoals
  end
end
