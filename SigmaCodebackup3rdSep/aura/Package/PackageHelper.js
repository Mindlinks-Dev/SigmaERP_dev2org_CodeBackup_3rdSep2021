({
     checkDueAmmountOfOrder:function(cmp,event,helper,orderId2)
    {
       if(orderId2!=undefined && JSON.stringify(orderId2)!='""')
         {
              var action = cmp.get("c.fetchdueamount");
                action.setParams({ "SOId": orderId2,
                             });
        		action.setCallback(this, function (response) {
            var state = response.getState();
            //  alert('fetchDefaultParameters for standard order>>'+state )
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                 //  alert(data);
                if(data>0)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                      //  title : 'Error Message',
                        message:'amount paid Partially.... ',
                     //   messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();        
                }
                else{

                }
            }
        });
        $A.enqueueAction(action);
         }
    },
    helperFetchSOItems:function(component,event,helper,soID,soName,indx){
        //alert('helperFetchSOItems');
		var action = component.get("c.fetchStappOrderItems");
        action.setParams({ "soID": soID,"basketId":undefined});
        //action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = [];
                console.log("response>>SODATA>>"+response.getReturnValue());

                if(response.getReturnValue().length>0){
                    for(var i=0;i<response.getReturnValue().length;i++)
                    {
                        response.getReturnValue()[i].ppLineItemRec.sobjectType = 'sigmaerpdev2__PackagedProducts__c';
                        //response.getReturnValue()[i].ppLineItemRec.stapp__Status__c=component.get('v.package.stapp__Status__c');
                        result.push(response.getReturnValue()[i]);
                    }
                    //alert("From server: " + JSON.stringify(result));
                    var packageProductWrap = component.get('v.packageProductWrap');
                    packageProductWrap[indx].SOId = soID;
                    packageProductWrap[indx].SOName = soName;
                    packageProductWrap[indx].packageLinItems = result;
                    //alert(response.getReturnValue()[0].compId);
                   // alert(component.get('v.packageProductWrap'));
                    component.set('v.compId',response.getReturnValue()[0].compId);
                    component.set('v.packageProductWrap',packageProductWrap);
                    
                    var idListStr;
                    var packageProductWrap = component.get('v.packageProductWrap');
                    for(var i=0;i<packageProductWrap.length;i++)
                    {
                        if(i==0)
                            idListStr=packageProductWrap[i].SOId;
                        else
                            idListStr+='\',\''+packageProductWrap[i].SOId;
                    }
                    component.set('v.idListStr',idListStr);
                }
                else{
                    let isfound=false;
                     console.log('soID>>'+JSON.stringify(soID));
                    var action10 = component.get("c.validateSalesOrder");
                    
                     action10.setParams({ "OrderId": soID});
       
                    action10.setCallback(this, function (response) {
                        var state = response.getState();
                        console.log('state>>'+JSON.stringify(state));
                        //  alert('fetchDefaultParameters for standard order>>'+state )
                        if (state === "SUCCESS") {
                            
                            var data = response.getReturnValue();
                            console.log('data>>'+JSON.stringify(data));
                            
                            if(JSON.stringify(data)!='{}' && data!==undefined && data!==null && data!==NaN && data!==null)
                            {
                                //isfound=true;
                                let pp=data['Found'];
                                //let packageName=sp[0].sigmaerpdev2__Package_ID__r.Name;
                               // let ShipmentName=sp[0].sigmaerpdev2__Shipment__r.Name;
                                ////console.log('packageName'+packageName);
                                console.log('pp>>'+pp);
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    //title : 'Alert',
                                    message: 'Some of the line items of the Order are either Packaged or yet to be Picked.',
                                    messageTemplate: 'Record {0} created! See it {1}!',
                                    duration:' 5000',
                                    //key: 'info_alt',
                                    type: 'warning',
                                    mode: 'pester'
                                });
                                toastEvent.fire();
                                
                               // component.set("v.packageId","");
                              //  return;
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                    });
                    $A.enqueueAction(action10);
                    
                    
                    var packageProductWrap = component.get('v.packageProductWrap');
                    console.log('packageProductWrap[indx]>>'+JSON.stringify(packageProductWrap[indx]));
                    packageProductWrap[indx].SOId = soID;
                    packageProductWrap[indx].SOName = soName;
                    packageProductWrap[indx].packageLinItems = [];
                    
                     
                    component.set('v.packageProductWrap',packageProductWrap);
                    var idListStr;
                    var packageProductWrap = component.get('v.packageProductWrap');
                    for(var i=0;i<packageProductWrap.length;i++)
                    {
                        if(i==0)
                            idListStr=packageProductWrap[i].SOId;
                        else
                            idListStr+='\',\''+packageProductWrap[i].SOId;
                    }
                    component.set('v.idListStr',idListStr);
                }
              //  alert('wrap data:::'+JSON.stringify(component.get('v.packageProductWrap')));
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
     },
    //Code added by rashmi to handle standard order in package on 25-07-2019
  	helperFetchOrdItems:function(component,event,helper,soID,soName,indx){
		
		var action = component.get("c.fetchStandOrderItems");
        action.setParams({ "soID": soID,"basketId":undefined});
        //action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState();
           // alert("state>>"+state)
            if (state === "SUCCESS") {
                var result = [];
               // alert('frompackage'+JSON.stringify(response.getReturnValue()[0].solData));
                if(response.getReturnValue().length>0){
                    for(var i=0;i<response.getReturnValue().length;i++)
                    {
                        response.getReturnValue()[i].ppLineItemRec.sobjectType = 'sigmaerpdev2__PackagedProducts__c';
                        //response.getReturnValue()[i].ppLineItemRec.stapp__Status__c=component.get('v.package.stapp__Status__c');
                        result.push(response.getReturnValue()[i]);
                    }
                    //alert("From server: " + JSON.stringify(result));
                    var packageProductWrap = component.get('v.packageProductWrap');
                    packageProductWrap[indx].SOId = soID;
                    packageProductWrap[indx].SOName = soName;
                    packageProductWrap[indx].packageLinItems = result;
                    //alert(response.getReturnValue()[0].compId);
					//alert(component.get('v.packageProductWrap'));
                    component.set('v.compId',response.getReturnValue()[0].compId);
                    component.set('v.packageProductWrap',packageProductWrap);
                    
                    var idListStr;
                    var packageProductWrap = component.get('v.packageProductWrap');
                    for(var i=0;i<packageProductWrap.length;i++)
                    {
                        if(i==0)
                            idListStr=packageProductWrap[i].SOId;
                        else
                            idListStr+='\',\''+packageProductWrap[i].SOId;
                    }
                    component.set('v.idListStr',idListStr);
                }
                else{
                      console.log('soID>>'+JSON.stringify(soID));
                    var action10 = component.get("c.validateStandardOrder");
                    
                     action10.setParams({ "OrderId": soID});
       
                    action10.setCallback(this, function (response) {
                        var state = response.getState();
                        console.log('state>>'+JSON.stringify(state));
                        //  alert('fetchDefaultParameters for standard order>>'+state )
                        if (state === "SUCCESS") {
                            
                            var data = response.getReturnValue();
                            console.log('data>>'+JSON.stringify(data));
                            
                            if(JSON.stringify(data)!='{}' && data!==undefined && data!==null && data!==NaN && data!==null)
                            {
                                let pp=data['Found'];
                                //let packageName=sp[0].sigmaerpdev2__Package_ID__r.Name;
                               // let ShipmentName=sp[0].sigmaerpdev2__Shipment__r.Name;
                                ////console.log('packageName'+packageName);
                                console.log('pp>>'+pp);
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    //title : 'Alert',
                                    message: 'Some of the line items of the Order are either Packaged or yet to be Picked.',
                                    messageTemplate: 'Record {0} created! See it {1}!',
                                    duration:' 5000',
                                    //key: 'info_alt',
                                    type: 'warning',
                                    mode: 'pester'
                                });
                                toastEvent.fire();
                               // component.set("v.packageId","");
                              //  return;
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                    });
                    $A.enqueueAction(action10);
                    
                   
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    var packageProductWrap = component.get('v.packageProductWrap');
                    packageProductWrap[indx].SOId = soID;
                    packageProductWrap[indx].SOName = soName;
                    packageProductWrap[indx].packageLinItems = [];
                    component.set('v.packageProductWrap',packageProductWrap);
                    var idListStr;
                    var packageProductWrap = component.get('v.packageProductWrap');
                    for(var i=0;i<packageProductWrap.length;i++)
                    {
                        if(i==0)
                            idListStr=packageProductWrap[i].SOId;
                        else
                            idListStr+='\',\''+packageProductWrap[i].SOId;
                    }
                    component.set('v.idListStr',idListStr);
                }
              //  alert('wrap data:::'+JSON.stringify(component.get('v.packageProductWrap')));
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    removePPFromDataBase:function(component,event,helper,ppRemoveIdList){
			var action = component.get("c.deletePPLines");        
			action.setParams({ 
				"ppList" : ppRemoveIdList
			});
			action.setCallback( this, function(a){
				var state = a.getState();
				if (state === "SUCCESS")
				{
					var resultsToast = $A.get("e.force:showToast");
					resultsToast.setParams({
						"title": "Deleted",
						"message": "The PackageProducts deleted from Database also."
					});
					resultsToast.fire();
				}
			});
			$A.enqueueAction(action);
    },
       fetchConfigValues: function (component, event, helper) 
	   {
		var action = component.get("c.fetchConfigarationValues");
		action.setCallback(this, function (a) {
			var state = a.getState();
			if (state === "SUCCESS")
				{                
					if (a.getReturnValue() != null) 
					{
						component.set("v.configValues",a.getReturnValue());
					}
				}
        });
        $A.enqueueAction(action);
    },
    
    fetchPackageDataUpdate:function(component, event, helper,recId){
       //  alert('fetchPackageDataUpdate'+JSON.stringify(component.get("v.recordId")));
        var action = component.get("c.fetchPackageDataForEdit");
        if(recId!==undefined  && recId!==null && recId!=='' )
        {
            action.setParams({ "pId": recId,"customername":null});
        }
 
        
        action.setCallback(this, function (response) {
            var state = response.getState();
           // alert('state.....'+state);
             if (state === "SUCCESS") {
          //      alert(response.getReturnValue().pData.sigmaerpdev2__Customer__r.Name);
		   var data = response.getReturnValue();
                //  alert('data..........'+JSON.stringify(data));
				if(data==null)
				{
					component.set("v.isPackage",false);
						var msg = "Dont have Access to Proceed Package , Please Check Inventory Status  in Custom Settings Default Parameters";
						component.set("v.errorMsg", msg);
						component.set("v.isError",true);
						return;            
					
				}
				else
				{
                    /// alert("data"+JSON.stringify(data));
					component.set("v.isPackage",true);
						component.set("v.package",response.getReturnValue().pData);
						component.set("v.oldStatus",response.getReturnValue().pData.sigmaerpdev2__Status__c);
						if(component.get("v.package.sigmaerpdev2__Customer__c")!=undefined)
						{
							component.set("v.customerName",response.getReturnValue().pData.sigmaerpdev2__Customer__r.Name);
						}
						if(component.get("v.package.sigmaerpdev2__Location__c")!=undefined)
						{
							component.set("v.locationName",response.getReturnValue().pData.sigmaerpdev2__Location__r.Name);
					   }
					   // component.set('v.compId',response.getReturnValue().compId);
						component.set("v.packageProductWrap",response.getReturnValue().ppsow);
						var idListStr;
						var packageProductWrap = component.get('v.packageProductWrap');
						for(var i=0;i<packageProductWrap.length;i++)
						{
							if(i==0)
								idListStr=packageProductWrap[i].SOId;
							else
								idListStr+='\',\''+packageProductWrap[i].SOId;
						}
						component.set('v.idListStr',idListStr);
				}  
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    //Code added by rashmi to handle standard order in package on 24-07-2019
    fetchPackageOrdDataUpdate:function(component, event, helper,recId){
     //    alert('inside helper fetchPackageOrdDataUpdate');
        var action = component.get("c.fetchPackageOrderDataForEdit");
 
        action.setParams({ "pId": recId,"customername":null});
        action.setCallback(this, function (response) {
            var state = response.getState();
         //   alert(state +'in helper');
             if (state === "SUCCESS") {
          //      alert(response.getReturnValue().pData.sigmaerpdev2__Customer__r.Name);
		   var data = response.getReturnValue();
                 // alert(JSON.stringify(data) + 'in helper');
				if(data==null)
				{
					component.set("v.isPackage",false);
						var msg = "Dont have Access to Proceed Package , Please Check Inventory Status  in Custom Settings Default Parameters";
						component.set("v.errorMsg", msg);
						component.set("v.isError",true);
						return;        	
				}
				else
				{
					component.set("v.isPackage",true);
						component.set("v.package",response.getReturnValue().pData);
						component.set("v.oldStatus",response.getReturnValue().pData.sigmaerpdev2__Status__c);
						if(component.get("v.package.sigmaerpdev2__Customer__c")!=undefined)
						{
							component.set("v.customerName",response.getReturnValue().pData.sigmaerpdev2__Customer__r.Name);
						}
						if(component.get("v.package.sigmaerpdev2__Location__c")!=undefined)
						{
							component.set("v.locationName",response.getReturnValue().pData.sigmaerpdev2__Location__r.Name);
					   }
					   // component.set('v.compId',response.getReturnValue().compId);
					    //alert(JSON.stringify(data.ppsow) + 'in helper  packageProductWrap'); 
						component.set("v.packageProductWrap",response.getReturnValue().ppsow);
                    
						var idListStr;
						var packageProductWrap = component.get('v.packageProductWrap');
						for(var i=0;i<packageProductWrap.length;i++)
						{
							if(i==0)
								idListStr=packageProductWrap[i].SOId;
							else
								idListStr+='\',\''+packageProductWrap[i].SOId;
						}
						component.set('v.idListStr',idListStr);
				}  
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    saveDataHelper: function(component, event, helper,proceedToShipment) 
    {
        //alert(JSON.stringify(component.get('v.packageProductWrap')));
        //return;
        let recordId=component.get('v.recordId');
        //alert(JSON.stringify(recordId));
        var packageData = component.get('v.package');
       //alert('packageData'+JSON.stringify(packageData));
        var ppList = component.get('v.packageProductWrap');
       // alert(JSON.stringify(component.get('v.packageProductWrap')));
        var automateStockRes = component.get("v.autoAllocFlag");
       // alert(JSON.stringify(component.get('v.autoAllocFlag')));
        if(automateStockRes == false){
        	var action = component.get("c.savePackage");
            action.setParams({ "packageData": JSON.stringify(packageData),
                              "ppData": JSON.stringify(ppList),
                              "proceedToShipmentFlag":proceedToShipment? true:false
                             });
            action.setCallback(this, function (response) {
                var state = response.getState();
               //alert("state::"+state);
                if (state === "SUCCESS") {
                    var response1 =response.getReturnValue();
                  
                  // alert("response1"+JSON.stringify(response1));
                    // alert("response.getReturnValue().message::"+response.getReturnValue().message);
                    if(response.getReturnValue().message ==="success")
                    {
                    var data=response1.data;
                      let  name=data.substring(0, data.indexOf(","));
                        console.log('data>>>'+data);
                        console.log('name>>>'+name);
                         //let recordId=component.get('v.recordId');
                       
                        console.log('name>>>'+name);
                        
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
						if(packageData.sigmaerpdev2__Status__c == 'Un-Package')
						{
							var toastEvent = $A.get("e.force:showToast");
							toastEvent.setParams({
								"title": "Success!",
								"type" : "success",
								"message": "Unpacked Successfully."
							});
							toastEvent.fire();
						}
						else
						{
							var toastEvent = $A.get("e.force:showToast");
                            if(recordId==undefined)
                            {
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "type" : "success",
                                    "message": name+" Package created successfully."
                                });
                                
                            }
                            else
                            {
								toastEvent.setParams({
                                    "title": "Success!",
                                    "type" : "success",
                                    "message": name+" Package updated successfully."
                                });                                
                            }

							toastEvent.fire();
                            var packageProductWrap= component.get('v.packageProductWrap');
                            console.log('packageProductWrap>>>>>>>>>>'+JSON.stringify(packageProductWrap));

                            var orderId= component.get('v.orderId');
                              console.log('orderId>>>>>>>>>>>>>>>'+JSON.stringify(orderId));
                            if(JSON.stringify(orderId)!=undefined)
                            {
                                var objectFound= packageProductWrap.find((ele)=>{
                                    return  ele.SOId === orderId;
                                });
                                var objectFoundIndex= packageProductWrap.findIndex((ele)=>{
                                    return  ele.SOId === orderId;
                                });
                                packageProductWrap[objectFoundIndex].SOId='';
                                packageProductWrap[objectFoundIndex].SOName='';
                                packageProductWrap[objectFoundIndex].packageLinItems=[];
                                component.get('v.packageProductWrap',packageProductWrap)
                            }
                            var evt = $A.get("e.force:navigateToComponent");
                            evt.setParams({
                                componentDef : "c:SalesOrderModules",
                                componentAttributes: {
                                    from : 'PKG'
                                }
                            });
                            evt.fire();
                             $A.get('e.force:refreshView').fire();
                           // window.location.href = "/" +response.getReturnValue().data;
                            //rw.data;
						}
                        //$A.get("e.force:refreshView").fire();
                        if(proceedToShipment? true:false){
                            var ShipmentLineWrap=response.getReturnValue().shipmentData;
                            if(ShipmentLineWrap.length>0){
                                for(var i=0;i<ShipmentLineWrap.length;i++)
                                {
                                    ShipmentLineWrap[i].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                                    ShipmentLineWrap[i].packageName=ShipmentLineWrap[i].packageName;
                                }
                                //returnValue[0].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                                //ShipmentLineWrap[0].packageName=returnValue[0].packageName;
                                //ShipmentLineWrap[0].shipLines=returnValue[0].shipLines;
                                $A.get("e.force:navigateToComponent").setParams(
                                    {
                                        componentDef: "stapp:Shipment", 
                                        componentAttributes: 
                                        {
                                            "ShipmentLineWrap": ShipmentLineWrap
                                        }
                                    }).fire();
                            }
                        }
                        else {
                            /*var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "sigmaerpdev2__Package__c"
                            });
                            homeEvent.fire();*/
                        }
                    
                    }else
                    {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "error!",
                            "type" : "error",
                            "message": response.getReturnValue().data
                        });
                        toastEvent.fire();
                    }
                }else if (state === "INCOMPLETE") {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');                 
                }else if (state === "ERROR") {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        }else{
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);    
        }else{
            var action = component.get("c.AutomateStockReservationSavePackage");
            action.setParams({ "packageData": JSON.stringify(packageData),"ppData": JSON.stringify(ppList),"proceedToShipmentFlag":proceedToShipment? true:false});
            action.setCallback(this, function (response) {
                var state = response.getState();
                //alert('state==='+state);
                if (state === "SUCCESS") {
                    var response1=response.getReturnValue();
                    //alert('msg==='+response.getReturnValue().message);
                    if(response.getReturnValue().message ==="success")
                    {
                            var data=response1.data;
                      let  name=data.substring(0, data.indexOf(","));
                        console.log('data>>>'+data);
                        console.log('name>>>'+name);
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        if(packageData.sigmaerpdev2__Status__c == 'Un-Package')
						{
							var toastEvent = $A.get("e.force:showToast");
							toastEvent.setParams({
								"title": "Success!",
								"type" : "success",
								"message": "Unpacked Successfully."
							});
							toastEvent.fire();
						}
						else
						{
							var toastEvent = $A.get("e.force:showToast");
							 if(recordId==undefined)
                            {
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "type" : "success",
                                    "message": name+" Package created successfully."
                                });
                                
                            }
                            else
                            {
								toastEvent.setParams({
                                    "title": "Success!",
                                    "type" : "success",
                                    "message": name+" Package updated successfully."
                                });                                
                            }

							toastEvent.fire();
                            var packageProductWrap= component.get('v.packageProductWrap');
                            console.log('packageProductWrap>>>>>>>>>>'+JSON.stringify(packageProductWrap));

                            var orderId= component.get('v.orderId');
                              console.log('orderId>>>>>>>>>>>>>>>'+JSON.stringify(orderId));
                            if(JSON.stringify(orderId)!=undefined)
                            {
                                var objectFound= packageProductWrap.find((ele)=>{
                                    return  ele.SOId === orderId;
                                });
                                var objectFoundIndex= packageProductWrap.findIndex((ele)=>{
                                    return  ele.SOId === orderId;
                                });
                                packageProductWrap[objectFoundIndex].SOId='';
                                packageProductWrap[objectFoundIndex].SOName='';
                                packageProductWrap[objectFoundIndex].packageLinItems=[];
                                component.get('v.packageProductWrap',packageProductWrap)
                            }
                              var evt = $A.get("e.force:navigateToComponent");
                            evt.setParams({
                                componentDef : "c:SalesOrderModules",
                                componentAttributes: {
                                    from : 'PKG'
                                }
                            });
                            evt.fire();
                             $A.get('e.force:refreshView').fire();
						}
                      //  $A.get("e.force:refreshView").fire();
                        if(proceedToShipment? true:false){
                            var ShipmentLineWrap=response.getReturnValue().shipmentData;
                            if(ShipmentLineWrap.length>0){
                                for(var i=0;i<ShipmentLineWrap.length;i++)
                                {
                                    ShipmentLineWrap[i].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                                    ShipmentLineWrap[i].packageName=ShipmentLineWrap[i].packageName;
                                }
                                //returnValue[0].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                                //ShipmentLineWrap[0].packageName=returnValue[0].packageName;
                                //ShipmentLineWrap[0].shipLines=returnValue[0].shipLines;
                                $A.get("e.force:navigateToComponent").setParams(
                                    {
                                        componentDef: "stapp:Shipment", 
                                        componentAttributes: 
                                        {
                                            "ShipmentLineWrap": ShipmentLineWrap
                                        }
                                    }).fire();
                            }
                            
                        }
                        else{
                           /* var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "sigmaerpdev2__Package__c"
                            });
                            homeEvent.fire();*/
                        }
                    }else
                    {                       
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type" : "error",
                            "message": response.getReturnValue().message
                        });
                        toastEvent.fire();
                    }
                }else if (state === "INCOMPLETE") {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');                 
                }else if (state === "ERROR") {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        }else{
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);  
        }      
    },
    //Code added by rashmi to handle standard order in package on 24-07-2019
    saveOrdDataHelper : function(component, event, helper,proceedToShipment) 
    {
		//alert(JSON.stringify(component.get('v.packageProductWrap')));
        //return;
         let recordId=component.get('v.recordId');
                   //    alert(JSON.stringify(component.get('v.recordId')));
        var packageData = component.get('v.package');
       // alert(JSON.stringify(component.get('v.package')));
        var ppList = component.get('v.packageProductWrap');
      //  alert(JSON.stringify(component.get('v.packageProductWrap')));
        var automateStockRes = component.get("v.autoAllocFlag");
        console.log("automateStockRes>>>"+JSON.stringify(automateStockRes));
        if(automateStockRes == false){
        	var action = component.get("c.saveOrderPackage");
            action.setParams({ "packageData": JSON.stringify(packageData),
                              "ppData": JSON.stringify(ppList),
                              "proceedToShipmentFlag":proceedToShipment? true:false
                             });
            action.setCallback(this, function (response) {
                var state = response.getState();
               // alert("state::"+state);
                if (state === "SUCCESS") {
                     var result=response.getReturnValue(); 
                    console.log("result::"+JSON.stringify(result));
                     console.log("response.getReturnValue().message::"+response.getReturnValue().message);
                       console.log('data==='+result.data);
                    if(response.getReturnValue().message ==="success")
                    {
                           var data=result.data;
                      let  name=data.substring(0, data.indexOf(","));
                        console.log('data>>>'+data);
                        console.log('name>>>'+name);
                        
                      //  var spinner=component.find('spinner');
                       // $A.util.toggleClass(spinner, 'slds-hide');
						if(packageData.sigmaerpdev2__Status__c == 'Un-Package')
						{
							var toastEvent = $A.get("e.force:showToast");
							toastEvent.setParams({
								"title": "Success!",
								"type" : "success",
								"message": "Unpacked Successfully."
							});
							toastEvent.fire();
						}
						else
						{
							var toastEvent = $A.get("e.force:showToast");
                            if(recordId==undefined)
                            {
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "type" : "success",
                                    "message": name+" Package created successfully."
                                });
                                
                            }
                            else
                            {
                                 toastEvent.setParams({
                                    "title": "Success!",
                                    "type" : "success",
                                    "message": name+" Package updated  successfully."
                                });
                                
                                
                            }

							toastEvent.fire();
                               var packageProductWrap= component.get('v.packageProductWrap');
                            console.log('packageProductWrap>>>>>>>>>>'+JSON.stringify(packageProductWrap));

                            var orderId= component.get('v.orderId');
                              console.log('orderId>>>>>>>>>>>>>>>'+JSON.stringify(orderId));
                            if(JSON.stringify(orderId)!=undefined)
                            {
                                var objectFound= packageProductWrap.find((ele)=>{
                                    return  ele.SOId === orderId;
                                });
                                var objectFoundIndex= packageProductWrap.findIndex((ele)=>{
                                    return  ele.SOId === orderId;
                                });
                                packageProductWrap[objectFoundIndex].SOId='';
                                packageProductWrap[objectFoundIndex].SOName='';
                                packageProductWrap[objectFoundIndex].packageLinItems=[];
                                component.get('v.packageProductWrap',packageProductWrap)
                            }
                              var evt = $A.get("e.force:navigateToComponent");
                            evt.setParams({
                                componentDef : "c:SalesOrderModules",
                                componentAttributes: {
                                    from : 'PKG'
                                }
                            });
                            evt.fire();
                            
                             $A.get('e.force:refreshView').fire();
						}
                        //$A.get("e.force:refreshView").fire();
                        console.log("proceedToShipment::"+proceedToShipment);
                        if(proceedToShipment? true:false){
                            var ShipmentLineWrap=response.getReturnValue().shipmentData;
                            if(ShipmentLineWrap.length>0){
                                for(var i=0;i<ShipmentLineWrap.length;i++)
                                {
                                    ShipmentLineWrap[i].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                                    ShipmentLineWrap[i].packageName=ShipmentLineWrap[i].packageName;
                                }
                                //returnValue[0].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                                //ShipmentLineWrap[0].packageName=returnValue[0].packageName;
                                //ShipmentLineWrap[0].shipLines=returnValue[0].shipLines;
                                $A.get("e.force:navigateToComponent").setParams(
                                    {
                                        componentDef: "stapp:Shipment", 
                                        componentAttributes: 
                                        {
                                            "ShipmentLineWrap": ShipmentLineWrap
                                        }
                                    }).fire();
                            }
                        }
                        else {
                            /*
                            
                            var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "sigmaerpdev2__Package__c"
                            });
                            homeEvent.fire();*/
                        }
                    
                    }else
                    {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "error!",
                            "type" : "error",
                            "message": response.getReturnValue().data
                        });
                        toastEvent.fire();
                    }
                }else if (state === "INCOMPLETE") {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');                 
                }else if (state === "ERROR") {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        }else{
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);    
        }else{
            var action = component.get("c.AutomateStockReservationSavePackage");
            action.setParams({ "packageData": JSON.stringify(packageData),"ppData": JSON.stringify(ppList),"proceedToShipmentFlag":proceedToShipment? true:false});
            action.setCallback(this, function (response) {
                var state = response.getState();
              //  alert('state==='+state);
                if (state === "SUCCESS") {
                    var result=response.getReturnValue(); 
                    console.log("result::"+JSON.stringify(result));
                     console.log("response.getReturnValue().message::"+response.getReturnValue().message);
                       console.log('data==='+result.data);
                    /// var response1=response.getReturnValue();
                   console.log('msg==='+response.getReturnValue().message);
                     console.log('data==='+response.getReturnValue().data);
                    if(response.getReturnValue().message ==="success")
                    {
                           var data=result.data;
                      let  name=data.substring(0, data.indexOf(","));
                        console.log('data>>>'+data);
                        console.log('name>>>'+name); 
                        
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        if(packageData.sigmaerpdev2__Status__c == 'Un-Package')
						{
							var toastEvent = $A.get("e.force:showToast");
							toastEvent.setParams({
								"title": "Success!",
								"type" : "success",
								"message": "Unpacked Successfully."
							});
							toastEvent.fire();
						}
						else
						{
							var toastEvent = $A.get("e.force:showToast");
							  if(recordId==undefined)
                            {
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "type" : "success",
                                    "message": name+" Package created successfully."
                                });
                                
                            }
                            else
                            {
                                 toastEvent.setParams({
                                    "title": "Success!",
                                    "type" : "success",
                                    "message": name+" Package updated  successfully."
                                });
                                
                                
                            }

							toastEvent.fire();
                            var packageProductWrap= component.get('v.packageProductWrap');
                            console.log('packageProductWrap>>>>>>>>>>'+JSON.stringify(packageProductWrap));

                            var orderId= component.get('v.orderId');
                              console.log('orderId>>>>>>>>>>>>>>>'+JSON.stringify(orderId));
                            if(JSON.stringify(orderId)!=undefined)
                            {
                                var objectFound= packageProductWrap.find((ele)=>{
                                    return  ele.SOId === orderId;
                                });
                                var objectFoundIndex= packageProductWrap.findIndex((ele)=>{
                                    return  ele.SOId === orderId;
                                });
                                packageProductWrap[objectFoundIndex].SOId='';
                                packageProductWrap[objectFoundIndex].SOName='';
                                packageProductWrap[objectFoundIndex].packageLinItems=[];
                                component.get('v.packageProductWrap',packageProductWrap)
                            }
                              var evt = $A.get("e.force:navigateToComponent");
                            evt.setParams({
                                componentDef : "c:SalesOrderModules",
                                componentAttributes: {
                                    from : 'PKG'
                                }
                            });
                            evt.fire();
                           
                            
                             $A.get('e.force:refreshView').fire();
						}
                        $A.get("e.force:refreshView").fire();
                         console.log('proceedToShipment>>'+proceedToShipment);
                        if(proceedToShipment? true:false){
                            var ShipmentLineWrap=response.getReturnValue().shipmentData;
                            if(ShipmentLineWrap.length>0){
                                for(var i=0;i<ShipmentLineWrap.length;i++)
                                {
                                    ShipmentLineWrap[i].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                                    ShipmentLineWrap[i].packageName=ShipmentLineWrap[i].packageName;
                                }
                                //returnValue[0].shipLines.sobjectType = 'stapp__Shipment_Line_Item__c';
                                //ShipmentLineWrap[0].packageName=returnValue[0].packageName;
                                //ShipmentLineWrap[0].shipLines=returnValue[0].shipLines;
                                $A.get("e.force:navigateToComponent").setParams(
                                    {
                                        componentDef: "stapp:Shipment", 
                                        componentAttributes: 
                                        {
                                            "ShipmentLineWrap": ShipmentLineWrap
                                        }
                                    }).fire();
                            }
                            
                        }
                        else{
                            /*var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "sigmaerpdev2__Package__c"
                            });
                            homeEvent.fire();*/
                        }
                    }else
                    {                       
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type" : "error",
                            "message": response.getReturnValue().message
                        });
                        toastEvent.fire();
                    }
                }else if (state === "INCOMPLETE") {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');                 
                }else if (state === "ERROR") {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        }else{
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);  
        }
    },
    savePackAndDeliveryNote : function(component, event, helper,saveAndDeliveryNote ) 
    {
        var packageData = component.get('v.package');
        var ppList = component.get('v.packageProductWrap');
        var automateStockRes = component.get("v.autoAllocFlag");
        var noteType = component.get("v.noteType");
        if(automateStockRes == false ){
        	var action = component.get("c.savePackage");
            action.setParams({ "packageData": JSON.stringify(packageData),
                              "ppData": JSON.stringify(ppList),
                              "proceedToShipmentFlag":false
                             });
            action.setCallback(this, function (response) {
                var state = response.getState();
              //  alert("state::"+state)
                if (state === "SUCCESS") {
                    if(response.getReturnValue().message ==="success")
                    {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type" : "success",
                            "message": "Package created successfully."
                        });
                        toastEvent.fire();
                        //$A.get("e.force:refreshView").fire();
                        if(saveAndDeliveryNote? true:false){
                            if(component.get("v.noteType")=='Package'){
                                var url = '/apex/stapp__DeliveryNotePDF?ListId='+'['+JSON.stringify(response.getReturnValue().data)+']';
                            }
                            else if(component.get("v.noteType")=='Shipment'){
                                //var url = '/apex/stapp__DeliveryNoteShipPDF?ListId='+'['+JSON.stringify(response.getReturnValue().data)+']';
                            }
                            
                			window.open(url);
                            var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "sigmaerpdev2__Package__c"
                            });
                            homeEvent.fire();
                        }
                        else {
                            var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "sigmaerpdev2__Package__c"
                            });
                            homeEvent.fire();
                        }
                    
                    }else
                    {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "error!",
                            "type" : "error",
                            "message": response.getReturnValue().data
                        });
                        toastEvent.fire();
                    }
                }else if (state === "INCOMPLETE") {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');                 
                }else if (state === "ERROR") {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        }else{
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);    
        }else{
            var action = component.get("c.AutomateStockReservationSavePackage");
            action.setParams({ "packageData": JSON.stringify(packageData),"ppData": JSON.stringify(ppList),"proceedToShipmentFlag":proceedToShipment? true:false});
            action.setCallback(this, function (response) {
                var state = response.getState();
                //alert('state==='+state);
                if (state === "SUCCESS") {
                    //alert('msg==='+response.getReturnValue().message);
                    if(response.getReturnValue().message ==="success")
                    {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type" : "success",
                            "message": "Package created successfully."
                        });
                        toastEvent.fire();
                        $A.get("e.force:refreshView").fire();
                        if(saveAndDeliveryNote? true:false){
                            var url = '/apex/stapp__DeliveryNotePDF?ListId='+'['+JSON.stringify(response.getReturnValue().data)+']';
                			window.open(url);
                            var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "sigmaerpdev2__Package__c"
                            });
                            homeEvent.fire();
                        }
                        else{
                            var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "sigmaerpdev2__Package__c"
                            });
                            homeEvent.fire();
                        }
                    }else
                    {                       
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type" : "error",
                            "message": response.getReturnValue().message
                        });
                        toastEvent.fire();
                    }
                }else if (state === "INCOMPLETE") {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');                 
                }else if (state === "ERROR") {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        }else{
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);  
        }      
    },
    
    
})