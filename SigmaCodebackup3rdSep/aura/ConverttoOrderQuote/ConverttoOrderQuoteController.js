({
    myAction : function(component, event, helper) {
       var sid = component.get("v.recordId");
         //var action1 = component.get("c.getcustomsettings");
         //action1.setCallback( this, function(res){  
            //  var state = res.getState();
            /*if (state === "SUCCESS")
            {  
                var getstatus = res.getReturnValue();  
                if(getstatus.sigmaerpdev2__Proposal__c==true||getstatus.sigmaerpdev2__Order__c==true)
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
            }*/
           //alert('sid'+sid);  
        var action = component.get("c.getQuote");
        action.setParams
        ({ 
            "Quoteid": sid            
        });
        action.setCallback( this, function(a){            
            var state = a.getState();
            if (state === "SUCCESS")
            {   
                
                var sigmaQuote = a.getReturnValue(); 
                //alert('sigmaQuote>>>0'+JSON.stringify(sigmaQuote));
                //alert('status>>'+sigmaQuote.sigmaerpdev2__Status__c);
                  /*if(sigmaOrder.sigmaerpdev2__Inventory_Allocated__c==true)
                        {
                            var msg = "Not Possible to Create order,Inventory is alredy allocated for this Proposal!";
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;
                        }*/
                if(sigmaQuote.sigmaerpdev2__Status__c=='Signed')
                {
                    component.set('v.Quotename',sigmaQuote.Name);
                    component.set("v.contactName",sigmaQuote.sigmaerpdev2__Account__r.Name);
                    component.set('v.Billingperson',sigmaQuote.sigmaerpdev2__Work_Order__r.sigmaerpdev2__FFP_MR_Contact__r.Name);    // change to dynamic   
                }
                 if(sigmaQuote.sigmaerpdev2__Is_Order_Created__c==true)
                {
                    var msg = "Order already Created for this Quote.!";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    
                }
                 else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    }
                if(sigmaQuote.sigmaerpdev2__Status__c!='Signed')
                {
                    var msg = "Order can be created only for Quote with Signed Status";
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
        
        //$A.enqueueAction(action);
         //});
          $A.enqueueAction(action);
        
    },
    submit : function(component, event, helper) {
        var sid = component.get("v.recordId");
        var action = component.get("c.saveOrderQuote");
        var spinner=component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        //alert('sid>>'+sid);
        action.setParams
        ({ 
            "Orderid": sid            
        });
        action.setCallback( this, function(a){            
            var state = a.getState();
            //alert('state++'+state);
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