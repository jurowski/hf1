// testjs.js contains the following code
(function(){
  var url = "http://www.habitforge.com/widget/start_princeton_club";
  var current_location = window.location.hostname;
  url += "?" + "host=" + current_location + "&key="+unique_key_each_host;


  //if (!/^http:\/\/([a-z0-9]+\.)?(habitforge\.com|discovery\.com)/.test(top.location.href)) {
  //  alert('The HabitForge Widget is currently only available by invite only. Email support@habitforge.com for more details.');
  //  return;
  //}
  //if (!/^http:\/\/([a-z0-9]+\.)?habitforge\.com/.test(document.referrer)) {
  //  alert('The HabitForge Widget is currently only available by invite only.');
  //  return;
  //}


		document.write("<div style='margin-left:100px;width:400px;height:370px;border-style:none;border:0px;background:url(http://www.habitforge.com/images/widget_background_333x285.png);background-repeat:no-repeat;'>");


			document.write("<div style='margin-top:0px;padding-left:-13px;padding-right:3px;padding-top:0px;'>");
			document.write("hi");
                        document.write("<span style='font-size:120%;font-weight:900;'>Create a Princeton Club<br>Workout Habit in 21 days!</span>");

			document.write("<iframe width='320' height='235' scrolling='yes' src='http://www.habitforge.com/widget/start_princeton_club?affiliate_name=princeton_club&widget_goal=doing cardio or strength training at the Princeton Club&weekdays_only=false'></iframe>");
			document.write("</div>");
			document.write("<table cellpadding=0 cellspacing=0 border=0>");
				document.write("<tr>");
					document.write("<td nowrap>");
						document.write("<a href='http://habitforge.com' target='_blank'><img src='http://www.habitforge.com/images/habitforge_logo_widget.png' height=15px border=0 ></a>");
					document.write("</td>");
					document.write("<td nowrap width=130px>");
						document.write("&nbsp");
					document.write("</td>");
					document.write("<td>");
					document.write("</td>");
				document.write("</tr>");
			document.write("</table>");
		document.write("</div>");

})()
