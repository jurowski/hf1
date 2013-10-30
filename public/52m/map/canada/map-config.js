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
      'data':'<div>Population-Adjusted Goal for Alberta: <strong>Lose 515,178 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for AB --<br>Total Population: 3,645,257<br>Obesity Rate: 25%<br>Est # of Obese Adults: 701,711</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_2':{
      'namesId':'BC',
      'name':'BRITISH COLUMBIA',
      'data':'<div>Population-Adjusted Goal for British Columbia: <strong>Lose 472,608 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for BC --<br>Total Population: 4,400,057<br>Obesity Rate: 19%<br>Est # of Obese Adults: 643,728</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_3':{
      'namesId':'MB',
      'name':'MANITOBA',
      'data':'<div>Population-Adjusted Goal for Manitoba: <strong>Lose 191,253 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for MB --<br>Total Population: 1,208,268<br>Obesity Rate: 28%<br>Est # of Obese Adults: 260,502</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_4':{
      'namesId':'NB',
      'name':'NEW BRUNSWICK',
      'data':'<div>Population-Adjusted Goal for New Brunswick: <strong>Lose 123,147 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for NB --<br>Total Population: 751,171<br>Obesity Rate: 29%<br>Est # of Obese Adults: 167,736</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_5':{
      'namesId':'NL',
      'name':'NEWFOUNDLAND AND LABRADOR',
      'data':'<div>Population-Adjusted Goal for Newfoundland and Labrador: <strong>Lose 98,896 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for NL --<br>Total Population: 514,536<br>Obesity Rate: 34%<br>Est # of Obese Adults: 134,705</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_7':{
      'namesId':'NS',
      'name':'NOVA SCOTIA',
      'data':'<div>Population-Adjusted Goal for Nova Scotia: <strong>Lose 130,265 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for NS --<br>Total Population: 921,727<br>Obesity Rate: 25%<br>Est # of Obese Adults: 177,432</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_9':{
      'namesId':'ON',
      'name':'ONTARIO',
      'data':'<div>Population-Adjusted Goal for Ontario: <strong>Lose 1,671,022 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for ON --<br>Total Population: 12,851,821<br>Obesity Rate: 23%<br>Est # of Obese Adults: 2,276,057</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_10':{
      'namesId':'PE',
      'name':'PRINCE EDWARD ISLAND',
      'data':'<div>Population-Adjusted Goal for Prince Edward Island: <strong>Lose 20,606 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for PE --<br>Total Population: 140,204<br>Obesity Rate: 26%<br>Est # of Obese Adults: 28,068</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_11':{
      'namesId':'QC',
      'name':'QUEBEC',
      'data':'<div>Population-Adjusted Goal for Quebec: <strong>Lose 982,888 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for QC --<br>Total Population: 7,903,001<br>Obesity Rate: 22%<br>Est # of Obese Adults: 1,338,768</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_12':{
      'namesId':'SK',
      'name':'SASKATCHEWAN',
      'data':'<div>Population-Adjusted Goal for Saskatchewan: <strong>Lose 181,096 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for SK --<br>Total Population: 1,033,381<br>Obesity Rate: 31%<br>Est # of Obese Adults: 246,667</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_6':{
      'namesId':'NT',
      'name':'NORTHWEST TERRITORIES',
      'data':'<div>Population-Adjusted Goal for Northwest Territories: <strong>Lose 5,390 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for NT --<br>Total Population: 41,462<br>Obesity Rate: 23%<br>Est # of Obese Adults: 7,342</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_8':{
      'namesId':'NU',
      'name':'NUNAVUT',
      'data':'<div>Population-Adjusted Goal for Nunavut: <strong>Lose 4,148 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for NU --<br>Total Population: 31,906<br>Obesity Rate: 23%<br>Est # of Obese Adults: 5,650</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
  'map_13':{
      'namesId':'YT',
      'name':'YUKON',
      'data':'<div>Population-Adjusted Goal for Yukon: <strong>Lose 4,407 lbs.</strong><br># of Challenge Participants: 0 have signed up<br>Lbs lost so far: 0 lbs.<br>% of Goal Reached: 0%<br>Challenge Rank (US & Canada): #0 out of 64<br><br><br><br>-- Obesity Facts for YT --<br>Total Population: 33,897<br>Obesity Rate: 23%<br>Est # of Obese Adults: 6,003</div>',
      'upcolor':'#EBECED',
      'overcolor':'#99CC00',
      'downcolor':'#993366',
      'enable':true,
  },
}
