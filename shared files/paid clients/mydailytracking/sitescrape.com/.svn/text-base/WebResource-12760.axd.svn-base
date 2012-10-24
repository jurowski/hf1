/***********************************************************************************************************************
 * File Name    : OfbPanelHelper.js
 * Date Created : 02/12/2008
 * Author       : Sajeev Ravindran
 * Purpose      : This file has Javascript helper code required for OfbPanel class
 * Usage        : 
 * ---------------------------------------------------------------------------------------------------------------------
 * Revision history
 * ---------------------------------------------------------------------------------------------------------------------
 *  Author       Date       Description
 *----------------------------------------------------------------------------------------------------------------------
 * 
 **********************************************************************************************************************/
//IMPORTANT Any changes to this should be reflected in OfbPanel.ePanelLocation
var OFB_ENUM_PANEL_LOCATION    = {None : 0, Right : 1,  Left : 2, Bottom : 3, Top :  4} 
var OFB_ENUM_PANEL_OPTIONS     = {None : 0, AutoFitViewPort : 1} 
var OFB_ENUM_SIZE    = {Left : 0, Top : 1,  Width : 2, Height : 3, Right : 4, Bottom : 5} 
var OFB_PANEL_STYLE_DISPLAY_HIDE = 'none';
var OFB_PANEL_STYLE_DISPLAY_BLOCK = 'block';
var OFB_PANEL_STYLE_DEFAULT_ZINDEX = 100;        // A Higher z Index to prevent hidingfrom most items.
var OFB_DEFAULT_INT_VALUE = -32767
var m_arCurrentDivIds = new Array();
//Constants - Derived from OfbWebUILibCommon.js
var WIDTH                    = 0;
var HEIGHT                   = 1;

function __ofbPanelShowHideDivRelativePosition(strDivId, strReferceControlId, oePanelLocation, oePanelOptions, intVerticalOffset, intHorizontalOffset, intZIndex )
{
    if(!strDivId)
        return;
    var oDiv = document.getElementById(strDivId);
    if(oDiv){
        if( oDiv.style.display == OFB_PANEL_STYLE_DISPLAY_HIDE ){
            __ofbPanelShowDivRelativePosition(strDivId, strReferceControlId, oePanelLocation, oePanelOptions, intVerticalOffset, intHorizontalOffset, intZIndex );
        }
        else
            oDiv.style.display = OFB_PANEL_STYLE_DISPLAY_HIDE;
    }
}

function __ofbPanelShowDivRelativePosition(strDivId, strReferceControlId, oePanelLocation, oePanelOptions, intVerticalOffset, intHorizontalOffset, intZIndex )
{
    var oDiv = null, oReferenceControl = null, oDimensions = null, oReferenceControlLocation = null, oReferenceControlSize = null;
    var intReferenceControlLeft = 0, intReferenceControlTop = 0, intReferenceControlWidth = 0, intReferenceControlHeight = 0, intReferenceControlRight = 0, intReferenceControlBottom = 0;
    var intDivTop = OFB_DEFAULT_INT_VALUE, intDivLeft = 0, intDivWidth = 0, intDivHeight = 0, intSafePaddingSize = 4;
    var arBrowserSize = __ofbGetBrowserSize();
    var arBrowserScroll = __getScrollXY();
    
    if(!strDivId)
        return;
    if( !intVerticalOffset )        intVerticalOffset = 0;
    if( !intHorizontalOffset )      intHorizontalOffset = 0;
    
    oDiv = document.getElementById(strDivId);
    //debugger;
    if( oDiv){
        oDimensions = __ofbPanelGetControlDimensions( oDiv );
//        intDivLeft = oDimensions[OFB_ENUM_SIZE.Left];           intDivTop  = oDimensions[OFB_ENUM_SIZE.Top];
        intDivWidth = oDimensions[OFB_ENUM_SIZE.Width];         intDivHeight = oDimensions[OFB_ENUM_SIZE.Height];
    }
    if( !intZIndex )     intZIndex = OFB_PANEL_STYLE_DEFAULT_ZINDEX;
    if( strReferceControlId ){
        oReferenceControl = document.getElementById(strReferceControlId);
        if( !oePanelLocation )
            oePanelLocation = OFB_ENUM_PANEL_LOCATION.None;
    }
    if( !oePanelOptions )
        oePanelOptions = OFB_ENUM_PANEL_OPTIONS.None;
    if( oReferenceControl ){
        oDimensions = __ofbPanelGetControlDimensions( oReferenceControl );
        intReferenceControlLeft = oDimensions[OFB_ENUM_SIZE.Left];          intReferenceControlTop  = oDimensions[OFB_ENUM_SIZE.Top];
        intReferenceControlWidth = oDimensions[OFB_ENUM_SIZE.Width];        intReferenceControlHeight = oDimensions[OFB_ENUM_SIZE.Height]
        intReferenceControlRight = oDimensions[OFB_ENUM_SIZE.Right];        intReferenceControlBottom = oDimensions[OFB_ENUM_SIZE.Bottom];
        switch( oePanelLocation ){
            case OFB_ENUM_PANEL_LOCATION.Right :
                intDivLeft = intReferenceControlRight + intHorizontalOffset;
                intDivTop = intReferenceControlTop + intVerticalOffset;
                break;
            case OFB_ENUM_PANEL_LOCATION.Left :
                intDivLeft = intReferenceControlLeft - intDivWidth - intHorizontalOffset;
                intDivTop = intReferenceControlTop + intVerticalOffset;
                if( intDivLeft < 0 )    intDivLeft = 0;
                break;
            case OFB_ENUM_PANEL_LOCATION.Bottom :
                intDivTop = intReferenceControlBottom + intVerticalOffset;
                intDivLeft = intReferenceControlLeft + intHorizontalOffset;
                break;
            case OFB_ENUM_PANEL_LOCATION.Top :
                intDivTop = intReferenceControlTop - intVerticalOffset;
                intDivLeft = intReferenceControlLeft + intHorizontalOffset;
                if( intDivTop < 0 )    intDivTop = 0;
                break;
        }
    }
    if(oDiv){
        if( intDivTop != OFB_DEFAULT_INT_VALUE){
            if( (oePanelOptions & OFB_ENUM_PANEL_OPTIONS.AutoFitViewPort) == OFB_ENUM_PANEL_OPTIONS.AutoFitViewPort && (intDivTop + intDivHeight) > arBrowserSize[HEIGHT]){
                intDivTop = ((arBrowserSize[HEIGHT] - intDivHeight - intSafePaddingSize) + arBrowserScroll[1]);
                if( intDivTop < 0 ) intDivTop = 0;
            }
            oDiv.style.top = intDivTop + 'px';
        }
        if( intDivLeft ){
            if( (oePanelOptions & OFB_ENUM_PANEL_OPTIONS.AutoFitViewPort) == OFB_ENUM_PANEL_OPTIONS.AutoFitViewPort && (intDivLeft + intDivWidth) > arBrowserSize[WIDTH]){
                intDivLeft = (arBrowserSize[WIDTH] - intDivWidth - intSafePaddingSize) + arBrowserScroll[0];
                if( intDivLeft < 0 ) intDivLeft = 0;
            }
            oDiv.style.left = intDivLeft + 'px';
        }
        oDiv.style.zIndex = intZIndex;
        AddToCurrentDivList( strDivId );
        //m_strCurrentDivId = strDivId;
        oDiv.style.display = OFB_PANEL_STYLE_DISPLAY_BLOCK;
    }
}
function IsDivVisible( strDivId )
{
    var intCount = 0;
    for( intCount = 0; intCount < m_arCurrentDivIds.length; intCount++ ){
        if( m_arCurrentDivIds[intCount] == strDivId )
            return( 1 );
    }
    return( 0 );
}
function AddToCurrentDivList( strDivId )
{
    var intCount = 0;
    for( intCount = 0; intCount < m_arCurrentDivIds.length; intCount++ ){
        if( m_arCurrentDivIds[intCount] == strDivId )
            return;
    }
    m_arCurrentDivIds[intCount] = strDivId;
    return;
}
function RemoveFromCurrentDivList( strDivId )
{
    var intCount = 0;
    for( intCount = 0; intCount < m_arCurrentDivIds.length; intCount++ ){
        if( m_arCurrentDivIds[intCount] == strDivId ){
            m_arCurrentDivIds.splice( intCount, 1 );
            return;
        }
    }
    return;
}

function __ofbPanelGetControlDimensions(oControl)
{
   var intLeft = 0, intTop = 0, intWidth = 0, intHeight = 0, intRight = 0, intBottom = 0;
   
   if( oControl ){
        oControlLocation = __ofbFindAbsolutePosition( oControl );
        if( oControlLocation ){
            intLeft = oControlLocation[OFB_ENUM_SIZE.Left];
            intTop = oControlLocation[OFB_ENUM_SIZE.Top];
        }
        oControlSize = __ofbGetControlCalcuatedPositionSize( oControl );
        if( oControlSize ){
            intWidth = oControlSize[OFB_ENUM_SIZE.Width];
            intHeight = oControlSize[OFB_ENUM_SIZE.Height];
            intRight = intLeft + oControlSize[OFB_ENUM_SIZE.Width];
            intBottom = intTop + oControlSize[OFB_ENUM_SIZE.Height];
        }
    }
     return[intLeft, intTop, intWidth, intHeight, intRight, intBottom];
}

function __ofbPanelHideDivWithDelay(strDivID, intDelay)  //Delay in milli seconds
{
    if(!strDivID)
        return;
    RemoveFromCurrentDivList( strDivID );
    setTimeout( '__ofbPanelHideDivCheck( \'' + strDivID + '\')', intDelay )
}
function __ofbPanelHideDivCheck(strDivId)
{
    if(!strDivId || (IsDivVisible( strDivId ) == 1))
        return;
        
    __ofbHideDiv(strDivId)
}
