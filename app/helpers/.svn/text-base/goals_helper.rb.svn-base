module GoalsHelper
  #def get_previous_date(goal_id, newstart)
  #  #### SHOULDN'T BE USED ANYMORE
  #
  #  @goal = Goal.find(goal_id)
  #  dnow = newstart - 1
  #  previous_date = dnow
  #
  #  ######### BEGIN GETTING THE PREVIOUS RELEVANT CHECKPOINT DAY
  #  ### skipdays support
  #  today_dayname = dnow.strftime("%A")
  #  puts "today_dayname = #{today_dayname}"
  #  puts "@goal.daym = #{@goal.daym}"
  #  if today_dayname == "Monday"
  #    if @goal.daym == true        
  #      previous_date = dnow
  #    else
  #      #Monday's not checked, go to Tuesday
  #      if @goal.dayt == true        
  #        previous_date = dnow - 1
  #      else
  #        #Tuesday's not checked, go to Wednesday
  #        if @goal.dayw == true        
  #          previous_date = dnow - 2
  #        else
  #          #Wednesday's not checked, go to Thursday
  #          if @goal.dayr == true        
  #            previous_date = dnow - 3
  #          else
  #            #Thursday's not checked, go to Friday
  #            if @goal.dayf == true        
  #              previous_date = dnow - 4
  #            else
  #              #Friday's not checked, go to Saturday
  #              if @goal.days == true        
  #                previous_date = dnow - 5
  #              else
  #                #Saturday's not checked, go to Sunday
  #                if @goal.dayn == true        
  #                  previous_date = dnow - 6
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end
  #
  #  if today_dayname == "Tuesday"
  #    puts "1"
  #    if @goal.dayt == true        
  #      puts "2"
  #      previous_date = dnow
  #    else
  #      puts "3"
  #      #Tuesday's not checked, go to Wed
  #      if @goal.dayw == true        
  #        previous_date = dnow - 1
  #      else
  #        #Wed's not checked, go to Thur
  #        if @goal.dayr == true        
  #          previous_date = dnow - 2
  #        else
  #          #Thur's not checked, go to Fri
  #          if @goal.dayf == true        
  #            previous_date = dnow - 3
  #          else
  #            #Fri's not checked, go to Sat
  #            if @goal.days == true        
  #              previous_date = dnow - 4
  #            else
  #              #Sat's not checked, go to Sun
  #              if @goal.dayn == true        
  #                previous_date = dnow - 5
  #              else
  #                #Sun's not checked, go to Mon
  #                if @goal.daym == true        
  #                  previous_date = dnow - 6
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end
  #
  #
  #
  #  if today_dayname == "Wednesday"
  #    if @goal.dayw == true        
  #      previous_date = dnow
  #    else
  #      #Wed's not checked, go to Thur
  #      if @goal.dayr == true        
  #        previous_date = dnow - 1
  #      else
  #        #Thur's not checked, go to Fri
  #        if @goal.dayf == true        
  #          previous_date = dnow - 2
  #        else
  #          #Fri's not checked, go to Sat
  #          if @goal.days == true        
  #            previous_date = dnow - 3
  #          else
  #            #Sat's not checked, go to Sun
  #            if @goal.dayn == true        
  #              previous_date = dnow - 4
  #            else
  #              #Sun's not checked, go to Mon
  #              if @goal.daym == true        
  #                previous_date = dnow - 5
  #              else
  #                #Mon's not checked, go to Tues
  #                if @goal.dayt == true        
  #                  previous_date = dnow - 6
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end
  #
  #  if today_dayname == "Thursday"
  #    if @goal.dayr == true        
  #      previous_date = dnow
  #    else
  #      #Thur's not checked, go to Fri
  #      if @goal.dayf == true        
  #        previous_date = dnow - 1
  #      else
  #        #Fri's not checked, go to Sat
  #        if @goal.days == true        
  #          previous_date = dnow - 2
  #        else
  #          #Sat's not checked, go to Sun
  #          if @goal.dayn == true        
  #            previous_date = dnow - 3
  #          else
  #            #Sun's not checked, go to Mon
  #            if @goal.daym == true        
  #              previous_date = dnow - 4
  #            else
  #              #Mon's not checked, go to Tues
  #              if @goal.dayt == true        
  #                previous_date = dnow - 5
  #              else
  #                #Tues's not checked, go to Wed
  #                if @goal.dayw == true        
  #                  previous_date = dnow - 6
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end
  #
  #  if today_dayname == "Friday"
  #    if @goal.dayf == true        
  #      previous_date = dnow
  #    else
  #      #Fri's not checked, go to Sat
  #      if @goal.days == true        
  #        previous_date = dnow - 1
  #      else
  #        #Sat's not checked, go to Sun
  #        if @goal.dayn == true        
  #          previous_date = dnow - 2
  #        else
  #          #Sun's not checked, go to Mon
  #          if @goal.daym == true        
  #            previous_date = dnow - 3
  #          else
  #            #Mon's not checked, go to Tues
  #            if @goal.dayt == true        
  #              previous_date = dnow - 4
  #            else
  #              #Tues's not checked, go to Wed
  #              if @goal.dayw == true        
  #                previous_date = dnow - 5
  #              else
  #                #Wed's not checked, go to Thur
  #                if @goal.dayr == true        
  #                  previous_date = dnow - 6
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end
  #
  #  if today_dayname == "Saturday"
  #    if @goal.days == true        
  #      previous_date = dnow
  #    else
  #      #Sat's not checked, go to Sun
  #      if @goal.dayn == true        
  #        previous_date = dnow - 1
  #      else
  #        #Sun's not checked, go to Mon
  #        if @goal.daym == true        
  #          previous_date = dnow - 2
  #        else
  #          #Mon's not checked, go to Tues
  #          if @goal.dayt == true        
  #            previous_date = dnow - 3
  #          else
  #            #Tues's not checked, go to Wed
  #            if @goal.dayw == true        
  #              previous_date = dnow - 4
  #            else
  #              #Wed's not checked, go to Thur
  #              if @goal.dayr == true        
  #                previous_date = dnow - 5
  #              else
  #                #Thur's not checked, go to Fri
  #                if @goal.dayf == true        
  #                  previous_date = dnow - 6
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end
  #
  #  if today_dayname == "Sunday"
  #    if @goal.dayn == true        
  #      previous_date = dnow
  #    else
  #      #Sun's not checked, go to Mon
  #      if @goal.daym == true        
  #        previous_date = dnow - 1
  #      else
  #        #Mon's not checked, go to Tues
  #        if @goal.dayt == true        
  #          previous_date = dnow - 2
  #        else
  #          #Tues's not checked, go to Wed
  #          if @goal.dayw == true        
  #            previous_date = dnow - 3
  #          else
  #            #Wed's not checked, go to Thur
  #            if @goal.dayr == true        
  #              previous_date = dnow - 4
  #            else
  #              #Thur's not checked, go to Fri
  #              if @goal.dayf == true        
  #                previous_date = dnow - 5
  #              else
  #                #Fri's not checked, go to Sat
  #                if @goal.days == true        
  #                  previous_date = dnow - 6
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end
  #  ######### END GETTING THE PREVIOUS RELEVANT CHECKPOINT DAY
  #
  #  return previous_date
  #  
  #end
  #
  #def set_start_date(goal_id, newstart)
  #  #### SHOULDN'T BE USED ANYMORE
  #
  #    @goal = Goal.find(goal_id)
  #    ### Once the goal is saved, set the start and stop dates
  #
  #    dnow = newstart
  #    dtomorrow = dnow + 1
  #    ######
  #
  #
  #    ######### BEGIN SETTING THE START DATE
  #    ### skipdays support
  #    today_dayname = dnow.strftime("%A")
  #    puts "today_dayname = #{today_dayname}"
  #    puts "@goal.daym = #{@goal.daym}"
  #    if today_dayname == "Monday"
  #      if @goal.daym == true        
  #        @goal.start = dnow
  #      else
  #        #Monday's not checked, go to Tuesday
  #        if @goal.dayt == true        
  #          @goal.start = dnow + 1
  #        else
  #          #Tuesday's not checked, go to Wednesday
  #          if @goal.dayw == true        
  #            @goal.start = dnow + 2
  #          else
  #            #Wednesday's not checked, go to Thursday
  #            if @goal.dayr == true        
  #              @goal.start = dnow + 3
  #            else
  #              #Thursday's not checked, go to Friday
  #              if @goal.dayf == true        
  #                @goal.start = dnow + 4
  #              else
  #                #Friday's not checked, go to Saturday
  #                if @goal.days == true        
  #                  @goal.start = dnow + 5
  #                else
  #                  #Saturday's not checked, go to Sunday
  #                  if @goal.dayn == true        
  #                    @goal.start = dnow + 6
  #                  end
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #
  #    if today_dayname == "Tuesday"
  #      puts "1"
  #      if @goal.dayt == true        
  #        puts "2"
  #        @goal.start = dnow
  #      else
  #        puts "3"
  #        #Tuesday's not checked, go to Wed
  #        if @goal.dayw == true        
  #          @goal.start = dnow + 1
  #        else
  #          #Wed's not checked, go to Thur
  #          if @goal.dayr == true        
  #            @goal.start = dnow + 2
  #          else
  #            #Thur's not checked, go to Fri
  #            if @goal.dayf == true        
  #              @goal.start = dnow + 3
  #            else
  #              #Fri's not checked, go to Sat
  #              if @goal.days == true        
  #                @goal.start = dnow + 4
  #              else
  #                #Sat's not checked, go to Sun
  #                if @goal.dayn == true        
  #                  @goal.start = dnow + 5
  #                else
  #                  #Sun's not checked, go to Mon
  #                  if @goal.daym == true        
  #                    @goal.start = dnow + 6
  #                  end
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #
  #    if today_dayname == "Wednesday"
  #      if @goal.dayw == true        
  #        @goal.start = dnow
  #      else
  #        #Wed's not checked, go to Thur
  #        if @goal.dayr == true        
  #          @goal.start = dnow + 1
  #        else
  #          #Thur's not checked, go to Fri
  #          if @goal.dayf == true        
  #            @goal.start = dnow + 2
  #          else
  #            #Fri's not checked, go to Sat
  #            if @goal.days == true        
  #              @goal.start = dnow + 3
  #            else
  #              #Sat's not checked, go to Sun
  #              if @goal.dayn == true        
  #                @goal.start = dnow + 4
  #              else
  #                #Sun's not checked, go to Mon
  #                if @goal.daym == true        
  #                  @goal.start = dnow + 5
  #                else
  #                  #Mon's not checked, go to Tues
  #                  if @goal.dayt == true        
  #                    @goal.start = dnow + 6
  #                  end
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #
  #    if today_dayname == "Thursday"
  #      if @goal.dayr == true        
  #        @goal.start = dnow
  #      else
  #        #Thur's not checked, go to Fri
  #        if @goal.dayf == true        
  #          @goal.start = dnow + 1
  #        else
  #          #Fri's not checked, go to Sat
  #          if @goal.days == true        
  #            @goal.start = dnow + 2
  #          else
  #            #Sat's not checked, go to Sun
  #            if @goal.dayn == true        
  #              @goal.start = dnow + 3
  #            else
  #              #Sun's not checked, go to Mon
  #              if @goal.daym == true        
  #                @goal.start = dnow + 4
  #              else
  #                #Mon's not checked, go to Tues
  #                if @goal.dayt == true        
  #                  @goal.start = dnow + 5
  #                else
  #                  #Tues's not checked, go to Wed
  #                  if @goal.dayw == true        
  #                    @goal.start = dnow + 6
  #                  end
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #
  #    if today_dayname == "Friday"
  #      if @goal.dayf == true        
  #        @goal.start = dnow
  #      else
  #        #Fri's not checked, go to Sat
  #        if @goal.days == true        
  #          @goal.start = dnow + 1
  #        else
  #          #Sat's not checked, go to Sun
  #          if @goal.dayn == true        
  #            @goal.start = dnow + 2
  #          else
  #            #Sun's not checked, go to Mon
  #            if @goal.daym == true        
  #              @goal.start = dnow + 3
  #            else
  #              #Mon's not checked, go to Tues
  #              if @goal.dayt == true        
  #                @goal.start = dnow + 4
  #              else
  #                #Tues's not checked, go to Wed
  #                if @goal.dayw == true        
  #                  @goal.start = dnow + 5
  #                else
  #                  #Wed's not checked, go to Thur
  #                  if @goal.dayr == true        
  #                    @goal.start = dnow + 6
  #                  end
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #
  #    if today_dayname == "Saturday"
  #      if @goal.days == true        
  #        @goal.start = dnow
  #      else
  #        #Sat's not checked, go to Sun
  #        if @goal.dayn == true        
  #          @goal.start = dnow + 1
  #        else
  #          #Sun's not checked, go to Mon
  #          if @goal.daym == true        
  #            @goal.start = dnow + 2
  #          else
  #            #Mon's not checked, go to Tues
  #            if @goal.dayt == true        
  #              @goal.start = dnow + 3
  #            else
  #              #Tues's not checked, go to Wed
  #              if @goal.dayw == true        
  #                @goal.start = dnow + 4
  #              else
  #                #Wed's not checked, go to Thur
  #                if @goal.dayr == true        
  #                  @goal.start = dnow + 5
  #                else
  #                  #Thur's not checked, go to Fri
  #                  if @goal.dayf == true        
  #                    @goal.start = dnow + 6
  #                  end
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #
  #    if today_dayname == "Sunday"
  #      if @goal.dayn == true        
  #        @goal.start = dnow
  #      else
  #        #Sun's not checked, go to Mon
  #        if @goal.daym == true        
  #          @goal.start = dnow + 1
  #        else
  #          #Mon's not checked, go to Tues
  #          if @goal.dayt == true        
  #            @goal.start = dnow + 2
  #          else
  #            #Tues's not checked, go to Wed
  #            if @goal.dayw == true        
  #              @goal.start = dnow + 3
  #            else
  #              #Wed's not checked, go to Thur
  #              if @goal.dayr == true        
  #                @goal.start = dnow + 4
  #              else
  #                #Thur's not checked, go to Fri
  #                if @goal.dayf == true        
  #                  @goal.start = dnow + 5
  #                else
  #                  #Fri's not checked, go to Sat
  #                  if @goal.days == true        
  #                    @goal.start = dnow + 6
  #                  end
  #                end
  #              end
  #            end
  #          end
  #        end
  #      end
  #    end
  #    ######### END SETTING THE START DATE
  #
  #    ### The old way of doing it, before people could choose what days of the week were relevant:
  #    #@goal.start = dnow
  #    #@goal.stop = @goal.start + 21
  #
  #    @goal.save
  #
  #  end
  #
  #  def set_stop_date(goal_id, extending)
  #    #### SHOULDN'T BE USED ANYMORE
  #
  #    @goal = Goal.find(goal_id)
  #
  #      baseline = @goal.start
  #      if extending == 1
  #        baseline = @goal.stop
  #      end
  #      
  #
  #      dnow = get_dnow
  #      dtomorrow = dnow + 1
  #      ######
  #
  #      ######### BEGIN Setting the STOP DATE
  #      counter = 1 #counts the number of "relevant" days found 
  #      test_date = baseline + 1 #test_date will keep getting incremented over both relevant and non-relevant days until counter reaches 21
  #      while counter < 21      
  #        test_dayname = test_date.strftime("%A")
  #        if test_dayname == "Monday"
  #          if @goal.daym == true
  #            test_date = test_date + 1
  #            counter = counter + 1
  #          else
  #            test_date = test_date + 1
  #          end
  #        end
  #        if test_dayname == "Tuesday"
  #          if @goal.dayt == true
  #            test_date = test_date + 1
  #            counter = counter + 1
  #          else
  #            test_date = test_date + 1
  #          end
  #        end
  #        if test_dayname == "Wednesday"
  #          if @goal.dayw == true
  #            test_date = test_date + 1
  #            counter = counter + 1
  #          else
  #            test_date = test_date + 1
  #          end
  #        end
  #        if test_dayname == "Thursday"
  #          if @goal.dayr == true
  #            test_date = test_date + 1
  #            counter = counter + 1
  #          else
  #            test_date = test_date + 1
  #          end
  #        end
  #        if test_dayname == "Friday"
  #          if @goal.dayf == true
  #            test_date = test_date + 1
  #            counter = counter + 1
  #          else
  #            test_date = test_date + 1
  #          end
  #        end
  #        if test_dayname == "Saturday"
  #          if @goal.dayn == true
  #            test_date = test_date + 1
  #            counter = counter + 1
  #          else
  #            test_date = test_date + 1
  #          end
  #        end
  #        if test_dayname == "Sunday"
  #          if @goal.dayn == true
  #            test_date = test_date + 1
  #            counter = counter + 1
  #          else
  #            test_date = test_date + 1
  #          end
  #        end
  #      end
  #      @goal.stop = test_date
  #      ######### END Setting the STOP DATE
  #
  #      ### The old way of doing it, before people could choose what days of the week were relevant:
  #      #@goal.start = dnow
  #      #@goal.stop = @goal.start + 21
  #
  #      @goal.save
  #      #return
  #    end  
end
