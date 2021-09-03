({
    fetchProductImageDataHelper:function (component, event, helper,proId)
    {
        var action = component.get("c.fetchProductImageInformation");
        action.setParams({
            'prodId':proId
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
           //alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                console.log('data>>>'+JSON.stringify(data));
                if(data!=null){
                    component.set('v.ProductImageData',data);
                    component.set('v.productimageexist',true);
                    component.set('v.ProductView',true);
                }
                else{
                      component.set('v.productimageexist',false);
                    component.set('v.ProductView',true);
                    /*var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": "Image Is Not Available."
                    });
                    resultsToast.fire();*/
                }
            }
        });
        $A.enqueueAction(action);
    },
    getPickingDataHelper : function(component, event, helper,soID) 
    {
        var action = component.get("c.fetchPickingData");
        action.setParams({
            'soID':soID,
            'callingFrom':'NewPicking'
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert(state);
            if (state === "SUCCESS") 
            {
                //var spinner=component.find('spinner');
                //$A.util.toggleClass(spinner, 'slds-hide');
                var data = response.getReturnValue();
               // alert(JSON.stringify(data));
                if(data.PickingDuplicateDataWrap.length>0){
                    component.set('v.dataForPicking',data);
                }
                else{
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": "No Picking Data found for this Order."
                    });
                    resultsToast.fire();
                }
                
                
            }
            else{
                //var spinner=component.find('spinner');
              //  $A.util.toggleClass(spinner, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
  
    submitPickedDataHelper:function(component, event, helper)
    {
        var spinner=component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
      //alert('pickedData::'+JSON.stringify(component.get('v.dataForPicking')));
        var action = component.get("c.sumbitPickedData");
		
      //alert('pickedData>>'+component.get('v.dataForPicking'));
      //alert('sow>>'+component.get("v.StandOrderWrap"));
        component.get("v.originalILPLIData")
        action.setParams({
            'pickedData':JSON.stringify(component.get('v.dataForPicking')),
         //   'sow':JSON.stringify(component.get("v.StandOrderWrap")),
		//	'ilplis':component.get("v.originalILPLIData"),
		//	'enteredQuantity':component.get('v.ilpliIdAllocatedQuantMap1'),
            'solw':JSON.stringify(component.get("v.standOrderLineWrapper")),
        }); 
       
        action.setCallback(this, function(response) {
            var state = response.getState();
           //alert("state::"+state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
              //alert("data.message::"+JSON.stringify(data));
                
                if(data.message=='success')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "success",
                        "message": "Order Picked Successfully."
                    });
                    resultsToast.fire();
                   // component.set('v.soID','');
                   // component.set('v.soName','');
                 /*   component.find("PickingNewNav").navigate({
                        type: "standard__component",
                        attributes: {
                            componentName: "c:PickingOrder"
                            
                        }
                    },true);*/
                     var evt = $A.get("e.force:navigateToComponent");
                	evt.setParams({
                    componentDef : "c:SalesOrderModules",
                    componentAttributes: {
                        from : 'Picking'
                    }
                	});
                	evt.fire();
                                  $A.get('e.force:refreshView').fire();//added on 01-05-2020
                    //$A.get("e.force:refreshView").fire();
                }
                else if(data.message=='error')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": data.data
                    });
                    resultsToast.fire();
                       $A.get('e.force:refreshView').fire();//added on 01-05-2020
                    //$A.get("e.force:refreshView").fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    proceedToPackage: function(component, event, helper,packageData)
    {
        alert('hi');
        packageData.packData.sobjectType = 'stapp__Package__c';
        var packageProductWrap=component.get('v.packageProductWrap');
        if(packageData.ppData.length>0){
            for(var i=0;i<packageData.ppData.length;i++)
            {
                packageData.ppData[i].ppLineItemRec.sobjectType = 'stapp__Packaged_Product__c';
            }
            packageProductWrap[0].SOId = component.get('v.soID');
            packageProductWrap[0].SOName = packageData.soName;
            packageProductWrap[0].packageLinItems = packageData.ppData;
            component.set('v.packageProductWrap',packageProductWrap);
        }
        $A.get("e.force:navigateToComponent").setParams(
            {
                componentDef: "stapp:Package", 
                componentAttributes: 
                {
                    "customerName":packageData.custName,
                    "package": packageData.packData,
                    "packageProductWrap": packageProductWrap
                }
            }).fire();
    },
    proceedToShipment: function(component, event, helper,packageData)
    {
        return new Promise($A.getCallback(function(resolve) {
            packageData.packData.sobjectType = 'stapp__Package__c';
            var packageProductWrap=component.get('v.packageProductWrap');
            if(packageData.ppData.length>0){
                for(var i=0;i<packageData.ppData.length;i++)
                {
                    packageData.ppData[i].ppLineItemRec.sobjectType = 'stapp__Packaged_Product__c';
                }
                packageProductWrap[0].SOId = component.get('v.soID');
                packageProductWrap[0].SOName = packageData.soName;
                packageProductWrap[0].packageLinItems = packageData.ppData;
                component.set('v.packageProductWrap',packageProductWrap);
            }
            var action = component.get("c.proceedToShipmentApex");
            action.setParams({
                'packageData':JSON.stringify(packageData.packData),
                'ppData':JSON.stringify(packageProductWrap)
            });  
            action.setCallback(this, function(response) {
                var state = response.getState();
             //   alert(state);
                if (state === "SUCCESS") 
                {
                   // alert(JSON.stringify(response.getReturnValue()));
                    var returnValue=response.getReturnValue();
                    var ShipmentLineWrap=component.get('v.ShipmentLineWrap');
                    if(returnValue.length>0){
                        returnValue[0].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                        ShipmentLineWrap[0].packageName=returnValue[0].packageName;
                        ShipmentLineWrap[0].shipLines=returnValue[0].shipLines;
                        component.set('v.ShipmentLineWrap',ShipmentLineWrap);
                    }
                    
                    //if (response.getReturnValue().message === "success") {
                    resolve(ShipmentLineWrap);
                    //}
                }
            });
            $A.enqueueAction(action);
        }));
    },
  
    helperStartPicking: function(component, event, helper){
        var dataForPicking=component.get('v.dataForPicking');
      //  alert('helperStartPicking:: called :: dataForPicking::'+JSON.stringify(dataForPicking));
        //alert(dataForPicking.PickingDuplicateDataWrap.length);
        var action = component.get("c.apexStartPicking");
        action.setParams({
            'pickingData':JSON.stringify(component.get('v.dataForPicking')),
            'soId':component.get('v.soID')
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
        //    alert(state);
            if (state === "SUCCESS") 
            {
                //var spinner=component.find('spinner');
                //$A.util.toggleClass(spinner, 'slds-hide');
                var data = response.getReturnValue();
                //alert(JSON.stringify(data.PickingDuplicateDataWrap[0].iaData));
              //  alert(JSON.stringify(data));
                if(data.PickingDuplicateDataWrap.length>0){
                    component.set('v.dataForPicking',data);
             		 
                        component.set('v.isBarcodeScanned',true);
                      
                }
                else{
                   var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": "No Picking Data found for this Order."
                    });
                    resultsToast.fire();
                }
            }
            else{
                
            }
        });
        $A.enqueueAction(action);
    }
})