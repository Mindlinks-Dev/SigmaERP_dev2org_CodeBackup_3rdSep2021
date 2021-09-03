({
    myAction : function(component, event, helper) {
       var sid = component.get("v.recordId");
         /*var action1 = component.get("c.getcustomsettings");
         action1.setCallback( this, function(res){  
              var state = res.getState();
            if (state === "SUCCESS")
            {  
             
                var getstatus = res.getReturnValue();  
                if(getstatus.sigma__Proposal__c==true||getstatus.sigma__Order__c==true)
                {
                    var msg = "Can not convert Proposal to Order Please Look into settings.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }
                else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }
            } */
             
        var action = component.get("c.getOpportunity");
        action.setParams
        ({ 
            "Proposalid": sid            
        });
        action.setCallback( this, function(a){            
            var state = a.getState();
          // alert('state'+state);
            if (state === "SUCCESS")
            {   
                 
                var sigmaOrder = a.getReturnValue();
                var oppline = sigmaOrder.OpportunityLineItems;
                //alert('oppline'+JSON.stringify(sigmaOrder.Account));
                if(oppline == undefined)
                {
                    var msg = "Add Product before converting to order";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;   
                } 
                
                 else if(sigmaOrder.StageName!='Closed Won')
                {
                    var msg = "Order can be created only with Closed Won Stage";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }
                else if(sigmaOrder.sigmaerpdev__Is_Order_Created__c==true)
                        {
                            var msg = "Order already created for this Opportunity";
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;
                            
                        }
               else if(sigmaOrder.Account == undefined){
                  // alert('in');
                    var msg=" Add account name before converting to order";
                    component.set("v.isError",true);
                    component.set("v.errorMsg", msg);
                    return;
                    }
                    else
                    {
                        // alert('sigmaOrder>>'+JSON.stringify(sigmaOrder));
                    component.set('v.Proposalname',sigmaOrder.Name);
                    component.set("v.contactName",sigmaOrder.Account.Name);
                   // alert('amount'+sigmaOrder.Amount);  
                    component.set('v.Amount',sigmaOrder.Amount);
                    }
                
           }
        });
        
        $A.enqueueAction(action);
         
         
        
    },
    submit : function(component, event, helper) {
        var sid = component.get("v.recordId");
        var action = component.get("c.saveOrder");
        var spinner=component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        action.setParams
        ({ 
            "Orderid": sid            
        });
        action.setCallback( this, function(a){            
            var state = a.getState();
            if (state === "SUCCESS")
            { 
               
                var sigmaOrder = a.getReturnValue(); 
                alert('Order Saved Successfully.');
                window.location.href = "/" + a.getReturnValue();
            }
        });
        
        // Enqueue the action                  
        $A.enqueueAction(action); 
    },
    cancel : function(component, event, helper)
    {
    	history.back();
	} 
})