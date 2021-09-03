({
	 doInit: function(cmp, event, helper) 
    {
        //alert('Inside doInit>>');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        //alert('Inside doInit userId>>'+userId);
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
        var MainWrapperObject = cmp.get("v.MainWrapperObject");  
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        //alert('sPageURL::'+sPageURL);
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var allParam
        var i;
		
        //alert('sURLVariables.length is: '+sURLVariables.length);
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            //sParameterName = sURLVariables[i].split(',');
			//alert('sParameterName: '+sParameterName);
            if (sParameterName[0] === 'orderId') 
            { 
                 //alert('orderId::'+sParameterName[1]);
                 MainWrapperObject.OrderId = sParameterName[1];
            }
            else if(sParameterName[0] === 'registryId')
            {
                 //alert('registryId::'+sParameterName[1]);
                 MainWrapperObject.RegistryId = sParameterName[1];
            }
        }
        console.log('Param name'+sParameterName[0]);
        console.log('Param value'+sParameterName[1]);
        cmp.set("v.MainWrapperObject",MainWrapperObject);  
        
        
        
        var urlString = window.location.href;
        var CommunityBaseURL = urlString.substring(0, urlString.indexOf("/s/"));
        cmp.set(
            "v.LogoutURL",
            CommunityBaseURL +
            "/secur/logout.jsp?retUrl=" +
            CommunityBaseURL +
            "/s/login"
    );
         //console.log('MainWrapperObject: ' + JSON.stringify(cmp.get("v.MainWrapperObject")));
        if(userId==undefined)
        {
              helper.FetchOrderDetails(cmp, event, helper);
        }else
        {
            var spinner = cmp.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide"); 
        }
         
 	
  },
  
  goToBasicInfo: function(component, event, helper) {
    //alert('checkbox>>'+component.get('v.isSelected'));
    if (component.get("v.isSelected")) {
      component.set("v.showAggrementSection", false);
      component.set("v.showFailureSection", false);  
      component.set("v.showPaymentSection", true);
      //component.set("v.currentStep", "step-2");
    } else {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Accept terms and conditions."
      });
      toastEvent.fire();
      return;
    }
  },    
    
    
    
})