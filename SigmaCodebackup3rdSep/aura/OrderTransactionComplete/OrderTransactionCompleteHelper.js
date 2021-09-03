({
    sendEmailHelper : function(cmp,event) {
        
        
        var action = cmp.get('c.sendEmail');
        var orderId = cmp.get('v.OrderIds');
       
        
        action.setParams({
            "OrderIds" : orderId,
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var getResult = response.getReturnValue();
            
            
            if(state === "SUCCESS")
            {
                
                    alert('Email sent successfully');
                   window.history.back();
                
                
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
    },
    sendstdEmailHelper : function(cmp,event) {
        
        var action = cmp.get('c.SendEmailOrder');
        var orderId = cmp.get('v.OrderIds');
       //alert('orderId@@'+orderId);
        
        action.setParams({
            "OrderIds" : orderId,
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var getResult = response.getReturnValue();
           // alert(state);
            
            if(state == "SUCCESS")
            {
                
                    alert('Email sent successfully');
                   window.history.back();
                
                
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