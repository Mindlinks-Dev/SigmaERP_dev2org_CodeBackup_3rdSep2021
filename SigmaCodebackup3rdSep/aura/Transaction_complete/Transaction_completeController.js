({
    sendEmailMethod : function(component, event, helper) 
    {
        
        document.getElementById("Accspinner").style.display = "block";
        helper.sendEmailHelper(component);
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
        else if(component.get('v.frommagento'))
            {
                window.location.href = 'http://staging.quicksolar.com/payment/payment_controller/handlePaymentResponse?responseCode=0&responseToken=rA6OiCYKeY&transactionId=ch_1HbIz';
                    
            }
        else if(regid!=null){
            var url=component.get('v.LogoutURL');
            alert('url?>>'+url);
            
            window.location.href = url;
            
        }
        else{
            // Redirecting to Classic Record Page
            window.location.href = "/" + ordIdNo;
        }    
        
    }
    
    
})