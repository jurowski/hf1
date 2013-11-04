class WeightLossByStatesController < ApplicationController

  layout "application"

  before_filter :require_admin_user

  def arr_states_us
    @arr = Array.new

    @arr.push([" ", ""])
    @arr.push(["Alabama", "AL"])
    @arr.push(["Alaska", "AK"])
    @arr.push(["Arizona", "AZ"])
    @arr.push(["Arkansas", "AR"])
    @arr.push(["California", "CA"])
    @arr.push(["Colorado", "CO"])
    @arr.push(["Connecticut", "CT"])
    @arr.push(["Delaware", "DE"])
    @arr.push(["District of Columbia", "DC"])
    @arr.push(["Florida", "FL"])
    @arr.push(["Georgia", "GA"])
    @arr.push(["Hawaii", "HI"])
    @arr.push(["Idaho", "ID"])
    @arr.push(["Illinois", "IL"])
    @arr.push(["Indiana", "IN"])
    @arr.push(["Iowa", "IA"])
    @arr.push(["Kansas", "KS"])
    @arr.push(["Kentucky", "KY"])
    @arr.push(["Louisiana", "LA"])
    @arr.push(["Maine", "ME"])
    @arr.push(["Maryland", "MD"])
    @arr.push(["Massachusetts", "MA"])
    @arr.push(["Michigan", "MI"])
    @arr.push(["Minnesota", "MN"])
    @arr.push(["Mississippi", "MS"])
    @arr.push(["Missouri", "MO"])
    @arr.push(["Montana", "MT"])
    @arr.push(["Nebraska", "NE"])
    @arr.push(["Nevada", "NV"])
    @arr.push(["New Hampshire", "NH"])
    @arr.push(["New Jersey", "NJ"])
    @arr.push(["New Mexico", "NM"])
    @arr.push(["New York", "NY"])
    @arr.push(["North Carolina", "NC"])
    @arr.push(["North Dakota", "ND"])
    @arr.push(["Ohio", "OH"])
    @arr.push(["Oklahoma", "OK"])
    @arr.push(["Oregon", "OR"])
    @arr.push(["Pennsylvania", "PA"])
    @arr.push(["Rhode Island", "RI"])
    @arr.push(["South Carolina", "SC"])
    @arr.push(["South Dakota", "SD"])
    @arr.push(["Tennessee", "TN"])
    @arr.push(["Texas", "TX"])
    @arr.push(["Utah", "UT"])
    @arr.push(["Vermont", "VT"])
    @arr.push(["Virginia", "VA"])
    @arr.push(["Washington", "WA"])
    @arr.push(["West Virginia", "WV"])
    @arr.push(["Wisconsin", "WI"])
    @arr.push(["Wyoming", "WY"])
    @arr.push([" ", ""])
    return @arr
  end

  def arr_states_canada
    @arr = Array.new


    @arr.push([" ", ""])
    @arr.push(["Alberta", "AB"])
    @arr.push(["British Columbia", "BC"])
    @arr.push(["Manitoba", "MB"])
    @arr.push(["New Brunswick", "NB"])  
    @arr.push(["Newfoundland and Labrador", "NL"])
    @arr.push(["Nova Scotia", "NS"])
    @arr.push(["Ontario", "ON"])
    @arr.push(["Prince Edward Island", "PE"])
    @arr.push(["Quebec", "QC"])
    @arr.push(["Saskatchewan", "SK"])
    @arr.push(["Northwest Territories", "NT"])
    @arr.push(["Nunavut", "NU"])
    @arr.push(["Yukon", "YT"])
    @arr.push([" ", ""])
    return @arr
  end

  def seed_states
    
    ### if you want to delete them all and start again...
    if params[:drop_all]
      w = WeightLossByState.find(:all)
      w.each do |state|
        state.destroy
      end
    end

    arr = arr_states_us + arr_states_canada
    arr.each do |state|
      if state[1] != ""
        weight_loss_by_state = WeightLossByState.find(:first, :conditions => "state_code = '#{state[1]}'")
        if !weight_loss_by_state

          # t.string   "state"
          # t.string   "state_code"
          # t.integer  "demog_population"
          # t.integer  "demog_percent_adults"
          # t.integer  "demog_number_adults"
          # t.integer  "demog_percent_obesity_rate"
          # t.integer  "demog_number_obese_adults"
          # t.integer  "demog_percent_of_total_obese_adults_in_challenge"
          # t.integer  "challenge_weighted_goal"
          # t.integer  "challenge_qty_hold"
          # t.integer  "challenge_qty_active"
          # t.integer  "challenge_lbs_starting_weight_hold"
          # t.integer  "challenge_lbs_starting_weight_active"
          # t.integer  "challenge_lbs_last_weight_hold"
          # t.integer  "challenge_lbs_last_weight_active"
          # t.integer  "challenge_lbs_lost_hold"
          # t.integer  "challenge_lbs_lost_active"
          # t.integer  "challenge_lbs_lost_total"
          # t.integer  "challenge_percent_of_goal_met"
          # t.integer  "challenge_number_rank"
          # t.date     "challenge_last_updated_date"
          # t.string   "js_upcolor"
          # t.string   "js_overcolor"
          # t.string   "js_downcolor"


          overall_goal = 52000000
          total_of_obese_adults_in_us_and_canada = 70827882
          pounds_per_obese_person = 0.73417414910134  ### 52,000,000 / 70,827,882

          average_percent_of_pop_that_is_18_or_older = 77

          w = WeightLossByState.new()
          w.state_code = state[1]
          w.state = state[0]
          w.demog_percent_adults = average_percent_of_pop_that_is_18_or_older


          ### no entry found for this state/province, so create it
          case w.state_code
            when "AL"
              w.country = "usa"
              w.map_code = 1
              w.demog_population = 4779736
              w.demog_percent_obesity_rate = 33 

            when "AK"
              w.country = "usa"
              w.map_code = 2
              w.demog_population = 710231
              w.demog_percent_obesity_rate = 26

            when "AZ"
              w.country = "usa"
              w.map_code = 3
              w.demog_population = 6392017
              w.demog_percent_obesity_rate = 26

            when "AR"
              w.country = "usa"
              w.map_code = 4
              w.demog_population = 2915918
              w.demog_percent_obesity_rate = 35

            when "CA"
              w.country = "usa"
              w.map_code = 5
              w.demog_population = 37253956
              w.demog_percent_obesity_rate = 25

            when "CO"
              w.country = "usa"
              w.map_code = 6
              w.demog_population = 5029196
              w.demog_percent_obesity_rate = 21

            when "CT"
              w.country = "usa"
              w.map_code = 7
              w.demog_population = 3574097
              w.demog_percent_obesity_rate = 26

            when "DE"
              w.country = "usa"
              w.map_code = 8
              w.demog_population = 897934
              w.demog_percent_obesity_rate = 27

            when "DC"
              w.country = "usa"
              w.map_code = 51
              w.demog_population = 601723
              w.demog_percent_obesity_rate = 22

            when "FL"
              w.country = "usa"
              w.map_code = 9
              w.demog_population = 18801310
              w.demog_percent_obesity_rate = 25

            when "GA"
              w.country = "usa"
              w.map_code = 10
              w.demog_population = 9687653
              w.demog_percent_obesity_rate = 29

            when "HI"
              w.country = "usa"
              w.map_code = 11
              w.demog_population = 1360301
              w.demog_percent_obesity_rate = 24

            when "ID"
              w.country = "usa"
              w.map_code = 12
              w.demog_population = 1567582
              w.demog_percent_obesity_rate = 27

            when "IL"
              w.country = "usa"
              w.map_code = 13
              w.demog_population = 12830632
              w.demog_percent_obesity_rate = 28

            when "IN"
              w.country = "usa"
              w.map_code = 14
              w.demog_population = 6483802
              w.demog_percent_obesity_rate = 31

            when "IA"
              w.country = "usa"
              w.map_code = 15
              w.demog_population = 3046355
              w.demog_percent_obesity_rate = 30

            when "KS"
              w.country = "usa"
              w.map_code = 16
              w.demog_population = 2853118
              w.demog_percent_obesity_rate = 30

            when "KY"
              w.country = "usa"
              w.map_code = 17
              w.demog_population = 4339367
              w.demog_percent_obesity_rate = 31

            when "LA"
              w.country = "usa"
              w.map_code = 18
              w.demog_population = 4533372
              w.demog_percent_obesity_rate = 35

            when "ME"
              w.country = "usa"
              w.map_code = 19
              w.demog_population = 1328361
              w.demog_percent_obesity_rate = 28

            when "MD"
              w.country = "usa"
              w.map_code = 20
              w.demog_population = 5773552
              w.demog_percent_obesity_rate = 28

            when "MA"
              w.country = "usa"
              w.map_code = 21
              w.demog_population = 6547629
              w.demog_percent_obesity_rate = 23

            when "MI"
              w.country = "usa"
              w.map_code = 22
              w.demog_population = 9883640
              w.demog_percent_obesity_rate =  31

            when "MN"
              w.country = "usa"
              w.map_code = 23
              w.demog_population = 5303925
              w.demog_percent_obesity_rate = 26

            when "MS"
              w.country = "usa"
              w.map_code = 24
              w.demog_population = 2967297
              w.demog_percent_obesity_rate = 35

            when "MO"
              w.country = "usa"
              w.map_code = 25
              w.demog_population = 5988927
              w.demog_percent_obesity_rate = 30

            when "MT"
              w.country = "usa"
              w.map_code = 26
              w.demog_population = 989415
              w.demog_percent_obesity_rate = 24

            when "NE"
              w.country = "usa"
              w.map_code = 27
              w.demog_population = 1826341
              w.demog_percent_obesity_rate = 27  ### not finding NE on the CDC site....

            when "NV"
              w.country = "usa"
              w.map_code = 28
              w.demog_population = 2700551
              w.demog_percent_obesity_rate = 26

            when "NH"
              w.country = "usa"
              w.map_code = 29
              w.demog_population = 1316470
              w.demog_percent_obesity_rate = 27

            when "NJ"
              w.country = "usa"
              w.map_code = 30
              w.demog_population = 8791894
              w.demog_percent_obesity_rate = 25

            when "NM"
              w.country = "usa"
              w.map_code = 31
              w.demog_population = 2059179
              w.demog_percent_obesity_rate = 27

            when "NY"
              w.country = "usa"
              w.map_code = 32
              w.demog_population = 19378102
              w.demog_percent_obesity_rate = 24

            when "NC"
              w.country = "usa"
              w.map_code = 33
              w.demog_population = 9535483
              w.demog_percent_obesity_rate = 30

            when "ND"
              w.country = "usa"
              w.map_code = 34
              w.demog_population = 672591
              w.demog_percent_obesity_rate = 30

            when "OH"
              w.country = "usa"
              w.map_code = 35
              w.demog_population = 11536504
              w.demog_percent_obesity_rate = 30

            when "OK"
              w.country = "usa"
              w.map_code = 36
              w.demog_population = 3751351
              w.demog_percent_obesity_rate = 32

            when "OR"
              w.country = "usa"
              w.map_code = 37
              w.demog_population = 3831074
              w.demog_percent_obesity_rate = 27

            when "PA"
              w.country = "usa"
              w.map_code = 38
              w.demog_population = 12702379
              w.demog_percent_obesity_rate = 29

            when "RI"
              w.country = "usa"
              w.map_code = 39
              w.demog_population = 1052567
              w.demog_percent_obesity_rate = 26

            when "SC"
              w.country = "usa"
              w.map_code = 40
              w.demog_population = 4625364
              w.demog_percent_obesity_rate = 32

            when "SD"
              w.country = "usa"
              w.map_code = 41
              w.demog_population = 814180
              w.demog_percent_obesity_rate = 28

            when "TN"
              w.country = "usa"
              w.map_code = 42
              w.demog_population = 6346105
              w.demog_percent_obesity_rate = 31

            when "TX"
              w.country = "usa"
              w.map_code = 43
              w.demog_population = 25145561
              w.demog_percent_obesity_rate = 29

            when "UT"
              w.country = "usa"
              w.map_code = 44
              w.demog_population = 2763885
              w.demog_percent_obesity_rate = 24

            when "VT"
              w.country = "usa"
              w.map_code = 45
              w.demog_population = 625741
              w.demog_percent_obesity_rate = 24

            when "VA"
              w.country = "usa"
              w.map_code = 46
              w.demog_population = 8001024
              w.demog_percent_obesity_rate = 27

            when "WA"
              w.country = "usa"
              w.map_code = 47
              w.demog_population = 6724540
              w.demog_percent_obesity_rate = 27

            when "WV"
              w.country = "usa"
              w.map_code = 48
              w.demog_population = 1852994
              w.demog_percent_obesity_rate = 34

            when "WI"
              w.country = "usa"
              w.map_code = 49
              w.demog_population = 5686986
              w.demog_percent_obesity_rate = 30

            when "WY"
              w.country = "usa"
              w.map_code = 50
              w.demog_population = 563626
              w.demog_percent_obesity_rate = 25

            when "AB"
              w.country = "canada"
              w.map_code = 1
              w.demog_population = 3645257
              w.demog_percent_obesity_rate = 25

            when "BC"
              w.country = "canada"
              w.map_code = 2
              w.demog_population = 4400057
              w.demog_percent_obesity_rate = 19

            when "MB"
              w.country = "canada"
              w.map_code = 3
              w.demog_population = 1208268
              w.demog_percent_obesity_rate = 28

            when "NB"
              w.country = "canada"
              w.map_code = 4
              w.demog_population = 751171
              w.demog_percent_obesity_rate = 29

            when "NL"
              w.country = "canada"
              w.map_code = 5
              w.demog_population = 514536
              w.demog_percent_obesity_rate = 34

            when "NS"
              w.country = "canada"
              w.map_code = 7
              w.demog_population = 921727
              w.demog_percent_obesity_rate = 25

            when "ON"
              w.country = "canada"
              w.map_code = 9
              w.demog_population = 12851821
              w.demog_percent_obesity_rate = 23

            when "PE"
              w.country = "canada"
              w.map_code = 10
              w.demog_population = 140204
              w.demog_percent_obesity_rate = 26

            when "QC"
              w.country = "canada"
              w.map_code = 11
              w.demog_population = 7903001
              w.demog_percent_obesity_rate = 22

            when "SK"
              w.country = "canada"
              w.map_code = 12
              w.demog_population = 1033381
              w.demog_percent_obesity_rate = 31

            when "NT"
              w.country = "canada"
              w.map_code = 6
              w.demog_population = 41462
              w.demog_percent_obesity_rate = 23 ### unknown, using Canada overall of 23

            when "NU"
              w.country = "canada"
              w.map_code = 8
              w.demog_population = 31906
              w.demog_percent_obesity_rate = 23 ### unknown, using Canada overall of 23

            when "YT"
              w.country = "canada"
              w.map_code = 13
              w.demog_population = 33897
              w.demog_percent_obesity_rate = 23 ### unknown, using Canada overall of 23

          end


          w.demog_number_adults = (((w.demog_percent_adults + 0.0) / 100) * w.demog_population).floor
          w.demog_number_obese_adults = (((w.demog_percent_obesity_rate + 0.0) / 100) *  w.demog_number_adults).floor
          # w.demog_percent_of_total_obese_adults_in_challenge = (w.demog_number_obese_adults + 0.0) / total_of_obese_adults_in_us_and_canada
          w.challenge_weighted_goal = (( w.demog_number_obese_adults + 0.0000) * pounds_per_obese_person).floor

          w.save

        end
      end
    end

  end

  # GET /weight_loss_by_states
  # GET /weight_loss_by_states.xml
  def index

    if params[:seed_states]
      seed_states
    end


    @weight_loss_by_states = WeightLossByState.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weight_loss_by_states }
    end
  end

  # GET /weight_loss_by_states/1
  # GET /weight_loss_by_states/1.xml
  def show
    @weight_loss_by_state = WeightLossByState.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @weight_loss_by_state }
    end
  end

  # GET /weight_loss_by_states/new
  # GET /weight_loss_by_states/new.xml
  def new
    @weight_loss_by_state = WeightLossByState.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weight_loss_by_state }
    end
  end

  # GET /weight_loss_by_states/1/edit
  def edit
    @weight_loss_by_state = WeightLossByState.find(params[:id])
  end

  # POST /weight_loss_by_states
  # POST /weight_loss_by_states.xml
  def create
    @weight_loss_by_state = WeightLossByState.new(params[:weight_loss_by_state])

    respond_to do |format|
      if @weight_loss_by_state.save
        flash[:notice] = 'WeightLossByState was successfully created.'
        format.html { redirect_to(@weight_loss_by_state) }
        format.xml  { render :xml => @weight_loss_by_state, :status => :created, :location => @weight_loss_by_state }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @weight_loss_by_state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weight_loss_by_states/1
  # PUT /weight_loss_by_states/1.xml
  def update
    @weight_loss_by_state = WeightLossByState.find(params[:id])

    respond_to do |format|
      if @weight_loss_by_state.update_attributes(params[:weight_loss_by_state])
        flash[:notice] = 'WeightLossByState was successfully updated.'
        format.html { redirect_to(@weight_loss_by_state) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weight_loss_by_state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /weight_loss_by_states/1
  # DELETE /weight_loss_by_states/1.xml
  def destroy
    @weight_loss_by_state = WeightLossByState.find(params[:id])
    @weight_loss_by_state.destroy

    respond_to do |format|
      format.html { redirect_to(weight_loss_by_states_url) }
      format.xml  { head :ok }
    end
  end
end
