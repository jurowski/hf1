/***********************************************************************************************************************
 * File Name    : OfbBaseValidationHelper.js
 * Date Created : 05/17/2008
 * Author       : Jalpesh Shah
 * Purpose      : This file has Javascript code required for Common functionality of validator control 
 * Usage        : Use this to Set the common functionality.
 * ---------------------------------------------------------------------------------------------------------------------
 * Revision history
 * ---------------------------------------------------------------------------------------------------------------------
 *  Author       Date       Description
 *----------------------------------------------------------------------------------------------------------------------
 * 
 **********************************************************************************************************************/
function TrimString(strVal) {
    var strRetVal = strVal.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (strRetVal == null) ? "" : strRetVal[1];
}
function AddDefaultSettings(oVal)
{
    var strMessageType = oVal.MessageType;
    if(strMessageType ==null){
        return;
    }
    if(oVal.display == "Dynamic"){
        switch (strMessageType){
            case "Alert":{
                PromptAlertMessage(oVal);
                break;
            }
            case "HighlightRow":{
                HighlightRow(oVal);
                break;
            }
        }
    }
	DisplaySummaryMessage(oVal);
	
}

function DisplaySummaryMessage(oVal)
{
    var oSummaryFormat;
    var arrCtrlPosition;
    var oDiv ;
    var strHidePanelMessage ;
    var arrHidePanelMessage;
    var intCount;
	if (typeof(Page_ValidationSummaries) == "undefined")
        return;

    for (intCount = 0; intCount< Page_ValidationSummaries.length; intCount++) {
	    oSummary = Page_ValidationSummaries[intCount];
		if((oSummary.showsummary != "False" ) || (oSummary.showmessagebox != "False" ))
			oSummary.validationGroup = oVal.validationGroup;
		if (typeof(oSummary.SummaryFormat) == "undefined")
            break;
		oSummaryFormat = oSummary.SummaryFormat;
		
        if(oSummaryFormat == null)
            break;
        switch (oSummaryFormat){
            case "Normal":{
                break;
            }
            case "Expandable":{
                ExpandableFormat(oSummary);
                break;
            }
        }
        if(typeof(oSummary.HidePanelsOnMessage) == "undefined")
		    return; 
		strHidePanelMessage = oSummary.HidePanelsOnMessage;
		arrHidePanelMessage = strHidePanelMessage.split("~");
		for (intCount = 0; intCount < arrHidePanelMessage.length; intCount++) {
				oDiv = document.getElementById(arrHidePanelMessage[intCount]);
		        if(oDiv){
		            oDiv.style.display = 'none';
		        }
		    }
        //arrCtrlPosition  = __ofbFindAbsolutePosition(oSummary);
        
    }
  //  if((arrCtrlPosition[0] != null) && (arrCtrlPosition[1] != null))
  //      window.scrollTo(arrCtrlPosition[0],arrCtrlPosition[1]);
        
}
function PromptAlertMessage(oVal)
{
   oVal.style.display = "none";
   oVal.style.visibility ="hidden";
   return false; 
}

function HighlightRow(oVal)
{
	var strCssClass;
	var strControlContainerRowID;
	if ((oVal.ControlContainerRowID == "undefined") || (oVal.ControlContainerRowID == null)) 
		return;
	strControlContainerRowID = oVal.ControlContainerRowID;
	if ((oVal.HighlightRowCSS != "undefined") && (oVal.HighlightRowCSS != null)) {
		strCssClass= oVal.HighlightRowCSS;
		if((strControlContainerRowID!= null) && (strControlContainerRowID!= ""))
		   changeClass(strControlContainerRowID,strCssClass);
	}
}
function RemoveHighlightedRow(oVal)
{
	var strControlContainerRowID;
	var oElement ;
	if ((oVal.ControlContainerRowID == "undefined") || (oVal.ControlContainerRowID == null)) 
		return;
    strControlContainerRowID = oVal.ControlContainerRowID;
   if ((strControlContainerRowID == "undefined") || (strControlContainerRowID == null) || (strControlContainerRowID == "")) 
		return;
    oElement = document.getElementById(strControlContainerRowID);
	if((oElement == null) || (oElement == "undefined"))
		return;
    oElement.setAttribute("class", ""); 
    oElement.setAttribute("className", ""); 
}

function changeClass (elementID, newClass) {
	var oElement;
	if((elementID == null) || (elementID == "undefined"))
		return;
	
	oElement = document.getElementById(elementID);
	if((oElement == null) || (oElement == "undefined"))
		return;
	oElement.setAttribute("class", newClass); 
	oElement.setAttribute("className", newClass); 
	
}
function Format(strVal)
{
	for(i = 1; i < arguments.length; i++){
		strVal = strVal.replace("{" + (i - 1) + "}", arguments[i]);
	}
	return strVal;
}

function RemoveDefaultSettings(oVal)
{
    var strMessageType = oVal.MessageType;
    var ret;
    if(strMessageType ==null){
        return;
    }
    switch (strMessageType){
        case "Alert":{
            PromptAlertMessage(oVal);
            break;
        }
        case "HighlightRow":{
            RemoveHighlightedRow(oVal);
            break;
        }
    }
}

function ExpandableFormat(oSummary)
{   
    var strAllMessage="";
	var strMessage ="";
	var stkErrorMessage = new Stack();
	var strPopMessage ;
	var strParentMarkup = "";
	var strAllChildMarkup = "";
	var strSingleChildMarkup ="";
	var strSingleMessage ="";
	var oShowSummaryInTable =""; 
	var ostrAnchor ="";
	var ctrlSingleMessage;
	var ctrlAllMessage ;
	if(typeof(Page_Validators) != "undefined"){
	    oSummary.showsummary = "False";
	    oSummary.style.display ="none";
		for (intCounter=0; intCounter<=Page_Validators.length - 1; intCounter++) {
		    if (!Page_Validators[intCounter].isvalid && typeof(Page_Validators[intCounter].errormessage) == "string") {
		        stkErrorMessage.push(Page_Validators[intCounter].errormessage);
              }
            }
		if( typeof(oSummary.ShowSummaryInTable) != "undefined")
	        oShowSummaryInTable = oSummary.ShowSummaryInTable
	    if( typeof(oSummary.MoreAnchor) != "undefined")
	        ostrAnchor = oSummary.MoreAnchor;
		 if (typeof(ParentMarkup) != "undefined"){
	         for (intParent=0; intParent <= ParentMarkup.length - 1; intParent++) {
		            strParentMarkup = ParentMarkup[intParent];
                }
         }
         if (typeof(AllChildMarkup) != "undefined"){
             for (intChild=0; intChild <= AllChildMarkup.length - 1; intChild++) {
		            strAllChildMarkup = AllChildMarkup[intChild];
                }
	     }
    	 if (typeof(SingleChildMarkup) != "undefined"){
             for (intOneChild=0; intOneChild <= SingleChildMarkup.length - 1; intOneChild++) {
		            strSingleChildMarkup = SingleChildMarkup[intOneChild];
                }
	     }
		

		 while (stkErrorMessage.errorLength >0){
             strPopMessage = stkErrorMessage.pop();
             if(stkErrorMessage.errorLength == 0)
                 strSingleMessage  = Format(strSingleChildMarkup , strPopMessage+ostrAnchor); 
 	         strMessage = Format(strAllChildMarkup,strPopMessage); 
	         strAllMessage = strAllMessage + strMessage ;
	    }
		 if(oSummary.SingleErrorLabelId != null){
	        ctrlSingleMessage = document.getElementById(oSummary.SingleErrorLabelId);
		}

		 if(ctrlSingleMessage != null){
	            ctrlSingleMessage.style.display="inline";
	            if((oShowSummaryInTable == "True") || (oShowSummaryInTable == "true"))
	            {
	                  strSingleMessage = Format(strParentMarkup,strSingleMessage); 
	                  strAllMessage = Format(strParentMarkup,strAllMessage); 
	            }    
    	        ctrlSingleMessage.innerHTML = Format(strParentMarkup,strSingleMessage); 
	            if(oSummary.AllErrorLabelId != null)
                    ctrlAllMessage  = document.getElementById(oSummary.AllErrorLabelId);
	            if(ctrlAllMessage != null)
	                ctrlAllMessage.innerHTML = Format(strParentMarkup,strAllMessage); 
	     }
	}

}



 function Stack()	//Creating Stack Object
    {
        // Create an empty array of errorMessageList.
        this.errorMessageList = new Array();  //errorMessageList array inside stack object
        this.push  = pushdata;      //Call pushdata function on push operation
        this.pop   = popdata;	     //Call popdata function on pop operation
        this.printStack = displayMessageColloection; //Call showStackData function on printstack operation
	  }
 
    function pushdata(data)
    {
        this.errorMessageList.push(data);
		this.errorLength =  this.errorMessageList.length;
    }
	function popdata(data)
    {
		this.errorLength =  this.errorMessageList.length - 1;
	    return this.errorMessageList.pop();			
    }
 
    function displayMessageColloection()
    {
        return this.errorMessageList;
    }
	function showLength()
	{
		return (this.errorMessageList.length);
	}
