class AddLastactivitydateToImpactleader < ActiveRecord::Migration
  def self.up
	add_column :impact_leaders, :last_activity_date, :date
  end

  def self.down
  	remove_column :impact_leaders, :last_activity_date

  end

end
