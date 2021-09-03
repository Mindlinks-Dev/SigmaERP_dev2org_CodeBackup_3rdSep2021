({
	saveEditedStockH : function(component,event,helper) {
		var oldQty = component.get("v.reservedQty");				
		var rowId = component.get("v.prodId");        
		var showEditQuan = document.getElementById('requiredQnt_'+rowId);
		var newQty = showEditQuan.value;
		var manfID = component.get("v.recID");
		var editBtn = document.getElementById('edit_'+rowId);
		
		var productId = component.get("v.prodId");
		
		if(newQty == '' || isNaN(newQty)){
			var msg = '';
			if(newQty == ''){
				msg = 'Required quantity cannot be blank.';
			}				
			else if(isNaN(newQty)){
				msg = 'Invalid value for Required quantity.';
			}				
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"type": "error",
				"title": "Error!",
				"message": msg
			});
			toastEvent.fire();			
			if(editBtn.disabled == true){
				editBtn.disabled = false;            
			} 
			if(showEditQuan.disabled == false){               
				showEditQuan.disabled = true; 						    
			}
			showEditQuan.value = oldQty;
			return;	
		}else if(newQty <= 0){			
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"type": "error",
				"title": "Error!",
				"message": "Required quantity must greater than 0."
			});
			toastEvent.fire();			
			if(editBtn.disabled == true){
				editBtn.disabled = false;            
			} 
			if(showEditQuan.disabled == false){               
				showEditQuan.disabled = true; 						    
			}
			showEditQuan.value = oldQty;
			return;
		}
															
		if(oldQty != newQty){
			var action = component.get("c.editReservedStock");
			action.setParams({
				"manfID" : manfID,
				"oldVal" : oldQty,
				"newVal" : newQty,
				"prodId" : productId
			});
			action.setCallback(this, function(response){                
				var state1 = response.getState();                
				if(state1 == "SUCCESS"){
					var res = response.getReturnValue();					
					if(res == 'INCREASED'){
                        var spinner = component.find("mySpinner");
						$A.util.toggleClass(spinner, "slds-hide");
                        var action3 = component.get("c.viewReservedStock");
						action3.setParams({
							"manufactureRunObj": component.get("v.manfObj")
						});
						action3.setCallback(this, function (response1) {
							var response = response1.getReturnValue();
							component.set("v.orderItemNewForView", response);
						});
						$A.enqueueAction(action3);

						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"type": "success",
							"title": "Success!",
							"message": "Reserved Stock for the selected product has been increased successfully."
						});
						toastEvent.fire();	
					}else if(res == 'LOWSTOCK'){                        
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"type": "error",
							"title": "Error!",
							"message": "Stock is low for the selected product.Increase the Stock before trying to modify the reserved stock."
						});
						toastEvent.fire();                                                       	                        
					}else if(res == 'REDUCED'){ 
                        var spinner = component.find("mySpinner");
						$A.util.toggleClass(spinner, "slds-hide");
                        var action3 = component.get("c.viewReservedStock");
						action3.setParams({
							"manufactureRunObj": component.get("v.manfObj")
						});
						action3.setCallback(this, function (response1) {
							var response = response1.getReturnValue();
							component.set("v.orderItemNewForView", response);
						});
						$A.enqueueAction(action3);
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"type": "success",
							"title": "Success!",
							"message": "Reserved Stock for the selected product has been decreased successfully."
						});
						toastEvent.fire();
					}	                    
                    if(res == 'LOWSTOCK'){                                                                       
                       if(component.get("v.rowDetails.requiredQnt") != undefined){
                        	component.set("v.rowDetails.requiredQnt",oldQty); 	    
                       }
                       document.getElementById('requiredQnt_'+rowId).value = oldQty;
                    }else{						                       
                        if(component.get("v.rowDetails.requiredQnt") != undefined){
                        	component.set("v.rowDetails.requiredQnt",newQty);  	    
                        }                    	    
                    }                    
					if(editBtn.disabled == true){
						editBtn.disabled = false;            
					} 
					if(showEditQuan.disabled == false){               
						showEditQuan.disabled = true; 						    
					}                    
				}
			});
			$A.enqueueAction(action);			
		}else if(oldQty == newQty){
			if(editBtn.disabled == true){
				editBtn.disabled = false;            
			} 
			if(showEditQuan.disabled == false){               
				showEditQuan.disabled = true; 						    
			}
		}
	}
})