// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// from: http://marklunds.com/s5/rails101/html/ajax.html
// Will show the spinner whenever  
// an AJAX request is in process.  
Ajax.Responders.register({   
  onCreate: function(){   
    $('spinner').show();   
  },   
  onComplete: function() {   
    if(Ajax.activeRequestCount == 0)   
      $('spinner').hide();   
  }   
});   



// from: https://github.com/grosser/simple_auto_complete/blob/master/example_js/javascripts/application.js
jQuery(function($){//on document ready
  //autocomplete
  $('input.autocomplete').each(function(){
    var input = $(this);
    input.autocomplete(input.attr('data-autocomplete-url'),{
      matchContains:1,//also match inside of strings when caching
      //    mustMatch:1,//allow only values from the list
      //    selectFirst:1,//select the first item on tab/enter
      removeInitialValue:0//when first applying $.autocomplete
    });
  }); 
});