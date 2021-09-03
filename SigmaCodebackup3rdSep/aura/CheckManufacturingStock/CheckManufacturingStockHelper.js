({
	reserveStockH: function (component, event, helper) {
		var myWrapList = component.get("v.orderItemNew");
		var manFacDetails = component.get("v.manfRunDet");
		var interimListUpdated = JSON.stringify(myWrapList).replace(/""/g, '"0"'); //convert to JSON string 
		//alert(JSON.stringify(myWrapList));
        var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		console.log('interimListUpdated::'+interimListUpdated);
		var action1 = component.get("c.reserveRecipeStock");
		action1.setParams({
			"selProductsList": interimListUpdated,
			"manfRunId": component.get("v.manfObj.Id"),
			"manufactureRunObj": component.get("v.manfObj"),
			"additionalProducts" : JSON.stringify(manFacDetails)
		});
		action1.setCallback(this, function (response1) {
			var state = response1.getState();
			if (state == "SUCCESS") {				
				component.set('v.isStockReservedStock', true);
				var ManufactureApplicationEvent = $A.get("e.c:ManufactureApplicationEvent");
				ManufactureApplicationEvent.setParams({ "flag": "stockReserved" });
				ManufactureApplicationEvent.fire();
				
				var action11 = component.get("c.fetchUnitPrice");
				action11.setParams({					
					"manfRunId": component.get("v.manfObj.Id")
				});
				action11.setCallback(this, function (response11) {
					var response = response11.getReturnValue();                    
					component.set("v.manfObj.sigmaerpdev2__Unit_Price__c",response.sigmaerpdev2__Unit_Price__c);                    
                    component.set("v.manfObj.sigmaerpdev2__Total_Cost__c",response.sigmaerpdev2__Total_Cost__c);                    
				});
				$A.enqueueAction(action11);

				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": "success",
					"title": "Success!",
					"message": "Stock required for this recipe has been reserved successfully."
				});
				toastEvent.fire();
			} else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": "success",
					"title": "Success!",
					"message": "Error occured:" + JSON.stringify(Error)
				});
				toastEvent.fire();
			}
			var spinner = component.find("mySpinner");
			$A.util.toggleClass(spinner, "slds-hide");
		});
		$A.enqueueAction(action1);
	},

	AutoReserveStockH: function (component, event, helper) {
		var manRunID = component.get("v.manfObj.Id");
		var manFacDetails = component.get("v.manfRunDet");		
		var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
        var fromSkipAllocFlow = false;
		var action2 = component.get("c.AutoReserveStockForManufactureRun");
		action2.setParams({
			"manRunID": manRunID,
			"manufactureRunObj": component.get("v.manfObj"),
			"data": JSON.stringify(manFacDetails),
            "fromSkipAllocFlow" : fromSkipAllocFlow
		});
		action2.setCallback(this, function (response1) {
			var responseState = response1.getState();
			var state = response1.getReturnValue();
			var res = state.split("_");
			if (state == 'true') {				
				component.set('v.isStockReservedStock', true);                
				var ManufactureApplicationEvent = $A.get("e.sigmaerpdev22:ManufactureApplicationEvent");
				ManufactureApplicationEvent.setParams({ "flag": "stockReserved" });
				ManufactureApplicationEvent.fire();												
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": "success",
					"title": "Success!",
					"message": "Stock required for this recipe has been auto reserved successfully."
				});
				toastEvent.fire();				
				var action12 = component.get("c.fetchUnitPrice");
				action12.setParams({					
					"manfRunId": component.get("v.manfObj.Id")
				});
				action12.setCallback(this, function (response12) {
                    var responseState = response12.getState();                    
					var response = response12.getReturnValue();	                    					
					component.set("v.manfObj.sigmaerpdev2__Unit_Price__c",response.sigmaerpdev2__Unit_Price__c);                    
                    component.set("v.manfObj.sigmaerpdev2__Total_Cost__c",response.sigmaerpdev2__Total_Cost__c);                   
				});
				$A.enqueueAction(action12);

				var action22 = component.get("c.viewReservedStock");
				action22.setParams({
					"manufactureRunObj": component.get("v.manfObj")
				});
				action22.setCallback(this, function (response11) {
					var response = response11.getReturnValue();
					component.set("v.orderItemNew", response);					
				});
				$A.enqueueAction(action22);
			} else if (res[0] == 'false') {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": "error",
					"title": "Error!",
					"message": "Stock quantity is low for the Product(s) '" + res[1] + "'. System cannot continue with the Auto Reserve-Stock process."					
				});
				toastEvent.fire();
			} else if (responseState == "ERROR") {				                
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": "error",
					"title": "Error!",
					"message": "Error occured : " + JSON.stringify(Error)
				});
				toastEvent.fire();
			}
			var spinner = component.find("mySpinner");
			$A.util.toggleClass(spinner, "slds-hide");
		});
		$A.enqueueAction(action2);
	},

	showStockH: function (component, event, helper) {        
		var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		var manRunID = component.get("v.manfObj.Id");
		var manufacturingQuantity = component.get("v.manfObj.sigmaerpdev2__Required_Quantity__c");
		var manFacDetails = component.get("v.manfRunDet");
        
		var showStock = component.find('showRow');
		$A.util.removeClass(showStock, "slds-hide");
		var action = component.get("c.getFullStock");
		action.setParams({
			"manfRunId": manRunID,
			"manfQuan": manufacturingQuantity,
			"data": JSON.stringify(manFacDetails)
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
            
			if (state == "SUCCESS") {
				component.set("v.showAutoResvBtn", true);
				component.set("v.orderItemNew", response.getReturnValue());
                //console.log('res=='+response.getReturnValue());
				var retValue = component.get("v.orderItemNew");                
				for (var i = 0; i < retValue[0].mainWrapProdList.length; i++) {
					if (retValue[0].mainWrapProdList[i].requiredQnt > retValue[0].mainWrapProdList[i].totalAvailQty) {
						component.set("v.disableBtnIfStockLow", true);
                    }else{
                        component.set("v.disableBtnIfStockLow", false);
                    }
				}
				var selStock = component.find('showReserveStockBtn');
				$A.util.removeClass(selStock, "slds-hide");
			}
			var spinner = component.find("mySpinner");
			$A.util.toggleClass(spinner, "slds-hide");
		});
		$A.enqueueAction(action);
	},

	editReservedStockH: function (component, event, helper) {
		var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		var manRunID = component.get("v.manfObj.Id");
		var manufacturingQuantity = component.get("v.manfObj.sigmaerpdev2__Required_Quantity__c");
		var manFacDetails = component.get("v.manfRunDet");		
		var showStock = component.find('showRow');
		$A.util.removeClass(showStock, "slds-hide");
		var action = component.get("c.getFullStock");
		action.setParams({
			"manfRunId": manRunID,
			"manfQuan": manufacturingQuantity,
			"data": JSON.stringify(manFacDetails)
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS"){				
				component.set("v.isStockReservedStock", false);
				component.set("v.editReservedStock", true);
				component.set("v.orderItemNew", response.getReturnValue());				
				console.log('logger::'+JSON.stringify(component.get("v.orderItemNew")));
			}
			var spinner = component.find("mySpinner");
			$A.util.toggleClass(spinner, "slds-hide");				
		});
		$A.enqueueAction(action);
	},

	showReserveStockBtnH : function(component, event, helper){         
		var getStock = component.get("v.orderItemNew");
        var currStatus = component.get("v.manfObj.sigmaerpdev2__Status__c");        
        if (currStatus == 'Date Confirmed' && getStock != null) {           
            var selStock = component.find('showReserveStockBtn');
            $A.util.removeClass(selStock, "slds-hide");
        }
	},

	showReservedStockH: function (component, event, helper) {
		var action3 = component.get("c.viewReservedStock");
		action3.setParams({
			"manufactureRunObj": component.get("v.manfObj")
		});
		action3.setCallback(this, function (response1) {
			var response = response1.getReturnValue();
			component.set("v.orderItemNewForView", response);
		});
		$A.enqueueAction(action3);
	},

	vieworDownloadPDFH: function (component, event, helper) {		
		var interimListUpdated;
		var myWrapListEditMode = component.get("v.orderItemNewForView");	
        var manRunID = component.get("v.manfObj.Id");
		interimListUpdated = JSON.stringify(myWrapListEditMode).replace(/""/g, '"0"');  //convert to JSON string		
		interimListUpdated = JSON.stringify(myWrapListEditMode).replace(/\+/g, "%2B"); //replace '+' with '%2B' or else '+' char will not be displayed in VF page.			                               				
        window.open('/apex/sigmaerpdev2__MR_Picking_Document?manfId='+manRunID);        				
	}
  
})