({
    sendEmailMethod : function(component, event, helper) 
    {
        
        document.getElementById("Accspinner").style.display = "block";
     
        
       // alert('order'+component.get("v.StndOrder"));
        if(component.get("v.SigmaOrder")==true)
            {
                helper.sendEmailHelper(component);     
            }
            else if(component.get("v.StndOrder")==true)
            {
                helper.sendstdEmailHelper(component);
            }   
    },
    showMainPage: function(component, event, helper){                
        var ordIdNo = component.get('v.orderSFId');
        var device = $A.get("$Browser.formFactor");  
        var regid =   component.get("v.regid");
		//alert(device);
        if(device==='PHONE'){
        //if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
            // Redirecting to Lightning Record Page
            //window.location.href = "/one/one.app#/sObject/" + ordIdNo;
        var homeEvent = $A.get("e.force:navigateToObjectHome");
       homeEvent.setParams({
           "scope": "ordIdNo"
       });
       homeEvent.fire();
        }
        
        else{
            // Redirecting to Classic Record Page
           // window.location.href = "/" + ordIdNo;
        window.history.back();
        }    
        
    }
    
    
})