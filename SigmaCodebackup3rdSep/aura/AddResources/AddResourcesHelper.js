({
	 updateData : function(component, event, helper) {
        var params = event.getParams();
        var RecipeManagementEvent = $A.get("e.c:RecipeManagementEvent");
        if(params.response.apiName == "sigmaerpdev2__Project_Resource__c")
        {
            RecipeManagementEvent.setParams({"flag":"updateresourcelist" });
            RecipeManagementEvent.fire();
        }else
        {
            RecipeManagementEvent.setParams({"flag":"refreshchild" });
            RecipeManagementEvent.fire();
        }
        
    },
     //added for reset UI
    removeResRelData: function (component, event, helper) {
        component.set("v.sigmaOrder.sigmaerpdev2__Customer_Type__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__BillingPersonNew__c",'');
        component.set("v.sigmaOrder.sigmaerpdev2__Orders_Status__c", 'Pending');
        component.set("v.sigmaOrder.sigmaerpdev2__Shipping_Street__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingCity__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingState__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingCountry__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingPostalCode__c", '');
        
    },
      helperGetResourceData:function (component, event, helper,accid) {
        var action = component.get("c.fetchResourceRelatedDataWrap");
        action.setParams({
            "resId": resid,
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                  
                    var resRelatedData=new Object();
                    if(returnData.allocaterresource){
                        resRelatedData.resourceRole=returnData.allocaterresource.sigmaerpdev2__Roles__c;
                        
                      
                       
                     }
                    component.set("v.resRelatedData",resRelatedData);
                //    alert(JSON.stringify('helperaccRelatedData:::'+JSON.stringify(resRelatedData)));
                }
                else
                    component.set("v.resRelatedData",'');
            }
            else{
                component.set("v.resRelatedData",'');
            }
        });
        $A.enqueueAction(action);
    },
   
 
})