// var map_config = {
// 	'default':{
// 		'bordercolor':'#9CA8B6', //inter-province borders
// 		'shadowcolor':'#000000', //shadow color below the map
// 		'shadowOpacity':'50', //shadow opacity, value, 0-100
// 		'namescolor':'#666666', //color of the abbreviations 
// 		'namesShadowColor':'#666666', //tooltip shadow color
// 		'msg_title':'52 Million Pound Challenge',//default title text
// 		'msg_data': 'Click the name of a province to view details',//default content text
// 	},
// 	'map_1':{
// 		'namesId':'AB',//name's ID (Don't change it)
// 		'name': 'ALBERTA',  //province name
// 		'data':'Data of Alberta',//data appears in the text box when a user clicks this province
// 		'upcolor':'#EBECED', //province's color when page loads
// 		'overcolor':'#99CC00', //province's color when mouse hover
// 		'downcolor':'#993366',//province's color when mouse clicking
// 		'enable':true,//true/false to enable/disable this province
// 	},

// 	...

// 	'map_14':{
// 		'name': 'OTTAWA',
// 		'data':'Data of Ottawa',
// 		'upcolor':'#FF0000',
// 		'overcolor':'#99CC00',
// 		'downcolor':'#993366',
// 		'enable':true,
// 	},
// }

var map_config = {
	'default':{
		'bordercolor':'#9CA8B6', //inter-province borders
		'shadowcolor':'#000000', //shadow color below the map
		'shadowOpacity':'50', //shadow opacity, value, 0-100
		'namescolor':'#666666', //color of the abbreviations 
		'namesShadowColor':'#666666', //tooltip shadow color
		'msg_title':'52 Million Pound Challenge',//default title text
		'msg_data': 'Click the name of a province to view details',//default content text
	},
  'map_1':{
      'namesId':'AB',
      'name':'ALBERTA',
      'data':'<div> Weighted Goal*: <strong>Lose 515,178 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     AB Obesity Rate: <strong>25%**</strong>     <br>Est # of Obese Adults: <strong>701,711</strong> </div> <h3>*Goal based on est. # of obese adults in AB</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_2':{
      'namesId':'BC',
      'name':'BRITISH COLUMBIA',
      'data':'<div> Weighted Goal*: <strong>Lose 472,608 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     BC Obesity Rate: <strong>19%**</strong>     <br>Est # of Obese Adults: <strong>643,728</strong> </div> <h3>*Goal based on est. # of obese adults in BC</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_3':{
      'namesId':'MB',
      'name':'MANITOBA',
      'data':'<div> Weighted Goal*: <strong>Lose 191,253 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     MB Obesity Rate: <strong>28%**</strong>     <br>Est # of Obese Adults: <strong>260,502</strong> </div> <h3>*Goal based on est. # of obese adults in MB</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_4':{
      'namesId':'NB',
      'name':'NEW BRUNSWICK',
      'data':'<div> Weighted Goal*: <strong>Lose 123,147 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     NB Obesity Rate: <strong>29%**</strong>     <br>Est # of Obese Adults: <strong>167,736</strong> </div> <h3>*Goal based on est. # of obese adults in NB</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_5':{
      'namesId':'NL',
      'name':'NEWFOUNDLAND AND LABRADOR',
      'data':'<div> Weighted Goal*: <strong>Lose 98,896 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     NL Obesity Rate: <strong>34%**</strong>     <br>Est # of Obese Adults: <strong>134,705</strong> </div> <h3>*Goal based on est. # of obese adults in NL</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_7':{
      'namesId':'NS',
      'name':'NOVA SCOTIA',
      'data':'<div> Weighted Goal*: <strong>Lose 130,265 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     NS Obesity Rate: <strong>25%**</strong>     <br>Est # of Obese Adults: <strong>177,432</strong> </div> <h3>*Goal based on est. # of obese adults in NS</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_9':{
      'namesId':'ON',
      'name':'ONTARIO',
      'data':'<div> Weighted Goal*: <strong>Lose 1,671,022 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     ON Obesity Rate: <strong>23%**</strong>     <br>Est # of Obese Adults: <strong>2,276,057</strong> </div> <h3>*Goal based on est. # of obese adults in ON</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_10':{
      'namesId':'PE',
      'name':'PRINCE EDWARD ISLAND',
      'data':'<div> Weighted Goal*: <strong>Lose 20,606 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     PE Obesity Rate: <strong>26%**</strong>     <br>Est # of Obese Adults: <strong>28,068</strong> </div> <h3>*Goal based on est. # of obese adults in PE</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_11':{
      'namesId':'QC',
      'name':'QUEBEC',
      'data':'<div> Weighted Goal*: <strong>Lose 982,888 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     QC Obesity Rate: <strong>22%**</strong>     <br>Est # of Obese Adults: <strong>1,338,768</strong> </div> <h3>*Goal based on est. # of obese adults in QC</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_12':{
      'namesId':'SK',
      'name':'SASKATCHEWAN',
      'data':'<div> Weighted Goal*: <strong>Lose 181,096 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     SK Obesity Rate: <strong>31%**</strong>     <br>Est # of Obese Adults: <strong>246,667</strong> </div> <h3>*Goal based on est. # of obese adults in SK</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_6':{
      'namesId':'NT',
      'name':'NORTHWEST TERRITORIES',
      'data':'<div> Weighted Goal*: <strong>Lose 5,390 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     NT Obesity Rate: <strong>23%**</strong>     <br>Est # of Obese Adults: <strong>7,342</strong> </div> <h3>*Goal based on est. # of obese adults in NT</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_8':{
      'namesId':'NU',
      'name':'NUNAVUT',
      'data':'<div> Weighted Goal*: <strong>Lose 4,148 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     NU Obesity Rate: <strong>23%**</strong>     <br>Est # of Obese Adults: <strong>5,650</strong> </div> <h3>*Goal based on est. # of obese adults in NU</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_13':{
      'namesId':'YT',
      'name':'YUKON',
      'data':'<div> Weighted Goal*: <strong>Lose 4,407 lbs.</strong> <br><strong>0 Participants have lost 0 lbs.</strong> so far <br><strong>0%</strong> of Goal Reached <br>Challenge Rank (US & Canada): <strong>#0 of 64</strong> <br> <br> <div style="background-color:#ffffff;padding:5px;margin:5px;">     YT Obesity Rate: <strong>23%**</strong>     <br>Est # of Obese Adults: <strong>6,003</strong> </div> <h3>*Goal based on est. # of obese adults in YT</h3> <h3>Population data: Canada 2011 Census (statcan.gc.ca)</h3> <h3>**Obesity data: Obesity rates in Canada provinces, 2004;Regional differences in obesity (2006), Statistics Canada </h3> <div style="background-color:#ffffff;padding:5px;margin:5px;">     <center>Challenge Tracking Powered By:      <br><a href="http://habitforge.com" target="_blank"><img src="http://habitforge.com/home/images/logos/HF-ETR-Logo-Header_120.png" /></a></center> </div></div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
}
