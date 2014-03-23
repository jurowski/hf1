class AddTracksToPrograms < ActiveRecord::Migration
  def self.up
  	add_column :programs, :track_1_name, :string
  	add_column :programs, :track_2_name, :string
  	add_column :programs, :track_3_name, :string
  	add_column :programs, :track_4_name, :string
  	add_column :programs, :track_5_name, :string
  	add_column :programs, :track_6_name, :string
  	add_column :programs, :track_7_name, :string
  	add_column :programs, :track_8_name, :string
  	add_column :programs, :track_9_name, :string
  	add_column :programs, :track_10_name, :string
  end

  def self.down
  	remove_column :programs, :track_1_name
  	remove_column :programs, :track_2_name
  	remove_column :programs, :track_3_name
  	remove_column :programs, :track_4_name
  	remove_column :programs, :track_5_name
  	remove_column :programs, :track_6_name
  	remove_column :programs, :track_7_name
  	remove_column :programs, :track_8_name
  	remove_column :programs, :track_9_name
  	remove_column :programs, :track_10_name
  end
end
