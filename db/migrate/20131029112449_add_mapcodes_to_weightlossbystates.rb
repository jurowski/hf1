class AddMapcodesToWeightlossbystates < ActiveRecord::Migration
  def self.up
  	add_column :weight_loss_by_states, :country, :string
  	add_column :weight_loss_by_states, :map_code, :integer  	
  end

  def self.down
  	remove_column :weight_loss_by_states, :country
  	remove_column :weight_loss_by_states, :map_code
  end
end
