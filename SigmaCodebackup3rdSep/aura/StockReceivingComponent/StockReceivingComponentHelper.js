({
        chechDefaultValues: function (component, event, helper,TransID,TransName,indx) {
        
        var action = component.get("c.fetchDefaultParameters");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue();
                console.log('returnValue>>'+returnValue)
                if(returnValue)
                component.set('v.isShowDispatchedQuantity',returnValue);
                else component.set('v.isShowDispatchedQuantity',false);
                
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
    fetchVendorcontactDetails: function (component, event, helper,vendName) {
      //  alert('trying to fetch vendName'+vendName);
        var action = component.get("c.fetchVendorContactdetails");
        action.setParams({ "vendName": vendName });
		action.setCallback(this, function (a) {
			var state = a.getState();
          //  alert(state);
			if (state === "SUCCESS") {                
				if (a.getReturnValue() != null) {
                    var configValues=component.get("v.configValues");
                    configValues.vendcontact=a.getReturnValue().vendcontact;
                    configValues.acccon=a.getReturnValue().acccon;
                    component.set("v.configValues",a.getReturnValue());
                    if(configValues.acccon){
                        component.set('v.stockReceive.sigmaerpdev2__Delivery_Person__c',configValues.acccon.Id);
                        component.set('v.stockReceive.sigmaerpdev2__Delivery_Person__r.Name',configValues.acccon.Name);
                    }
                   /* if(configValues.company){
                        component.set('v.stockReceive.stapp__Company__c',configValues.company.Id);
                        component.set('v.stockReceive.stapp__Company__r.Name',configValues.company.Name);
                    }*/
                    //below lines added on 20-5-2019 to default User and his associated companies.
                    /*if(configValues.userCompIds)
                    	component.set("v.compIdStr", a.getReturnValue().userCompIds);
                    if(configValues.userProfile)
                    	component.set("v.userProfile", a.getReturnValue().userProfile);*/
                    //ends here
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchStockItemsHelper: function (component, event, helper,TransID,TransName,indx) {
        
        var action = component.get("c.fetchStockReceivingItems");
      //  alert('TransID>>'+TransID);
        action.setParams({ "transID": TransID });
        //action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
              //  alert('state>>>'+state);
                var result = [];
             //  	alert('response>>'+ JSON.stringify(response.getReturnValue()));
                for(var i=0;i<response.getReturnValue().length;i++)
                {
                    response.getReturnValue()[i].SRLineItemRec.sobjectType = 'sigmaerpdev2__Stock_In_Product__c';
                    result.push(response.getReturnValue()[i]);
                   
                }
                if(response.getReturnValue().length==0)
                {
                     component.set("v.errorMessage", "Selected PO don't have Quantity to Receive..");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    return;
                }
                var StockReceivingWrap = component.get('v.StockReceivingWrap');
                StockReceivingWrap[indx].transID = TransID;
                StockReceivingWrap[indx].transName = TransName;
                StockReceivingWrap[indx].TransLineItems = result;
                component.set('v.StockReceivingWrap',StockReceivingWrap);
                
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
    removeSRP: function (component, event, helper,deletedIdList) {
        var action = component.get("c.removeSRP");
        action.setParams({ "deletedSRPIdList": deletedIdList });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
               // alert('resp>>>'+a.getReturnValue());
                if (a.getReturnValue() != null) {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Deleted",
                        "message": "The SRP deleted from Database also."
                    });
                    resultsToast.fire();
                }
            }
            else{
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type":"error",
                    "title": "error",
                    "message": "Something went wrong."
                });
                resultsToast.fire();
            }
        });
        $A.enqueueAction(action);
    },
    openModalHelper : function(component, event, helper,data) {
        var SRP = component.get("v.StockReceivingWrap");
        var srlLength = SRP[data.parentIndex].TransLineItems[data.index].serialNo?SRP[data.parentIndex].TransLineItems[data.index].serialNo.length:0;
        var serialData = component.get("v.StockReceivingWrap")[data.parentIndex].TransLineItems[data.index].serialNo;
        //alert(serialData);
        // alert(JSON.stringify(SRP[data.parentIndex].TransLineItems[data.index].serialNo));
        var prodName = SRP[data.parentIndex].TransLineItems[data.index].productName;
        component.set('v.selectedProdName',prodName);
        var serialList = [];
        if(srlLength >0 && srlLength == data.qty)
        {
           
            serialList = serialData;
        }
        else if(srlLength >0 && data.qty > srlLength)
        {
            serialList = serialData;
          //   alert('serialList-->'+serialList);
          //  alert('data.qty-->'+data.qty);
            for(var i=srlLength;i<data.qty;i++)
            {
               
                serialList[i] = {'sigmaerpdev2__Serial_Number__c':''};
            }
        }
            else if(srlLength >0 && data.qty < srlLength)
            {
               //  alert('data.qty-->'+data.qty);
                for(var i=0;i<data.qty;i++)
                {
                    serialList[i] = serialData[i];
                }
            }else
            {
                for(var i=0;i<data.qty;i++)
                {
                   //  alert('data.qty-->'+data.qty);
                    serialList[i] = {'sigmaerpdev2__Serial_Number__c':''};
                }
            }
        
        //component.set('v.StockReceivingWrap[data.parentIndex].TransLineItems[data.index].serialNo',serialList);
        component.set('v.serials',serialList);	
        component.set('v.openModal',true);
    },
    saveDataHelper: function(component, event, helper) 
    {
      //  alert('inside helper'+JSON.stringify(component.get('v.stockReceive')));
        var SR = component.get('v.stockReceive');
        var SRL = component.get('v.StockReceivingWrap');
        
        var action = component.get("c.saveStockReceiving");
      	//alert(JSON.stringify(SR));
        action.setParams({ "srData": JSON.stringify(SR),"srpl": JSON.stringify(SRL) });
        action.setCallback(this, function (response) {
            var state = response.getState();
          //  alert('State>>'+state);
            if (state === "SUCCESS") {
               //  alert('response.getReturnValue().message'+response.getReturnValue().message);
                if(response.getReturnValue().message ==="success")
                {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type" : "success",
                        "message": "Stock Received Successfully."
                    });
                    toastEvent.fire();
                    $A.get("e.force:refreshView").fire();
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "sigmaerpdev2__Stock_In__c",
                        
                    });
                    homeEvent.fire();*/
                    
                    //commented above lines and added below lines on 6-2-2020 to show StockReceiving page in PurchaseOrdeModules UI page after add/update button is clicked
                    var msg = '';                    
                    if(component.get("v.recordId") == undefined)
                        msg = 'Stock receiving record created successfully!';
                    else
                        msg = 'Stock receiving record updated successfully!';                    
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": msg
                    });
                    toastEvent.fire();                    
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:PurachaseOrderModules",
                        componentAttributes: {
                            from : 'SR'
                        }
                    });
                    evt.fire();
                    //ends here     
                    
                    
                }else
                {
                  //  alert('Error Came');
                    component.set('v.disableSave',false);
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');
					//alert('Response>>'+response.getReturnValue().message);
                    if(response.getReturnValue().data.includes("DUPLICATE_VALUE, duplicate value found: sigmaerpdev2__Serial_Number__c"))
                    {
						if(SRL.length>0)
						{
							for(var i=0;i<SRL.length;i++)
							{
								//alert('I-->>'+i);
								var tli=SRL[i].TransLineItems;
								for(var j=0;j<tli.length;j++)
								{
									//alert('J-->>'+j);
									var tlir=tli[j].SRLineItemRec;
									var srlNo=tli[j].serialNo;
									
									//alert('attributeType-->>'+ tli[j].attributeType + 'status-->>' + tlir.sigmaerpdev2__Status__c );
									if(tli[j].attributeType==='SERIALIZED' && tlir.sigmaerpdev2__Status__c=='Verified')
									{
										for(var k=0;k<srlNo.length;k++)
										{
											alert('K-->>'+k);
											if(srlNo[k].sigmaerpdev2__Serial_Number__c==response.getReturnValue().duplicateSerialNo )
											{
												
											    alert('Serial_Number__c>>'+srlNo[k].sigmaerpdev2__Serial_Number__c);
												var toastEvent = $A.get("e.force:showToast");
												toastEvent.setParams({
													"title": "Error!",
													"type" : "error",
												    "message": "Duplicate serial number Found. The duplicate value is '" + response.getReturnValue().duplicateSerialNo + "' at Line '" + (j+1) + "' of Purchase Order '"+SRL[i].transName+"' at Line '" + (k+1) + "' of Serial Number.",
												//	"message": "Duplicate serial number Found. The duplicate value is '"+response.getReturnValue().duplicateSerialNo+"' at Line '" + (k+1) + "' of serial No in '" +SRL[i].transName+ "'  Purchase Order.",
												});
												toastEvent.fire();
											}
											
										}
										
									}
									
								}
							}
						}
						
						
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type" : "error",
                            "message": response.getReturnValue().data
                        });
                        toastEvent.fire();
                    }
                }  
            }
            else if (state === "INCOMPLETE") {
                component.set('v.disableSave',false);
                var spinner=component.find('spinner');
                $A.util.toggleClass(spinner, 'slds-hide');
                // do something
            }
                else if (state === "ERROR") {
                    component.set('v.disableSave',false);
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].data);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
       
    },
    fetchStockReceivingDataUpdate: function(component, event, helper, recordId) 
    {
      //  alert('calling heper class')
        var action = component.get("c.fetchStockLinesUpdate");
       // alert('action--->'+action);
        action.setParams({ "srID": recordId});
        action.setCallback(this, function (response) {
            var state = response.getState();
            // alert('state-->'+state);
            if (state === "SUCCESS") {
               
                var stockReceive = response.getReturnValue().stockReceive;
                stockReceive.sobjectType = 'sigmaerpdev2__Stock_In__c';
                component.set('v.stockReceive',stockReceive);
               // alert('stockReceive::'+JSON.stringify(stockReceive));
                if(stockReceive.sigmaerpdev2__Delivery_Person__c!=undefined)
                    component.set('v.recordName1',stockReceive.sigmaerpdev2__Delivery_Person__r.Name);
               		component.set('v.recordName2',stockReceive.sigmaerpdev2__Location__r.Name);
                	component.set('v.recordName',stockReceive.sigmaerpdev2__Vendor__r.Name);
                //component.set('v.isopen',true);
                var srlwrapList = response.getReturnValue().srlwList;
             //  alert('srlwrapList-->'+JSON.stringify(srlwrapList));
                console.log('srlwrapList-->'+JSON.stringify(srlwrapList));
              
                for(var i=0;i<srlwrapList.length;i++){
                    
                    for(var j=0;j<srlwrapList[i].TransLineItems.length;j++)
                    {
                        srlwrapList[i].TransLineItems[j].SRLineItemRec.sobjectType = 'sigmaerpdev2__Stock_In_Product__c';
                       // alert('xsjkhchs'+JSON.stringify(srlwrapList[i].TransLineItems[j]));
                        if(srlwrapList[i].TransLineItems[j].SRLineItemRec.sigmaerpdev2__Status__c=='Verified'){
                            srlwrapList[i].TransLineItems[j].SRLineItemRec.isVerified=true;
                             // srlwrapList[i].TransLineItems[j].productid= srlwrapList[i].TransLineItems[j].SRLineItemRec.sigmaerpdev2__Product__c;
                            srlwrapList[i].isVerified=true;
                           
                        }
                        // srlwrapList[i].TransLineItems[j].SRLineItemRec.isVerified=false;
                      //   alert('StockReceivingWrap::'+JSON.stringify(srlwrapList[i].isVerified));     //  srlwrapList[i].isVerified=false;
                    }
                }
                // console.log(JSON.stringify(srlwrapList));
                component.set('v.StockReceivingWrap',srlwrapList);
                //alert('StockReceivingWrap::'+JSON.stringify(component.get('v.StockReceivingWrap')));
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
    
})