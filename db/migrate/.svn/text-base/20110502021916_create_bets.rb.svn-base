class CreateBets < ActiveRecord::Migration
  def self.up
    create_table :bets do |t|
      t.integer :credits
      t.date :start_date
      t.date :end_date
      t.integer :success_rate
      t.decimal :donated_amount
      t.date :donation_date
      t.integer :active_yn

      t.timestamps
    end
  end

  def self.down
    drop_table :bets
  end
end
