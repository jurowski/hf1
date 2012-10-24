class AddExpirenoticesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :sent_expire_warning_on, :date
    add_column :users, :sent_expire_notice_on, :date
  end

  def self.down
    remove_column :users, :sent_expire_notice_on
    remove_column :users, :sent_expire_warning_on
  end
end
