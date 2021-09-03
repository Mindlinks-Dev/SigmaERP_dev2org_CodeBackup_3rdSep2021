({
	sendEmailMethod : function(component, event, helper) 
    {
		document.getElementById("Accspinner").style.display = "block";
        helper.sendEmailHelper(component);
	},
    showMainPage: function(component, event, helper){                
        var ordIdNo = component.get('v.orderSFId');
      if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
         
            // Redirecting to Lightning Record Page
              window.location.href = "/one/one.app#/sObject/" + ordIdNo;
        }
        else{
             
            // Redirecting to Classic Record Page
            window.location.href = "/" + ordIdNo;
        }    
         
         
    }
	
    
})