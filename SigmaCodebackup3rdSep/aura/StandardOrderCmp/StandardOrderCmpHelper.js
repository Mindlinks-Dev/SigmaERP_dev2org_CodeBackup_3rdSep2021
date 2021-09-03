({
	fetchConfigDefaultValues: function (component, event, helper) {
        var action = component.get("c.fetchDefualtConfig");
        action.setCallback(this, function (a) {
            var state = a.getState();
        	//alert('state::'+state);
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                 component.set("v.defaultConfigValues",a.getReturnValue().sigmaerpdev2__Allocation_in_Sales_Order__c);
                   // alert('boolean'+ JSON.stringify(component.get("v.defaultConfigValues")));
                }
            }
            });
        $A.enqueueAction(action);
		var action1 = component.get("c.fetchallocation");
        action1.setCallback(this, function (a1) {
            var state = a1.getState();
            //alert('state::'+state);
            if (state === "SUCCESS") {
                if (a1.getReturnValue() != null) {
                 component.set("v.defualtallocate",a1.getReturnValue().sigmaerpdev2__Inventory_Status__c);
                 component.set("v.showAutoResvButton", a1.getReturnValue().sigmaerpdev2__Auto_Reserve_Stock__c); 
				 if(component.get("v.showAutoResvButton") == true){
                        component.set("v.autoAllocFlag", true);
                    }  
				   //alert('allocated::'+ JSON.stringify(component.get("v.defualtallocate")));
                }
            }
            });
        $A.enqueueAction(action1); 
    
    
    }, 
  
	//added for reset UI
    removeAccRelData: function (component, event, helper) {
        component.set("v.sigmaOrder.sigmaerpdev2__Customer_Type__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__BillingPersonNew__c",'');
        component.set("v.sigmaOrder.sigmaerpdev2__Orders_Status__c", 'Pending');
        component.set("v.sigmaOrder.sigmaerpdev2__Shipping_Street__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingCity__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingState__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingCountry__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingPostalCode__c", '');
        
    },
    
    
    helperGetAccountDataobject:function (component, event, helper,accid) {
	 var action = component.get("c.fetchAddress");
        action.setParams({
            "customer": accid,
         });	
           action.setCallback(this, function (a) {
            var state = a.getState();
               //alert('state::'+state);
            if (state == "SUCCESS") {
                if(a.getReturnValue()!=null)
                {
                    //alert( "before::"+component.get("v.standOrder.sigmaerpdev2__Customer_Type__c"));
                    var accountaddress=a.getReturnValue();
                    //alert(JSON.stringify(accountaddress));
                    if(accountaddress.sigmaerpdev2__Shipment_Details__r != undefined)
                    {
                         component.set("v.standOrder.sigmaerpdev2__Shipping_Street__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__Address__c);
                  	  	 component.set("v.standOrder.sigmaerpdev2__ShippingCity__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__City__c);
                   		 component.set("v.standOrder.sigmaerpdev2__ShippingState__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__State__c);
                    	component.set("v.standOrder.sigmaerpdev2__ShippingCountry__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__Country__c);
                    	component.set("v.standOrder.sigmaerpdev2__ShippingPostalCode__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__Zip__c);
                    }
                   
                    component.set("v.standOrder.sigmaerpdev2__Customer_Type__c",accountaddress.sigmaerpdev2__Customer_Type__c);
                   // alert( "after:"+component.get("v.standOrder.sigmaerpdev2__ShippingPostalCode__c"));
					//alert('sigmaerpdev2__Exchange_Currency__c'+accountaddress.sigmaerpdev2__Exchange_Currency__c);
					 if(accountaddress.sigmaerpdev2__Exchange_Currency__c!=null || accountaddress.sigmaerpdev2__Exchange_Currency__c!=undefined)
                    {
                          if(accountaddress.sigmaerpdev2__Exchange_Currency__r.Name !=undefined)
                       //alert('inside');
                    component.set("v.currencyname",accountaddress.sigmaerpdev2__Exchange_Currency__r.sigmaerpdev2__Display_Name__c);
                    component.set("v.standOrder.sigmaerpdev2__Currency__c",accountaddress.sigmaerpdev2__Exchange_Currency__c);
                    }
					 if(accountaddress.sigmaerpdev2__Customer_Type__c == 'Credit Customer')
                    {
                      component.set("v.RemainCB",accountaddress.sigmaerpdev2__Dimension_Tags__r[0].sigmaerpdev2__Remaining_Credit_Limit__c);
                    }
                    if(accountaddress.Contacts.length==1){
                        //alert(JSON.stringify(accountaddress.Contacts));
                        //standOrder.sigmaerpdev2__BillingPersonNew__r.Name
                        component.set("v.CreatedBy",accountaddress.Contacts[0].Name);
                        component.set('v.standOrder.sigmaerpdev2__BillingPersonNew__c', accountaddress.Contacts[0].Id);
                        //component.set("v.recordName",accountaddress.Contacts[0].Name);
                    }
                    if(accountaddress.Contacts.length > 1){
                        component.set("v.CreatedBy",'');
                    }
                      
                }
            }
              
                });
        $A.enqueueAction(action);
	},
    
    helperGetAccountData:function (component, event, helper,accid) {
        var action = component.get("c.fetchAccountRelatedDataWrap");
        action.setParams({
            "accId": accid,
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                  
                    var accRelatedData=new Object();
                    if(returnData.dimensionTag){
                        accRelatedData.creditLimit=returnData.dimensionTag.sigmaerpdev2__Base_Credit_Limit__c;
                        accRelatedData.stoppedOrders=returnData.dimensionTag.sigmaerpdev2__Stopped_Orders__c;
                        accRelatedData.dueAmount=returnData.dimensionTag.sigmaerpdev2__Due_Amount__c;
                      
                       // if(returnData.dimensionTag.sigmaerpdev2__Stopped_Orders__c)
                        //    component.set("v.stappOrder.stapp__Stopped_Order__c",true);
                     }
                    component.set("v.accRelatedData",accRelatedData);
                   // alert(JSON.stringify('helperaccRelatedData:::'+JSON.stringify(accRelatedData)));
                }
                else
                    component.set("v.accRelatedData",'');
            }
            else{
                component.set("v.accRelatedData",'');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    removeOrderLinesHelper: function (component, event, helper,ind) {
        // var reduceIndexFlag = false;
        var olRemoveIdList=new Array();
        var orderLines = component.get("v.orderLinesData");
      //  var splitBackPresentIndex;
        var splitBackPresentFlag=false;
      //  alert(JSON.stringify(component.get('v.orderLines')));
       component.set("v.hide",false);
        if (orderLines[ind].orderLines.sigmaerpdev2__Back_Order__c || orderLines[ind].orderLines.sigmaerpdev2__Splited_Order_Line__c) 
		{
            for (var i = 0; i < orderLines.length && i != ind; i++) {
                if (orderLines[ind].orderLines.Product2Id == orderLines[i].orderLines.Product2Id 
                    && (!orderLines[i].orderLines.sigmaerpdev2__Back_Order__c||!orderLines[i].orderLines.sigmaerpdev2__Splited_Order_Line__c) )
                {
                    orderLines[i].orderLines.sigmaerpdev2__Net_Quantity__c -= orderLines[ind].orderLines.Quantity;
                //    splitBackPresentIndex=i;
                }
            
            }
        }
		
		if(orderLines[ind].orderLines.sigmaerpdev2__Back_Order__c ==undefined || (component.get('v.recordId') && orderLines[ind].orderLines.sigmaerpdev2__Back_Order__c ==false))
        {
        
            if(orderLines[ind+1] !=undefined && orderLines[ind+1].orderLines.sigmaerpdev2__Back_Order__c)
            {
				olRemoveIdList.push(orderLines[ind+1].orderLines); 
				orderLines.splice(ind+1, 1);
				component.set("v.orderLinesData", orderLines); 
            }
        }
		
		if(orderLines[ind].orderLines.sigmaerpdev2__Splited_Order_Line__c ==undefined || (component.get('v.recordId') && orderLines[ind].orderLines.sigmaerpdev2__Splited_Order_Line__c ==false))
        {
            for (var i = orderLines.length-1; i >= 0 && i != ind; i--) {
                    if (orderLines[ind].orderLines.Product2Id == orderLines[i].orderLines.Product2Id && orderLines[i].orderLines.sigmaerpdev2__Splited_Order_Line__c) {
                        if(orderLines[i].orderLines.Id!=undefined)
                            olRemoveIdList.push(orderLines[i].orderLines);
                        orderLines.splice(i, 1);
                    }
                }
        }
        
        if(orderLines[ind].orderLines.Id)
            olRemoveIdList.push(orderLines[ind].orderLines);
            orderLines.splice(ind, 1);
            component.set("v.orderLinesData", orderLines);
        
        
        var orderLines = component.get("v.orderLinesData");
        var idListStr;
        for(var i=0;i<orderLines.length;i++)
        {
            if(i==0)
                idListStr=orderLines[i].orderLines.Product2Id;
            else
                idListStr+='\',\''+orderLines[i].orderLines.Product2Id;
        }
        component.set('v.idListStr',idListStr);
        
        if(olRemoveIdList.length>0){
            var action = component.get("c.deleteIndividualOrderLines");        
            action.setParams({ 
                "StandOrderLines" : olRemoveIdList
            });
            action.setCallback( this, function(a){
                var state = a.getState();
               // alert("state"+state);
                if (state === "SUCCESS")
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Deleted",
                        "message": "The Order Lines deleted from Database also."
                    });
                    resultsToast.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    
     getILPLIDataForManSelect: function (component, event, helper,ind){
        var action = component.get("c.fetchILPLIDataForManualSelection");
        action.setParams({
            "prodID": component.get("v.orderLinesData")[ind].orderLines.Product2Id,
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
          //  alert('state::'+state);
            if (state === "SUCCESS") {
                
              //  alert(JSON.stringify(a.getReturnValue()));
                if (a.getReturnValue().length > 0) {
                    
                 //   alert("size::"+a.getReturnValue().length);
                    //component.set("v.originalILPLIData", a.getReturnValue());
                    var ilpliIdAllocatedQuantMap=new Object;
                    var orderLinesData=component.get("v.orderLinesData");
                    for(var i=0;i<orderLinesData.length;i++)
                    {
                        if(ind!=i){
                            if(orderLinesData[i].ilpliData)
                            {
                              //  alert(inside1stif);
                                for(var j=0;j<orderLinesData[i].ilpliData.length;j++){
                                    if(ilpliIdAllocatedQuantMap[orderLinesData[i].ilpliData[j].Id])
                                    	ilpliIdAllocatedQuantMap[orderLinesData[i].ilpliData[j].Id]+=orderLinesData[i].ilpliData[j].enteredQuant;
                                    else
                                        ilpliIdAllocatedQuantMap[orderLinesData[i].ilpliData[j].Id]=orderLinesData[i].ilpliData[j].enteredQuant;
                                }
                                
                            }
                        }
                    }
                    //var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
                    var originalILPLIData=[];
                    for(var i=0;i<a.getReturnValue().length;i++)
                    {
                        if(ilpliIdAllocatedQuantMap[a.getReturnValue()[i].Id])
                        {
                          //  alert("Inside 2nd");
                            a.getReturnValue()[i].sigmaerpdev2__Available_Quantity__c-=ilpliIdAllocatedQuantMap[a.getReturnValue()[i].Id];
                            if(a.getReturnValue()[i].sigmaerpdev2__Available_Quantity__c>0)
                                originalILPLIData.push(a.getReturnValue()[i]);
                        }
                        else
                        {
                         //  alert("Inside 3nd");
                            originalILPLIData.push(a.getReturnValue()[i]);
                        }
                    }
                    
                    var availCount=0;
                    for(var i=0;i<originalILPLIData.length;i++)
                    {
                        availCount+=originalILPLIData[i].sigmaerpdev2__Available_Quantity__c;
                         if(orderLinesData[ind].ilpliData)
                        {
                            for(var j=0;j<orderLinesData[ind].ilpliData.length;j++){
                                if(orderLinesData[ind].ilpliData[j].Id==originalILPLIData[i].Id){
                                    originalILPLIData[i].enteredQuant=orderLinesData[ind].ilpliData[j].enteredQuant;
                                   // selectedQuant+=parseInt(orderLinesData[ind].ilpliData[j].enteredQuant);
                                }
                            }
                        }
                    }
                    if(availCount<orderLinesData[ind].orderLines.Quantity)
                    {
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "error",
                            "type": "error",
                            "message": "No Stock Available!"
                        });
                        resultsToast.fire();
                        return;
                    }
                    component.set("v.originalILPLIData", originalILPLIData);
                    component.set("v.openSelectManual", true);
                    component.find("manualSelectProdName").set('v.value',component.get("v.orderLinesData")[ind].productName);
                    component.find("orderedQuant").set('v.value',component.get("v.orderLinesData")[ind].orderLines.Quantity);
                }
                 else {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "error",
                        "type": "error",
                        "message": "No Stock Available!"
                    });
                    resultsToast.fire();
                }
             }
            else {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "error",
                    "message": "Error while getting ILPLI data for this Product."
                });
                resultsToast.fire();
                }
       });
         $A.enqueueAction(action);
       },
    
     getILPLIDataForAutopick: function (component, event, helper,ind) {
        // alert('inside auto pick');
        var action = component.get("c.fetchILPLIDataForManualSelection");
        action.setParams({
            "prodID": component.get("v.orderLinesData")[ind].orderLines.Product2Id,
            
        });
        action.setCallback(this, function (a) 
		{
            var state = a.getState();
            //alert(state);
            if (state === "SUCCESS") {
                 var ilpliIdAllocatedQuantMap=new Object;
                var orderLinesData=component.get("v.orderLinesData");
                for(var i=0;i<orderLinesData.length;i++)
                {
                    if(ind!=i){
                        if(orderLinesData[i].ilpliData)
                        {
                           // alert("insideind");
                            for(var j=0;j<orderLinesData[i].ilpliData.length;j++){
                                if(ilpliIdAllocatedQuantMap[orderLinesData[i].ilpliData[j].Id])
                                    ilpliIdAllocatedQuantMap[orderLinesData[i].ilpliData[j].Id]+=orderLinesData[i].ilpliData[j].enteredQuant;
                                else
                                    ilpliIdAllocatedQuantMap[orderLinesData[i].ilpliData[j].Id]=orderLinesData[i].ilpliData[j].enteredQuant;
                            }
                            
                        }
                    }
                }
                
                var tempILPLIData = a.getReturnValue();
                var requirderQuant =component.get("v.orderLinesData")[ind].orderLines.Quantity;
                var availStock = 0;
                
                 for (var i = 0; i < tempILPLIData.length; i++) 
                 {
                    if(ilpliIdAllocatedQuantMap[tempILPLIData[i].Id])
                        availStock +=(tempILPLIData[i].sigmaerpdev2__Available_Quantity__c-ilpliIdAllocatedQuantMap[tempILPLIData[i].Id]);
                    else
                        availStock += tempILPLIData[i].sigmaerpdev2__Available_Quantity__c;
                     
                 }
               // alert("availStock"+availStock);
                if (availStock < requirderQuant) {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "error",
                        "type": "error",
                        "message": "No Stock Available!"
                    });
                    resultsToast.fire();
                }
                
                else {
                   // alert("insideelse");
                    var newILPLI=[];
                    var outTempAvalQuant=component.get("v.orderLinesData")[ind].orderLines.Quantity;
                    for (var i = 0; i < tempILPLIData.length; i++)
                    {
                        var tempQuant=(tempILPLIData[i].sigmaerpdev2__Available_Quantity__c-(ilpliIdAllocatedQuantMap[tempILPLIData[i].Id]?ilpliIdAllocatedQuantMap[tempILPLIData[i].Id]:0));
                      //  alert('tempQuant'+JSON.stringify(tempQuant));
                        if(tempQuant>=outTempAvalQuant)
                        {
                            var tempnewILPLI=new Object();
                            tempnewILPLI.Id=tempILPLIData[i].Id;
                            tempnewILPLI.enteredQuant=outTempAvalQuant;
                            newILPLI.push(tempnewILPLI);
                            if(ilpliIdAllocatedQuantMap[tempnewILPLI.Id])
                                ilpliIdAllocatedQuantMap[tempnewILPLI.Id]=(outTempAvalQuant+ilpliIdAllocatedQuantMap[tempnewILPLI.Id]);
                            else
                                ilpliIdAllocatedQuantMap[tempnewILPLI.Id]=outTempAvalQuant;
                            outTempAvalQuant-=outTempAvalQuant;
                            break;
                        }
                        else{
                        //    alert("inside2else");
                            var tempnewILPLI=new Object();
                            tempnewILPLI.Id=tempILPLIData[i].Id;
                            tempnewILPLI.enteredQuant=tempQuant;
                            newILPLI.push(tempnewILPLI);
                            if(ilpliIdAllocatedQuantMap[tempnewILPLI.Id])
                                ilpliIdAllocatedQuantMap[tempnewILPLI.Id]=(ilpliIdAllocatedQuantMap[tempnewILPLI.Id]+tempQuant);
                            else
                                ilpliIdAllocatedQuantMap[tempnewILPLI.Id]=tempQuant;
                            outTempAvalQuant-=tempQuant;
                            }
                    }
                    
                 
                    component.get("v.orderLinesData")[ind].ilpliData=newILPLI;
                    component.set('v.ilpliIdAllocatedQuantMap',ilpliIdAllocatedQuantMap);
                  //  alert( "Autodata:"+JSON.stringify(component.get("v.ilpliIdAllocatedQuantMap")));
                    var orderLinesData=component.get('v.orderLinesData');
                    orderLinesData[ind].allocatedAs='AutoPick';
                    component.set('v.orderLinesData',orderLinesData);
					alert('auto allocation done sucessfully');
                  //  alert( "after:"+JSON.stringify(component.get("v.orderLinesData")));
                   
                }
			}
         });
         $A.enqueueAction(action);

		},
    
    saveDataHelper: function (component, event, helper,so,olData)
	{
        
  		var autoallocate = component.get('v.autoAllocFlag');
		if(component.get('v.recordId'))
        {
            component.set('v.isupdate',true);
        }       
        var action = component.get("c.saveStandOrder");
        action.setParams({
            "so": JSON.stringify(so),
            "sol": JSON.stringify(olData),
            "autostock": autoallocate,
            "soupdate": component.get('v.isupdate')
            //"otherVariablesWrapData":JSON.stringify(SOOVW)
        });
        action.setCallback(this, function (response) {
        //    alert('size>>>'+component.get("v.removedOrderLines").size);
            var state = response.getState();
        //     alert('state>>>'+state);
            if (state === "SUCCESS") {
				//	var spinner=component.find('spinner');
                 //   $A.util.toggleClass(spinner, 'slds-hide');
				//	 alert('state>>>'+state);
				//	 alert('value::'+JSON.stringify(response.getReturnValue().data));
					// alert(" inside order id:::::: "+JSON.stringify(response.getReturnValue()));
                    var recid=response.getReturnValue().data;
				//	 alert('data'+recid);
                
                     if(response.getReturnValue() != null && response.getReturnValue()!='undefined' && response.getReturnValue() != '')
                    {
						if (recid !=null && component.get('v.recordId') ==undefined) 
                        {
                            var spinner=component.find('spinner');
                            $A.util.toggleClass(spinner, 'slds-hide');
                            //alert('Sales Order Created Successfully !');
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"Success",
                                "title": "Success!",
                                "message": "Order Created Successfully,Please proceed to payment"
                            });
                            toastEvent.fire();
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
                                Payment: {
                                    text: 'Payment',
                                    btnClass: 'btn-green',
                                    action: function()
                                    {
                                        $A.get("e.force:navigateToComponent").setParams(
                                            {
                                                componentDef: "c:PaymentCallingOrder", 
                                                componentAttributes: 
                                                {
                                                    "recordId":recid
                                                   
                                                }
                                            }).fire();
                                    }
                                },
                                Cancel:{
                                    text:'Skip Payment',
                                    action: function()
                                    {
                                        var navEvt = $A.get("e.force:navigateToSObject");
                                        navEvt.setParams({
                                            "recordId": recid,
                                            "slideDevName": "detail"
                                        });
                                        navEvt.fire();
                                    
                                	}
                                }
                                
                            }
                          });
                        }
                        else
                        {
                            var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"Success",
                            "title": "Success!",
                            "message": "Order Updated Successfully"
                        });
                           toastEvent.fire();  
                         if(!component.get('v.standOrder.sigmaerpdev2__Is_Payment_Made__c'))
                        {
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
                                Payment: {
                                    text: 'Payment',
                                    btnClass: 'btn-green',
                                    action: function()
                                    {
                                        $A.get("e.force:navigateToComponent").setParams(
                                            {
                                                componentDef: "c:PaymentCalling", 
                                                componentAttributes: 
                                                {
                                                    "recordId":recid
                                                   
                                                }
                                            }).fire();
                                    }
                                },
                                Cancel:{
                                    text:'Skip Payment',
                                    action: function()
                                    {
                                        var navEvt = $A.get("e.force:navigateToSObject");
                                        navEvt.setParams({
                                            "recordId": recid,
                                            "slideDevName": "detail"
                                        });
                                        navEvt.fire();
                                    
                                	}
                                }
                                
                            }
                          });
                        }
                            else
                            {
                                 var navEvt = $A.get("e.force:navigateToSObject");
                                        navEvt.setParams({
                                            "recordId": recid,
                                            "slideDevName": "detail"
                                        });
                                        navEvt.fire();
                            }
                       
                             //window.location.href = "/" +recid;
                        }
                          $A.get('e.force:refreshView').fire();
                    } 
                            //   alert('Order Created Successfully !');
                            //    window.location.href = "/" +recid ;
				} else
                    {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
						alert('Standard Order Creation Failed');
                    }      
				  /* var recid=response.getReturnValue().data;
                     if(response.getReturnValue() != null)
                    {
                            
                                window.location.href = "/" +recid ;
                    } else
                    {
                  //      alert('Shipment Creation Failed');
                    }  */


					
                    //var spinner=component.find('spinner');
                    //$A.util.toggleClass(spinner, 'slds-hide');
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire();*/
                    
                   // var toastEvent = $A.get("e.force:showToast");
                   // toastEvent.setParams({
                    //    "title": "Success!",
                     //   "type" : "success",
                      //  "message": "Stock Received Successfully."
                   // });
                    //toastEvent.fire();
                  /*  $A.get("e.force:refreshView").fire();
                    var homeEvent = $A.get("e.force:navigateToSObject");
                    homeEvent.setParams({
                        "scope": "sigmaerpdev2__Sigma_Order__c"
                       
                    });
                    homeEvent.fire();
                    alert(response.getReturnValue().data);
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": response.getReturnValue().data,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();*/
                
            
        });
        $A.enqueueAction(action);
    },
    
    getStandOrderDataForEdit: function(component, event, helper, recId) {
		 //component.set("v.isbackordercheck", true);
        var tempRecId;
        if(recId){
            var action = component.get("c.getStandOrderData");
            tempRecId=recId;
        }
       	
        action.setParams({
            "soId": tempRecId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
          //  alert('state::'+state);
            if (state === "SUCCESS") {
                var completeWrapp = response.getReturnValue();
            //    alert('completeWrapp::'+JSON.stringify(completeWrapp.standOrder));
                
           /*     if(completeWrapp.standOrder.stapp__Status__c==='Cancelled' && recId)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "warning!",
                        "type": "warning",
                        "message": "Cancelled Orders can not be editable."
                    });
                    toastEvent.fire();
                    $A.get("e.force:refreshView").fire();
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "stapp__Stapp_Order__c"
                    });
                    homeEvent.fire();
                }  */
                component.set("v.standOrder", completeWrapp.standOrder);
                component.set('v.autoAllocFlag',completeWrapp.standOrder.sigmaerpdev2__Auto_Allocate__c);
               //alert('value'+component.get('v.autoAllocFlag'));
                if (completeWrapp.standOrder.AccountId != undefined)
                //    alert("inside ifff");
                    component.set("v.recordName", completeWrapp.standOrder.Account.Name);
				//alert('Billing >>'+completeWrapp.standOrder.sigmaerpdev2__BillingPersonNew__c);
				if (completeWrapp.standOrder.sigmaerpdev2__BillingPersonNew__c != undefined)
                    component.set("v.CreatedBy", completeWrapp.standOrder.sigmaerpdev2__BillingPersonNew__r.Name);
               // alert('sigmaerpdev2__No_Picking_Package_Shipment_Required__c >>'+ completeWrapp.standOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c);
                if (completeWrapp.standOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c != undefined)
                    component.set("v.nopickpackshipment", completeWrapp.standOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c);
               // alert('completeWrap>>'+completeWrapp.standOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c);
                document.getElementById("noPackShip").checked=completeWrapp.standOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c;
				//alert(completeWrapp.standOrder.sigmaerpdev2__Currency__c);
                if (completeWrapp.standOrder.sigmaerpdev2__Currency__c != undefined)
                  component.set("v.currencyname", completeWrapp.standOrder.sigmaerpdev2__Currency__r.sigmaerpdev2__Display_Name__c);
				
                if(completeWrapp.credituser != undefined)
                component.set('v.RemainCB',completeWrapp.credituser.sigmaerpdev2__Remaining_Credit_Limit__c);
               
                //alert('acc'+component.get('v.CreatedBy'));
              /*  if (completeWrapp.stappOrder.stapp__Sales_Person__c != undefined)
                    component.set("v.stappOrder.SalesPersonName", completeWrapp.stappOrder.stapp__Sales_Person__r.Name);
                if (completeWrapp.stappOrder.stapp__Currency__c != undefined)
                    component.set("v.stappOrder.CurrencyName", completeWrapp.stappOrder.stapp__Currency__r.Name);
                if (completeWrapp.stappOrder.stapp__Company__c != undefined)
                    component.set("v.stappOrder.CompanyName", completeWrapp.stappOrder.stapp__Company__r.Name);
                if (completeWrapp.stappOrder.stapp__Price_Book__c != undefined)
                    component.set("v.stappOrder.PricebookName", completeWrapp.stappOrder.stapp__Price_Book__r.Name);
                if (completeWrapp.stappOrder.stapp__Payment_Terms__c != undefined)
                    component.set("v.stappOrder.PaymentTermsName", completeWrapp.stappOrder.stapp__Payment_Terms__r.Name);
                if (completeWrapp.stappOrder.stapp__Tax_Treatment__c != undefined)
                    component.set("v.stappOrder.TaxTreatmentName", completeWrapp.stappOrder.stapp__Tax_Treatment__r.Name);
                
                */  
                
                component.set("v.orderLinesData", completeWrapp.solWrap);
                var orderLines = component.get("v.orderLinesData");
            //   alert('orderLines>>'+ JSON.stringify(orderLines));
                var idListStr;
                for(var i=0;i<orderLines.length;i++)
                {
                   // alert('orderLines>>'+ JSON.stringify(orderLines[i]));
                  //  alert('orderLines+productarr'+ JSON.stringify(orderLines.Product2Id));
                  //  alert('orderLines+productarrname'+orderLines.Product2.Name);
                    if(i==0)
                        idListStr=orderLines[i].orderLines.Product2Id;
                    else
                        idListStr+='\',\''+orderLines[i].orderLines.Product2Id;
                }
                component.set('v.idListStr',idListStr);  
            }
            else {
                alert('There was a problem : '+response.getError());
            }  
        });
        $A.enqueueAction(action);
    } ,
// code added on 25/08/2019
 automateStockResv : function(component, event, helper){      	
        var so = component.get("v.standOrder");
        var olData = component.get("v.orderLinesData");       
        var newArry = [];
        for(var i=0;i<olData.length;i++){           
            if(olData[i].orderLines.Name == undefined){
                newArry.push(olData[i]);
            }            
        }        
        var action = component.get("c.automateStockReservation");
        action.setParams({
            "so": JSON.stringify(so),
            //"sol": JSON.stringify(olData)
            "sol": JSON.stringify(newArry)
        });
        action.setCallback(this, function (response) {
            var state = response.getState();           	                                    
            if (state == "SUCCESS"){                
                var allocStatus = response.getReturnValue()[0].stockExist;                 
                var resvStatus = allocStatus.split("_"); 
                if(allocStatus == 'true'){
                	var automateResVal = response.getReturnValue();
                    var olData1 = component.get("v.orderLinesData");                    
                    for(var i=0;i<automateResVal.length;i++){
                        //olData[i].ilpliData = automateResVal[i].ilpliData;
                        if(component.get("v.recordId") == '' || component.get("v.recordId") == undefined){                            
                           newArry[i].ilpliData = automateResVal[i].ilpliData;                            
                        }
                        else{                              
                            for(var j=0;j<olData1.length;j++){
                                if(olData1[j].orderLines.Name == undefined && i==j){                                   
                                    var wrap; 
                                    if(automateResVal[i].ilpliData != undefined){
                                    	wrap = automateResVal[i].ilpliData;                                    
                                    	olData1[j].ilpliData = wrap;    
                                    }
                                }
                                else if(automateResVal[i].ilpliData !=null && olData1[j].orderLines.sigmaerpdev2__IsInventoryUpdated__c !=true && i==j )
                                {                                    
                                    var wrap;                                                  
                                    wrap = automateResVal[i].ilpliData;									                                   
                                    olData1[j].ilpliData = wrap;
                                }
                            }
                        }
                    } 
                                                            
                    if(component.get("v.recordId") == '' || component.get("v.recordId") == undefined)                       
                       component.set("v.orderLinesData", newArry);
                    else
                       component.set("v.orderLinesData", olData1);                    
                    
                    var updatedOlData = component.get("v.orderLinesData");
                   // alert('updated log=='+JSON.stringify(updatedOlData));
                    //return;
                    /*console.log('updated log=='+JSON.stringify(updatedOlData));
                    return;*/
                    //helper.saveDataHelper(component, event, helper, so, olData);
                    var spinner=component.find('spinner');
        			$A.util.toggleClass(spinner, 'slds-hide');     
                    helper.saveDataHelper(component, event, helper, so, updatedOlData);     
                }else if(resvStatus[0] == 'false'){
                    var spinner=component.find('spinner');
        			$A.util.toggleClass(spinner, 'slds-hide');
                    var msg ="Stock quantity is low for the Product(s) '"+resvStatus[1]+"'. System cannot continue with the Auto Reserve Stock process."; 
                    alert(msg);                   
                    return;
                }
            }else if(state == "ERROR"){
                var spinner=component.find('spinner');
        		$A.util.toggleClass(spinner, 'slds-hide');
                var msg ="Error occured : "+JSON.stringify(Error); 
                alert(msg);               
                return;
            }
        });
        $A.enqueueAction(action);
    },
     viewProductHelper: function (component, event, helper,ind) {
      //  alert('calling viewProductHelper');
        var prodId = component.get("v.orderLinesData")[ind].orderLines.Product2Id;
       //alert('prodId>>>'+prodId);
        var action = component.get("c.getproductimage");
        action.setParams({
            "prodId": prodId,
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState();
           // alert('state::'+state);
            if (state == "SUCCESS") {
                var productimage=a.getReturnValue();
               
                component.set('v.ProductImageData',productimage);
               
                component.set('v.productimageexist',true);
               // alert('dataaaa'+JSON.stringify(component.get('v.ProductImageData')));
                
            }
            else
            {
                component.set('v.productimageexist',false);
            }
             component.set('v.ProductView',true);
        });
        $A.enqueueAction(action);
    },
     getproductwarranty: function (component, event, helper,ind){
        	var proid = component.get("v.orderLinesData")[ind].orderLines.Product2Id;
            var custid = component.get("v.standOrder.AccountId");
            component.set('v.showwarranty',true);
            var action = component.get("c.getProdRelData");
			 action.setParams({
            "prodId": proid,
            "customerId":custid,
			});
			action.setCallback(this, function (a) {
            var state = a.getState();
             
            if (state == "SUCCESS") {
                
                if(a.getReturnValue()!=null)
                {
                    //alert( "before::"+component.get("v.sigmaOrder.sigmaerpdev2__ShippingPostalCode__c"));
                    var days;		
                    var totaldays;
                    var product=a.getReturnValue();	
                    //alert('product@@'+JSON.stringify(product));
                    var ProductWarranty= new Object();
                    ProductWarranty.index=ind;
                    ProductWarranty.productstartdate = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Delivery_Date__c; 
                    ProductWarranty.servicestartdate = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Delivery_Date__c;
					ProductWarranty.servicesinterval ='Day';
                    ProductWarranty.productinterval ='Day';
					if(product.sigmaerpdev2__Warranty_Applicable__c)
                    {
                        ProductWarranty.productduration = product.sigmaerpdev2__Warranty_Duration__c;
                        ProductWarranty.productinterval = product.sigmaerpdev2__Warranty_Interval__c;
                        if(ProductWarranty.productinterval =='Day')
                        {
                            days = 1;
                            totaldays = ProductWarranty.productduration * days;    
                        }
                         
                        else if(ProductWarranty.productinterval == 'Month')
                        {
                        days = 30;
                        totaldays = ProductWarranty.productduration * days;
                        }
                        else if(ProductWarranty.productinterval == 'Year')
                        {
                        days = 365;
                        totaldays = ProductWarranty.productduration * days;
                        }
                        var enddate = new Date(ProductWarranty.productstartdate);
                        enddate.setDate(enddate.getDate() + totaldays);
                        ProductWarranty.productenddate =  enddate.getFullYear()+ "-" +(enddate.getMonth()+1)+ "-" + enddate.getDate();
                       }
                   
                    
                    component.set('v.Warranty',ProductWarranty);
					//alert('data'+JSON.stringify(component.get('v.Warranty')));
                    
				}
			}
			});
			$A.enqueueAction(action);
    
    },
    getorderlinewarranty: function (component, event, helper,ind){
    	 component.set('v.showwarranty',true);
         var orderline = component.get("v.orderLinesData");
         var Warranty= new Object();
         Warranty.index=ind;
         Warranty.productstartdate = orderline[ind].orderLines.sigmaerpdev2__Product_Warranty_Start_Date__c; 
         Warranty.productduration = orderline[ind].orderLines.sigmaerpdev2__Product_Duration__c;
         Warranty.productinterval = orderline[ind].orderLines.sigmaerpdev2__Product_Interval__c;
         Warranty.productenddate =  orderline[ind].orderLines.sigmaerpdev2__Product_Warranty_End_Date__c;
         if(orderline[ind].orderLines.sigmaerpdev2__Service_Start_Date__c ==undefined)
         {
         	Warranty.servicestartdate = orderline[ind].orderLines.sigmaerpdev2__Delivery_Date__c;
             
         }
        else
        {
        	Warranty.servicestartdate = orderline[ind].orderLines.sigmaerpdev2__Service_Start_Date__c;
		     
        }
        Warranty.servicesinterval =orderline[ind].orderLines.sigmaerpdev2__Service_Interval__c;
     	 Warranty.servicesduration = orderline[ind].orderLines.sigmaerpdev2__Service_Duration__c;
         Warranty.servicesenddate = orderline[ind].orderLines.sigmaerpdev2__Service_End_Date__c;
         component.set('v.Warranty',Warranty);
         //alert('editdata@'+JSON.stringify(component.get('v.Warranty')));
     }
    
 
})