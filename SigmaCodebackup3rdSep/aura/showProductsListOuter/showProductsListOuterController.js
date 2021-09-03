({
	expandOrHide : function(component, event, helper) {
		var rowId = component.get("v.prodId");		  
        var selLineItem = document.getElementById('showHide_'+rowId);		           
        var imgId = document.getElementById('changeImage_'+rowId);         
        if(selLineItem.style.display == 'none') {  
            imgId.src= "/resource/sigmaerpdev2__NMinus";            
            imgId.title="Hide Stock";   
            selLineItem.style.display = 'block';            
        }else{             
            imgId.src= "/resource/sigmaerpdev2__NPlus";            
            imgId.title="Show Stock";   
            selLineItem.style.display = 'none';
        }
	},
    
    selectAutopick : function(component, event, helper){                
        var selStatus = component.get("v.manfstatusChild"); 
        if(selStatus == 'Planning'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Warning!",
                "message": "Auto Pick is not possible when Manufacturing Run is in Planning Stage."
            });
            toastEvent.fire();
            return;
        }
        var rowId = component.get("v.prodId");        
        var reqQuantity = component.get("v.rowDetails.requiredQnt");
        $.confirm({
                title: 'Are you sure?',
                content: 'You want to Allocate Stock automatically.',
                type: 'orange',
                typeAnimated: true,
                animation: 'scale',
                closeAnimation: 'scale',
                animationBounce: 2,
                buttons: {
                    Yes: {
                        text: 'Yes',
                        btnClass: 'btn-green',
                        action: function () {
                            window.setTimeout(
                                $A.getCallback(function () {
                                    var spinner = component.find("mySpinner");
                                    $A.util.toggleClass(spinner, "slds-hide");
                                    var action = component.get("c.AllocateStockUsingFIFODuringManufactureRun");
                                    action.setParams({
                                        "ProductId" : rowId,
                                        "reqQty" : reqQuantity,
                                        "manfRunId" : component.get("v.recID")
                                    });
                                    action.setCallback(this, function(response){
                                        var state = response.getState();                                        
                                        if(state == "SUCCESS"){                     
                                            component.set("v.showAutoReserve", false); //hide Auto reserve stock button once autopick stock is done.                                               
                                            var result = response.getReturnValue();               
                                            if(result == true){
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "type":"success",
                                                    "title": "Success!",
                                                    "message": "Auto Allocation done successfully."
                                                });
                                                toastEvent.fire();
                                                
                                                component.set("v.disableChkStkAfterAutopick",true); //set it to true so that Check Stock btn gets disabled in CheckManufacturingStock component
                                                
                                                document.getElementById('manualDiv_'+rowId).className = "slds-button slds-button_neutral disabledbutton";
                                                document.getElementById('autopickDiv_'+rowId).className = "slds-button slds-button_neutral disabledbutton";
                                                var action25 = component.get("c.getAutopickedStock"); //get back dynamically allocated stock
                                                action25.setParams({ 
                                                    "manfRunId" : component.get("v.recID"),
                                                    "ProductId" : rowId
                                                }); 
                                                action25.setCallback( this, function(response1) {
                                                    var state1 = response1.getState();                                                   
                                                    if (state1 === "SUCCESS"){ 
                                                        console.log('getAutopicked stock=='+JSON.stringify(response1.getReturnValue()));
                                                        component.set("v.rowDetails.wrapProdList",response1.getReturnValue()); 
                                                        component.set("v.rowDetails.allocatedViaAutopickOrManual",true);                                 
                                                    }
                                                });
                                                $A.enqueueAction(action25);
                                            }else if(result == false){
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "type":"error",
                                                    "title": "Warning!",
                                                    "message": "Not enough stock to do Auto Allocation."
                                                });
                                                toastEvent.fire();
                                            }else if(result == null){
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "type":"error",
                                                    "title": "Warning!",
                                                    "message": "Error during Auto Allocation."
                                                });
                                                toastEvent.fire();
                                            }
                                        }
                                        var spinner = component.find('mySpinner');
                                        $A.util.toggleClass(spinner, "slds-hide");        
                                    });        
                                    $A.enqueueAction(action);
                                }), 5
                            );                              
                        }                        
                    },
                    No: function () {                        
                    },
                }
            });
        /*if (confirm('Are you sure you want to Allocate Stock Automatically?')){            
        	var action = component.get("c.AllocateStockUsingFIFODuringManufactureRun");
            action.setParams({
                "ProductId" : rowId,
                "reqQty" : reqQuantity,
                "manfRunId" : component.get("v.recID")
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == "SUCCESS"){                     
                    component.set("v.showAutoReserve", false); //hide Auto reserve stock button once autopick stock is done.                                               
                    var result = response.getReturnValue();               
                    if(result == true){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Success!",
                            "message": "Auto Allocation done successfully."
                        });
                        toastEvent.fire();
                        
                        component.set("v.disableChkStkAfterAutopick",true); //set it to true so that Check Stock btn gets disabled in CheckManufacturingStock component
                        
                        document.getElementById('manualDiv_'+rowId).className = "slds-button slds-button_neutral disabledbutton";
                        document.getElementById('autopickDiv_'+rowId).className = "slds-button slds-button_neutral disabledbutton";
                        var action25 = component.get("c.getAutopickedStock"); //get back dynamically allocated stock
                        action25.setParams({ 
                            "manfRunId" : component.get("v.recID"),
                            "ProductId" : rowId
                        }); 
                        action25.setCallback( this, function(response1) {
                            var state1 = response1.getState();                            
                            if (state1 === "SUCCESS"){ 
                                console.log('getAutopicked stock=='+JSON.stringify(response1.getReturnValue()));
                                component.set("v.rowDetails.wrapProdList",response1.getReturnValue()); 
                                component.set("v.rowDetails.allocatedViaAutopickOrManual",true);                                 
                            }
                        });
                        $A.enqueueAction(action25);
                    }else if(result == false){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"error",
                            "title": "Warning!",
                            "message": "Not enough stock to do Auto Allocation."
                        });
                        toastEvent.fire();
                    }else if(result == null){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"error",
                            "title": "Warning!",
                            "message": "Error during Auto Allocation."
                        });
                        toastEvent.fire();
                    }
                }
               	var spinner = component.find('mySpinner');
        		$A.util.toggleClass(spinner, "slds-hide");         
            });        
            $A.enqueueAction(action);   
        }else{
            var spinner = component.find('mySpinner');
        	$A.util.toggleClass(spinner, "slds-hide");
        }*/
    },
    
    selectManual : function(component, event, helper){
        var selStatus = component.get("v.manfstatusChild"); 
        if(selStatus == 'Planning'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Warning!",
                "message": "Manual Selection of Stock is not possible when Manufacturing Run is in Planning Stage."
            });
            toastEvent.fire();
            return;
        }
        var rowId = component.get("v.prodId");
        document.getElementById('autopickDiv_'+rowId).className = "slds-button slds-button_neutral disabledbutton";
        var showStockList = document.getElementById('showdropdown_'+rowId);
        if(showStockList.style.display == 'none') {               
            showStockList.style.display = 'block';            
        }
    }
   
})