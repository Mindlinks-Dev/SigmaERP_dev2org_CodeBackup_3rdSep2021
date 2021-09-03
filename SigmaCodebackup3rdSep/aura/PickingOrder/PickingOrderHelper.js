({
     helperConfirmPickMultiSO : function(component, event, helper,selectedOrderIdList) 
    {
        var action = component.get("c.PickingPrintedOrderInBulk");
        action.setParams({
            'orderIDList':selectedOrderIdList
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
    helperAllocatBulk : function(component, event, helper,selectedOrderIdList)
    {
        var action = component.get("c.OrderBULKPickerAllocation");
        action.setParams({
            'oIdPickerIdMap':selectedOrderIdList,
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
               // alert('User Allocated Successfuly');
               // $A.get("e.force:refreshView").fire();
               
                //code added on 10 -02 -2020
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:SalesOrderModules",
                    componentAttributes: {
                        from : 'Picking'
                    }
                });
                evt.fire();
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
        
       // alert('getSOData is called');
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
            //alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
				console.log("data>>"+JSON.stringify(data));
				if(data){
					
            //console.log(JSON.stringify(accs));
                component.set('v.total', data.total);
                component.set('v.page', data.page);
                component.set('v.pages', Math.ceil(data.total/data.pageSize));
					
				}
				   
				
                if(data==null)
                {
                    component.set('v.isPicking',false); 
                    var msg = "Dont have Access to Proceed Picking , Please Check Inventory Status  in Custom Settings Default Parameters";
                    
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;            
                    
                }
                else
                {
                    //component.set('v.stappOrderData',data); 
                    component.set('v.isPicking',true); 
					if(data && data.standardorderlistPickScreen){
                    component.set('v.standOrderData',data.standardorderlistPickScreen);
					}
                    //component.set('v.boolean',false);
                    
                     //added on 29-08-2019
                  	//   alert('data in else part>>');
                /*  if(data.length>0)
                  {
                      component.set('v.ordercreated',data[0].sigmaOrder.sigmaerpdev2__Order_Created_Via__c);
                  }*/
                    
                    if(data.length>0 && data.standardorderlistPickScreen[0])
                    {
                        component.set('v.totalRowCount',data.standardorderlistPickScreen[0].totalRowCount);
                    }
                    
                    
                }
            }
           /* else{
                //alert(response.getError());
                //  var spinner=component.find('spinner');
                //  $A.util.toggleClass(spinner, 'slds-hide');
            }*/
        });
        $A.enqueueAction(action);
        //  alert('getSOData i s endded');
        //  alert("getSOData"+JSON.stringify(component.get("v.standOrderLineWrapper")));
    },
    helperAllocateUser : function(component, event, helper,pickIndex) 
    {
        //alert(component.get('v.stappOrderData')[pickIndex].PickedUser);
        var action = component.get("c.soPickerAllocation");
        action.setParams({
            
            'soID':component.get('v.standOrderData')[pickIndex].standOrder.Id,
            'userId':component.get('v.standOrderData')[pickIndex].PickedUser
            
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") 
            {
                // alert('state>>'+state);
                var data = response.getReturnValue();
                if(data=='success'){
                    // alert(JSON.stringify(data));
                    alert('User Allocated Successfuly');
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
        var action = component.get("c.fetchPickingData");
        action.setParams({
            'soID':component.get('v.standOrderData')[pickIndex].standOrder.Id,
            'callingFrom':'NavigateToPicking'
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert('pickIndex'+pickIndex);
            // alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                // alert("data"+JSON.stringify(data));
                if(data.PickingDuplicateDataWrap.length>0){
                    var pickIndex1 = event.target.name;
                    //  alert('pickIndex1:::'+pickIndex1);
                    var standOrderData=component.get('v.standOrderData');
                    //  alert("standOrderData:::"+JSON.stringify(standOrderData));
                    var StandOrderWrap=component.get('v.StandOrderWrap');
                    //  alert('StandOrderWrap:::'+JSON.stringify(StandOrderWrap));
                    var originalILPLIData=component.get('v.originalILPLIData');
                    // alert('originalILPLIData:::::'+JSON.stringify(originalILPLIData));
                    var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
                    //  alert('ilpliIdAllocatedQuantMap:::::'+JSON.stringify(ilpliIdAllocatedQuantMap));
                    
                    
                    //code added to handle pickng page
                     component.set('v.soIDs',standOrderData[pickIndex].standOrder.Id);
                     component.set('v.soName',standOrderData[pickIndex].standOrder.OrderNumber);
                  //  alert('name++'+component.get('v.soIDs'));
                     //var isSigmaOrder=component.get('v.isSigmaOrder');
                    component.set('v.isPicking',false);
                    component.set("v.pickingordernew",true);
                   // alert('value>>'+component.get('v.pickingnew'));
                   // 
                    //  alert('soID>>'+standOrderData[pickIndex].standOrder.Id);
                    //alert('soName>>'+standOrderData[pickIndex].standOrder.Name);
                    //  alert('soName>>'+standOrderData[pickIndex].standOrder.OrderNumber);
                    //  alert('standOrderLineWrapper>>'+standOrderLineWrapper);
                    
                    
                 /*   var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:PickingOrderNew",
                        componentAttributes: {
                            soID : standOrderData[pickIndex].standOrder.Id,
                            soName:standOrderData[pickIndex].standOrder.OrderNumber,
                            StandOrderWrap:component.get('v.StandOrderWrap'),
                            originalILPLIData:component.get('v.originalILPLIData'),
                            ilpliIdAllocatedQuantMap1:component.get('v.ilpliIdAllocatedQuantMap'),
                            // contactName : component.get("v.contact.Name"),
                            standOrderLineWrapper:component.get('v.standOrderLineWrapper'),
                        }
                    });
                    evt.fire();*/
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
       // alert('proceed to package');
        var action = component.get("c.apexProceedToPackage");
        action.setParams({
            'soID':component.get('v.standOrderData')[index].standOrder.Id,
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            //   alert('packageData for order::'+JSON.stringify(response.getState()));
            if (state === "SUCCESS") 
            {
                var packageData=response.getReturnValue();
                // alert('packageData for order::'+JSON.stringify(packageData.soName));
                packageData.packData.sobjectType = 'sigmaerpdev2__Package__c';
                var packageProductWrap=component.get('v.packageProductWrap');
                if(packageData.ppData.length>0){
                    for(var i=0;i<packageData.ppData.length;i++)
                    {
                        packageData.ppData[i].ppLineItemRec.sobjectType = 'sigmaerpdev2__PackagedProducts__c';
                    }
                    packageProductWrap[0].SOId = component.get('v.standOrderData')[index].standOrder.Id;
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
                //  alert('Either No data to Proceed or its already Picked');
            }
        });
        $A.enqueueAction(action);
    },
    helperPopupProceedToPackShip: function(component, event, helper,packageData) 
    {
        var isMobileScreen=false;
        if($A.get("$Browser.formFactor") !== "DESKTOP")
        {
            isMobileScreen=true;
        }
        
        $.confirm({
            title: 'Proceed To!',
            content: '',
            type: 'green', 
            boxWidth:isMobileScreen? '90%':'25%',
            typeAnimated:true,
            useBootstrap:false,
            buttons: {
                package: {
                    text: 'Package',
                    btnClass: 'btn-green',
                    action: function()
                    {
                        //$A.get("e.force:refreshView").fire();
                        component.set('v.customerName',packageData.custName);
                        component.set('v.package',packageData.packData);
                        component.set('v.packageProductWraplist',packageData.packageProductWrap);
                     	component.set('v.isPicking',false);
                        component.set('v.ispackagecmp',true); 
                         component.set('v.currectObject','Package');
                        //component.set('v.description','Package Tab ');
                         //component.set('v.descriptionBody','Functionality : Create Package   for Customer');
                        component.set('v.description','Packages Tab');
                        component.set('v.descriptionBody','Functionality : To create package for Sales Order.');
                       //   var str1 = "Packages Tab";
			//var str2= "Functionality : To create package for Sales Order.";
                     /*   $A.get("e.force:navigateToComponent").setParams(
                            {
                                componentDef: "c:Package", 
                                componentAttributes: 
                                {
                                    "customerName":packageData.custName,
                                    "package": packageData.packData,
                                    "packageProductWrap": packageData.packageProductWrap,
                                    "fromPickingSlip": true,
                                    "isSigmaOrder" : component.get("v.isSigmaOrder"),
                                     // "isSOComingFromPicking":"true",
                                }
                            }).fire();*/
                    }
                },
                
                Cancel: function () 
                {
                    text: 'Cancel'
                    
                    //$A.get("e.force:refreshView").fire();
                }
            }
        });
        // alert('helperPopupProceedToPackShip is ended::');
        
    },
    
    helperPrintPdf : function(component, event, helper,selectedList) 
    {
        //    alert('helper'+JSON.stringify(component.get("v.standOrderLineWrapper")));
        //   var StandOrderWrap = component.get("v.StandOrderWrap");helperPrintPdf
        var action = component.get("c.fetchPrintPDFData");
        
        action.setParams({
            'soIdList':selectedList,
            'selectedTab':component.get('v.selectedTab')
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
          //  alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
              //  alert('data>>'+JSON.stringify(response.getReturnValue()));
              //  alert('helper'+JSON.stringify(component.get("v.selectedList")));                
              //  alert('helper'+JSON.stringify(component.get("v.standOrderLineWrapper")));
              //  alert('helper'+JSON.stringify(component.get("v.selectedTab")));
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
                var standOrderLineWrapper= JSON.stringify(component.get("v.standOrderLineWrapper"));
                var url1 = '/apex/sigmaerpdev2__PickingPDF?soIdList='+selectedList+'&selectedTab='+component.get('v.selectedTab')+'&solw='+standOrderLineWrapper+'&Order='+Order; 
                window.open(url1);
                
                $A.get('e.force:refreshView').fire();
            }
            else{
                //  alert('Could not Print the PDF');
            }
        });
        $A.enqueueAction(action);
        
        // component.set('v.StandOrderWrap',StandOrderWrap);
        
        //    alert('helper'+JSON.stringify(component.get("v.standOrderLineWrapper")));
    },
    helperPickPrinted: function(component, event, helper,index) 
    {
        //	alert('helperPickPrinted');
        var StandOrderWrap=component.get('v.StandOrderWrap');
        var originalILPLIData=component.get('v.originalILPLIData');
        var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
        //alert('StandOrderWrap'+JSON.stringify(component.get('v.StandOrderWrap')));
        //alert(JSON.stringify(component.get('v.originalILPLIData')));
        //alert(JSON.stringify(component.get('v.ilpliIdAllocatedQuantMap')));
        
        var action = component.get("c.PickingPrintedOrder");
        action.setParams({
            'soID':component.get('v.standOrderData')[index].standOrder.Id,
        //    'sow':JSON.stringify(component.get('v.StandOrderWrap')),
        //    'ilplis':component.get('v.originalILPLIData'),
        //    'enteredQuantity':component.get('v.ilpliIdAllocatedQuantMap'),
            'solw':JSON.stringify(component.get('v.standOrderLineWrapper')),
            
            
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert(state);
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
            'soID':component.get('v.standOrderData')[pickIndex].standOrder.Id,
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