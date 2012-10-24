class AddStatusToFailedcheckpoint < ActiveRecord::Migration
  def self.up
    add_column :failedcheckpoints, :status, :string
  end

  def self.down
    remove_column :failedcheckpoints, :status
  end
end
