class CreateCronjobs < ActiveRecord::Migration
  def self.up
    create_table :cronjobs do |t|
      t.string :name
      t.datetime :started_at
      t.datetime :completed_at
      t.string :metric_1_name
      t.integer :metric_1_value
      t.string :metric_2_name
      t.integer :metric_2_value
      t.string :metric_3_name
      t.integer :metric_3_value
      t.boolean :success
      t.boolean :failure
      t.text :notes
      t.string :cron_entry_text

      t.timestamps
    end
  end

  def self.down
    drop_table :cronjobs
  end
end
