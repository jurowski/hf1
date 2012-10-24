class AddKillAdsUntilToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :kill_ads_until, :date
  end

  def self.down
    remove_column :users, :kill_ads_until
  end
end
