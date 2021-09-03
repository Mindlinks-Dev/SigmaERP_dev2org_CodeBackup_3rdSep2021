({
    helperConfirmPickMultiSO : function(component, event, helper,selectedSoIdList) 
    {
        var action = component.get("c.PickingPrintedOrderInBulk");
        action.setParams({
            'soIDList':selectedSoIdList
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") 
            {
                //var data = response.getReturnValue();
                //alert(data.message);
                //if(data.message=='success')
                //{
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "success",
                        "message": "Picking Done."
                    });
                    resultsToast.fire();
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');
                    $A.get("e.force:refreshView").fire();
                //}
                /*else if(data.message=='error')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": data.data
                    });
                    resultsToast.fire();
                    //$A.get("e.force:refreshView").fire();
                }*/
            }
            else{
                alert('Something Went Wrong');
                component.set('v.disableSave',false);
                var spinner=component.find('spinner');
                $A.util.toggleClass(spinner, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    	helperAllocatBulk : function(component, event, helper,selectedSoIdList)
    {
        var action = component.get("c.soBULKPickerAllocation");
        action.setParams({
            'soIdPickerIdMap':selectedSoIdList,
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") 
            {
                var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            //title : 'Alert',
                            message: 'User Allocated Successfuly',
                            messageTemplate: 'Record {0} created! See it {1}!',
                            duration:' 5000',
                            //key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                //alert('User Allocated Successfuly');
                //$A.get("e.force:refreshView").fire();
                //code added on 10 -02 -2020
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:SalesOrderModules",
                    componentAttributes: {
                        from : 'Picking'
                    }
                });
                evt.fire(); 
                 $A.get("e.force:refreshView").fire();
            }
            else{
                alert('Could not Allocate User-'+JSON.stringify(response.getError()));
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },
    getSOData : function(component, event, helper,sortField,ascDesc) 
    {
        var page = component.get("v.page") || 1;
        
     
       //  alert('getSOData is called');
        var action = component.get("c.fetchSOData2");
        action.setParams({
            'sortField':sortField,
            'ascDesc':ascDesc,
            'soId':component.get('v.soID'),
            'tabSelected':component.find('tabs').get('v.selectedTabId'),
            'numberOfRecordsToDisplay':component.get('v.numberOfRecordsToDisplay'),
            'pageNumber':page
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
           //  alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
            
            
           //alert(JSON.stringify(data.sigmaorderlistPickScreen.logedInUserId));
                console.log("data>>"+JSON.stringify(data));
            //console.log(JSON.stringify(accs));
                component.set('v.total', data.total);
                component.set('v.page', data.page);
                component.set('v.pages', Math.ceil(data.total/data.pageSize));
               // component.set("v.items",accs.PoWrapperList);
              //   alert('response111 >> SO created via :::'+JSON.stringify(data[0].sigmaOrder.sigmaerpdev2__Order_Created_Via__c));
                if(data==null)
                {
                    //alert(data);
                    component.set('v.isPicking',false); 
                    var msg = "Dont have Access to Proceed Picking , Please Check Inventory Status  in Custom Settings Default Parameters";
                    
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;            
                    
                }
                else
                {
                    //alert(data[0].isSystemAdmin);
                    //alert('data::11'+JSON.stringify(data));
                    // alert(data.sigmaOrder.Id);
                    //component.set('v.stappOrderData',data); 
                    component.set('v.isPicking',true); 
                    component.set('v.sigmaOrderData',data.sigmaorderlistPickScreen);
                    
                    //added on 30-07-2019
                  //   alert('data in else part>>');
                  if(data.length>0 && data.sigmaorderlistPickScreen.length>0 && data.sigmaorderlistPickScreen[0].sigmaOrder)
                  {
						component.set('v.ordercreated',data.sigmaorderlistPickScreen[0].sigmaOrder.sigmaerpdev2__Order_Created_Via__c);
                  
				  
                     // component.set('v.ordercreated',data[0].sigmaOrder.sigmaerpdev2__Order_Created_Via__c);
                  
				  }
                    
                    
                    //component.set('v.boolean',false);
                    //component.set('v.sigmaOrderData',data);
                    
                    // alert(data);
                    if(data.length>0)
                    {
                        component.set('v.totalRowCount',data.sigmaorderlistPickScreen[0].totalRowCount);
                    }
                    
                    
                }
                
                // var spinner=component.find('spinner');
                // $A.util.toggleClass(spinner, 'slds-hide');
                //if(component.find('tabs').get('v.selectedTabId')!='Picking In Progress'){
                //if(data.length>0)
                //component.set('v.isSystemAdmin',data[0].isSystemAdmin);
                //}
            }
            /* else{
                //alert(response.getError());
              //  var spinner=component.find('spinner');
              //  $A.util.toggleClass(spinner, 'slds-hide');
            }*/
        });
        $A.enqueueAction(action);
        //  alert('getSOData i s endded');
        //  alert("getSOData"+JSON.stringify(component.get("v.sigmaOrderLineWrapper")));
          //    var spinner=component.find('spinner');
          //      $A.util.toggleClass(spinner, 'slds-hide');
            // var spinner=component.find('spinner');
           //     $A.util.toggleClass(spinner, false);
           //    var elements = document.getElementsByClassName("slds-hide").innerHTML="slds-show";
		// elements[0] = 'none'; 
	//	component.set("v.isSpin", false);
    },
    helperAllocateUser : function(component, event, helper,pickIndex) 
    {
        //alert(component.get('v.stappOrderData')[pickIndex].PickedUser);
        var action = component.get("c.soPickerAllocation");
        action.setParams({
            //  'soID':component.get('v.stappOrderData')[pickIndex].stappOrder.Id,
            //   'userId':component.get('v.stappOrderData')[pickIndex].PickedUser
            'soID':component.get('v.sigmaOrderData')[pickIndex].sigmaOrder.Id,
            'userId':component.get('v.sigmaOrderData')[pickIndex].PickedUser
            
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                if(data=='success'){
                    //alert(JSON.stringify(data));
                    //  alert('User Allocated Successfuly');
                    $A.get("e.force:refreshView").fire();
                }
                else if(data=='Picking In Progress'){
                    //alert('Could not change user as the order Picking is in Progress');
                    $A.get("e.force:refreshView").fire();
                }
            }
            else{
                //  alert('Could not Allocate User');
            }
        });
        $A.enqueueAction(action);
    },
    getPickingDataHelper : function(component, event, helper,pickIndex) 
    {
        //alert('calling');
        var action = component.get("c.fetchPickingData");
        action.setParams({
            'soID':component.get('v.sigmaOrderData')[pickIndex].sigmaOrder.Id,
            'callingFrom':'NavigateToPicking'
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert('pickIndex'+pickIndex);
               //alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                // alert("data"+JSON.stringify(data));
                if(data.PickingDuplicateDataWrap.length>0){
                    var pickIndex1 = event.target.name;
                    //     alert('pickIndex1'+pickIndex1);
                    var sigmaOrderData=component.get('v.sigmaOrderData');
                   //  alert("sigmaOrderData"+JSON.stringify(sigmaOrderData));
                    
                    var SigmaOrderWrap=component.get('v.SigmaOrderWrap');
                     //  alert('SigmaOrderWrap:::::'+JSON.stringify(SigmaOrderWrap));
                    var originalILPLIData=component.get('v.originalILPLIData');
                     // alert('originalILPLIData:::::'+JSON.stringify(originalILPLIData));
                    var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
                    // alert('ilpliIdAllocatedQuantMap:::::'+JSON.stringify(ilpliIdAllocatedQuantMap));
                     
                    //code added to handle pickng page
                     component.set('v.soIDs',sigmaOrderData[pickIndex].sigmaOrder.Id);
                     component.set('v.soName',sigmaOrderData[pickIndex].sigmaOrder.Name);
                  //  alert('name++'+component.get('v.soIDs'));
                     var isSigmaOrder=component.get('v.isSigmaOrder');
                    component.set('v.isPicking',false);
                    component.set("v.pickingnew",true);
                   // alert('value>>'+component.get('v.pickingnew'));
                   
                   
                    
                    // component.set('v.soName',sigmaOrderData[pickIndex].sigmaOrder.Name);
                    //navigateToMyComponent : function(component, event, helper) 
                    //{
                 /*   var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:PickingNew",
                        componentAttributes: {
                            soID : sigmaOrderData[pickIndex].sigmaOrder.Id,
                            sigmaOrder:sigmaOrderData[pickIndex].sigmaOrder,
                            soName:sigmaOrderData[pickIndex].sigmaOrder.Name,
                            SigmaOrderWrap:component.get('v.SigmaOrderWrap'),
                            originalILPLIData:component.get('v.originalILPLIData'),
                            ilpliIdAllocatedQuantMap1:component.get('v.ilpliIdAllocatedQuantMap'),
                            //contactName : component.get("v.contact.Name"),
                            sigmaOrderLineWrapper:component.get('v.sigmaOrderLineWrapper'),
                            isSigmaOrder:isSigmaOrder,
                        }
                    });
                    evt.fire(); */
                    //}
                    
                    
                    
                    
                    
                    /*    component.find("nav").navigate({
                        type: "standard__component",
                        attributes: {
                            componentName: "c:PickingNew"
                            
                        },
                        state: {
                            soID : sigmaOrderData[pickIndex].sigmaOrder.Id,
                            soName:sigmaOrderData[pickIndex].sigmaOrder.Name, 
                           // SigmaOrderWrap:SigmaOrderWrap,
                           // originalILPLIData:originalILPLIData,
                           // ilpliIdAllocatedQuantMap1:ilpliIdAllocatedQuantMap,
                            SigmaOrderWrap:JSON.stringify(component.get('v.SigmaOrderWrap')),
                            originalILPLIData:component.get('v.originalILPLIData'),
                            ilpliIdAllocatedQuantMap1:component.get('v.ilpliIdAllocatedQuantMap'),
                            
                        }
                    });*/
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
                // var spinner=component.find('spinner');
                //  $A.util.toggleClass(spinner, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    helperProceedToPackShip: function(component, event, helper,index) 
    {
        var action = component.get("c.apexProceedToPackage");
        action.setParams({
            'soID':component.get('v.sigmaOrderData')[index].sigmaOrder.Id,
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
             //  alert('packageData for order::'+JSON.stringify(response.getState()));
            if (state === "SUCCESS") 
            {
                var packageData=response.getReturnValue();
               // alert('packageData for order::'+JSON.stringify(packageData));
                    console.log('packageData for order::'+JSON.stringify(packageData));
                packageData.packData.sobjectType = 'sigmaerpdev2__Package__c';
                var packageProductWrap=component.get('v.packageProductWrap');
                if(packageData.ppData.length>0){
                    for(var i=0;i<packageData.ppData.length;i++)
                    {
                        packageData.ppData[i].ppLineItemRec.sobjectType = 'sigmaerpdev2__PackagedProducts__c';
                    }
                    packageProductWrap[0].SOId = component.get('v.sigmaOrderData')[index].sigmaOrder.Id;
                    packageProductWrap[0].SOName = packageData.soName;
                    packageProductWrap[0].packageLinItems = packageData.ppData;
                    component.set('v.packageProductWrap',packageProductWrap);
                    packageData.packageProductWrap=packageProductWrap;
                    //alert(JSON.stringify(packageData.packData));
                }
                //  alert(JSON.stringify(packageData.packData));
                this.helperPopupProceedToPackShip(component, event, helper,packageData)
            }
            else{
                  alert('Either No data to Proceed or its already Picked');
            }
        });
        $A.enqueueAction(action);
    },
    helperPopupProceedToPackShip: function(component, event, helper,packageData) 
    {
        //  alert('helperPopupProceedToPackShip is called::custName::'+JSON.stringify(packageData.custName));
        //  alert('helperPopupProceedToPackShip is called::packData::'+JSON.stringify(packageData.packData));
        //   alert('helperPopupProceedToPackShip is called::packageProductWrap::'+JSON.stringify(packageData.packageProductWrap));
        // alert('helperPopupProceedToPackShip is called::packData::'+JSON.stringify(packageData.packData));
        var bool =true;
         if($A.get("$Browser.formFactor") !== "DESKTOP")
            bool = false; 
        $.confirm({
            title: 'Proceed To!',
            content: '',
            type: 'green', //
            boxWidth:bool?'25%':'90%',
            typeAnimated:true,
            useBootstrap:false,
            buttons: {
                package: {
                    text: 'Package',
                    btnClass: 'btn-green',
                    action: function()
                    {
                       // $A.get("e.force:refreshView").fire();
                      	component.set('v.customerName',packageData.custName);
                       // alert('custname'+component.get('v.customerName'));
                        component.set('v.package',packageData.packData);
                       // alert(''+component.get('v.package'));
                        component.set('v.packageProductWraplist',packageData.packageProductWrap);
                        component.set('v.isPicking',false);
                        component.set('v.ispackagecmp',true);
                        component.set('v.currectObject','Package');
                        component.set('v.description','Packages Tab');
                        component.set('v.descriptionBody','Functionality : To create package for Sales Order.');
                       //   var str1 = "Packages Tab";
			//var str2= "Functionality : To create package for Sales Order.";
                        
                        /* $A.get("e.force:navigateToComponent").setParams(
                            {
                                componentDef: "c:Package", 
                                componentAttributes: 
                                {
                                    "customerName":packageData.custName,
                                    "package": packageData.packData,
                                    "packageProductWrap": packageData.packageProductWrap,
                                    "fromPickingSlip": true,
                                    "isSigmaOrder" : component.get("v.isSigmaOrder"),
                                    "isSOComingFromPicking":"true",
                                    "isEditSOrder" : "true",
                                }
                            }).fire(); */
                    }
                },
                /*       shipment:{
                    text: 'Shipment',
                    btnClass: 'btn-green',
                    action: function()
                    {
                        helper.proceedToShipment(component, event, helper,packageData)
                                .then(
                                    // resolve handler
                                    $A.getCallback(function (result) {
                                        $A.get("e.force:refreshView").fire();
                                        //return anotherPromise();
                                        $A.get("e.force:navigateToComponent").setParams(
                                            {
                                                componentDef: "sigmaerpdev:Shipment", 
                                                componentAttributes: 
                                                {
                                                    "ShipmentLineWrap": result,
                                                    "fromPickingSlip": true
                                                }
                                            }).fire();
                                    }),
                                    // reject handler
                                    $A.getCallback(function (error) {
                                    })
                                )
                    }
                },*/
                 Cancel: function () 
                 {
                     text: 'Cancel'
                     
                     //$A.get("e.force:refreshView").fire();
                 }
             }
        });
        // alert('helperPopupProceedToPackShip is ended::');
        
    },
    /* proceedToShipment: function(component, event, helper,packageData)
    {
        alert('test'+JSON.stringify(packageData));
       
        return new Promise($A.getCallback(function(resolve) {
            var action = component.get("c.proceedToShipmentApex");
            alert('action>>>'+action);
            action.setParams({
                'packageData':JSON.stringify(packageData.packData),
                'ppData':JSON.stringify(packageData.packageProductWrap)
            });  
            action.setCallback(this, function(response) {
                var state = response.getState();
                alert(state);
                if (state === "SUCCESS") 
                {
                    alert(JSON.stringify(response.getReturnValue()));
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
    },*/
    helperPrintPdf : function(component, event, helper,selectedList) 
    {
        // alert('helper'+JSON.stringify(component.get("v.sigmaOrderLineWrapper")));
        //   var SigmaOrderWrap = component.get("v.SigmaOrderWrap");helperPrintPdf
        //  alert('SigmaOrderWrap:'+JSON.Stringify(SigmaOrderWrap));
        //  var ilpliIdAllocatedQuantMap = component.get("v.ilpliIdAllocatedQuantMap");
        // alert('ilpliIdAllocatedQuantMap:'+JSON.Stringify(ilpliIdAllocatedQuantMap));
        ///  var originalILPLIData = component.get("v.originalILPLIData");
        //  alert('originalILPLIData:'+JSON.Stringify(originalILPLIData));
        
        var action = component.get("c.fetchPrintPDFData");
        
        action.setParams({
            'soIdList':selectedList,
            'selectedTab':component.get('v.selectedTab')
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                /*for(var i=0;i<data.length;i++){
                    alert(data[i].soName);
                    if(data[i].PickingDuplicateDataWrap.length==0)
                    {
                        alert('Cant Print the PDF for Stapp Order '+data[i].soName+',because its \'Picking is in Progress\'');
                        return;
                    }
                }*/
                // var url = '/apex/sigmaerpdev2__PickingPDF?pickingPrintData='+JSON.stringify(data);
                // window.open(url);
                
                //code added to handle Print pdf after allocation on 31-07-2019 by rashmi
                var Order;
                if(component.get('v.isSigmaOrder')==true)
                    Order='SigmaOrder';
                else
                    Order='StandardOrder';
                console.log(window.location.href);
                let baseUrl=window.location.href.substring(0,window.location.href.indexOf("/one/"));
                 console.log("baseUrl"+baseUrl);
                var sigmaOrderLineWrapper= JSON.stringify(component.get("v.sigmaOrderLineWrapper"));
                var url1 = '/apex/sigmaerpdev2__PickingPDF?soIdList='+selectedList+'&selectedTab='+component.get('v.selectedTab')+'&solw='+sigmaOrderLineWrapper+'&Order='+Order; 
                window.open(url1);
                /* if(component.get('v.ConfigData')!=undefined && !component.get('v.ConfigData.stapp__Use_STD_Picking_PDF__c')){
                    var url1 = '/apex/Stapp__PickPDF?soIdList='+selectedList+'&selectedTab='+component.get('v.selectedTab');
                    window.open(url1);
                }
                else{
                    var url1 = '/apex/Stapp__PickingPDF?soIdList='+selectedList+'&selectedTab='+component.get('v.selectedTab');
                    window.open(url1);
                }*/
                $A.get('e.force:refreshView').fire();
            }
            else{
                // alert('Could not Print the PDF');
            }
        });
        $A.enqueueAction(action);
        
        // component.set('v.SigmaOrderWrap',SigmaOrderWrap);
        // component.set('v.ilpliIdAllocatedQuantMap',ilpliIdAllocatedQuantMap);
        //   component.set('v.originalILPLIData',originalILPLIData);
        
        //   alert('SigmaOrderWrap:'+JSON.Stringify(SigmaOrderWrap));
        //  var ilpliIdAllocatedQuantMap = component.get("v.ilpliIdAllocatedQuantMap");
        // alert('ilpliIdAllocatedQuantMap:'+JSON.Stringify(ilpliIdAllocatedQuantMap));
        //  var originalILPLIData = component.get("v.originalILPLIData");
        //   alert('originalILPLIData:'+JSON.Stringify(originalILPLIData));
        // var action = component.get("c.fetchPrintPDFData");
        // alert('helper'+JSON.stringify(component.get("v.sigmaOrderLineWrapper")));
    },
    helperPickPrinted: function(component, event, helper,index) 
    {
        //  alert('helperPickPrinted');
        var SigmaOrderWrap=component.get('v.SigmaOrderWrap');
        var originalILPLIData=component.get('v.originalILPLIData');
        var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
        //alert(JSON.stringify(component.get('v.SigmaOrderWrap')));
        //alert(JSON.stringify(component.get('v.originalILPLIData')));
        //alert(JSON.stringify(component.get('v.ilpliIdAllocatedQuantMap')));
        
        var action = component.get("c.PickingPrintedOrder");
        action.setParams({
            'soID':component.get('v.sigmaOrderData')[index].sigmaOrder.Id,
           // 'sow':JSON.stringify(SigmaOrderWrap),
          //  'ilplis':component.get('v.originalILPLIData'),
           // 'enteredQuantity':component.get('v.ilpliIdAllocatedQuantMap'),
            'solw':JSON.stringify(component.get('v.sigmaOrderLineWrapper')),
            
            
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //   alert(state);
            if (state === "SUCCESS") 
            {
                $A.get('e.force:refreshView').fire();
            }
            else{
                alert('Something Went Wrong');
            }
        });
        $A.enqueueAction(action);
    },
    helperAltPickForPrinted : function(component, event, helper,pickIndex) 
    {
        var action = component.get("c.fetchPickingData");
        action.setParams({
            'soID':component.get('v.sigmaOrderData')[pickIndex].sigmaOrder.Id,
            'callingFrom':'Printed'
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") 
            {
                //var spinner=component.find('spinner');
                //$A.util.toggleClass(spinner, 'slds-hide');
                var data = response.getReturnValue();
                //alert(JSON.stringify(data));
                if(data.PickingDuplicateDataWrap.length>0){
                    for(var i=0;i<data.PickingDuplicateDataWrap.length;i++)
                    {
                        data.PickingDuplicateDataWrap[i].totalPickedQty=data.PickingDuplicateDataWrap[i].reqQty;
                    }
                    component.set('v.dataForPicking',data);
                    component.set('v.altPickModelForPrinted',true);
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
                //$A.util.toggleClass(spinner, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
  /*  helperconfirmPicking:function(component, event, helper)
    {
        var action = component.get("c.sumbitAltPickFromPrinted");
        action.setParams({
            'pickedData':JSON.stringify(component.get('v.dataForPicking'))
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                //alert(data.message);
                if(data.message=='success')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "success",
                        "message": "Alternative Stock Allocated Successfully."
                    });
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else if(data.message=='error')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": data.data
                    });
                    resultsToast.fire();
                    //$A.get("e.force:refreshView").fire();
                }
            }
        });
        $A.enqueueAction(action);
    },*/
    
});