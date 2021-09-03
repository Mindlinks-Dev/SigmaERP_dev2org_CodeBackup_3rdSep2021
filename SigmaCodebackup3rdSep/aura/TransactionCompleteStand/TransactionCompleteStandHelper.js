({
    sendEmailHelper : function(cmp,event) {
        var action = cmp.get('c.SendEmailOrder');
        var orderId = cmp.get('v.orderSFId');
        action.setParams({
            "OrderId" : orderId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var getResult = response.getReturnValue();
            if (cmp.isValid() && state === "SUCCESS")
            {
                if(response.getReturnValue() != null){
                    alert('Email sent successfully');
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