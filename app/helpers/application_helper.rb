require "logger"







####################################33
####################################33
####################################33
####################################33
####################################33
####################################33
####################################33
####################################33
###### NOTE I BELIEVE THESE FUNCTIONS ARE ONLY AVAILABLE TO VIEWS, NOT MODELS !!!!!
###### NOTE I BELIEVE THESE FUNCTIONS ARE ONLY AVAILABLE TO VIEWS, NOT MODELS !!!!!
###### NOTE I BELIEVE THESE FUNCTIONS ARE ONLY AVAILABLE TO VIEWS, NOT MODELS !!!!!
###### NOTE I BELIEVE THESE FUNCTIONS ARE ONLY AVAILABLE TO VIEWS, NOT MODELS !!!!!
###### NOTE I BELIEVE THESE FUNCTIONS ARE ONLY AVAILABLE TO VIEWS, NOT MODELS !!!!!
###### NOTE I BELIEVE THESE FUNCTIONS ARE ONLY AVAILABLE TO VIEWS, NOT MODELS !!!!!
###### NOTE I BELIEVE THESE FUNCTIONS ARE ONLY AVAILABLE TO VIEWS, NOT MODELS !!!!!
####################################33
####################################33
####################################33
####################################33
####################################33


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

  #### convert a date of this format: 2012-01-01 into a date of the same essential format but "not a string"
  def to_date(date_string) 	   
    arr_date_string = date_string.split("-")
    date_string_as_date = Date.new(arr_date_string[0], arr_date_string[1], arr_date_string[2])
    return date_string_as_date
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


  def arr_countries
    @arr = Array.new

    @arr.push([" ", ""])
    @arr.push(["UNITED STATES", "US"])
    @arr.push(["CANADA", "CA"])
    @arr.push([" ----------------", ""])
    @arr.push(["AFGHANISTAN", "AF"])
    @arr.push(["ÅLAND ISLANDS", "AX"])
    @arr.push(["ALBANIA", "AL"])
    @arr.push(["ALGERIA", "DZ"])
    @arr.push(["AMERICAN SAMOA", "AS"])
    @arr.push(["ANDORRA", "AD"])
    @arr.push(["ANGOLA", "AO"])
    @arr.push(["ANGUILLA", "AI"])
    @arr.push(["ANTARCTICA", "AQ"])
    @arr.push(["ANTIGUA AND BARBUDA", "AG"])
    @arr.push(["ARGENTINA", "AR"])
    @arr.push(["ARMENIA", "AM"])
    @arr.push(["ARUBA", "AW"])
    @arr.push(["AUSTRALIA", "AU"])
    @arr.push(["AUSTRIA", "AT"])
    @arr.push(["AZERBAIJAN", "AZ"])
    @arr.push(["BAHAMAS", "BS"])
    @arr.push(["BAHRAIN", "BH"])
    @arr.push(["BANGLADESH", "BD"])
    @arr.push(["BARBADOS", "BB"])
    @arr.push(["BELARUS", "BY"])
    @arr.push(["BELGIUM", "BE"])
    @arr.push(["BELIZE", "BZ"])
    @arr.push(["BENIN", "BJ"])
    @arr.push(["BERMUDA", "BM"])
    @arr.push(["BHUTAN", "BT"])
    @arr.push(["BOLIVIA, PLURINATIONAL STATE OF", "BO"])
    @arr.push(["BONAIRE, SINT EUSTATIUS AND SABA", "BQ"])
    @arr.push(["BOSNIA AND HERZEGOVINA", "BA"])
    @arr.push(["BOTSWANA", "BW"])
    @arr.push(["BOUVET ISLAND", "BV"])
    @arr.push(["BRAZIL", "BR"])
    @arr.push(["BRITISH INDIAN OCEAN TERRITORY", "IO"])
    @arr.push(["BRUNEI DARUSSALAM", "BN"])
    @arr.push(["BULGARIA", "BG"])
    @arr.push(["BURKINA FASO", "BF"])
    @arr.push(["BURUNDI", "BI"])
    @arr.push(["CAMBODIA", "KH"])
    @arr.push(["CAMEROON", "CM"])
    @arr.push(["CANADA", "CA"])
    @arr.push(["CAPE VERDE", "CV"])
    @arr.push(["CAYMAN ISLANDS", "KY"])
    @arr.push(["CENTRAL AFRICAN REPUBLIC", "CF"])
    @arr.push(["CHAD", "TD"])
    @arr.push(["CHILE", "CL"])
    @arr.push(["CHINA", "CN"])
    @arr.push(["CHRISTMAS ISLAND", "CX"])
    @arr.push(["COCOS (KEELING) ISLANDS", "CC"])
    @arr.push(["COLOMBIA", "CO"])
    @arr.push(["COMOROS", "KM"])
    @arr.push(["CONGO", "CG"])
    @arr.push(["CONGO, THE DEMOCRATIC REPUBLIC OF THE", "CD"])
    @arr.push(["COOK ISLANDS", "CK"])
    @arr.push(["COSTA RICA", "CR"])
    @arr.push(["CROATIA", "HR"])
    @arr.push(["CUBA", "CU"])
    @arr.push(["CURAÇAO", "CW"])
    @arr.push(["CYPRUS", "CY"])
    @arr.push(["CZECH REPUBLIC", "CZ"])
    @arr.push(["CÔTE D'IVOIRE", "CI"])
    @arr.push(["DENMARK", "DK"])
    @arr.push(["DJIBOUTI", "DJ"])
    @arr.push(["DOMINICA", "DM"])
    @arr.push(["DOMINICAN REPUBLIC", "DO"])
    @arr.push(["ECUADOR", "EC"])
    @arr.push(["EGYPT", "EG"])
    @arr.push(["EL SALVADOR", "SV"])
    @arr.push(["EQUATORIAL GUINEA", "GQ"])
    @arr.push(["ERITREA", "ER"])
    @arr.push(["ESTONIA", "EE"])
    @arr.push(["ETHIOPIA", "ET"])
    @arr.push(["FALKLAND ISLANDS (MALVINAS)", "FK"])
    @arr.push(["FAROE ISLANDS", "FO"])
    @arr.push(["FIJI", "FJ"])
    @arr.push(["FINLAND", "FI"])
    @arr.push(["FRANCE", "FR"])
    @arr.push(["FRENCH GUIANA", "GF"])
    @arr.push(["FRENCH POLYNESIA", "PF"])
    @arr.push(["FRENCH SOUTHERN TERRITORIES", "TF"])
    @arr.push(["GABON", "GA"])
    @arr.push(["GAMBIA", "GM"])
    @arr.push(["GEORGIA", "GE"])
    @arr.push(["GERMANY", "DE"])
    @arr.push(["GHANA", "GH"])
    @arr.push(["GIBRALTAR", "GI"])
    @arr.push(["GREECE", "GR"])
    @arr.push(["GREENLAND", "GL"])
    @arr.push(["GRENADA", "GD"])
    @arr.push(["GUADELOUPE", "GP"])
    @arr.push(["GUAM", "GU"])
    @arr.push(["GUATEMALA", "GT"])
    @arr.push(["GUERNSEY", "GG"])
    @arr.push(["GUINEA", "GN"])
    @arr.push(["GUINEA-BISSAU", "GW"])
    @arr.push(["GUYANA", "GY"])
    @arr.push(["HAITI", "HT"])
    @arr.push(["HEARD ISLAND AND MCDONALD ISLANDS", "HM"])
    @arr.push(["HOLY SEE (VATICAN CITY STATE)", "VA"])
    @arr.push(["HONDURAS", "HN"])
    @arr.push(["HONG KONG", "HK"])
    @arr.push(["HUNGARY", "HU"])
    @arr.push(["ICELAND", "IS"])
    @arr.push(["INDIA", "IN"])
    @arr.push(["INDONESIA", "ID"])
    @arr.push(["IRAN, ISLAMIC REPUBLIC OF", "IR"])
    @arr.push(["IRAQ", "IQ"])
    @arr.push(["IRELAND", "IE"])
    @arr.push(["ISLE OF MAN", "IM"])
    @arr.push(["ISRAEL", "IL"])
    @arr.push(["ITALY", "IT"])
    @arr.push(["JAMAICA", "JM"])
    @arr.push(["JAPAN", "JP"])
    @arr.push(["JERSEY", "JE"])
    @arr.push(["JORDAN", "JO"])
    @arr.push(["KAZAKHSTAN", "KZ"])
    @arr.push(["KENYA", "KE"])
    @arr.push(["KIRIBATI", "KI"])
    @arr.push(["KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF", "KP"])
    @arr.push(["KOREA, REPUBLIC OF", "KR"])
    @arr.push(["KUWAIT", "KW"])
    @arr.push(["KYRGYZSTAN", "KG"])
    @arr.push(["LAO PEOPLE'S DEMOCRATIC REPUBLIC", "LA"])
    @arr.push(["LATVIA", "LV"])
    @arr.push(["LEBANON", "LB"])
    @arr.push(["LESOTHO", "LS"])
    @arr.push(["LIBERIA", "LR"])
    @arr.push(["LIBYA", "LY"])
    @arr.push(["LIECHTENSTEIN", "LI"])
    @arr.push(["LITHUANIA", "LT"])
    @arr.push(["LUXEMBOURG", "LU"])
    @arr.push(["MACAO", "MO"])
    @arr.push(["MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF", "MK"])
    @arr.push(["MADAGASCAR", "MG"])
    @arr.push(["MALAWI", "MW"])
    @arr.push(["MALAYSIA", "MY"])
    @arr.push(["MALDIVES", "MV"])
    @arr.push(["MALI", "ML"])
    @arr.push(["MALTA", "MT"])
    @arr.push(["MARSHALL ISLANDS", "MH"])
    @arr.push(["MARTINIQUE", "MQ"])
    @arr.push(["MAURITANIA", "MR"])
    @arr.push(["MAURITIUS", "MU"])
    @arr.push(["MAYOTTE", "YT"])
    @arr.push(["MEXICO", "MX"])
    @arr.push(["MICRONESIA, FEDERATED STATES OF", "FM"])
    @arr.push(["MOLDOVA, REPUBLIC OF", "MD"])
    @arr.push(["MONACO", "MC"])
    @arr.push(["MONGOLIA", "MN"])
    @arr.push(["MONTENEGRO", "ME"])
    @arr.push(["MONTSERRAT", "MS"])
    @arr.push(["MOROCCO", "MA"])
    @arr.push(["MOZAMBIQUE", "MZ"])
    @arr.push(["MYANMAR", "MM"])
    @arr.push(["NAMIBIA", "NA"])
    @arr.push(["NAURU", "NR"])
    @arr.push(["NEPAL", "NP"])
    @arr.push(["NETHERLANDS", "NL"])
    @arr.push(["NEW CALEDONIA", "NC"])
    @arr.push(["NEW ZEALAND", "NZ"])
    @arr.push(["NICARAGUA", "NI"])
    @arr.push(["NIGER", "NE"])
    @arr.push(["NIGERIA", "NG"])
    @arr.push(["NIUE", "NU"])
    @arr.push(["NORFOLK ISLAND", "NF"])
    @arr.push(["NORTHERN MARIANA ISLANDS", "MP"])
    @arr.push(["NORWAY", "NO"])
    @arr.push(["OMAN", "OM"])
    @arr.push(["PAKISTAN", "PK"])
    @arr.push(["PALAU", "PW"])
    @arr.push(["PALESTINE, STATE OF", "PS"])
    @arr.push(["PANAMA", "PA"])
    @arr.push(["PAPUA NEW GUINEA", "PG"])
    @arr.push(["PARAGUAY", "PY"])
    @arr.push(["PERU", "PE"])
    @arr.push(["PHILIPPINES", "PH"])
    @arr.push(["PITCAIRN", "PN"])
    @arr.push(["POLAND", "PL"])
    @arr.push(["PORTUGAL", "PT"])
    @arr.push(["PUERTO RICO", "PR"])
    @arr.push(["QATAR", "QA"])
    @arr.push(["RÉUNION", "RE"])
    @arr.push(["ROMANIA", "RO"])
    @arr.push(["RUSSIAN FEDERATION", "RU"])
    @arr.push(["RWANDA", "RW"])
    @arr.push(["SAINT BARTHÉLEMY", "BL"])
    @arr.push(["SAINT HELENA, ASCENSION AND TRISTAN DA CUNHA", "SH"])
    @arr.push(["SAINT KITTS AND NEVIS", "KN"])
    @arr.push(["SAINT LUCIA", "LC"])
    @arr.push(["SAINT MARTIN (FRENCH PART)", "MF"])
    @arr.push(["SAINT PIERRE AND MIQUELON", "PM"])
    @arr.push(["SAINT VINCENT AND THE GRENADINES", "VC"])
    @arr.push(["SAMOA", "WS"])
    @arr.push(["SAN MARINO", "SM"])
    @arr.push(["SAO TOME AND PRINCIPE", "ST"])
    @arr.push(["SAUDI ARABIA", "SA"])
    @arr.push(["SENEGAL", "SN"])
    @arr.push(["SERBIA", "RS"])
    @arr.push(["SEYCHELLES", "SC"])
    @arr.push(["SIERRA LEONE", "SL"])
    @arr.push(["SINGAPORE", "SG"])
    @arr.push(["SINT MAARTEN (DUTCH PART)", "SX"])
    @arr.push(["SLOVAKIA", "SK"])
    @arr.push(["SLOVENIA", "SI"])
    @arr.push(["SOLOMON ISLANDS", "SB"])
    @arr.push(["SOMALIA", "SO"])
    @arr.push(["SOUTH AFRICA", "ZA"])
    @arr.push(["SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS", "GS"])
    @arr.push(["SOUTH SUDAN", "SS"])
    @arr.push(["SPAIN", "ES"])
    @arr.push(["SRI LANKA", "LK"])
    @arr.push(["SUDAN", "SD"])
    @arr.push(["SURINAME", "SR"])
    @arr.push(["SVALBARD AND JAN MAYEN", "SJ"])
    @arr.push(["SWAZILAND", "SZ"])
    @arr.push(["SWEDEN", "SE"])
    @arr.push(["SWITZERLAND", "CH"])
    @arr.push(["SYRIAN ARAB REPUBLIC", "SY"])
    @arr.push(["TAIWAN, PROVINCE OF CHINA", "TW"])
    @arr.push(["TAJIKISTAN", "TJ"])
    @arr.push(["TANZANIA, UNITED REPUBLIC OF", "TZ"])
    @arr.push(["THAILAND", "TH"])
    @arr.push(["TIMOR-LESTE", "TL"])
    @arr.push(["TOGO", "TG"])
    @arr.push(["TOKELAU", "TK"])
    @arr.push(["TONGA", "TO"])
    @arr.push(["TRINIDAD AND TOBAGO", "TT"])
    @arr.push(["TUNISIA", "TN"])
    @arr.push(["TURKEY", "TR"])
    @arr.push(["TURKMENISTAN", "TM"])
    @arr.push(["TURKS AND CAICOS ISLANDS", "TC"])
    @arr.push(["TUVALU", "TV"])
    @arr.push(["UGANDA", "UG"])
    @arr.push(["UKRAINE", "UA"])
    @arr.push(["UNITED ARAB EMIRATES", "AE"])
    @arr.push(["UNITED KINGDOM", "GB"])
    @arr.push(["UNITED STATES", "US"])
    @arr.push(["UNITED STATES MINOR OUTLYING ISLANDS", "UM"])
    @arr.push(["URUGUAY", "UY"])
    @arr.push(["UZBEKISTAN", "UZ"])
    @arr.push(["VANUATU", "VU"])
    @arr.push(["VENEZUELA, BOLIVARIAN REPUBLIC OF", "VE"])
    @arr.push(["VIET NAM", "VN"])
    @arr.push(["VIRGIN ISLANDS, BRITISH", "VG"])
    @arr.push(["VIRGIN ISLANDS, U.S.", "VI"])
    @arr.push(["WALLIS AND FUTUNA", "WF"])
    @arr.push(["WESTERN SAHARA", "EH"])
    @arr.push(["YEMEN", "YE"])
    @arr.push(["ZAMBIA", "ZM"])
    @arr.push(["ZIMBABWE", "ZW"])


    return @arr
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
      @arr.push(["Caffeine Reduction", "Caffeine Reduction"])
      @arr.push(["Learning, Studying, Practice and Education", "Learning, Studying, Practice and Education"])
      @arr.push(["Smoking", "Smoking"])
      @arr.push(["Spirituality, Meditation and Prayer", "Spirituality, Meditation and Prayer"])
      @arr.push(["PMO", "PMO"])

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
