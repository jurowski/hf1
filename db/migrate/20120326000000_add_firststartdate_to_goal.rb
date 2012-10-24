class AddFirststartdateToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :first_start_date, :date
  end

  def self.down
    remove_column :goals, :first_start_date
  end
end
