class AddOnethendoneToProgramtemplates < ActiveRecord::Migration
  def self.up
  	add_column :program_templates, :one_then_done, :boolean, :default => false
  end

  def self.down
  	remove_column :program_templates, :one_then_done
  end
end
