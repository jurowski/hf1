/***********************************************************************************************************************
 * File Name    : OfbMarqueeHelper.js
 * Date Created : 01/15/2008
 * Author       : Satish Jha
 * Purpose      : This file has Javascript code required to render a marquee control
 * Usage        : Used internally to to render a marquee control
 * ---------------------------------------------------------------------------------------------------------------------
 * Revision history
 * ---------------------------------------------------------------------------------------------------------------------
 *  Author       Date       Description
 *----------------------------------------------------------------------------------------------------------------------
 * 
 **********************************************************************************************************************/
var marqueeObj = new OFB_Marquee();	// We only create one object of this class
var _OfbIsBrowserMSIE, _OfbIsBrowserNetscape;
var m_intDefaultWidth = 200;
var m_intDefaultHeight = 100;
var m_intDefaultSpeed = 1;
var m_intDefaultDirection = 1;
//Vertical = 1, Horizontal = 0

if(navigator.userAgent.indexOf('MSIE')>=0) _OfbIsBrowserMSIE = true;
if (document.layers) _OfbIsBrowserNetscape = true;

function _OfbMarqueeDisplay(intWidth, intHeight, intScrollSpeed, intDirection, strMarqueeContant, strContainerDivId, strMarqueeWrapperDivId, strMarqueeContentDivId)
{
    var intTimer = 100;
    if( !intWidth || intWidth <= 0)
        intWidth = m_intDefaultWidth;
    if( !intHeight || intHeight <= 0)
        intHeight = m_intDefaultHeight;
    if( !intScrollSpeed || intScrollSpeed <= 0)
        intScrollSpeed = m_intDefaultSpeed;
    if( intDirection || intDirection < 0)
        intDirection = m_intDefaultDirection;
    marqueeObj.ContainerDivId = strContainerDivId;
    marqueeObj.MarqueeWrapperDivId = strMarqueeWrapperDivId;
    marqueeObj.MarqueeContentDivId = strMarqueeContentDivId;
	marqueeObj.setContent(strMarqueeContant);
	marqueeObj.setSpeed(intScrollSpeed);
	marqueeObj.setSize(intWidth, intHeight);
	marqueeObj.setDirection(intDirection);
	marqueeObj.display();
	
	intTimer = intTimer - (intScrollSpeed * 10);
	if (intTimer < 20)
	    intTimer = 20;
	
    lefttime=setInterval("marqueeObj.MarqueeScroller()",intTimer);
}
