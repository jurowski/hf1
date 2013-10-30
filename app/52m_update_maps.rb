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
  ### RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/52m_update_maps.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/52m_update_maps.rb

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/52m_update_maps.rb



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
output_me("info", "START script")
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
FileUtils.cp 'public/52m/map/usa/map-config_template.js', 'public/52m/map/usa/map-config_template.js_in_progress'
FileUtils.cp 'public/52m/map/canada/map-config_template.js', 'public/52m/map/canada/map-config_template.js_in_progress'


# for each state in weight_loss_by_states
states = WeightLossByState.all
states.each do |state|
  #     set filepath_to_mod based on COUNTRY
  filepath_to_mod = "public/52m/map/#{state.country}/map-config_template.js_in_progress"
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
    state_data += "Population-Adjusted Goal for #{state.state}: <strong>Lose #{number_with_delimiter(goal_lbs, :delimiter => ',')} lbs.</strong>"
    state_data += "<br># of Challenge Participants: #{number_with_delimiter(total_participating, :delimiter => ',')} have signed up"
    state_data += "<br>Lbs lost so far: #{number_with_delimiter(challenge_lbs_lost_total, :delimiter => ',')} lbs."
    state_data += "<br>% of Goal Reached: #{challenge_percent_of_goal_met}%"
    state_data += "<br>Challenge Rank (US & Canada): ##{challenge_number_rank} out of #{states.size}"

    state_data += "<br><br><br>"
    state_data += "<br>-- Obesity Facts for #{state.state_code} --"
    state_data += "<br>Total Population: #{number_with_delimiter(demog_population, :delimiter => ',')}"
    state_data += "<br>Obesity Rate: #{demog_percent_obesity_rate}%"
    state_data += "<br>Est # of Obese Adults: #{number_with_delimiter(demog_number_obese_adults, :delimiter => ',')}"
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

    filepath_to_mod = "public/52m/map/usa/map-config_template.js_in_progress"
    File.open(filepath_to_mod, 'a') do |f| 
      f.puts "}"
    end

    filepath_to_mod = "public/52m/map/canada/map-config_template.js_in_progress"
    File.open(filepath_to_mod, 'a') do |f| 
      f.puts "}"
    end




# copy each country file "map-config.js" to "backup/map-config.js" + "_" + timestamp
FileUtils.cp 'public/52m/map/usa/map-config.js', 'public/52m/map/usa/backups/map-config.js_' + Time.now.strftime('%Y%m%d-%H%M%S')
FileUtils.cp 'public/52m/map/canada/map-config.js', 'public/52m/map/canada/backups/map-config.js_' + Time.now.strftime('%Y%m%d-%H%M%S')

# copy each country in_progress file from "map-config_template.js_in_progress" to "map-config.js"
FileUtils.cp 'public/52m/map/usa/map-config_template.js_in_progress', 'public/52m/map/usa/map-config.js'
FileUtils.cp 'public/52m/map/canada/map-config_template.js_in_progress', 'public/52m/map/canada/map-config.js'

# remove each country in_progress file
FileUtils.rm 'public/52m/map/canada/map-config_template.js_in_progress', :force => true   # never raises exception
FileUtils.rm 'public/52m/map/usa/map-config_template.js_in_progress', :force => true   # never raises exception

output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "END script")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")  

end
