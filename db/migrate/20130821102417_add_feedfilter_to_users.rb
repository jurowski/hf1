class AddFeedfilterToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :feed_filter_show_my_categories_only, :boolean
  	add_column :users, :feed_filter_hide_pmo, :boolean
  end

  def self.down
  	remove_column :users, :feed_filter_show_my_categories_only
  	remove_column :users, :feed_filter_hide_pmo
  end
end
