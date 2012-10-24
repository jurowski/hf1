/***********************************************************************************************************************
 * File Name    : OfbNewWinHelper.js
 * Date Created : 09/10/2007
 * Author       : Sajeev Ravindran
 * Purpose      : This file has Javascript code required for Opening new Browser Window Pages
 * Usage        : Used internally to Open a new Browser Window
 * ---------------------------------------------------------------------------------------------------------------------
 * Revision history
 * ---------------------------------------------------------------------------------------------------------------------
 *  Author       Date       Description
 *----------------------------------------------------------------------------------------------------------------------
 * 
 **********************************************************************************************************************/
function OfbDisplayNewWindow(strUrl, strWindowTitle, strWindowProperties, strHiddenFieldName)
{
    if( strHiddenFieldName && strHiddenFieldName != null && strHiddenFieldName.length > 0 ){
        var oHiddenField = document.getElementById( strHiddenFieldName );
        if( oHiddenField && oHiddenField.tagName.toLowerCase() == 'input' && oHiddenField.type.toLowerCase() == 'hidden'){
            strUrl = oHiddenField.value;
        }
    }
    if(window.open)
        window.open(strUrl, strWindowTitle, strWindowProperties);
}
