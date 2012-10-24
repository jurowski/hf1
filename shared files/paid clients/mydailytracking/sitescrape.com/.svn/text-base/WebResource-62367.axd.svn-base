
/**
* @constructor
*/

OFB_Marquee = function()
{
	var MarqueeText;					    // html of Marquee
	var scrollerwidth;								// Width of Marquee box
	var scrollerheight;								// Height of Marquee box
	var scrollerspeed;
	var scrollDirection;
    var MSIE;
    var pauseit; 
    var copyspeed;
    var actualheight; 
    var actualwidth;
    var cross_scroller;
    var marquee_wrapper;
    var ns_scroller; 
    var pausespeed; 
    var ContainerDivId;
    var MarqueeWrapperDivId;
    var MarqueeContentDivId;
    		
    this.ContainerDivId = '';
    this.MarqueeWrapperDivId = '';
    this.MarqueeContentDivId = '';
	this.MarqueeText = '';			        // Default message is blank
	this.height = 200;						// Default height of modal message
	this.width = 100;						// Default width of modal message
	this.scrollerspeed = 1;
	this.scrollDirection = 1;
	this.actualheight = '';
	this.actualwidth = '';
	if(navigator.userAgent.indexOf('MSIE')>=0) this.MSIE = true;
	if(navigator.userAgent.indexOf('Mozilla')>=0) this.MSIE = true;
	this.MSIE = document.all||document.getElementById;
	this.scrollerspeed=(this.MSIE)? this.scrollerspeed : Math.max(1, this.scrollerspeed-1); /*slow speed down by 1 for NS*/
	this.copyspeed=this.scrollerspeed; 
	this.pauseit = 1;
    this.pausespeed=(this.pauseit==0)? this.copyspeed: 0;
}

OFB_Marquee.prototype = {
	setSpeed : function(scrollSpeed)
	{
		if(scrollSpeed) this.scrollerspeed=(this.MSIE)? scrollSpeed : Math.max(1, scrollSpeed-1); /*slow speed down by 1 for NS*/
	}	
    ,
	setContent : function(marqueeContent)
	{
		this.MarqueeText = marqueeContent;
	}
	,
	setSize : function(width,height)
	{
		if(width)this.scrollerwidth = width;
		if(height)this.scrollerheight = height;		
	}
	,	
	setDirection : function(direction)
	{
		this.scrollDirection = direction;	
	}
	,	
	display : function()
	{
	    this.createDivs();
		if (this.scrollDirection == '1')
		{
	        if (this.MSIE){
	            this.cross_scroller = document.getElementById? document.getElementById(this.MarqueeContentDivId) : document.all.iescroller; 
	            this.marquee_wrapper = document.getElementById? document.getElementById(this.MarqueeWrapperDivId) : document.all.marqueewrapper; 
	            this.cross_scroller.style.top = parseInt(this.scrollerheight)+"px"; 
	            this.cross_scroller.innerHTML = this.MarqueeText; 
	            this.actualheight = this.cross_scroller.offsetHeight; 
	        }
	        else if (document.layers){
	            this.ns_scroller = document.ns_scroller.document.ns_scroller2; 
	            this.ns_scroller.top = parseInt(this.scrollerheight); 
	            this.ns_scroller.document.write(this.MarqueeText);
	            this.ns_scroller.document.close();
	            this.actualheight = this.ns_scroller.document.height; 
	        }
	    }
	    else if (this.scrollDirection == '0')
	    {
	       if (this.MSIE){
                this.cross_scroller = document.getElementById? document.getElementById("iescroller") : document.all.iescroller;
                this.cross_scroller.style.left = parseInt(this.scrollerwidth)+"px";
                this.cross_scroller.innerHTML = '<nobr>' + this.MarqueeText + '</nobr>';
                this.actualwidth = document.all? temp.offsetWidth : document.getElementById("temp").offsetWidth
            }
            else if (document.layers){
                this.ns_scroller = document.ns_scroller.document.ns_scroller2;
                this.ns_scroller.left = parseInt(this.scrollerwidth);
                this.ns_scroller.document.write('<nobr>' + this.MarqueeText + '</nobr>');
                this.ns_scroller.document.close();
                this.actualwidth = this.ns_marquee.document.width;
            } 
	    }
	}
	,
	MarqueeScroller : function()
	{
	    if (this.scrollDirection == '1')
		{
	        if (this.MSIE){
	            if (parseInt(this.cross_scroller.style.top)>(this.actualheight*(-1)))
	                this.cross_scroller.style.top=parseInt(this.cross_scroller.style.top)-this.copyspeed+"px"; 
	            else
	                this.cross_scroller.style.top=parseInt(this.scrollerheight)+"px"; 
	        }
	        else if (document.layers){
	            if (this.ns_scroller.top>(this.actualheight*(-1)))
	                this.ns_scroller.top-=this.copyspeed; 
	            else
	                this.ns_scroller.top=parseInt(this.scrollerheight); 
	        }
	    }
	    else if (this.scrollDirection == '0')
	    {
	       if (this.MSIE){
                if (parseInt(this.cross_scroller.style.left)>(this.actualwidth*(-1)))
                    this.cross_scroller.style.left=parseInt(this.cross_scroller.style.left)-this.copyspeed+"px";
                else
                    this.cross_scroller.style.left=parseInt(this.scrollerwidth)+"px";
            }
            else if (document.layers){
                if (this.ns_scroller.left>(this.actualwidth*(-1)))
                    this.ns_scroller.left-=this.copyspeed;
                else
                    this.ns_scroller.left=parseInt(this.scrollerwidth);
            }
        }
	}
	,
	createDivs : function()
	{
	    var ContainerDiv = document.getElementById(this.ContainerDivId);
	    //debugger;
	    if( !ContainerDiv || ContainerDiv == null )
	    {
	        ContainerDiv = document;
	        //this.MarqueeText = "<p>ContainerDiv Not Found</p>" + this.MarqueeText;
	    }
	    with (ContainerDiv){
	        if (this.scrollDirection == '1')
		    {
	            if (this.MSIE){	                   
	                //ContainerDiv.innerHTML = '<div id="marqueewrapper" style="position:relative;left:0;top:0;width:'+ this.scrollerwidth+'px;height:'+ this.scrollerheight+'px;overflow:hidden" onMouseover="marqueeObj.copyspeed=marqueeObj.pausespeed" onMouseout="marqueeObj.copyspeed=marqueeObj.scrollerspeed"><div id="iescroller" style="position:relative;left:0px;top:0px;width:100%;"></div></div>';
	            }
	            else if (document.layers){
	                ContainerDiv.innerHTML = '<ilayer width='+ this.scrollerwidth+' height='+ this.scrollerheight+' name="ns_scroller"><layer name="ns_scroller2" width='+ this.scrollerwidth+' height='+ this.scrollerheight+' left=0 top=0 onMouseover="marqueeObj.copyspeed=marqueeObj.pausespeed" onMouseout="marqueeObj.copyspeed=marqueeObj.scrollerspeed"></layer></ilayer>';
	            }
	        }
	        else if (this.scrollDirection == '0')
	        {
	            if (this.MSIE){
                    ContainerDiv.innerHTML = '<span id="temp" style="visibility:hidden;position:absolute;top:-100px;left:-9000px"><nobr>'+ this.MarqueeText +'</nobr></span><table border="0" cellspacing="0" cellpadding="0"><td><div style="position:relative;width:' + this.scrollerwidth + 'px;height:'+ this.scrollerheight +'px;overflow:hidden"><div style="position:absolute;width:' + this.scrollerwidth + 'px;height:'+ this.scrollerheight + 'px;" onMouseover="marqueeObj.copyspeed=marqueeObj.pausespeed" onMouseout="marqueeObj.copyspeed=marqueeObj.scrollerspeed"><div id="iescroller" style="position:relative;left:0px;top:0px;width:' + this.scrollerwidth + 'px;height:'+ this.scrollerheight +'px"></div></div></div></td></table>';
                }
                else if (document.layers){
                    ContainerDiv.innerHTML = '<table border="0" cellspacing="0" cellpadding="0"><td><ilayer width='+ this.scrollerwidth +' height='+ this.scrollerheight +' name="ns_scroller"><layer name="ns_scroller2" left=0 top=0 onMouseover="marqueeObj.copyspeed=marqueeObj.pausespeed" onMouseout="marqueeObj.copyspeed=marqueeObj.scrollerspeed"></layer></ilayer></td></table>';
                }
            }  
	    }
	}
}
