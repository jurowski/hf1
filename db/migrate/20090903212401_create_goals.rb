class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.integer :user_id
      t.string :title, :null => false
      t.text :summary
      t.text :why
      t.date :start
      t.date :stop
      t.date :established_on #date on which habit was done for 21 consecutive days
      t.string :category
      t.boolean :publish, :default => false #whether to let other signed-in-users see your goal
      t.boolean :share, :default => false #whether to invite others via email to keep you on track
      t.string :status, :default => "start"
      t.text :response_question
      t.string :response_options, :default => "yes;no"
      t.time :reminder_time
      t.boolean :higher_is_better, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :goals
  end
end
