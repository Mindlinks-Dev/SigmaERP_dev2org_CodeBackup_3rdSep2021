({
    doInit : function(component, event, helper){
       
        var recordIdFromUi = component.get("v.recordId");
     
        helper.fetchProductInventory(component);
        
    },
	computeDifferenceQuantity : function(cmp,event,helper){
        
        var originalQty = cmp.find('originalQty').get('v.value');
        var adjustedQty = cmp.find('adjustedQty').get('v.value');
        var diffQty = originalQty - adjustedQty;                
        cmp.set('v.diffQnty',diffQty);        
    },
    
    updateStockAdjust : function(component, event, helper) {
       
       helper.adjustmentsHelperMethod(component);       
	},
    
    SelectedID : function(component, event) 
    {
		var context = event.getParam("instanceId");
		var objectId = event.getParam("sObjectId");
		var objectName = event.getParam("SObjectLabel");
       
		if(context === 'MyUser')
		{  
			var stockAdjustmentObjUi = component.get("v.StockAdjustmentObj");
			stockAdjustmentObjUi.sigmaerpdev__Authorized_By__c = objectId;
            component.set("v.StockAdjustmentObj",stockAdjustmentObjUi);  
            component.set("v.userName",objectName);
		}
    },
     BackButton:function(cmp, event){
       
       
        window.history.back();
    },
})