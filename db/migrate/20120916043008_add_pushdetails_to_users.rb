class AddPushdetailsToUsers < ActiveRecord::Migration
  def self.up
	add_column :users, :supportpoints, :integer
	add_column :users, :supportpoints_log, :text
	add_column :users, :date_last_prompted_to_push_a_slacker, :date
	add_column :users, :date_i_last_pushed_a_slacker, :date
	add_column :users, :slacker_id_that_i_last_pushed, :integer
  end

#  def self.down
#        remove_column :users, :supportpoints
#        remove_column :users, :supportpoints_log
#        remove_column :users, :date_last_prompted_to_push_a_slacker
#        remove_column :users, :date_i_last_pushed_a_slacker
#        remove_column :users, :slacker_id_that_i_last_pushed
#  end

end
