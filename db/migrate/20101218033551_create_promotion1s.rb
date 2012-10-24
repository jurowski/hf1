class CreatePromotion1s < ActiveRecord::Migration
  def self.up
    create_table :promotion1s do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :promotion1s
  end
end
