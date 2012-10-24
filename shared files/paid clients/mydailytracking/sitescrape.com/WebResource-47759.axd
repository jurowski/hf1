var _OfbIsBrowserMSIE, _OfbIsBrowserNetscape;
var _OfbMouseX, _OfbMouseY;
var _strHideDisplayStyle;
var _strShowDisplayStyle;
//Constants
var WIDTH                    = 0;
var HEIGHT                   = 1;
var LEFT                     = 0;
var TOP                      = 1;
var MIN_OBJECT_HEIGHT        = 8;
var OFB_HDN_SELECTED_OBJECT_ID = '__hdnOfbSelectedObjectId';
var OFB_HDN_SELECTED_OBJECT_VALUE = '__hdnOfbSelectedItemValue';


_strHideDisplayStyle = 'none';
_strShowDisplayStyle = 'block';

_OfbIsBrowserMSIE = false;
_OfbIsBrowserNetscape = false;
_OfbMouseX = _OfbMouseY = 0;
_OfbCurObject = null;

if(navigator.userAgent.indexOf('MSIE')>=0){_OfbIsBrowserMSIE = true; _OfbIsBrowserNetscape = false;}
else if (navigator.userAgent.indexOf('Mozilla')>=0) _OfbIsBrowserNetscape = true;

//Capture mouse XY and retain so anyone ca use it.
if( _OfbIsBrowserNetscape)  document.captureEvents(Event.MOUSEMOVE);
document.onmousemove = __ofbTrackMousePos;

function __ofbGetBrowserSize()
{
	var bodyWidth = document.documentElement.clientWidth;
	var bodyHeight = document.documentElement.clientHeight;
	
	if (self.innerHeight){ // all except Explorer 
	   bodyWidth = self.innerWidth; 
	   bodyHeight = self.innerHeight; 
	}  else if (document.documentElement && document.documentElement.clientHeight) {
	   // Explorer 6 Strict Mode 		 
	   bodyWidth = document.documentElement.clientWidth; 
	   bodyHeight = document.documentElement.clientHeight; 
	} else if (document.body) {// other Explorers 		 
	   bodyWidth = document.body.clientWidth; 
	   bodyHeight = document.body.clientHeight; 
	} 
	return [bodyWidth,bodyHeight];		
}

function __getScrollXY() {
  var scrOfX = 0, scrOfY = 0;
  if( typeof( window.pageYOffset ) == 'number' ) {
    //Netscape compliant
    scrOfY = window.pageYOffset;
    scrOfX = window.pageXOffset;
  } else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
    //DOM compliant
    scrOfY = document.body.scrollTop;
    scrOfX = document.body.scrollLeft;
  } else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
    //IE6 standards compliant mode
    scrOfY = document.documentElement.scrollTop;
    scrOfX = document.documentElement.scrollLeft;
  }
  return [ scrOfX, scrOfY ];
}

function __ofbGetClientResolution(strControl)
{
    var Width = screen.width;
    var Height = screen.height;

    var oField = document.getElementById(strControl);
    if (oField)
    {
        oField.value = Height + ', ' + Width;
    }		
}
                                                            
function __ofbGetScrollWidth()
{
   var w = window.pageXOffset ||
           document.body.scrollLeft ||
           document.documentElement.scrollLeft;
           
   return w ? w : 0;
} 
function __ofbGetScrollHeight()
{
   var h = window.pageYOffset ||
           document.body.scrollTop ||
           document.documentElement.scrollTop;
           
   return h ? h : 0;
}
function __ofbTrackMousePos(e)
{
   if (_OfbIsBrowserNetscape){
        _OfbMouseX = e.pageX;
        _OfbMouseY = e.pageY;
    }
   else{
        _OfbMouseX = event.x;
        _OfbMouseY = event.y;
    }
    _OfbMouseX += __ofbGetScrollWidth();
    _OfbMouseY += __ofbGetScrollHeight();
}
function __ofbGetMouseX()
{
    return(_OfbMouseX);
}
function __ofbGetMouseY()
{
    return(_OfbMouseY);
}
//Div Related
function __ofbShowHideDiv(strDivID)
{
    if(!strDivID)
        return;
    var oDiv = document.getElementById(strDivID);
    if(oDiv){
        oDiv.style.display = (oDiv.style.display == _strHideDisplayStyle)? _strShowDisplayStyle: _strHideDisplayStyle;
    }
}
function __ofbShowDiv(strDivID)
{
    if(!strDivID)
        return;
    var oDiv = document.getElementById(strDivID);
    if(oDiv){
        oDiv.style.display = _strShowDisplayStyle;
    }
}
function __ofbHideDiv(strDivID)
{
    if(!strDivID)
        return;
    var oDiv = document.getElementById(strDivID);
    if(oDiv){
        oDiv.style.display = _strHideDisplayStyle;
    }
}
function __ofbHideDivWithLocationSense(strDivID)
{
    if(!strDivID)
        return;
    var oDiv = document.getElementById(strDivID);
    if(oDiv){
        oDiv.style.display = _strHideDisplayStyle;
    }
}
function __ofbHideDivWithDelay(strDivID, intDelay)  //Delay in milli seconds
{
    if(!strDivID)
        return;
    setTimeout( '__ofbHideDiv( \'' + strDivID + '\')', intDelay )
}
function __ofbEscapeHTML (strValue)
{
   var oDiv = document.createElement('div');
   var oText = document.createTextNode(strValue);
   oDiv.appendChild(oText);
   return oDiv.innerHTML;
}

function __ofbGetCurrentEvent( oEvent )
{
    if( !oEvent )   oEvent = event;
    return(oEvent);
}
function __ofbGetCurrentEventObject( oEvent )
{
    oEvent = __ofbGetCurrentEvent( oEvent );
    if(oEvent)  return oEvent.target || oEvent.srcElement;
    return( null )
}
function __ofbGetPercentHeight( intPercent, intOffsetTop )
{
    var arBrowserSize = __ofbGetBrowserSize();
    var intRetVal = 0;
    
    intPercent = __ofbStringToInt( intPercent );
    intOffsetTop = __ofbStringToInt( intOffsetTop );
    intRetVal = arBrowserSize[HEIGHT] - intOffsetTop;
    if( intPercent > 0 ){
        intRetVal = ((intRetVal / 100) * intPercent);
    }
    return( intRetVal );
}
function __ofbSetHeightByPercent( strControlId, intPercent )
{
    var oControl = document.getElementById(strControlId);
    var arControlOffset = null;
    var intPercentHeightPixels = 0;
    
    if( !oControl || oControl == null)
        return;

    arControlOffset = __ofbFindAbsolutePosition( oControl );
    intPercentHeightPixels = __ofbGetPercentHeight( intPercent, arControlOffset[TOP] );
    if(oControl && intPercentHeightPixels > 0){
        oControl.style.height = (intPercentHeightPixels + 'px');
    }
}
function __ofbSetHeightByBottomOffset( strControlId, intBottomOffset )
{
    var arViewPortSize = __ofbGetBrowserSize();
    var oControl = document.getElementById(strControlId);
    var arControlOffset = null;
    var intHeightPixels = 0;
    
    if( !oControl || oControl == null)
        return;
    intBottomOffset = __ofbStringToInt( intBottomOffset );
    arControlOffset = __ofbFindAbsolutePosition( oControl );
    intHeightPixels = (arViewPortSize[HEIGHT] - arControlOffset[TOP] - intBottomOffset);
    if( intHeightPixels <= 0 ){
        intHeightPixels = MIN_OBJECT_HEIGHT;
    }
    if(oControl && intHeightPixels > 0){
        oControl.style.height = (intHeightPixels + 'px');
    }
}
function __ofbSetHeightByBottomOffsetControlHeight( strControlId, strBottomOffsetControlId )
{
    var oControl = document.getElementById(strBottomOffsetControlId);
    var intBottomOffset = 0;
    
    if( oControl )
        intBottomOffset = oControl.offsetHeight;
    return( __ofbSetHeightByBottomOffset( strControlId, intBottomOffset ) );
}
function __ofbGetStyleProperty( oControl, strPropertyName ) {
    var oRetVal = '';
    
	if( typeof oControl == 'string')
	    oControl = document.getElementById(oControl);
	if( !oControl )
	    return( oRetVal );
	if (oControl.currentStyle) {
		oRetVal = oControl.currentStyle[strPropertyName];
	} else if (window.getComputedStyle) {
		oRetVal = document.defaultView.getComputedStyle(oControl,null).getPropertyValue(strPropertyName);
	}
	return oRetVal;
}



// The Following Methods are Copied from Designer to make sure that this generic code is not dependent on Designer Functions.
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//This method Converts any String to Integer this is mainly used to convert pixel sizes 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
function __ofbStringToInt( strInVal )
{
var intRetVal = 0, intCount = 0, strTemp = "", strVal ="";

    if( !strInVal )
        return( intRetVal );
    strVal = strInVal.toString();
    if( strVal ){
        if( strVal.length ){
            for( intCount = 0; intCount < strVal.length; intCount++ ){
                if( (strVal.charAt(intCount) >= '0' && strVal.charAt(intCount) <= '9') || strVal.charAt(intCount) == '-'  || strVal.charAt(intCount) == '+' ||strVal.charAt(intCount) == '.')
                    strTemp = strTemp.concat(strVal.charAt(intCount));  
                else break;
            } 
            if( strTemp.length > 0 )
                intRetVal = parseInt(strTemp, 0 );
         }
         else 
            intRetVal = parseInt(strTemp, 0 );
    }
    return intRetVal;
}
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//This method returns the Absolute Position of the Element 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
function __ofbFindAbsolutePosition( oElement) 
{
var intCurrLeft = intCurrTop = 0;

	if (oElement.offsetParent){
		intCurrLeft = oElement.offsetLeft;
		intCurrTop = oElement.offsetTop;
		while (oElement = oElement.offsetParent){
			intCurrLeft += oElement.offsetLeft;
			intCurrTop += oElement.offsetTop;
		}
	}
	return [intCurrLeft,intCurrTop];
}
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//This method calcualtes width and height of SrcElement based on diffent combinations and applies the style as well.  //TO DO this need to be tested for all scenarios
-------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
function __ofbGetControlCalcuatedPositionSize( oSrcElement )
{
var intCurrStyleLeft = 0, intCurrStyleTop = 0, intCurrStyleWidth = 0, intCurrStyleHeight = 0;
var strCurrStyle;

    if( oSrcElement ){
        //Calculate Left 
        //strCurrStyle = oSrcElement.currentStyle.left.toLowerCase();
        strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'left' ).toLowerCase();
        if(strCurrStyle != "auto" && strCurrStyle.indexOf("%") < 0 &&  __ofbStringToInt(strCurrStyle ) > 0 ){
    	    intCurrStyleLeft  = __ofbStringToInt(__ofbGetStyleProperty( oSrcElement, 'left'));
    	    strCurrStyle = __ofbGetStyleProperty(oSrcElement, 'padding-Left');
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleLeft += __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'border-Left-Width');
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleLeft  += __ofbStringToInt(strCurrStyle);
        }    	    
        else
    	    intCurrStyleLeft  = __ofbStringToInt(oSrcElement.offsetLeft);
        //Calculate Top
        strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'top' ).toLowerCase();
        if(strCurrStyle != "auto" && strCurrStyle.indexOf("%") < 0 &&  __ofbStringToInt(strCurrStyle ) > 0 ){
    	    intCurrStyleTop  = __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'padding-Top' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleTop  += __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'border-Top-Width');
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleTop  += __ofbStringToInt(strCurrStyle);
        }    	    
        else
    	    intCurrStyleTop  = __ofbStringToInt(oSrcElement.offsetTop);
        //Calculate Width 
        strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'width' ).toLowerCase();
        if(strCurrStyle != "auto" && strCurrStyle.indexOf("%") < 0 &&  __ofbStringToInt(strCurrStyle ) > 0 ){
    	    intCurrStyleWidth  = __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'padding-Left' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleWidth  += __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'padding-Right' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleWidth  += __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'border-Left-Width' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleWidth  += __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'border-Right-Width' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleWidth  += __ofbStringToInt(strCurrStyle );
        }    	    
        else
    	    intCurrStyleWidth  = __ofbStringToInt(oSrcElement.offsetWidth);
        //Calculate Height
        strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'height' ).toLowerCase();
        if(strCurrStyle != "auto" && strCurrStyle.indexOf("%") < 0 &&  __ofbStringToInt(strCurrStyle ) > 0 ){
    	    intCurrStyleHeight  = __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'padding-Top' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleHeight  += __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'padding-Bottom' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleHeight  += __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'border-Top-Width' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleHeight  += __ofbStringToInt(strCurrStyle);
    	    strCurrStyle = __ofbGetStyleProperty( oSrcElement, 'border-Bottom-Width' );
    	    if( strCurrStyle && strCurrStyle.length > 0 )
        	    intCurrStyleHeight  += __ofbStringToInt(strCurrStyle);
        }    	    
        else
    	    intCurrStyleHeight  = __ofbStringToInt(oSrcElement.offsetHeight);
    }            	    
    return[__ofbStringToInt(intCurrStyleLeft), __ofbStringToInt(intCurrStyleTop), __ofbStringToInt(intCurrStyleWidth), __ofbStringToInt(intCurrStyleHeight)];
}

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//This method Adds a Border to the SelectedObject and Retains the Selcted Object Id and the value passed which will be returned when __ofbGetSelectedObjectValue() is called 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
function __ofbSetSelectedObjectStyle( strSelectedObjectId, strSelectedItemValue, strBorderColor, strBorderWidth, strBorderStyle)
{
var ohdnSelectedObjectId = null, oPreviouslySelectedObject = null, ohdnSelectedItemValue = null, oSelectedObject  = null;

    if( ohdnSelectedObjectId = document.getElementById(OFB_HDN_SELECTED_OBJECT_ID)){ //Registred in OfbCommonJavaScript.cs
        if( ohdnSelectedObjectId.value && ohdnSelectedObjectId.value.length > 0 ){
            if( (oPreviouslySelectedObject = document.getElementById( ohdnSelectedObjectId.value)) && oPreviouslySelectedObject.style )
                oPreviouslySelectedObject.style.borderWidth  = 0;
        }
        if( oSelectedObject = document.getElementById(strSelectedObjectId) ){ 
            if( oSelectedObject.style ){
                oSelectedObject.style.borderColor = strBorderColor;
                oSelectedObject.style.borderWidth  = strBorderWidth;
                oSelectedObject.style.borderStyle = strBorderStyle;
            }
            if( oSelectedObject.id )
                ohdnSelectedObjectId.value = oSelectedObject.id;
            if( strSelectedItemValue ){
                if( ohdnSelectedItemValue = document.getElementById(OFB_HDN_SELECTED_OBJECT_VALUE)) //Registred in OfbCommonJavaScript.cs
                    ohdnSelectedItemValue.value = strSelectedItemValue;
            }
        }
    }
}
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//This method returns the Selected Item ClientId and Selected Item Value that was passed at the time of Selection when __ofbSetSelectedObjectStyle()is called
-------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
function __ofbGetSelectedObjectValue()
{
var ohdnSelectedObjectId = null, ohdnSelectedItemValue = null;
var strRetSelectedObjectClientId = '', strSelectedItemValue = '';

    if( ohdnSelectedObjectId = document.getElementById(OFB_HDN_SELECTED_OBJECT_ID) && ohdnSelectedObjectId.value ) //Registred in OfbCommonJavaScript.cs
        strRetSelectedObjectClientId = ohdnSelectedObjectId.value;
    if( ohdnSelectedItemValue = document.getElementById(OFB_HDN_SELECTED_OBJECT_VALUE) && ohdnSelectedItemValue.value ) //Registred in OfbCommonJavaScript.cs
        ohdnSelectedItemValue = ohdnSelectedItemValue.value;
    return [strRetSelectedObjectClientId, strSelectedItemValue];
}

//Form related methods
function __ofbSubmitAjaxForm( oTriggerObj, config )
{
    var defaults = {AjaxDataPacketHeader: 'PH', AjaxFormData: 'FD', AjaxFormCollection: 'FC',FormID: 'FI', ActionHeader: 'AH', ActionPayload: 'AP', ActionResponse: 'AR', ActionCode: 'AC', MetaSessionID: 'MSI', ActionCodeAttr: 'data-ofboac', MetaSessionIDAttr: 'data-ofbmsi', RowSelectorAttr: 'data-ofbfrs', RowDataCollection: 'RC', RowID: 'RI', RowValue: 'RV', RowData: 'RD', ColID: 'CI', ColName: 'CN', ColValue: 'CV', QueryStringParamName: '080.DTA', FormSelector: 'body', DataSelector: ':input[name]:not("#__OFBVSTATE,#__VIEWSTATE")', RowSelector: null, SubmitUrl: false, OnSuccess: function(data){return;} };
    config = $.extend( {}, defaults, config );
    
    if( !config.SubmitUrl )     return( false );
    var DataPacket = DataTable( config.AjaxDataPacketHeader + "," + config.AjaxFormData);
    var FormData = DataTable( config.FormID + "," + config.ActionHeader + "," + config.ActionPayload);
    var ActionHdr = DataTable( config.ActionCode + "," + config.MetaSessionID );
    var DataRow = DataTable( config.RowID + "," + config.RowValue + "," + config.RowData );
    var ColData = DataTable( config.ColID + "," + config.ColName + "," + config.ColValue );
    var oForms = [], oForm;
    var oFormsRows = [];
    var intFormCount = 0, intRowCount = 0, intColCount = 0;
    var strDataSelector = config.DataSelector;  //':input[name]:not("#__OFBVSTATE,#__VIEWSTATE")';
    var oRow, strRowValue = '', oDataPacket, oActionHeader;
    var strActionCode = '', strDefaultMetaSessionId = '';
    //SubFormSelector: 'span._OfbAjxSubForm', 
    
    if( oTriggerObj && oTriggerObj.length ){
        strActionCode = oTriggerObj.attr(config.ActionCodeAttr)
        if( !strActionCode )  strActionCode = '';
        strDefaultMetaSessionId = oTriggerObj.attr(config.MetaSessionIDAttr);
        if( !strDefaultMetaSessionId )  strDefaultMetaSessionId = '';
    }
    if( config.SubFormSelector ){
        $(config.SubFormSelector).each( function(){
            oFormsRows[intFormCount] = CompileFormData( $(this), $(this).attr(config.RowSelectorAttr)? $(this).attr(config.RowSelectorAttr): config.RowSelector );
            var oRowColl = { RC: oFormsRows[intFormCount] };
            var oActionHeader = new ActionHdr(strActionCode, $(this).attr(config.MetaSessionIDAttr) );
            oForm = new FormData( $(this).attr('id'), oActionHeader, oRowColl );
            oForms[intFormCount] = oForm;
            intFormCount++;
        } );
    }
    else{
            oFormsRows[intFormCount] = CompileFormData( $(config.FormSelector), config.RowSelector );
            var oRowColl = { RC: oFormsRows[intFormCount] };
            var oActionHeader = new ActionHdr(strActionCode, strDefaultMetaSessionId );
            oForm = new FormData( $(config.FormSelector).attr('id'), oActionHeader, oRowColl );
            oForms[intFormCount] = oForm;
            intFormCount++;
    }
    oActionHeader = new ActionHdr(strActionCode, strDefaultMetaSessionId );
    var oFormColl = {FC: oForms};
    oDataPacket = new DataPacket(oActionHeader, oFormColl );
    strPortParam = config.QueryStringParamName + '=' + escape(JSON.stringify(oDataPacket));
    //strPortParam = config.QueryStringParamName + '=' + escape(JSON.stringify(oRowC));
    $.ajax( { type: 'POST', url: config.SubmitUrl, data: strPortParam, success: ajaxOnSuccess, error: ajaxOnError } );

    function CompileFormData(oParentContext, strRowSelector ){
        var oRows = [];
        intRowCount = 0;
        if( strRowSelector ){
            oParentContext.find(strRowSelector).each( function(){
                var oCols = [];
                intColCount = 0;
                $(this).find(strDataSelector).each( function(){
                    oCols[intColCount] = new ColData( intColCount, $(this).attr('name' ), ($(this).is('input:checkbox')? $(this).is(':checked').toString(): $(this).val()) );
                    intColCount++;
                });
                strRowValue = $(this).attr('id' )
                oRow = new DataRow( intRowCount, strRowValue, oCols );
                oRows[intRowCount++] = oRow;
            });
        }
        else{
            oParentContext.find(strDataSelector).each( function(){
                var oCols = [];
                intColCount = 0;
                oCols[intColCount] = new ColData( intColCount, $(this).attr('name' ), ($(this).is('input:checkbox')? $(this).is(':checked').toString(): $(this).val()) );
                intColCount++;
                oRow = new DataRow( intRowCount, strRowValue, oCols );
                oRows[intRowCount++] = oRow;
            });
        }
        return(oRows);
    }
    function ajaxOnSuccess(data)
    {
        var oResponse;
        if( data.length ){
            oResponse = JSON.parse(data);
            if( oResponse.FD ){
                ProcessAjaxFormResponse( oResponse );
            }
            
        }
        if( config.OnSuccess )  config.OnSuccess(data);
    }
    function ajaxOnError(XMLHttpRequest, textStatus, errorThrown)
    {
        alert( "A System Error occured while processing your request. Please redo your action. If this error persists, please contact technical support." );
    }
    function ProcessAjaxFormResponse( oResponse )
    {
        if( !oResponse || !oResponse.FD || !oResponse.FD.FC )
            return;
        for( var oForm in oResponse.FD.FC ){
            if( !oForm.AR || !oForm.AR.length || !oForm.AR.RC || !oForm.AR.RC.length )
                continue;
            for( var oRow in oForm.AR.RC ){
                if( !oRow.RD || !oRow.RD.length ){
                    for( var oCol in oRow.RD ){
                        if( oCol.RA )
                            UpdateField( oCol );
                    }
                }
            }
        }
        return;
    }
    function UpdateField( oCol )
    {
        switch( oCol.RA ){
            case 701: // Update Control Value
                // $(?? RowSelector).find( oCol.CD ).val( oCol.CV ); ???????????????????
                break;
        }
    }
}

function DataTable(strColumns) {
  var arCols = strColumns.split(',');
  var intNoCols = arCols.length;
  function newRow() {
    for (var intCount = 0; intCount < intNoCols; intCount++) {
      this[arCols[intCount]] = arguments[intCount];
    }
  }
  return newRow;
}

function OfbDialogClose(event){
    if( parent && parent.$ && parent.$.nyroModalRemove )
        parent.$.nyroModalRemove();
    else if( $ && $.nyroModalRemove )
        $.nyroModalRemove();
    return(false);
}