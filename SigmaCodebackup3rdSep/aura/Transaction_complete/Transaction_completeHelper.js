({
    sendEmailHelper : function(cmp,event) {
        
        
        var action = cmp.get('c.sendEmail');
        var orderId = cmp.get('v.orderSFId');
        var regId = cmp.get('v.MainWrapperObject.RegistryId');
        var mailId= cmp.get('v.MainWrapperObject.EmailId');
        var Brewery=cmp.get('v.MainWrapperObject.BreweryName');
        
        action.setParams({
            "Id" : orderId,
            "regId": regId,
            "mailId": mailId,
            "Brewery": Brewery
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var getResult = response.getReturnValue();
            
            
            if (cmp.isValid() && state === "SUCCESS")
            {
                if(response.getReturnValue() != null){
                    alert('Email sent successfully');
                    if(cmp.get('v.frommagento'))
                    {
                        window.location.href = 'http://staging.quicksolar.com/payment/payment_controller/handlePaymentResponse?responseCode=0&responseToken=rA6OiCYKeY&transactionId=ch_1HbIz';
                    }
                }
                
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        alert('error');
                    }
                }
                else
                {
                    alert('error');
                }
            }
            document.getElementById("Accspinner").style.display = "none";
        }); 
        
        $A.enqueueAction(action);  
    }
    
})