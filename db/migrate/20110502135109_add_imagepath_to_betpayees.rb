class AddImagepathToBetpayees < ActiveRecord::Migration
  def self.up
    add_column :betpayees, :image_path, :string
  end

  def self.down
    remove_column :betpayees, :image_path
  end
end
