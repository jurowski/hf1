class CreateBetpayees < ActiveRecord::Migration
  def self.up
    create_table :betpayees do |t|
      t.string :name
      t.string :url
      t.decimal :totaldonated

      t.timestamps
    end
  end

  def self.down
    drop_table :betpayees
  end
end
