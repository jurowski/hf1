// testjs.js contains the following code
(function(){
  var url = "http://www.habitforge.com/widget/start_any";
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

  // sample url generated : http://www.quarkruby.com/show_data?host=quarkruby.com&width=200&key=quarkruby_123
  document.write("<div style='width:326px;height:209px;border-style:none;border:0px;background:url(http://www.habitforge.com/images/widget_bg_326x209.png);'>");
  document.write("<div style='margin-left:10px;'><img src='http://www.habitforge.com/images/habitforge_slogan.png' border=0 ></div>");
  document.write("<div style='margin-top:0px;padding-left:3px;padding-right:3px;padding-top:0px;'><iframe src='" + url + "' width='320' height='160' frameborder='0'></iframe></div>");
  document.write("<br>");
  //increase page rank with linking outside the iframe
  document.write("<div style='margin-top:-20px;margin-left:100px;><a href='http://habitforge.com' target='_blank' onclick=\"window.open('http://habitforge.com', 'newwindow', config='height=300,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=yes,directories=no,status=no'); return false\"><img src='http://www.habitforge.com/images/habitforge_logo_widget.png' border=0 height=25px></a></div>");
  document.write("</div>");
})()
