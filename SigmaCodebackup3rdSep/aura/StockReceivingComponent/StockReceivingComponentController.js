({
    showDispoatchQty: function(component, event, helper) {
        component.set("v.isShowDispatchedQuantity",!component.get("v.isShowDispatchedQuantity"));
        
        console.log(">>>>>>>"+component.get("v.isShowDispatchedQuantity"))
    },
    doInit: function(component, event, helper) {
        helper.chechDefaultValues(component, event, helper);
        var recordId = component.get("v.recordId");
        
        if(recordId != null && recordId != undefined)
            helper.fetchStockReceivingDataUpdate(component, event, helper, recordId);
    },
    //code added on 04-04-2020
    handleLookupValueselected: function(component, event, helper) 
    {
        /*  if(event.getParam("objectAPIName")==='Account'){
            component.set('v.stockReceive.sigmaerpdev2__Delivery_Person__c','');
            component.set('v.stockReceive.sigmaerpdev2__Delivery_Person__r.Name','');
          //alert('name>>'+JSON.stringify(component.get('v.stockReceive.sigmaerpdev2__Vendor__r.Name')));
         // helper.fetchVendorcontactDetails(component, event, helper, component.get('v.stockReceive.sigmaerpdev2__Vendor__r.Name'));
        }*/
        
    },
    SelectedID : function(cmp, event) 
    {
        // alert('inside came');
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");
        
        if(context == 'MyVendor')
        {  
            
            cmp.set("v.stockReceive.sigmaerpdev2__Vendor__c",objectId);
            
        }else if(context =='MyAccount2')
        { 
            
            cmp.set("v.stockReceive.sigmaerpdev2__Location__c",objectId); 
            
        }
            else if(context =='MyContact')
            {
                cmp.set("v.stockReceive.sigmaerpdev2__Delivery_Person__c",objectId); 
            }
        
    },
    addSRP : function(component, event, helper) {
        
        var stockReceive=component.get('v.stockReceive');
        if(!(stockReceive.sigmaerpdev2__Vendor__c && stockReceive.sigmaerpdev2__Location__c))
        {
            alert('Please make sure that Vendor and Location are selected.');
            return;
        }
        /* var stockReceive=component.get('v.stockReceive');
        if(!(stockReceive.sigmaerpdev2__Vendor__c && stockReceive.sigmaerpdev2__Location__c))
        {
            alert('Please make sure that Vendor and Location are selected.');
            return;
        }*/
        var SRP = component.get("v.StockReceivingWrap");
        
        // alert('SRP>>'+JSON.stringify(component.get("v.StockReceivingWrap")));
        SRP.push({'transID':'','TransLineItems':[]});
        
        
        component.set("v.StockReceivingWrap",SRP);
    },
    
    handleSRComponentEvent: function(component, event, helper) {
        
        var data = event.getParam("data");
        
        component.set('v.eventData',data);
        var flag = event.getParam("flag");
        // alert('flag>>>>'+flag);
        if(flag == 'removeSRPro')
        {
            var SRP = component.get("v.StockReceivingWrap");
            // alert(SRP[data.index].TransLineItems[0].TransLineItemRec.Id);
            var deletedIdList=[];
            // alert(SRP[data.index].TransLineItems.length);
            for(var i=0;i<SRP[data.index].TransLineItems.length;i++)
            {
                //alert('for');
                if(SRP[data.index].TransLineItems[i].SRLineItemRec.Id)
                    deletedIdList.push(SRP[data.index].TransLineItems[i].SRLineItemRec.Id);
                // alert('deletedIdList>>>>>>>'+deletedIdList);
            }
            SRP.splice(data.index, 1);
            //alert('SRP>>>'+JSON.stringify(SRP));
            component.set("v.StockReceivingWrap",SRP);
            // alert('deletedIdList'+deletedIdList.length());
            if(deletedIdList.length>0)
                helper.removeSRP(component,event,helper,deletedIdList);
        }
        else if(flag == 'openModal')
        {
            helper.openModalHelper(component, event, helper,data);
        }
            else if(flag == 'fetchStockLines')
            {
                //alert('test');
                helper.fetchStockItemsHelper(component, event, helper, data.transID,data.transName,data.index);
            }
    },
    closeModal: function(component, event, helper) {
        component.set('v.openModal',false);
    },
    addSerialNumber: function(component, event, helper) {
        var srlNo=component.get('v.serials');
        for(var j=0;j<srlNo.length;j++)
        {
            //alert(JSON.stringify(srlNo[i].sigmaerpdev2__Serial_Number__c));
            //alert(JSON.stringify(srp[i].transName));
            if(!srlNo[j].sigmaerpdev2__Serial_Number__c){
                //   alert("Serial No Missing at Line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                alert("Serial No Missing at Line '"+(j+1)+"' of Selected Purchase Order");
                return;
            }
        }
        /*   var sr=component.get('v.stockReceive');
		var srp=component.get('v.StockReceivingWrap');
		if(srp.length>0)
		{
			for(var i=0;i<srp.length;i++)
			{
				alert('I-->'+i);
				var tli=srp[i].TransLineItems;
				for(var j=0;j<tli.length;j++)
				{
					alert('J-->'+j);
					var tlir=tli[j].SRLineItemRec;
					//var srlNo=tli[j].serialNo;
					
					alert('attributeType>>'+tli[j].attributeType + 'status>>' +tlir.sigmaerpdev2__Status__c );
					if(tli[j].attributeType==='SERIALIZED' && tlir.sigmaerpdev2__Status__c=='Verified')
					{
						alert('success' );
						for(var k=0;k<srlNo.length;k++)
						{
							alert('K-->'+k); 
							if(!srlNo[k].sigmaerpdev2__Serial_Number__c)
							{
								alert('Serial no-->'+srlNo[k].sigmaerpdev2__Serial_Number__c); 
							  //alert("Serial No Missing at Line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
								alert("Serial No Missing at Line '"+(k+1)+"' of Serial No at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
								return;
							}
						}
					}
				}
			}
            
		}*/
        component.set('v.openModal',false);
        var data = component.get('v.eventData');
        //alert(JSON.stringify(component.get('v.StockReceivingWrap['+data.parentIndex+'].TransLineItems['+data.index+']')));
        component.set('v.StockReceivingWrap['+data.parentIndex+'].TransLineItems['+data.index+'].serialNo',component.get('v.serials'));
    },
    saveData: function(component, event, helper) {
        //alert('trying to save SR ');
        component.set("v.errorMessage", null);
        component.set("v.isError", false);
        var sr=component.get('v.stockReceive');
        var srp=component.get('v.StockReceivingWrap');
        //  alert(JSON.stringify(component.get('v.StockReceivingWrap')));
        if(!(sr.sigmaerpdev2__Vendor__c && sr.sigmaerpdev2__Received_Date_Time__c && sr.sigmaerpdev2__Location__c)){
            component.set("v.errorMessage", "Please fill all the mandatory fields.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        
        else if(sr.sigmaerpdev2__Received_Date_Time__c<$A.localizationService.formatDate(new Date(), "YYYY-MM-DD")){
            component.set("v.errorMessage", "Received date must not be in the past.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        //   alert('if2');
        var serialNos=[];	
        if(srp.length>0){
            for(var i=0;i<srp.length;i++)
            {
                
                var tli=srp[i].TransLineItems;
                
                //alert('srp:::'+JSON.stringify(srp[i]));
                //alert('tli>>'+JSON.stringify(tli));
                if(tli.length==0)
                {
                    component.set("v.errorMessage", "Remove the Line items which does not have any Products.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    return;
                }
                //   alert('if3');
                
                for(var j=0;j<tli.length;j++)
                {
                    var tlir=tli[j].SRLineItemRec;
                    // alert('qty-->>'+((tlir.sigmaerpdev2__Quantity_Received__c)%1));
                    if((!parseInt(tlir.sigmaerpdev2__Quantity_Received__c) && tlir.sigmaerpdev2__Status__c=='Verified')|| (parseInt(tlir.sigmaerpdev2__Quantity_Received__c)<=0 && tlir.sigmaerpdev2__Status__c=='Verified'))
                    {// && tlir.stapp__Lot__c)){
                        component.set("v.errorMessage", "Please Enter Valid Receiving Quantity at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                        component.set("v.isError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                    }
                    else if((tlir.sigmaerpdev2__Quantity_Received__c) % 1 != 0)
                    {
                        component.set("v.errorMessage", "Decimal Values are not allowed,Please Enter a valid Quantity at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                        component.set("v.isError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                        
                    }
                    //   alert('if4');
                    /*  if(!tlir.sigmaerpdev2__Putaway_location__c && tlir.sigmaerpdev2__Status__c=='Verified'){// && tlir.stapp__Lot__c)){
                        component.set("v.errorMessage", "Actual Location is Mandatory for Verified Status at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                        component.set("v.isError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                    }*/
                    // alert('tli[j].BinId>> '+tli[j].BinId);
                    if(!tli[j].BinId && tlir.sigmaerpdev2__Status__c	=='Verified'){// && tlir.stapp__Lot__c)){
                        // alert('j>>'+j);
                        component.set("v.errorMessage", "Bin is Mandatory for Verified Status at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                        component.set("v.isError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                    }
                    //   alert('if5');
                    // alert('tlir.sigmaerpdev2__Expiry_Date__c >> '+tlir.sigmaerpdev2__Expiry_Date__c );
                    if(tlir.sigmaerpdev2__Expiry_Date__c && tlir.sigmaerpdev2__Expiry_Date__c<$A.localizationService.formatDate(new Date(), "YYYY-MM-DD")){// && tlir.stapp__Lot__c)){
                        // 	alert('j>>'+j);
                        component.set("v.errorMessage", "Expiry date must not be in the past at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                        component.set("v.isError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                    }
                    //   alert('if6');
                    if(tlir.sigmaerpdev2__Status__c=='Verified' && tli[j].hasExpiryDate && !tlir.sigmaerpdev2__Expiry_Date__c){
                        component.set("v.errorMessage", "Expiry Date is mandatory for the product '"+tli[j].productName+" at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                        component.set("v.isError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                    }
                    // alert('if7');
                    
                    var srlNo=tli[j].serialNo;
                    
                    if(tli[j].attributeType==='SERIALIZED' && tlir.sigmaerpdev2__Status__c=='Verified')
                    {
                        if(!srlNo){
                            //  alert('srlNo>'+srlNo);
                            component.set("v.errorMessage", "Serial No. is Mandatory for Serialized Products  at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                            component.set("v.isError", true);
                            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return;
                        }
                        //   alert('if8');
                        if(srlNo.length<tlir.sigmaerpdev2__Quantity_Received__c || srlNo.length<=0){
                            //alert('srlNo>'+srlNo);
                            component.set("v.errorMessage", "Serial No. is Mandatory for Serialized Products  at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                            component.set("v.isError", true);
                            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return;
                        }
                        //    alert('if9');
                        /*  if(srlNo[i].sigmaerpdev2__Serial_Number__c==srlNo[j].sigmaerpdev2__Serial_Number__c){
                            //alert('Duplicate Serial No. found!');
                            component.set("v.errorMessage", "Duplicate Serial No. found at '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                            component.set("v.isError", true);
                            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return;
                        }*/
                        
                        {
                            for(var k=0;k<srlNo.length;k++){
                                if(!srlNo[k].sigmaerpdev2__Serial_Number__c){
                                    //    alert('srlNo>'+srlNo);
                                    component.set("v.errorMessage", "Serial No. Can not be null  at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                                    component.set("v.isError", true);
                                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                                    return;
                                }
                                //  alert('if10');
                                //  alert('serialNo'+serialNos);
                                //  alert('dup sl>>'+srlNo[k].sigmaerpdev2__Serial_Number__c);
                                if(serialNos.includes(srlNo[k].sigmaerpdev2__Serial_Number__c)){
                                    // alert('srlNo>'+srlNo);
                                    component.set("v.errorMessage", "Added Duplicate Serial No at line '" +(k+1)+ "' --> '"+srlNo[k].sigmaerpdev2__Serial_Number__c+"' found at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                                    component.set("v.isError", true);
                                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                                    return;
                                }
                                // alert('if11');
                                serialNos.push(srlNo[k].sigmaerpdev2__Serial_Number__c);
                            }
                            
                        }
                    }
                    // alert('12345556');
                    if(tlir.isVerified!=true){
                        var dupTransactionTotalRecQuant=parseInt(tlir.sigmaerpdev2__Quantity_Received__c);
                        
                        for(var a=parseInt(i)+1;a<srp.length;a++){
                            
                            if(srp[i].transID==srp[a].transID)
                            {
                                
                                for(var b=0;b<srp[a].TransLineItems.length;b++){
                                    
                                    if(tlir.sigmaerpdev2__Product__c==srp[a].TransLineItems[b].SRLineItemRec.sigmaerpdev2__Product__c && j==b)
                                    {
                                        
                                        dupTransactionTotalRecQuant+=parseInt(srp[a].TransLineItems[b].SRLineItemRec.sigmaerpdev2__Quantity_Received__c);
                                    }
                                }
                            }
                        }
                        if(tli[j].remainqty<dupTransactionTotalRecQuant){
                            component.set("v.errorMessage", "Receiving quantity is Exceeding the Remaining quantity at the line '"+(j+1)+"' of '"+srp[i].transName+"'Purchase Order.");
                            component.set("v.isError", true);
                            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return;
                        }
                        // alert('if12');
                    }
                    
                }
                
                //code changed by rashmi to check duplicate bin id on 22-10-2019
                for(var j=i+1;j<srp.length;j++)
                {
                    //   alert('in for j-->>'+j);
                    var tlitest=srp[i].TransLineItems;
                    var tlitest1=srp[j].TransLineItems;
                    //	alert('tlitest-->>'+JSON.stringify(tlitest));
                    //	alert('tlitest1-->>'+JSON.stringify(tlitest1));
                    for(var k=0;k<tlitest.length;k++)
                    {
                        //alert('in for k-->>'+k);
                        for(var n=0;n<tlitest1.length;n++)
                        {
                            //  alert('srp[i].transID1-->>'+srp[i].transID);
                            //alert('srp[j].transID2-->>'+srp[j].transID);
                            //alert('tlitest[k].BinId1-->>'+tlitest[k].BinId);
                            //	alert('tlitest1[n].BinId2-->>'+tlitest1[n].BinId);
                            if(srp[i].transID==srp[j].transID && tlitest[k].BinId==tlitest1[n].BinId)
                            {
                                //	alert('in for if');
                                component.set("v.errorMessage", "Duplicate Bin Found  at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                                component.set("v.isError", true);
                                window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                                return;  
                            }
                        }
                    }//ends here
                    
                    //  var tlitest1=srp[j].TransLineItems;
                    /*  	 alert('in for 1');
                     alert('i PO>>>'+srp[i].transID);
                     alert('j PO>>>'+srp[j].transID);
                     alert('i Bin Id>>>'+tlitest[i].BinId);
                    alert('j Bin Id>>>'+tlitest1);
                    if(srp[i].transID==srp[j].transID && tlitest[i].BinId == tlitest1)
                    {
                         alert('in for if');
                        component.set("v.errorMessage", "Duplicate Bin Found  at the line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                        component.set("v.isError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                    }
                     alert('if13');*/
                } 
            }
        }
        
        else
        {
            // alert('Inside else');
            component.set("v.errorMessage", "Atleast One Line Item is Required.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        //  alert('outsideif');
        component.set('v.disableSave',true);
        var spinner=component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        //  alert('calling helper');
        helper.saveDataHelper(component, event, helper); 
    },
    vendorIDChange: function(component, event, helper) {
        component.set("v.stockReceive.sigmaerpdev2__Vendor__c",component.get("v.vendorID"));
        component.set("v.stockReceive.sigmaerpdev2__Vendor__r.Name",component.get("v.vendorName"));
    },
    contactIDChange: function(component, event, helper) {
        component.set("v.stockReceive.sigmaerpdev2__Delivery_Person__c",component.get("v.contactID"));
        component.set("v.stockReceive.sigmaerpdev2__Delivery_Person__r.Name",component.get("v.contactName"));
    },
    recsiteIDChange: function(component, event, helper) {
        component.set("v.stockReceive.sigmaerpdev2__Location__c",component.get("v.recsiteID"));
        component.set("v.stockReceive.sigmaerpdev2__Location__r.Name",component.get("v.recsiteName"));
    },
    handleCancel: function(component, event, helper) {
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Stock_In__c"
        });
        homeEvent.fire();*/
        //commented above line and added below line on 6-2-2020 to show in PurchaseOrderModules UI page after cancel is pressed	    
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:PurachaseOrderModules",
            componentAttributes: {
                from : 'SR'
            }
        });
        evt.fire();
        //ends here
    },
    closeErrorMsg: function(component, event, helper) {
        component.set("v.errorMessage", "");
        component.set("v.isError", false);
    },
    /* afterProductScaned: function(component, event, helper) {
        
        // component.set("v.productFoundFlag",false);
        if(!component.get('v.scannedProductBarCodeValue') || component.get('v.scannedProductBarCodeValue').length <5){
            
            return;
        }
        var prodBarCodeValue=component.get('v.scannedProductBarCodeValue');
        window.setTimeout(
            $A.getCallback(function() {
                var prodBarCodeValueInner=component.get('v.scannedProductBarCodeValue');
                var prodFound = false;
                var allProdPicked = false;
                var allPickedProdName = '';
                if(prodBarCodeValueInner.length==prodBarCodeValue.length)
                {
                    var StockReceivingWrap=component.get('v.StockReceivingWrap');
                    
                    
                    for(var i=0;i<StockReceivingWrap.length;i++)
                    {
                        
                        for(var j=0;j<StockReceivingWrap[i].TransLineItems.length;j++)
                        {
                            
                            
                            if(StockReceivingWrap[i].TransLineItems[j].Product_Bar_Code==prodBarCodeValue && StockReceivingWrap[i].TransLineItems[j].remainqty!=StockReceivingWrap[i].TransLineItems[j].SRLineItemRec.sigmaerpdev2__Quantity_Received__c)
                            {
                                
                                StockReceivingWrap[i].TransLineItems[j].SRLineItemRec.sigmaerpdev2__Quantity_Received__c=StockReceivingWrap[i].TransLineItems[j].SRLineItemRec.sigmaerpdev2__Quantity_Received__c? parseInt(StockReceivingWrap[i].TransLineItems[j].SRLineItemRec.sigmaerpdev2__Quantity_Received__c)+1:1;
                                component.set("v.scannedProductName",StockReceivingWrap[i].TransLineItems[j].productName);
                                prodFound=true;
                                
                                /*if(StockReceivingWrap[i].TransLineItems[j].remainqty==StockReceivingWrap[i].TransLineItems[j].SRLineItemRec.sigmaerpdev2__Quantity_Received__c)
                                    {
                                        allProdPicked=true;
                                       // allPickedProdName=precheckData.precheckChildWrapData[i].prodName;
                                    }*/
    /*   break;
                                }  
                            }
                        if(prodFound)
                        {
                            break; 
                        }
                        
                    }
                    component.set('v.StockReceivingWrap',StockReceivingWrap);
                    
                    if(prodFound)
                    {
                        component.set('v.scannedProductBarCodeValue','');
                        component.set("v.productFoundFlag",true);
                    }
                    else
                    {
                        component.set("v.scannedProductName",'Not Found');
                        component.set("v.productFoundFlag",true);
                    }*/
    /* if(allProdPicked){
                        
                        var allProductsRecieved=true;
                        for(var i=0;i<precheckData.precheckChildWrapData.length;i++)
                        {
                            if(precheckData.precheckChildWrapData[i].qtyRemaining!=precheckData.precheckChildWrapData[i].qtyDelivered)
                            {
                                allProductsRecieved=false;
                            }
                        }
                        if(allProductsRecieved){
                            component.find('basketScanedCode').blur();
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type": "success",
                                "message": "All Products Checked completely. Now you can click on submit"
                            });
                            resultsToast.fire();
                        }
                        else{
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type": "success",
                                "message": "Product '"+allPickedProdName+"' checked completely."
                            });
                            resultsToast.fire();
                        }
                    }*/
    /* }
            }), 1000
        );
         
     },*/
    barCodeClear: function(component, event, helper) {
        if(!component.get('v.scannedProductBarCodeValue')){
            //$A.util.addClass(component.find('productNameDispaly'), 'slds-hide');
        }
    },
    ChangeVendorId: function(component, event, helper) {
        var vendorId =component.get('v.vendorId');
        var vendorName =component.get('v.vendorName');
        if(vendorId){
            component.set('v.stockReceive.sigmaerpdev2__Vendor__c',vendorId);
            component.set('v.stockReceive.sigmaerpdev2__Vendor__r.Name',vendorName);
            // display default contact, added by Krishna pujara on 15-06-2021
            var action = component.get("c.fetchVendorContact");
            action.setParams({ "vendorId": vendorId });
            action.setCallback(this, function (a) {
                var state = a.getState();
                //  alert(state);
                if (state === "SUCCESS") {                
                    if (a.getReturnValue() != null) {
                        if(a.getReturnValue().length==1){
                            component.set('v.contactId',a.getReturnValue()[0].Id);
                            component.set('v.contactName',a.getReturnValue()[0].Name);
                        }
                    }
                }
            });
            $A.enqueueAction(action);           
            //$A.util.addClass(component.find('productNameDispaly'), 'slds-hide');
            
            
            //$A.util.addClass(component.find('productNameDispaly'), 'slds-hide');
        }
        else{
            component.set('v.stockReceive.sigmaerpdev2__Vendor__c','');
            component.set('v.stockReceive.sigmaerpdev2__Vendor__r.Name','');
            component.set('v.contactId','');
            
        }
        
    },
    ChangeContactId: function(component, event, helper) {
        var contactId =component.get('v.contactId');
        //alert(contactId);
        var contactName =component.get('v.contactName');
        //alert(contactName);
        if(contactId){
            component.set('v.stockReceive.sigmaerpdev2__Delivery_Person__c',contactId);
            component.set('v.stockReceive.sigmaerpdev2__Delivery_Person__r.Name',contactName);
            //$A.util.addClass(component.find('productNameDispaly'), 'slds-hide');
        }
        else{
            component.set('v.stockReceive.sigmaerpdev2__Delivery_Person__c','');
            component.set('v.stockReceive.sigmaerpdev2__Delivery_Person__r.Name','');
            
        }
    },
    ChangeLocationId: function(component, event, helper) {
        var locationId =component.get('v.locationId');
        var locationName =component.get('v.locationName');
        if(locationId){
            component.set('v.stockReceive.sigmaerpdev2__Location__c',locationId);
            component.set('v.stockReceive.sigmaerpdev2__Location__r.Name',locationName);
            //$A.util.addClass(component.find('productNameDispaly'), 'slds-hide');
        }
        else{
            component.set('v.stockReceive.sigmaerpdev2__Location__c','');
            component.set('v.stockReceive.sigmaerpdev2__Location__r.Name','');
            
        }
    },
    
})