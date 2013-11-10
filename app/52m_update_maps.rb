require 'active_record'
require 'logger'

include ActionView::Helpers::NumberHelper

### make it easy to write output to the terminal + log at the same time
def output_me(level, print_and_log_me)

    print_and_log_me = "52m_update_maps.rb:" + print_and_log_me
    puts print_and_log_me

    if level == "debug"
        logger.debug(print_and_log_me)
    end
    if level == "info"
        logger.info(print_and_log_me)
    end
    if level == "error"
        logger.error(print_and_log_me)
    end
end

class UpdateMaps52m < ActiveRecord::Base

  # This script updates the maps for John Rowley's 52M

  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/52m_update_maps.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/52m_update_maps.rb

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/52m_update_maps.rb


  ################### UPDATE THE DATA ###################################

  # create_table "weight_loss_by_states", :force => true do |t|
  #   t.string   "state"
  #   t.string   "state_code"
  #   t.integer  "demog_population"
  #   t.integer  "demog_percent_adults"
  #   t.integer  "demog_number_adults"
  #   t.integer  "demog_percent_obesity_rate"
  #   t.integer  "demog_number_obese_adults"
  #   t.integer  "demog_percent_of_total_obese_adults_in_challenge"
  #   t.integer  "challenge_weighted_goal"
  #   t.integer  "challenge_qty_hold"
  #   t.integer  "challenge_qty_active"
  #   t.integer  "challenge_lbs_starting_weight_hold"
  #   t.integer  "challenge_lbs_starting_weight_active"
  #   t.integer  "challenge_lbs_last_weight_hold"
  #   t.integer  "challenge_lbs_last_weight_active"
  #   t.integer  "challenge_lbs_lost_hold"
  #   t.integer  "challenge_lbs_lost_active"
  #   t.integer  "challenge_lbs_lost_total"
  #   t.integer  "challenge_percent_of_goal_met"
  #   t.integer  "challenge_number_rank"
  #   t.date     "challenge_last_updated_date"
  #   t.string   "js_upcolor"
  #   t.string   "js_overcolor"
  #   t.string   "js_downcolor"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  #   t.string   "country"
  #   t.integer  "map_code"
  # end

output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "--     CALC AND SAVE LATEST DATA      --")
output_me("info", "--           START script             --")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")


# hash_states = Hash.new()
# for each state in weight_loss_by_states
states = WeightLossByState.all
states.each do |state|

    challenge_qty_total_signed_up = 0
    challenge_total_lbs_lost = 0
    #count the number of people in the challenge for that state
    goals = Goal.find(:all, :conditions => "goal_added_through_template_from_program_id = '4'")
    if goals
        goals.each do |goal|
            if goal.user.state_code == state.state_code and goal.tracker
                challenge_qty_total_signed_up += 1

                if goal.quant_diff_between_first_and_last
                    challenge_total_lbs_lost += goal.quant_diff_between_first_and_last.to_i
                end

            end
        end
    end
    state.challenge_lbs_lost_total = challenge_total_lbs_lost
    state.challenge_qty_active = challenge_qty_total_signed_up


    # challenge_lbs_starting_weight_total = 0
    # challenge_lbs_last_weight_total = 0
    # challenge_lbs_lost_total = 0


    # challenge_qty_total_weighing_in = 0


    # state.challenge_qty_total_signed_up = challenge_qty_total_signed_up
    # state.challenge_lbs_starting_weight_total = challenge_lbs_starting_weight_total
    # state.challenge_lbs_last_weight_total = challenge_lbs_last_weight_total
    # state.challenge_lbs_lost_total = challenge_lbs_lost_total
    # state.challenge_qty_total_weighing_in = challenge_qty_total_weighing_in

    state.challenge_percent_of_goal_met = 0
    if state.challenge_weighted_goal > 0
        state.challenge_percent_of_goal_met = (((state.challenge_lbs_lost_total + 0.0) / state.challenge_weighted_goal)*100).floor
    end

    # hash_states["#{state.state_code}"] = state.challenge_percent_of_goal_met
  end ### end for each state


#   hash_ordered = hash_states.sort_by {|_key, value| value}.reverse
#   for each state and province
#     ### find rank of state in the ordered hash, set to challenge_number_rank
#   end



output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "--     (CALC AND SAVE LATEST DATA)    --")
output_me("info", "--           END script               --")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")









  ################### TAKE THE DATA AND WRITE IT TO MAPS ###################################
  # PSEUDOCODE 
    # make a copy of each country template (US + CANADA), from "map-config_template.js" to  + "map-config_template.js_in_progress"

    # for each state in weight_loss_by_states
    #     set filepath_to_mod based on COUNTRY
    #     set line_to_mod based on STATE (ex: line_to_mod = "some " + STATE + " text")
    #     perform the find / replace, replacing template dummy text for that STATE with real data like this:

    #     -----------------------------------------------------
    #     Population:
    #     Obesity Rate:
    #     Est. # of Obese Adults:

    #     # of Participants:
    #     Challenge Goal: Lose XX lbs.

    #     Lbs Lost So Far: xx lbs

    #     Challenge Rank (US & Canada): xx of xx

    #     % of Goal Reached:
    #     (set color based on % reached threshold)
    #     -----------------------------------------------------        
    # end

    # rename each country file "map-config.js" to "map-config.js" + "_" + timestamp
    # rename each country in_progress file from "map-config_template.js_in_progress" to "map-config.js"

    ### END PSEUDOCODE


    ### REAL CODE



output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "--     WRITE THE DATA TO MAPS         --")
output_me("info", "--           START script             --")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")

### REFERENCE OF FILES AND FOLDERS USED
# ../public/52m/map/canada/map-config_template.js
# ../public/52m/map/canada/map-config.js
# ../public/52m/map/canada/backups

# ../public/52m/map/usa/map-config_template.js
# ../public/52m/map/usa/map-config.js
# ../public/52m/map/usa/backups


# make a copy of each country template (US + CANADA), from "map-config_template.js" to  + "map-config_template.js_in_progress"
# !! (if the "_in_progress" file already exists it will be overwritten!)

dir_path = "/home/jurowsk1/etc/rails_apps/habitforge/current/"

FileUtils.cp dir_path + 'public/52m/map/usa/map-config_template.js', dir_path + 'public/52m/map/usa/map-config_template.js_in_progress'
FileUtils.cp dir_path + 'public/52m/map/canada/map-config_template.js', dir_path + 'public/52m/map/canada/map-config_template.js_in_progress'


# for each state in weight_loss_by_states
states = WeightLossByState.all
states.each do |state|
  #     set filepath_to_mod based on COUNTRY
  filepath_to_mod = dir_path + "public/52m/map/#{state.country}/map-config_template.js_in_progress"
  output_me("info","working on " + state.country + ":" + state.state_code )

    ### DEFAULT OUTPUT FOR *.JS FILES
    #
    # 'map_1':{
    #     'namesId':'AL',
    #     'name': 'ALABAMA',
    #     'data':'Data of Alabama',
    #     'upcolor':'#EBECED',
    #     'overcolor':'#99CC00',
    #     'downcolor':'#993366',
    #     'enable':true,
    # },

    total_participating = 0
    if state.challenge_qty_hold
        total_participating += state.challenge_qty_hold
    end
    if state.challenge_qty_active
        total_participating += state.challenge_qty_active
    end

    goal_lbs = 0
    if state.challenge_weighted_goal
        goal_lbs = state.challenge_weighted_goal
    end

    challenge_lbs_lost_total = 0
    if state.challenge_lbs_lost_total
        challenge_lbs_lost_total = state.challenge_lbs_lost_total
    end

    challenge_percent_of_goal_met = 0
    if state.challenge_percent_of_goal_met
        challenge_percent_of_goal_met = state.challenge_percent_of_goal_met
    end

    challenge_number_rank = 0
    if state.challenge_number_rank
        challenge_number_rank = state.challenge_number_rank
    end

    demog_population = 0
    if state.demog_population
        demog_population = state.demog_population
    end

    demog_percent_obesity_rate = 0
    if state.demog_percent_obesity_rate
        demog_percent_obesity_rate = state.demog_percent_obesity_rate
    end

    demog_number_obese_adults = 0
    if state.demog_number_obese_adults
        demog_number_obese_adults = state.demog_number_obese_adults
    end

    state_data = "<div>"
    state_data += " Weighted Goal*: <strong>Lose #{number_with_delimiter(goal_lbs, :delimiter => ',')} lbs.</strong>"
    state_data += " <br><strong>#{number_with_delimiter(total_participating, :delimiter => ',')} Participants"
    state_data += " have lost #{number_with_delimiter(challenge_lbs_lost_total, :delimiter => ',')} lbs.</strong> so far"
    state_data += " <br><strong>#{challenge_percent_of_goal_met}%</strong> of Goal Reached"
    state_data += " <br>Challenge Rank (US & Canada): <strong>##{challenge_number_rank} of #{states.size}</strong>"
    state_data += " <br>"
    state_data += " <br>"
    state_data += " <div style=\"background-color:#ffffff;padding:5px;margin:5px;\">"
    state_data += "     #{state.state_code} Obesity Rate: <strong>#{demog_percent_obesity_rate}%**</strong>"
    state_data += "     <br>Est # of Obese Adults: <strong>#{number_with_delimiter(demog_number_obese_adults, :delimiter => ',')}</strong>"
    state_data += " </div>"
    state_data += " <h3>*Goal based on est. # of obese adults in #{state.state_code}</h3>"    

    if state.country == "canada"
    state_data += " <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3>"        
    state_data += " <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3>"
    end

    if state.country == "usa"
    state_data += " <h3>Population data: Census Data 2010 (census.gov)</h3>"
    state_data += " <h3>**Obesity data: CDC 2012 (cdc.gov)</h3>"
    end

    state_data += " <div style=\"background-color:#ffffff;padding:5px;margin:5px;\">"
    state_data += "     <center>Challenge Tracking Powered By: "
    state_data += "     <br><a href=\"http://habitforge.com\" target=\"_blank\"><img src=\"http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png\" /></a></center>"
    state_data += " </div>"
    state_data += "</div>"

    File.open(filepath_to_mod, 'a') do |f| 
      f.puts "  'map_#{state.map_code}':{"
      f.puts "      'namesId':'#{state.state_code}',"
      f.puts "      'name':'#{state.state.upcase}',"
      f.puts "      'data':'#{state_data}',"
      f.puts "      'upcolor':'#EBECED',"
      f.puts "      'overcolor':'#99CC00',"
      f.puts "      'downcolor':'#993366',"
      f.puts "      'enable':true,"
      f.puts "  },"

    end



end

    #     set line_to_mod based on STATE (ex: line_to_mod = "some " + STATE + " text")
    #     perform the find / replace, replacing template dummy text for that STATE with real data like this:

    #     -----------------------------------------------------
    #     Population:
    #     Obesity Rate:
    #     Est. # of Obese Adults:

    #     # of Participants:
    #     Challenge Goal: Lose XX lbs.

    #     Lbs Lost So Far: xx lbs

    #     Challenge Rank (US & Canada): xx of xx

    #     % of Goal Reached:
    #     (set color based on % reached threshold)
    #     -----------------------------------------------------        
    # end

    output_me("info","adding a final closing bracket " )

    filepath_to_mod = dir_path + "public/52m/map/usa/map-config_template.js_in_progress"
    File.open(filepath_to_mod, 'a') do |f| 
      f.puts "}"
    end

    filepath_to_mod = dir_path + "public/52m/map/canada/map-config_template.js_in_progress"
    File.open(filepath_to_mod, 'a') do |f| 
      f.puts "}"
    end




# copy each country file "map-config.js" to "backup/map-config.js" + "_" + timestamp
FileUtils.cp dir_path + 'public/52m/map/usa/map-config.js', dir_path + 'public/52m/map/usa/backups/map-config.js_' + Time.now.strftime('%Y%m%d-%H%M%S')
FileUtils.cp dir_path + 'public/52m/map/canada/map-config.js', dir_path + 'public/52m/map/canada/backups/map-config.js_' + Time.now.strftime('%Y%m%d-%H%M%S')

# copy each country in_progress file from "map-config_template.js_in_progress" to "map-config.js"
FileUtils.cp dir_path + 'public/52m/map/usa/map-config_template.js_in_progress', dir_path + 'public/52m/map/usa/map-config.js'
FileUtils.cp dir_path + 'public/52m/map/canada/map-config_template.js_in_progress', dir_path + 'public/52m/map/canada/map-config.js'

# remove each country in_progress file
FileUtils.rm dir_path + 'public/52m/map/canada/map-config_template.js_in_progress', :force => true   # never raises exception
FileUtils.rm dir_path + 'public/52m/map/usa/map-config_template.js_in_progress', :force => true   # never raises exception


output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "--     (WRITE THE DATA TO MAPS)       --")
output_me("info", "--           END script               --")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")


output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "--         FINALE END of script       --")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")  

end
