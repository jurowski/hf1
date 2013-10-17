class CreateWeightLossByStates < ActiveRecord::Migration
  def self.up
    create_table :weight_loss_by_states do |t|
      t.string :state
      t.string :state_code
      t.integer :demog_population
      t.integer :demog_percent_adults
      t.integer :demog_number_adults
      t.integer :demog_percent_obesity_rate
      t.integer :demog_number_obese_adults
      t.integer :demog_percent_of_total_obese_adults_in_challenge
      t.integer :challenge_weighted_goal
      t.integer :challenge_qty_hold
      t.integer :challenge_qty_active
      t.integer :challenge_lbs_starting_weight_hold
      t.integer :challenge_lbs_starting_weight_active
      t.integer :challenge_lbs_last_weight_hold
      t.integer :challenge_lbs_last_weight_active
      t.integer :challenge_lbs_lost_hold
      t.integer :challenge_lbs_lost_active
      t.integer :challenge_lbs_lost_total
      t.integer :challenge_percent_of_goal_met
      t.integer :challenge_number_rank
      t.date :challenge_last_updated_date
      t.string :js_upcolor
      t.string :js_overcolor
      t.string :js_downcolor

      t.timestamps
    end
  end

  def self.down
    drop_table :weight_loss_by_states
  end
end
