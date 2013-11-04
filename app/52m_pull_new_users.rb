require 'active_record'
require 'logger'
require 'json'
require 'pp'
require 'net/http'


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

class PullNewUsers52m < ActiveRecord::Base

  # This script talks to the GetResponse account for John Rowley's 52M
  # and pulls the new users and creates HF accounts and signs them up for the 52M challenge

  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/52m_pull_new_users.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/52m_pull_new_users.rb

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/52m_pull_new_users.rb



  # PSEUDOCODE



output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "START script")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")


#states = WeightLossByState.all

#json = File.read('employees.json')
#empls = JSON.parse(json)

#json = File.read('http://api2.getresponse.com')
#gr = JSON.pars(json)
#pp gr

#`pwd`



# [
#     "e9aaf5761d004bf4cc27952620209c3a",
#     {
#         "campaign"  : "52_million_pound_challenge"
#     }
# ]

#jsonbody = File.read('app/52m_pull_new_users_json_get_users.json')

# jsonbody = "{"
# jsonbody = "    \"e9aaf5761d004bf4cc27952620209c3a\""
# jsonbody += "}"

# http = Net::HTTP.new('api2.getresponse.com')
# response = http.request_put('/', jsonbody)
# puts response


#@host = 'localhost'
@host = 'api2.getresponse.com'
@port = '8099'

#@path = "/posts"
@path = "/"

# @body ={
# "bbrequest" => "BBTest",
# "reqid" => "44",
# "data" => {"name" => "test"}
# }.to_json

# @body ={
# "API_KEY" => "e9aaf5761d004bf4cc27952620209c3a",
# "id" => "4534534"
# }.to_json

@body ={
{"API_KEY" => "e9aaf5761d004bf4cc27952620209c3a"
}.to_json


request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
request.body = @body
#response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
response = Net::HTTP.new(@host).start {|http| http.request(request) }
puts "Response #{response.code} #{response.message}: #{response.body}"


output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "END script")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")  

end
