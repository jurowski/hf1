class CreateCheckpointRemoveds < ActiveRecord::Migration
  def self.up
    create_table :checkpoint_removeds do |t|
      t.integer :checkpoint_id


      t.string :deleted_by
      t.date :deleted_on

      	### copied from checkpoints table 20140107 (minus a few fields that we don't care about)
	    t.date     "checkin_date"
	    t.time     "checkin_time"
	    t.string   "status"
	    t.integer  "goal_id"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.text     "comment"
	    t.string   "syslognote"


      t.timestamps
    end
  end

  def self.down
    drop_table :checkpoint_removeds
  end
end
