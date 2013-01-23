# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_dnow
    ### GET DATE NOW ###
    jump_forward_days = 0

    tnow = Time.new()

    if current_user

      Time.zone = current_user.time_zone
      if Time.zone != nil
          tnow = Time.zone.now #User time
      else
          tnow = Time.now #User time
      end

    else
      if params[:u]
        ### a user might not be logged in, but if they're coming from autoupdate or autoupdatemultiple, we can still determine their local datetime
        current_user = User.find(params[:u])
        if current_user != nil
          Time.zone = current_user.time_zone


          if Time.zone != nil
              tnow = Time.zone.now #User time
          else
              tnow = Time.now #User time
          end

        end
      end
      tnow = Time.now
    end

    tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
    tnow_m = tnow.strftime("%m").to_i #month of the year
    tnow_d = tnow.strftime("%d").to_i #day of the month
    tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
    tnow_M = tnow.strftime("%M").to_i #minute of the hour
    #puts tnow_Y + tnow_m + tnow_d  
    #puts "Current timestamp is #{tnow.to_s}"
    dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
    ######
    return dnow
  end


  def arr_all_habitforge_supporting_members
      supporting_members = User.find(:all, :conditions => "kill_ads_until is not null and kill_ads_until >= '#{current_user.dtoday}'")
      return supporting_members
  end

  def arr_all_habitforge_supporting_members_opted_in_random_fire_except_current_user
      supporting_members = User.find(:all, :conditions => "kill_ads_until is not null and kill_ads_until >= '#{current_user.dtoday}' and opt_in_random_fire = '1' and email != '#{current_user.email}'")
      return supporting_members
  end


  def arr_tags
    @arr = Array.new

    @tags = Tag.all
    for tag in @tags
        @arr.push([tag.name,tag.id])
    end
    
    return @arr
  end
  
  def arr_goaltemplates
    @arr = Array.new

    @goaltemplates = Goaltemplate.all
    for goaltemplate in @goaltemplates
        @arr.push([goaltemplate.title,goaltemplate.id])
    end
    
    return @arr
  end

  def arr_categories_with_goaltemplates
    categories_w_goaltemplates = Array.new
    for arr_goal_category in arr_goal_categories
        goaltemplates = Goaltemplate.find(:all, :conditions => "category = '#{arr_goal_category[1]}'")
        if goaltemplates.size > 0
            categories_w_goaltemplates.push([arr_goal_category])
        end
    end
    return categories_w_goaltemplates
  end

  def arr_goaltemplates_in_category(category)
      goaltemplates = Goaltemplate.find(:all, :conditions => "category = '#{category[1]}'")
      return goaltemplates
  end


  
  def arr_goal_categories
    @arr = Array.new
    if session[:sponsor] == "clearworth"
      @arr.push(["", "None"])
      @arr.push(["Exercise / fitness", "Exercise - fitness"])
      @arr.push(["Health / diet / water", "Health - diet - water"])
      @arr.push(["Early to bed...", "Early to bed..."])
      @arr.push(["Creating", "Creating"])
      @arr.push(["Reading ", "Reading "])
      @arr.push(["Art / drawing / painting", "Art - drawing - painting"])
      @arr.push(["Dance / expressive arts", "Dance - expressive arts"])
      @arr.push(["Writing / literature", "Writing - literature"])
      @arr.push(["Languages", "Languages"])
      @arr.push(["Music", "Music"])
      @arr.push(["Photography", "Photography"])
      @arr.push(["Textiles", "Textiles"])
      @arr.push(["Learning / studying", "Learning - studying"])
      @arr.push(["Practice / education", "Practice - education"])
      @arr.push(["Thinking", "Thinking"])
      @arr.push(["Meditation / mindfulness", "Meditation - mindfulness"])
      @arr.push(["Values", "Values"])
      @arr.push(["Spirituality", "Spirituality"])
      @arr.push(["Prayer", "Prayer"])
      @arr.push(["Feelings", "Feelings"])
      @arr.push(["Personal", "Personal"])
      @arr.push(["Friends and family", "Friends and family"])
      @arr.push(["Work / life balance", "Work - life balance"])
      @arr.push(["Financial", "Financial"])
      @arr.push(["Planning", "Planning"])
      @arr.push(["Cleaning and organising", "Cleaning and organising"])
      @arr.push(["Smoking / drinking / drugs", "Smoking - drinking - drugs"])
      @arr.push(["Business / career", "Business - career"])
      @arr.push(["Networking / marketing Presenting / communications", "Networking - marketing Presenting - communications"])
      @arr.push(["Strategy / change", "Strategy - change"])
      @arr.push(["Influence / conflict", "Influence - conflict"])
      @arr.push(["Other", "Other"])
    else
      @arr.push(["", "None"])
      @arr.push(["Exercise", "Exercise"])
      @arr.push(["Diet, Healthy Foods and Water", "Diet, Healthy Foods and Water"])
      @arr.push(["Learning, Studying, Practice and Education", "Learning, Studying, Practice and Education"])
      @arr.push(["Smoking", "Smoking"])
      @arr.push(["Spirituality, Meditation and Prayer", "Spirituality, Meditation and Prayer"])

      @arr.push(["", "None"])
      @arr.push(["", "None"])


      @arr.push(["Drawing and Painting", "Drawing and Painting"])
      @arr.push(["Music", "Music"])
      @arr.push(["Photography", "Photography"])
      @arr.push(["Reading", "Reading"])
      @arr.push(["Writing", "Writing"])

      @arr.push(["", "None"])
      @arr.push(["", "None"])

      @arr.push(["Brush", "Brush"])
      @arr.push(["Career", "Career"])
      @arr.push(["Cleaning and Organizing", "Cleaning and Organizing"])
      @arr.push(["Drinking", "Drinking"])
      @arr.push(["Drugs", "Drugs"])
      @arr.push(["Early to Bed, Early to Rise", "Early to Bed, Early to Rise"])
      @arr.push(["Family", "Family"])
      @arr.push(["Financial", "Financial"])
      @arr.push(["Floss", "Floss"])
      @arr.push(["Focus", "Focus"]) 
      @arr.push(["Gratitude", "Gratitude"]) 
      @arr.push(["Happiness", "Happiness"]) 
      @arr.push(["Love", "Love"]) 
      @arr.push(["Planning", "Planning"])
      @arr.push(["Productivity", "Productivity"])
      @arr.push(["Positive Thought", "Positive Thought"])
      @arr.push(["Relationships", "Relationships"])
      @arr.push(["Other", "Other"])      
    end
    return @arr
  end

end
