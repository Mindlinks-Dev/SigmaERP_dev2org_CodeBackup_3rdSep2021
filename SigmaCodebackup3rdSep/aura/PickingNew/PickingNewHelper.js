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
     ShowToastMessages:function (component, event, helper,title,message,type)
    {
         var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : title,
                    message:message,
                    messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
                    duration:' 5000',
                    key: 'info_alt',
                    type: type,
                });
                toastEvent.fire();
                return;        
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
                
                /*if(data.pickingData.stapp__Status__c=='Picked' || data.pickingData.stapp__Status__c=='Manual Pick')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "success",
                        "message": "This Order Already Picked. Click On 'ShowPicked' Button to see details."
                    });
                    resultsToast.fire();
                    //component.set('v.PickedFlag',true);
                }*/
                //alert(JSON.stringify(component.get('v.dataForPicking.')));
            }
            else{
                //var spinner=component.find('spinner');
              //  $A.util.toggleClass(spinner, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
  /*  helperAfterBasketScaned:function (component, event, helper,basketBarCodeValue){
        var action = component.get("c.getBasket");
        action.setParams({
            'basketBarCode':basketBarCodeValue,
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                if(data.stapp__Pickings__r==undefined)
                {
                    component.set('v.basket',data);
                    component.get('v.dataForPicking').basket=data;
                    //baskatName.set('v.value',data.Name);
                    //$A.util.removeClass(component.find('baskatName'), 'slds-hide');
                    component.set("v.basketFoundFlag",true);
                    component.set("v.scannedBasketName",data.Name);
                    component.set('v.isBarcodeScanned',true);
                    window.setTimeout(
                        $A.getCallback(function() {
                            var input = component.find("locScanedCode");
                            input.focus ();
                        }), 100
                    );
                }
                else{
                    alert('This Basket is in use with '+data.stapp__Pickings__r[0].stapp__Stapp_Order__r.Name+' and is \''+data.stapp__Pickings__r[0].stapp__Status__c+'\'');
                }
            }
            else
            {
                //baskatName.set('v.value','No Basket Found.');
                //$A.util.toggleClass(component.find('baskatName'), 'slds-hide');
                component.set('v.basket','');
                component.get('v.dataForPicking').basket='';
                component.set('v.isBarcodeScanned',false);
                component.set("v.scannedBasketName",'');
            }
        });
        $A.enqueueAction(action);
    },*/
    submitPickedDataHelper:function(component, event, helper)
    {
         var spinner=component.find('spinner');
            $A.util.toggleClass(spinner, 'slds-hide');
      //  alert('pickedData::'+JSON.stringify(component.get('v.dataForPicking')));
        var action = component.get("c.sumbitPickedData");
		
      //  alert('sigmaOrderLineWrapper>>>>'+JSON.stringify(component.get("v.sigmaOrderLineWrapper")));
       // alert('originalILPLIData>>>'+JSON.stringify(component.get("v.originalILPLIData")));
       // alert('ilpliIdAllocatedQuantMap1>>>'+JSON.stringify(component.get("v.ilpliIdAllocatedQuantMap1")));
		//component.get("v.originalILPLIData")
		
		//JSON.stringify(component.get('v.ilpliIdAllocatedQuantMap1'))
		//component.get("v.ilpliIdAllocatedQuantMap1")
        action.setParams({
            'pickedData':JSON.stringify(component.get('v.dataForPicking')),
			//'sow':JSON.stringify(component.get("v.SigmaOrderWrap")),
			//'ilplis':component.get("v.originalILPLIData"),
			//'enteredQuantity':component.get('v.ilpliIdAllocatedQuantMap1'),
            'solw':JSON.stringify(component.get("v.sigmaOrderLineWrapper")),
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
          //  alert("state::"+state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
           //     alert("data.message::"+JSON.stringify(data));
                
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
                   var evt = $A.get("e.force:navigateToComponent");
                	evt.setParams({
                    componentDef : "c:SalesOrderModules",
                    componentAttributes: {
                        from : 'Picking'
                    }
                	});
                	evt.fire();
                     $A.get('e.force:refreshView').fire();
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
                     $A.get('e.force:refreshView').fire();
                    //$A.get("e.force:refreshView").fire();
                }
                /*$.confirm({
                    title: 'Order Picked successfully!',
                    content: '',
                    type: 'green',
                    boxWidth:'32%',
                    typeAnimated: true,
                    useBootstrap:false,
                    buttons: {
                        package: {
                            text: 'Proceed to Package',
                            btnClass: 'btn-green',
                            action: function()
                            {
                                helper.proceedToPackage(component, event, helper,data.respPackData);
                            }
                        },
                        shipment:{
                            text: 'Proceed to Shipment',
                            btnClass: 'btn-green',
                            action: function()
                            {
                                helper.proceedToShipment(component, event, helper,data.respPackData)
                                .then(
                                    
                                    // resolve handler
                                    $A.getCallback(function (result) {
                                        //return anotherPromise();
                                        $A.get("e.force:navigateToComponent").setParams(
                                            {
                                                componentDef: "stapp:Shipment", 
                                                componentAttributes: 
                                                {
                                                    "ShipmentLineWrap": result
                                                }
                                            }).fire();
                                    }),
                                    // reject handler
                                    $A.getCallback(function (error) {
                                    })
                                )
                            }
                        },
                        close: function () 
                        {
                            text: 'Cancel'
                            $A.get("e.force:refreshView").fire();
                        }
                    }
                });*/
            }
        });
        $A.enqueueAction(action);
        
    },
    proceedToPackage: function(component, event, helper,packageData)
    {
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
                //alert(state);
                if (state === "SUCCESS") 
                {
                    //alert(JSON.stringify(response.getReturnValue()));
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
         //        var spinner=component.find('spinner');
          //  $A.util.toggleClass(spinner, 'slds-hide');
        var dataForPicking=component.get('v.dataForPicking');
      //  alert('helperStartPicking:: called :: dataForPicking::'+JSON.stringify(dataForPicking));
      //  alert('dataForPicking'+JSON.stringify(component.get('v.dataForPicking')));
      //  
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