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
              w.demog_population = 4779736
              w.demog_percent_obesity_rate = 32 

            when "AK"
              w.demog_population = 710231
              w.demog_percent_obesity_rate = 25

            when "AZ"
              w.demog_population = 6392017
              w.demog_percent_obesity_rate = 24

            when "AR"
              w.demog_population = 2915918
              w.demog_percent_obesity_rate = 30

            when "CA"
              w.demog_population = 37253956
              w.demog_percent_obesity_rate = 24

            when "CO"
              w.demog_population = 5029196
              w.demog_percent_obesity_rate = 21

            when "CT"
              w.demog_population = 3574097
              w.demog_percent_obesity_rate = 23

            when "DE"
              w.demog_population = 897934
              w.demog_percent_obesity_rate = 28

            when "DC"
              w.demog_population = 601723
              w.demog_percent_obesity_rate = 27 ### unknown, using 27 for Maryland MD, same as national avg

            when "FL"
              w.demog_population = 18801310
              w.demog_percent_obesity_rate = 27

            when "GA"
              w.demog_population = 9687653
              w.demog_percent_obesity_rate = 30

            when "HI"
              w.demog_population = 1360301
              w.demog_percent_obesity_rate = 23

            when "ID"
              w.demog_population = 1567582
              w.demog_percent_obesity_rate = 27

            when "IL"
              w.demog_population = 12830632
              w.demog_percent_obesity_rate = 28

            when "IN"
              w.demog_population = 6483802
              w.demog_percent_obesity_rate = 30

            when "IA"
              w.demog_population = 3046355
              w.demog_percent_obesity_rate = 28

            when "KS"
              w.demog_population = 2853118
              w.demog_percent_obesity_rate = 29

            when "KY"
              w.demog_population = 4339367
              w.demog_percent_obesity_rate = 31

            when "LA"
              w.demog_population = 4533372
              w.demog_percent_obesity_rate = 31

            when "ME"
              w.demog_population = 1328361
              w.demog_percent_obesity_rate = 27

            when "MD"
              w.demog_population = 5773552
              w.demog_percent_obesity_rate = 27

            when "MA"
              w.demog_population = 6547629
              w.demog_percent_obesity_rate = 23

            when "MI"
              w.demog_population = 9883640
              w.demog_percent_obesity_rate =  31

            when "MN"
              w.demog_population = 5303925
              w.demog_percent_obesity_rate = 25

            when "MS"
              w.demog_population = 2967297
              w.demog_percent_obesity_rate = 34

            when "MO"
              w.demog_population = 5988927
              w.demog_percent_obesity_rate = 31

            when "MT"
              w.demog_population = 989415
              w.demog_percent_obesity_rate = 23

            when "NE"
              w.demog_population = 1826341
              w.demog_percent_obesity_rate = 27

            when "NV"
              w.demog_population = 2700551
              w.demog_percent_obesity_rate = 22

            when "NH"
              w.demog_population = 1316470
              w.demog_percent_obesity_rate = 25

            when "NJ"
              w.demog_population = 8791894
              w.demog_percent_obesity_rate = 24

            when "NM"
              w.demog_population = 2059179
              w.demog_percent_obesity_rate = 25

            when "NY"
              w.demog_population = 19378102
              w.demog_percent_obesity_rate = 24

            when "NC"
              w.demog_population = 9535483
              w.demog_percent_obesity_rate = 28

            when "ND"
              w.demog_population = 672591
              w.demog_percent_obesity_rate = 27

            when "OH"
              w.demog_population = 11536504
              w.demog_percent_obesity_rate = 29

            when "OK"
              w.demog_population = 3751351
              w.demog_percent_obesity_rate = 30

            when "OR"
              w.demog_population = 3831074
              w.demog_percent_obesity_rate = 27

            when "PA"
              w.demog_population = 12702379
              w.demog_percent_obesity_rate = 29

            when "RI"
              w.demog_population = 1052567
              w.demog_percent_obesity_rate = 26

            when "SC"
              w.demog_population = 4625364
              w.demog_percent_obesity_rate = 32

            when "SD"
              w.demog_population = 814180
              w.demog_percent_obesity_rate = 27

            when "TN"
              w.demog_population = 6346105
              w.demog_percent_obesity_rate = 31

            when "TX"
              w.demog_population = 25145561
              w.demog_percent_obesity_rate = 31

            when "UT"
              w.demog_population = 2763885
              w.demog_percent_obesity_rate = 23

            when "VT"
              w.demog_population = 625741
              w.demog_percent_obesity_rate = 23

            when "VA"
              w.demog_population = 8001024
              w.demog_percent_obesity_rate = 26

            when "WA"
              w.demog_population = 6724540
              w.demog_percent_obesity_rate = 26

            when "WV"
              w.demog_population = 1852994
              w.demog_percent_obesity_rate = 33

            when "WI"
              w.demog_population = 5686986
              w.demog_percent_obesity_rate = 26

            when "WY"
              w.demog_population = 563626
              w.demog_percent_obesity_rate = 25

            when "AB"
              w.demog_population = 3645257
              w.demog_percent_obesity_rate = 25

            when "BC"
              w.demog_population = 4400057
              w.demog_percent_obesity_rate = 19

            when "MB"
              w.demog_population = 1208268
              w.demog_percent_obesity_rate = 28

            when "NB"
              w.demog_population = 751171
              w.demog_percent_obesity_rate = 29

            when "NL"
              w.demog_population = 514536
              w.demog_percent_obesity_rate = 34

            when "NS"
              w.demog_population = 921727
              w.demog_percent_obesity_rate = 25

            when "ON"
              w.demog_population = 12851821
              w.demog_percent_obesity_rate = 23

            when "PE"
              w.demog_population = 140204
              w.demog_percent_obesity_rate = 26

            when "QC"
              w.demog_population = 7903001
              w.demog_percent_obesity_rate = 22

            when "SK"
              w.demog_population = 1033381
              w.demog_percent_obesity_rate = 31

            when "NT"
              w.demog_population = 41462
              w.demog_percent_obesity_rate = 23 ### unknown, using Canada overall of 23

            when "NU"
              w.demog_population = 31906
              w.demog_percent_obesity_rate = 23 ### unknown, using Canada overall of 23

            when "YT"
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
