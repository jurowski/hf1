class AddMomentumToTriggers < ActiveRecord::Migration
  def self.up
  	add_column :triggers, :trigger_on_momentum_rate, :boolean
  	add_column :triggers, :max_success_or_failure_rate, :integer
  end

  def self.down
  	remove_column :triggers, :max_success_or_failure_rate
  	remove_column :triggers, :trigger_on_momentum_rate
  end
end
