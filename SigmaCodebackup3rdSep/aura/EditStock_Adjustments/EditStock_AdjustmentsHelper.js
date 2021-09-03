({
    fetchProductInventory : function(component, event) 
    {		       
       var recordInvId = component.get("v.recordId");
      
       var action = component.get("c.getSA");  
        action.setParams({
            "SAID" : recordInvId
        });
        
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                            
                               if (state=== 'SUCCESS')
                               {
                                 
                                   
                                     var SAObj = response.getReturnValue();
                                   var stockAdjustmentObj = component.get('v.StockAdjustmentObj');
                                   stockAdjustmentObj.sigmaerpdev__Original_Qty__c = SAObj.sigmaerpdev__Available_Inventory__c;
                                   stockAdjustmentObj.sigmaerpdev__Adjusted_Qty__c = SAObj.sigmaerpdev__Adjusted_Qty__c;
                                   stockAdjustmentObj.sigmaerpdev__Available_Inventory__c = SAObj.sigmaerpdev__Available_Inventory__c;
                                   stockAdjustmentObj.sigmaerpdev__Comments__c = SAObj.sigmaerpdev__Comments__c;
                                   stockAdjustmentObj.sigmaerpdev__Date__c = SAObj.sigmaerpdev__Date__c;
                                   stockAdjustmentObj.sigmaerpdev__Reason_Code__c = SAObj.sigmaerpdev__Reason_Code__c;
                                   component.set('v.StockAdjustmentObj',stockAdjustmentObj);
                                   component.set('v.ilpName',SAObj.sigmaerpdev__ILPName__c);
                                   component.set('v.PreviousQty',SAObj.sigmaerpdev__Adjusted_Qty__c);
                                   
                               }
                               else
                               { 
                                   
                              
                                  
                                var errors = response.getError();
                                   if (errors) {
                                       if (errors[0] && errors[0].message) {
                                           alert("Error message: " + 
                                                 errors[0].message);
                                       }
                                   } else {
                                       alert("Unknown error");
                                   }
                                  
                                   
                               }
                               
                           });
        
        $A.enqueueAction(action); 
       
                
        
    },
    adjustmentsHelperMethod : function(component) 
    {		   
        var stockAdjustments = component.get("v.StockAdjustmentObj");
        var PreviousQty = component.get('v.PreviousQty')
        var action = component.get("c.updateStockAdjustment");  
         var recordInvId = component.get("v.recordId");
       if(stockAdjustments.sigmaerpdev__Adjusted_Qty__c > stockAdjustments.sigmaerpdev__Available_Inventory__c)
       {
             var msg = "Please enter valid adjusted quantity.";
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
       }
      
        action.setParams({
            "stockAdjustments" : stockAdjustments,
            "PreviousQuantity" : PreviousQty,
            "SAID" : recordInvId
        });
        
        action.setCallback(this, function(response) 
                           {
                                if(response.getReturnValue() != null)
                                  {
                                    if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                                        sforce.one.navigateToSObject(response.getReturnValue().Id);
                                    }else{
                                        window.location.href = "/" + response.getReturnValue().Id;

                                   }    
                                  } else{
                                   alert('Stock Adjustment update Failed.');
                                 }   

                              
                               
                               
                               
                           });
        
        $A.enqueueAction(action); 
    }
})