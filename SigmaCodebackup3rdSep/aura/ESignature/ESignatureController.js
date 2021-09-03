({
    Init : function(component, event, helper) {  
        var RecordID = component.get("v.recordId");
        var action = component.get("c.fetchdetails");
        action.setParams({ 
            "ObjectId" : RecordID
        });
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               var state1 =response.getReturnValue();
                               if (state1 === "true1") 
                               {
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       title : 'Error',
                                       message: 'Product Transfer already taken for this Record',
                                       duration:' 10000',
                                       key: 'info_alt',
                                       type: 'error',
                                       mode: 'sticky'
                                   });
                                   toastEvent.fire();
                                   component.set("v.showproduct",false);
                                   return;
                               }
                           });
        
        $A.enqueueAction(action);
        helper.doInit(component, event, helper);
    },
    erase:function(component, event, helper){
        helper.eraseHelper(component, event, helper);
    },
    save:function(component, event, helper){
        var producttransfer = component.get("v.productvalidation");
       // alert('producttransfer>>>'+JSON.stringify(producttransfer));
        for(var i=0; i<producttransfer.length; i++)
        {
            var reqant = producttransfer[i].wrapProdList;
            
            for(var j=0; j<reqant.length; j++)
            {
                var result2 = producttransfer[i].wrapProdList[j].selQuantity;
                var quant = producttransfer[i].wrapProdList[j].quantity;
                var prodNames = producttransfer[i].wrapProdList[j].ProductName;
                if(result2 == undefined || result2 == null)
                {
                    j +=1;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Please fill the Received Quantity of ' +prodNames +' at line Number  '+ j,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }
                else if(result2 > quant)
                {
                     j +=1;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Received Quantity cannot be more than Transferred Quantity of '+ prodNames +' at line Number  '+ j,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return; 
                }
                 else if(result2 < 0)
                {
                    j +=1;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Received Quantity cannot be Negative of '+ prodNames +' at line Number '+ j,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return; 
                }
            }
        }
        helper.saveHelper(component, event, helper);
    }
})