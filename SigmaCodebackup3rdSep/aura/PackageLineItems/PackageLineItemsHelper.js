({
     fetchProductImageDataHelper:function (component, event, helper,proId)
    {
        var action = component.get("c.fetchProductImageInformation");
        action.setParams({
            'prodId':proId
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
         // alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                console.log('data>>>'+JSON.stringify(data));
                if(data!=null){
                    component.set('v.ProductImageData',data);
                    component.set('v.productimageexist',true);
                    component.set('v.ProductView',true)
                }
                else{
                    component.set('v.productimageexist',false);
                    component.set('v.ProductView',true);
                   /* var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": "Image Is Not Available.."
                    });
                    resultsToast.fire();*/
                }
            }
        });
        $A.enqueueAction(action);
    },
    getBasketInfoH : function(component, event, helper) { 

        var status = component.get("v.headerStatus"); 
        if(status == 'In Progress' || status == 'Ready'){ //added on 17/4/2019
        	var action = component.get("c.getBasketInfo");
            action.setParams({
                "stappOrderId" : component.get("v.stappOrderID")
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();                        
                if (state === "SUCCESS"){															                    
                    var resp = response.getReturnValue();                  
                    if(resp.basketBarCode != null && resp.basketBarCode != undefined){
                        component.set("v.basketBarCodeValue", resp.basketBarCode);
                    }
                 /* else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Warning!",
                            "type" : "Warning",
                            "message": "No basket has been assigned for this Stapp Order.",
                        });
                        toastEvent.fire(); 
                    }  */
                }else{                                                       
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "Error",
                        "message": "Error occured while fetching  details11.",//"message": "Error occured while fetching basket details.",
                    });
                    toastEvent.fire();                     
                }             
            }));
            $A.enqueueAction(action);	
        }		
	},
    //Code added by rashmi to handle standard order in package on 25-07-2019
    getBasketOrderInfoH : function(component, event, helper) { 

        var status = component.get("v.headerStatus"); 
        if(status == 'In Progress' || status == 'Ready'){ //added on 17/4/2019
        	var action = component.get("c.getBasketInfoFromOrder");
            action.setParams({
                "stappOrderId" : component.get("v.stappOrderID")
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();                        
                if (state === "SUCCESS"){															                    
                    var resp = response.getReturnValue();                  
                    if(resp.basketBarCode != null && resp.basketBarCode != undefined){
                        component.set("v.basketBarCodeValue", resp.basketBarCode);
                    }
                 }else{                                                       
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "Error",
                        "message": "Error occured while fetching  details.",//"message": "Error occured while fetching basket details.",
                    });
                    toastEvent.fire();                     
                }             
            }));
            $A.enqueueAction(action);	
        }		
	},
    /* getBasketDetailsH : function(component, event, helper)
	{
       var baskBarCodeValue = component.get('v.basketBarCodeValue');
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");                    
        var action = component.get("c.getBasketDetails");
		 action.setParams({
            "barCodeVal" : baskBarCodeValue
        });
		 action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();  
            //alert('state==='+state); 
            if (state === "SUCCESS"){
                var resp = response.getReturnValue();  
                //alert('response==='+JSON.stringify(resp));
                //console.log('response==='+JSON.stringify(resp));                
               // component.set("v.stappOrderName", resp.stappOrderName); 
                component.set("v.soNameFromBasket1", resp.stappOrderName); 
                component.set("v.custId", resp.custId);                            
                component.set("v.custName1", resp.custName);                             
                component.set("v.stappOrderID", resp.stappOrderId); 
                if(component.get("v.isSigmaOrder")==false)
               {
                	component.set("v.stappOrderName", resp.stappOrderName); 
               }
               else
               {
                    component.set("v.standOrderNumber", resp.standOrderNumber);
               }
                //alert(resp.msg);
                if(resp.msg == 'Exists'){
                    if(component.get('v.stappOrderID') != '' && component.get('v.stappOrderID') != undefined){
                        var StappComponentEvent = component.getEvent("StappComponentEvent");
                        StappComponentEvent.setParams({
                            "data" : {"index":component.get('v.indexNum'),"soID":component.get('v.stappOrderID'),"soName":component.get('v.stappOrderName')},
                            "flag" : "fetchPPDataList"
                        });
                        StappComponentEvent.fire();    
                    }
                    else if(component.get('v.stappOrderID') != '' && component.get('v.stappOrderID') != undefined){
                        var StappComponentEvent = component.getEvent("StappComponentEvent");
                        StappComponentEvent.setParams({
                            "data" : {"index":component.get('v.indexNum'),"soID":component.get('v.stappOrderID'),"soName":component.get('v.standOrderNumber')},
                            "flag" : "fetchPPDataList"
                        });
                        StappComponentEvent.fire();
                    }
                }else if(resp.msg == 'Packaged'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "type" : "Warning",
                        "message": "Stapp Order associated with this basket has already been fully packaged.",
                    });
                    toastEvent.fire();
                  }
                    else if(resp.msg == 'Not-Assigned'){
                        if(component.get("v.packRecordId") == undefined){
                            component.set("v.custId", '');                            
                            component.set("v.custName1", '');      
                        }                                          
                        component.set("v.stappOrderID", ''); 
                        
                        if(component.get("v.isSigmaOrder")==false)
                       {
                           alert('Sales order');
                           component.set("v.stappOrderName", ''); 
                       }
                       else
                       {
                           alert('Order');
                           component.set("v.standOrderNumber", '');
                       }
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type" : "Error",
                            "message": "Selected basket is not associated with any of the Stapp Order.",
                        });
                        toastEvent.fire();
                        component.set('v.basketBarCodeValue', baskBarCodeValue);
                    }
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
            }
			else{
                //alert('im');
                if(component.get("v.packRecordId") == undefined){
                	component.set("v.custId", '');                            
                	component.set("v.custName1", '');      
                }                                          
                if(component.get("v.isSigmaOrder")==false)
                {
                    component.set("v.stappOrderName", ''); 
                }
                else
                {
                    component.set("v.standOrderNumber", '');
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "Error",
                    "message": "Selected basket is not associated with any of the Stapp Order.",
                });
                toastEvent.fire();
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                component.set('v.basketBarCodeValue', baskBarCodeValue);                            
            }             
        }));
        $A.enqueueAction(action);
    },*/
	
})