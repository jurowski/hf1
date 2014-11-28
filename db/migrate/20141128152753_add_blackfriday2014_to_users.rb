class AddBlackfriday2014ToUsers < ActiveRecord::Migration
  def self.up
	add_column :users, :promotion_black_friday_2014_sent, :date
  end

  def self.down
  	remove_column :users, :promotion_black_friday_2014_sent
  end
end
