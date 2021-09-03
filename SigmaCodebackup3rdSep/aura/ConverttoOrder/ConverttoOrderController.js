({
    myAction : function(component, event, helper) {
        var sid = component.get("v.recordId");
        if(sid!=null && sid!='')
        {
            
      
        var action1 = component.get("c.getcustomsettings");
        action1.setCallback( this, function(res){  
            var state = res.getState();
            if (state === "SUCCESS")
            {  
                
                var getstatus = res.getReturnValue();  
              //  alert('data'+getstatus);
               /* if(getstatus.sigmaerpdev2__Proposal__c==true||getstatus.sigmaerpdev2__Order__c==true)
                {
                    var msg = "Can not convert Proposal to Order Please Look into seettings.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                } */
                if(getstatus.sigmaerpdev2__Standard_object__c==true)
                {
                    var msg = "Change the Order Usage to Sigma Order";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }
                else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }
            }
            if(sid!=null) 
            {
                var action = component.get("c.getProposal");
                action.setParams
                ({ 
                    "Proposalid": sid            
                });
                action.setCallback( this, function(a){            
                    var state = a.getState();
                    if (state === "SUCCESS")
                    {                
                        var sigmaOrder = a.getReturnValue(); 
                        if(sigmaOrder.sigmaerpdev2__Inventory_Allocated__c==true)
                        {
                            var msg = "Not Possible to Create order,Inventory is alredy allocated for this Proposal!";
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;
                        }
                       /* if(sigmaOrder.sigmaerpdev2__Type__c == 'Proposal')
                        {
                            var msg = "Can't Convert Proposal to Order";
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;
                        } */
                        
                        if(sigmaOrder.sigmaerpdev2__Status__c=='Signed')
                        {
                            component.set('v.Proposalname',sigmaOrder.sigmaerpdev2__Proposal_Name__c);
                            component.set("v.contactName",sigmaOrder.sigmaerpdev2__Client__r.Name);
                            component.set('v.Billingperson',sigmaOrder.sigmaerpdev2__Billing_Contact__r.Name);  
                            
                        }
                        if(sigmaOrder.sigmaerpdev2__Is_Order_Created__c==true)
                        {
                            var msg = "Order already Created for this Proposal.!";
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;
                            
                        }
                        else{
                            component.set("v.isError",false);
                            component.set("v.errorMsg", "");
                        }
                        if(sigmaOrder.sigmaerpdev2__Status__c!='Signed')
                        {
                            var msg = "Order can be created only for Proposal with Signed Status.";
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;
                        }
                        else{
                            component.set("v.isError",false);
                            component.set("v.errorMsg", "");
                        }
                        
                    }
                });
                
                $A.enqueueAction(action);
            }
            
        });
        $A.enqueueAction(action1);
      }
        
    },
    submit : function(component, event, helper) {
        document.getElementById("Accspinner").style.display = 'block';
        var sid = component.get("v.recordId");
        var action = component.get("c.saveOrder");
        action.setParams
        ({ 
            "Orderid": sid            
        });
        action.setCallback( this, function(a){  
            
            
            var state = a.getState();
            //alert('state'+state);
            if (state === "SUCCESS")
            {
                var sigmaOrder = a.getReturnValue(); 
                window.location.href = "/" + a.getReturnValue();
                
        	    document.getElementById("Accspinner").style.display = 'none';
                alert('Order Saved Successfully.');
                //window.location.href = "/" + a.getReturnValue();
            }
        });
        
        // Enqueue the action                  
        $A.enqueueAction(action); 
    },
    cancel : function(component, event, helper)
    {
        //history.back();
        window.location.href = "/" + component.get("v.recordId") ;
    }
})