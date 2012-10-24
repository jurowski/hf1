/***********************************************************************************************************************
 * File Name    : OfbValidationHelper.js
 * Date Created : 05/17/2008
 * Author       : Jalpesh Shah
 * Purpose      : This file has Javascript code required for Validating the clientside form validation. 
 * Usage        : Use this to Set the validation.
 * ---------------------------------------------------------------------------------------------------------------------
 * Revision history
 * ---------------------------------------------------------------------------------------------------------------------
 *  Author       Date       Description
 *----------------------------------------------------------------------------------------------------------------------
 * Jalpesh Shah		28/07/2008		Changed the property name PreDefRegexExpression from PredefinedRegexExpression 
 **********************************************************************************************************************/

function __ofbIsMandatory(oVal)
{
	 var blnRetVal;
	 oVal.isvalid = true;
     var strCtrlType = oVal.ControlType;
	 switch (strCtrlType) {
			case "Input":{
					blnRetVal = ValidateInput(oVal);
					break;
				}
			case "Select":{
					blnRetVal = ValidateSelect(oVal);
					 break;
				}
			case "Radio":{
					blnRetVal = ValidateRadio(oVal);
					break;
				}
			case "Checkbox":{
					blnRetVal = ValidateCheckBox(oVal);
					break;
				}
			default:{
				blnRetVal = ValidateInput(oVal);
				break;
				}
            }
            oVal.isvalid = blnRetVal;
           if(blnRetVal == false){
                AddDefaultSettings(oVal);
                return false;
           }
           else{
                RemoveDefaultSettings(oVal);
                return true;
           }
}
function __ofbIsValidRegex(oVal)
{
	var oCtrlToValidate ;
	 oVal.isvalid = true;
	if ((typeof(oVal) != "undefined")  && (oVal != null)) {
        oCtrlToValidate = document.getElementById(oVal.controltovalidate);
		if (TrimString(oCtrlToValidate.value).length == 0) {
        return true;
		}
		else if(!IsValidExpression(oVal,oCtrlToValidate)) {
		    oVal.isvalid = false;
			AddDefaultSettings(oVal);
			return false;
		}
		else {
			RemoveDefaultSettings(oVal);
			return true;
		}
    }


}

function ValidateRadio(oVal)
{
    return true;
}
function ValidateCheckBox(oVal)
{
    return true;
}
function ValidateSelect(oVal)
{
	if ((typeof(oVal) != "undefined")  && (oVal != null)) {
		if ((oVal.DefaultDropdownValue != "undefined")  && (oVal.DefaultDropdownValue != null)) {
			var intDropdownDefaultValue = oVal.DefaultDropdownValue;
			var oCtrlToValidate = document.getElementById(oVal.controltovalidate);
			if(oCtrlToValidate.value == intDropdownDefaultValue){
				return false;
			 }
			else{
				return true;
			 }
		}
		else{
			return;
		}

	}
}
function ValidateInput(oVal)
{
	if ((typeof(oVal) != "undefined")  && (oVal != null)) {
	   var oCtrlToValidate = document.getElementById(oVal.controltovalidate);
	   if (TrimString(oCtrlToValidate.value).length > 0){
			return true;
		}
		else{
			return false;
		}
	}
}

function IsValidExpression(oVal,oCtrlToValidate)
{
   var strCtrlValue ;
   var strRegExpression;
   var blnMatches ;
   var strPredefRegexExpression="";
   var strRegexValue="";
    if ((oCtrlToValidate != "undefined") && (oCtrlToValidate != null)) {
	   strCtrlValue =  oCtrlToValidate.value;
	   if (TrimString(oCtrlToValidate.value).length >0){
	      if ((typeof(oVal.PreDefRegexExpression) == "undefined") || (oVal.PreDefRegexExpression== null)) {
			   return true;
		   }
		  strPredefRegexExpression = oVal.PreDefRegexExpression;
		   if(strPredefRegexExpression != ""){
		    strRegexValue = strPredefRegexExpression ;
		   }
		   else{
		       if ((typeof(oVal.RegexExpression) == "undefined") || (oVal.RegexExpression== null)) {
			       return true;
		       }
		       strRegexValue = oVal.RegexExpression;
		    }
		strRegExpression= new RegExp(strRegexValue);
		blnMatches  = strRegExpression.exec(strCtrlValue);
		return (blnMatches != null && blnMatches[0]!= null);
		}
		else{
			return true;
		}
	}
}
