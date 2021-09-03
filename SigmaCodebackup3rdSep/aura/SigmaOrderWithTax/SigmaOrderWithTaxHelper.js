({
      taxTreatmentChangeHandler: function (component, event, helper) {
        var action = component.get("c.fetchTaxTreatementRelatedData");
        action.setParams({
            "taxTreatmentId": component.get('v.sigmaOrder.sigmaerpdev2__Tax_Treatment__c')
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            //alert(state);
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    //alert(JSON.stringify(a.getReturnValue()));
                    component.set('v.taxTreatmentData',a.getReturnValue());
                }
            }
            else{
                alert('Please configure Tax Rate and Tax Code for the selected  Tax Treatment');
                console.log(JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
    },
     helperGetAccountDataforcontact:function (component, event, helper,accid) {
       // alert('hiii>>'+accid);
        var action = component.get("c.fetchAccountData");
        action.setParams({
            "accId": accid
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                 // alert('returnData>>>>'+JSON.stringify(returnData)) 
                    if(returnData){
                         if(returnData.Contacts.length==1){ 
                        component.set("v.sigmaOrder.sigmaerpdev2__BillingPersonNew__c",returnData.Contacts[0].Id);
                        component.set("v.sigmaOrder.ContactName",returnData.Contacts[0].Name);
                        } 
            
                    }
                }
                
            }
            else{
                //component.set("v.accRelatedData",'');
            }
        });
        $A.enqueueAction(action);
    }, 
     getTaxDetailsHelper: function (component, event, helper) {
        // alert(' inside getTaxDetailsHelper')
        //alert('getTaxDetailsHelper>>>'+JSON.stringify(component.get("v.sigmaOrder")))
       //alert('ol>>'+JSON.stringify(component.get("v.orderLinesData")))
        var action = component.get("c.fetchTaxData");
        action.setParams({
            "headerData": JSON.stringify(component.get("v.sigmaOrder")),
            "LinesData": JSON.stringify(component.get("v.orderLinesData")),
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
        //alert('state'+state);
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                    component.set('v.taxDataList',JSON.parse(returnData));
                 // alert('44'+JSON.stringify(JSON.parse(returnData)));
                    var taxDataList=component.get('v.taxDataList');
                    var solList=component.get("v.orderLinesData");
                   // alert('solList'+JSON.stringify(solList))
                    var totalGross=0;
                    var taxAmt=0;
                    for(var i=0; i< solList.length; i++)
                    {
                        for(var j=0;j<taxDataList.length;j++)
                        {
                            //alert(i+'-'+j+'-'+taxDataList[j].indx);
                            if(i==taxDataList[j].indx)
                            {
                               //commented bellow lines to do not round off amount
                              /*  taxDataList[j].taxAmount=taxDataList[j].taxAmount.toFixed(2);
                                taxDataList[j].totAmount=taxDataList[j].totAmount.toFixed(2);*/
                                 taxDataList[j].taxAmount=taxDataList[j].taxAmount;
                                taxDataList[j].totAmount=taxDataList[j].totAmount;

                                solList[i].orderLines.sigmaerpdev2__tax_amount__c=taxDataList[j].taxAmount;
                                
                                totalGross+=parseFloat(taxDataList[j].totAmount);
                                taxAmt+=parseFloat(taxDataList[j].taxAmount);
                                var sumOfTaxRate=0
                                for(var k=0;k<taxDataList[j].TaxDataList.length;k++)
                                {
                                    sumOfTaxRate+=taxDataList[j].TaxDataList[k].taxRate;
                                }
                                solList[i].orderLines.sigmaerpdev2__Tax_Rate__c =sumOfTaxRate;
                            }
                        }
                    }
                    component.set("v.orderLinesData",solList);
                   /* component.set("v.totalGross",totalGross.toFixed(2));
                    component.set("v.taxAmt",taxAmt.toFixed(2));*/
                     component.set("v.totalGross",totalGross);
                    component.set("v.taxAmt",taxAmt);
                   // alert('81'+component.get("v.totalGross"))
                   // alert('orderLinesData'+ component.get("v.orderLinesData"))
                   // this.netGrossCalculation(component, event, helper)
                    
                }
            }
            else{
               // this.netGrossCalculation(component, event, helper);
                
                console.log(JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
    },
   
    fetchConfigDefaultValues: function (component, event, helper) {
        var action = component.get("c.fetchDefualtConfig");
        action.setCallback(this, function (a) {
            var state = a.getState();
            //  alert('state::'+state);
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    component.set("v.defaultConfigValues",a.getReturnValue().sigmaerpdev2__Allocation_in_Sales_Order__c);
                    //alert('boolean'+ JSON.stringify(component.get("v.defaultConfigValues")));
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
                    /*if(component.get("v.sigmaOrderIdForClone")){
                        
                    }*/
                   //alert(component.get("v.defualtallocate"));
                    component.set("v.showAutoResvButton", a1.getReturnValue().sigmaerpdev2__Auto_Reserve_Stock__c);
                    if(component.get("v.showAutoResvButton") == true){
                        component.set("v.autoAllocFlag", true);
                    }
                }
            }
        });
        $A.enqueueAction(action1); 
        
        
    },
    
    
    //added for reset UI
    removeAccRelData: function (component, event, helper) {
        //alert('in');
        
        component.set("v.sigmaOrder.sigmaerpdev2__Customer_Type__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__BillingPersonNew__c",'');
        component.set("v.sigmaOrder.sigmaerpdev2__Orders_Status__c", 'Pending');
        component.set("v.sigmaOrder.sigmaerpdev2__Shipping_Street__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingCity__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingState__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingCountry__c", '');
        component.set("v.sigmaOrder.sigmaerpdev2__ShippingPostalCode__c", '');
        component.set("v.currencyname",'');
        component.set("v.sigmaOrder.sigmaerpdev2__Tax_Treatment__c",'');
       component.set("v.sigmaOrder.TaxTreatmentName",'');
        component.set("v.sigmaOrder.sigmaerpdev2__BillingPersonNew__c",'');
         component.set("v.sigmaOrder.ContactName",'');
        
    },
    
    
    
    helperGetAccountDataobject:function (component, event, helper,accid) {
        //alert(accid);
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
                    // alert( "before::"+component.get("v.sigmaOrder.sigmaerpdev2__ShippingPostalCode__c"));
                    var accountaddress=a.getReturnValue();
                   
                    
                    if(accountaddress.sigmaerpdev2__Shipment_Details__r != undefined) 
                    {
                     	component.set("v.sigmaOrder.sigmaerpdev2__Shipping_Street__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__Address__c);
                    	component.set("v.sigmaOrder.sigmaerpdev2__ShippingCity__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__City__c);
                    	component.set("v.sigmaOrder.sigmaerpdev2__ShippingState__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__State__c);
                    	component.set("v.sigmaOrder.sigmaerpdev2__ShippingCountry__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__Country__c);
                    	component.set("v.sigmaOrder.sigmaerpdev2__ShippingPostalCode__c",accountaddress.sigmaerpdev2__Shipment_Details__r[0].sigmaerpdev2__Zip__c);
                    	
                       
                    }
                    component.set("v.sigmaOrder.sigmaerpdev2__Customer_Type__c",accountaddress.sigmaerpdev2__Customer_Type__c);
                    //alert('sigmaerpdev2__Exchange_Currency__c'+accountaddress.sigmaerpdev2__Exchange_Currency__c);
                    if(accountaddress.sigmaerpdev2__Exchange_Currency__c!=null || accountaddress.sigmaerpdev2__Exchange_Currency__c!=undefined)
                    {
                        if(accountaddress.sigmaerpdev2__Exchange_Currency__r.Name !=undefined)
                            //alert('inside');
                            component.set("v.currencyname",accountaddress.sigmaerpdev2__Exchange_Currency__r.sigmaerpdev2__Display_Name__c);
                        component.set("v.sigmaOrder.sigmaerpdev2__Currency__c",accountaddress.sigmaerpdev2__Exchange_Currency__c);
                    }
                    
                    
                    if(accountaddress.sigmaerpdev2__Customer_Type__c == 'Credit Customer')
                    {
                        component.set("v.RemainCB",accountaddress.sigmaerpdev2__Dimension_Tags__r[0].sigmaerpdev2__Remaining_Credit_Limit__c);
                    }
                    //display default contact, added by Krishna pujara on 11-06-2021
                    if(accountaddress.Contacts.length==1){
                        //alert(JSON.stringify(accountaddress.Contacts[0].Id));
                        component.set("v.CreatedBy",accountaddress.Contacts[0].Name);
                        component.set('v.sigmaOrder.sigmaerpdev2__BillingPersonNew__c', accountaddress.Contacts[0].Id);
                        //component.set("v.recordName",accountaddress.Contacts[0].Name);
                    }
                    if(accountaddress.Contacts.length > 1){
                        component.set("v.CreatedBy",'');
                    }
                    //ends here
                    // alert( "after:"+component.get("v.sigmaOrder.sigmaerpdev2__ShippingPostalCode__c"));
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    helperGetTaxData:function (component, event, helper) {
        var accid=component.get("v.sigmaOrder.sigmaerpdev2__AccountId__c");
       // alert('inside helper'+accid)
        var action = component.get("c.fetchTaxtreatmentData");
        // alert('inside action')
        action.setParams({
            "accId": accid,
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
           // alert('state'+state)
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                  //  alert('130>>>'+JSON.stringify(returnData));
                     if(returnData.acc.sigmaerpdev2__Tax_Treatment__c)
                            {
                                component.set("v.sigmaOrder.sigmaerpdev2__Tax_Treatment__c",returnData.acc.sigmaerpdev2__Tax_Treatment__c);
                                component.set("v.sigmaOrder.TaxTreatmentName",returnData.acc.sigmaerpdev2__Tax_Treatment__r.Name);
                            }
                            else
                            {
                                component.set("v.sigmaOrder.sigmaerpdev2__Tax_Treatment__c",'');
                                component.set("v.sigmaOrder.TaxTreatmentName",'');
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
                    //alert(JSON.stringify(returnData));
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
    viewProductHelper: function (component, event, helper,ind) {
      //  alert('calling viewProductHelper');
        var prodId = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Product__c;
     //   alert('prodId>>>'+prodId);
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
   removeOrderLinesHelper: function (component, event, helper,ind) {
        // var reduceIndexFlag = false;
        var olRemoveIdList=new Array();
        var orderLines = component.get("v.orderLinesData");
       // alert('orderLines@@'+JSON.stringify(orderLines));
        //var splitBackPresentIndex;
        var splitBackPresentFlag=false;
       //alert(JSON.stringify(component.get('v.orderLines')));
        
        component.set("v.hide",false);
        if (orderLines[ind].orderLines.sigmaerpdev2__Back_Order__c || orderLines[ind].orderLines.sigmaerpdev2__Splited_Order_Line__c) 
        {
            for (var i = 0; i < orderLines.length && i != ind; i++) {
                if (orderLines[ind].orderLines.sigmaerpdev2__Product__c == orderLines[i].orderLines.sigmaerpdev2__Product__c && (!orderLines[i].orderLines.sigmaerpdev2__Back_Order__c || !orderLines[i].orderLines.sigmaerpdev2__Splited_Order_Line__c) )
                {
                    orderLines[i].orderLines.sigmaerpdev2__Quantity__c -= orderLines[ind].orderLines.sigmaerpdev2__Net_Quantity__c;
                    // splitBackPresentIndex=i;
                }
                
            }
        }
        
        
        
        if(orderLines[ind].orderLines.sigmaerpdev2__Back_Order__c ==undefined || (component.get('v.recordId') && orderLines[ind].orderLines.sigmaerpdev2__Back_Order__c ==false))
        {
          
           //alert(orderLines[ind+1]);
            // return;
            if((orderLines[ind+1] !=undefined && orderLines[ind+1].orderLines.sigmaerpdev2__Back_Order__c))
            {
               
                olRemoveIdList.push(orderLines[ind+1].orderLines); 
                orderLines.splice(ind+1, 1);
                component.set("v.orderLinesData", orderLines); 
            }
            // alert('342'+ JSON.stringify(component.get("v.orderLinesData")))
        }
        if(orderLines[ind].orderLines.sigmaerpdev2__Splited_Order_Line__c ==undefined || (component.get('v.recordId') && orderLines[ind].orderLines.sigmaerpdev2__Splited_Order_Line__c ==false))
        {
           
            for (var i = orderLines.length-1; i >= 0 && i != ind; i--) {
                if (orderLines[ind].orderLines.sigmaerpdev2__Product__c == orderLines[i].orderLines.sigmaerpdev2__Product__c && orderLines[i].orderLines.sigmaerpdev2__Splited_Order_Line__c) {
                     
                    if(orderLines[i].orderLines.Id!=undefined)
                        olRemoveIdList.push(orderLines[i].orderLines);
                    orderLines.splice(i, 1);
                }
            }
           // alert('342'+ JSON.stringify(component.get("v.orderLinesData")))
        }
        this.getTaxDetailsHelper(component, event, helper);
       
        if(orderLines[ind].orderLines.Id)
             
            olRemoveIdList.push(orderLines[ind].orderLines);
        orderLines.splice(ind, 1);
        component.set("v.orderLinesData", orderLines);
   
        
     console.log('removeorderline'+component.get("v.orderLinesData"));
        
        var orderLines = component.get("v.orderLinesData");
        var idListStr;
        for(var i=0;i<orderLines.length;i++)
        {
            if(i==0)
                
                idListStr=orderLines[i].orderLines.sigmaerpdev2__Product__c;
            else
                
                idListStr+='\',\''+orderLines[i].orderLines.sigmaerpdev2__Product__c;
        }
        component.set('v.idListStr',idListStr);
         
        if(olRemoveIdList.length>0){
           
            var action = component.get("c.deleteIndividualOrderLines");        
            action.setParams({ 
                "SigmaOrderLines" : olRemoveIdList
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
            "prodID": component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Product__c,
            
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
           // alert('state::'+state);
            if (state === "SUCCESS") {
                
               // alert(JSON.stringify(a.getReturnValue()));
                if (a.getReturnValue().length > 0) {
                    
                     // alert("size::"+a.getReturnValue().length);
                     // alert("returnvalue::"+JSON.stringify(a.getReturnValue()));
                    //component.set("v.originalILPLIData", a.getReturnValue());
                    var ilpliIdAllocatedQuantMap=new Object;
                    //alert(JSON.stringify('ilpliIdAllocatedQuantMap::'+ilpliIdAllocatedQuantMap));
                    var orderLinesData=component.get("v.orderLinesData");
                    for(var i=0;i<orderLinesData.length;i++)
                    {
                        if(ind!=i){
                            if(orderLinesData[i].ilpliData)
                            {
                                // alert(inside1stif);
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
                           // alert("Inside 2nd");
                            a.getReturnValue()[i].sigmaerpdev2__Available_Quantity__c-=ilpliIdAllocatedQuantMap[a.getReturnValue()[i].Id];
                            if(a.getReturnValue()[i].sigmaerpdev2__Available_Quantity__c>0)
                                originalILPLIData.push(a.getReturnValue()[i]);
                        }
                        else
                        {
                            //alert("Inside 3nd");
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
                    if(availCount<orderLinesData[ind].orderLines.sigmaerpdev2__Net_Quantity__c)
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
                    //alert('1')
                     
                    component.set("v.originalILPLIData", originalILPLIData);
                     // alert('openSelectManual1>>>>'+ component.get("v.openSelectManual"))
                   component.set("v.openSelectManual", true);
                     //alert('openSelectManual2>>>>'+ component.get("v.openSelectManual"))
                    component.find("manualSelectProdName").set('v.value',component.get("v.orderLinesData")[ind].productName);
                    component.find("orderedQuant").set('v.value',component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Net_Quantity__c);
                    //alert(JSON.stringify('ilpliIdAllocatedQuantMap::'+ilpliIdAllocatedQuantMap));
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
        var action = component.get("c.fetchILPLIDataForManualSelection");
        action.setParams({
            "prodID": component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Product__c,
            
            
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
                                   var requirderQuant =component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Net_Quantity__c;
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
                                       var outTempAvalQuant=component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Net_Quantity__c;
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
    
    saveDataHelper: function (component, event, helper,so,olData,socloneId)
    {
       // alert('2')
        //alert('check orderline????????'+JSON.stringify(olData));
        var autoallocate = component.get('v.autoAllocFlag');
        if(component.get('v.recordId'))
        {
            component.set('v.isupdate',true);
        }
        if(socloneId)
        {
            //alert('else if')
            component.set('v.isupdate',false);
        }
        
        //alert(component.get('v.isupdate'));
        
		//alert(JSON.stringify(so))        
        var action = component.get("c.saveSigmaOrder");
        action.setParams({
            "so": JSON.stringify(so),
            "sol": JSON.stringify(olData),
            "autostock": autoallocate,
            "soupdate": component.get('v.isupdate')
            
            
        });
        action.setCallback(this, function (response) {
            var spinner=component.find('spinner');
            $A.util.toggleClass(spinner, 'slds-hide');
            var state = response.getState();
           // alert('state>>>'+state);  
            if (state === "SUCCESS") {
               // alert(" inside order id:::::: "+JSON.stringify(response.getReturnValue()));
                
                
                if (response.getReturnValue().message === "success") {
                    var recid=response.getReturnValue().data;
                    if(recid !=null && component.get('v.recordId') ==undefined)
                    {
                        var spinner=component.find('spinner');
                        $A.util.toggleClass(spinner, 'slds-hide');
                        //alert('Sales Order Created Successfully !');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"Success",
                            "title": "Success!",
                            "message": "Sales Order Created Successfully,Please proceed to payment"
                        });
                        toastEvent.fire();
                       // alert(recid);
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
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"Success",
                            "title": "Success!",
                            "message": "Sales Order Updated Successfully"
                        });
                        toastEvent.fire();
                       // alert('order@@'+JSON.stringify(component.get('v.sigmaOrder')));
                        // alert('Sales Order Updated Successfully !');
                         
                        if(!component.get('v.sigmaOrder.sigmaerpdev2__Is_Payment_Made__c'))
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
                         $A.get('e.force:refreshView').fire();
                        //     window.location.href = "/" +recid; //uncommented by rashmi on 31-12-2019
                     }
                }
                else {
					//alert('else1104')
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "error!",
                        "type": "error",
                        "message": response.getReturnValue().data
                    });
                    toastEvent.fire();
                }
            }else {
                
                var spinner=component.find('spinner');
                $A.util.toggleClass(spinner, 'slds-hide');
                alert('Sales Order Creation Failed');
                
            }
            
            
        });
        
        
        $A.enqueueAction(action);
    },
   
    getSigmaOrderDataForEdit: function(component, event, helper, recId,sigmaOrderIdForClone) {
        component.set("v.isbackordercheck", true);
       // alert('check edit>>'+recId + ' clone functionality>>>>'+ sigmaOrderIdForClone);
        var tempRecId;
        if(recId){
            console.log('if>>'+recId);
            var action = component.get("c.getSigmaOrderData");
            tempRecId=recId;
        }
        else{
            console.log('else>>'+sigmaOrderIdForClone);
            component.set("v.sigmaOrder.sigmaerpdev2__Is_Payment_Made__c",'false');
            //alert(component.get("v.sigmaOrder.sigmaerpdev2__Is_Payment_Made__c"));
            action = component.get("c.getSigmaOrderDataForCloning");
            tempRecId=sigmaOrderIdForClone;
        }
        action.setParams({
            "soId": tempRecId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
             //alert('state::'+state);
            if (state === "SUCCESS") {
                var completeWrapp = response.getReturnValue();
                //console.log('completeWrapp::'+JSON.stringify(completeWrapp));
               // alert('completeWrapp::'+JSON.stringify(completeWrapp.solWrap));
                
                // alert('accountdetails::'+JSON.stringify(completeWrapp.credituser));
                // alert('remaining::'+JSON.stringify(completeWrapp.credituser.sigmaerpdev2__Remaining_Credit_Limit__c));
                   if(completeWrapp.sigmaOrder.sigmaerpdev2__Order_Created_Via__c==='Time Based Inventory')
				{
                  var msg = "Can not edit the Time Based Inventory Order";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError1",true);
                    component.set("v.TimeBasedInv",true);
                    return;
                } 
                 else if(completeWrapp.sigmaOrder.sigmaerpdev2__Order_Created_Via__c==='Subscription')
				{
                  var msg = "Can not edit the Subscription Order";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError1",true);
                    return;
                }
                else{
                    component.set("v.isError1",false);
                    component.set("v.errorMsg", "");
                }
                component.set("v.sigmaOrder", completeWrapp.sigmaOrder);
                component.set('v.autoAllocFlag',completeWrapp.sigmaOrder.sigmaerpdev2__Auto_Allocate__c);
                //  alert('sigmaorder'+JSON.stringify(component.get("v.sigmaOrder")));
                if (completeWrapp.sigmaOrder.sigmaerpdev2__AccountId__c != undefined)
                    //   alert("inside ifff");
                    component.set("v.recordName", completeWrapp.sigmaOrder.sigmaerpdev2__AccountId__r.Name);
                if (completeWrapp.sigmaOrder.Name != undefined)
                    component.set("v.sigmaOrder.sigmaerpdev2__Cloned_From__c",completeWrapp.sigmaOrder.Name);
                if (completeWrapp.sigmaOrder.sigmaerpdev2__BillingPersonNew__c != undefined)
                    component.set("v.CreatedBy", completeWrapp.sigmaOrder.sigmaerpdev2__BillingPersonNew__r.Name);
                if (completeWrapp.sigmaOrder.sigmaerpdev2__Tax_Treatment__c != undefined)
                {
                    component.set("v.sigmaOrder.TaxTreatmentName", completeWrapp.sigmaOrder.sigmaerpdev2__Tax_Treatment__r.Name);
                	//helper.taxTreatmentChangeHandler(component, event, helper);
                }
               
                   
                	//helper.taxTreatmentChangeHandler(component, event, helper);
                
                //alert(component.get("v.CreatedBy"));
                if (completeWrapp.sigmaOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c != undefined)
                    component.set("v.nopickpackshipment", completeWrapp.sigmaOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c);
                // alert("completeWrapp.sigmaOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c"+completeWrapp.sigmaOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c);
                document.getElementById("noPackShip").checked=completeWrapp.sigmaOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c;
                // alert(completeWrapp.sigmaOrder.sigmaerpdev2__Currency__c);
                if (completeWrapp.sigmaOrder.sigmaerpdev2__Currency__c != undefined)
                    component.set("v.currencyname", completeWrapp.sigmaOrder.sigmaerpdev2__Currency__r.sigmaerpdev2__Display_Name__c);
                //alert('currency'+ component.get("v.currencyname"));
                
                if(completeWrapp.credituser != undefined)
                    component.set('v.RemainCB',completeWrapp.credituser.sigmaerpdev2__Remaining_Credit_Limit__c);
                
                
                component.set("v.orderLinesData", completeWrapp.solWrap);
                 
                //console.log('orderline@@'+ JSON.stringify(component.get("v.orderLinesData")));
             //  alert ('orderline@@'+ JSON.stringify(response.getReturnValue().taxCodeName));
                var orderLines = component.get("v.orderLinesData");
                
                var idListStr;
                for(var i=0;i<orderLines.length;i++)
                {
                    if(i==0)
                        idListStr=orderLines[i].orderLines.sigmaerpdev2__Product__c;
                    else
                        idListStr+='\',\''+orderLines[i].orderLines.sigmaerpdev2__Product__c;
                }
                component.set('v.idListStr',idListStr); 
                
            }
            else {
                alert('There was a problem : '+JSON.stringify(response.getError()));
            }  
        });
        $A.enqueueAction(action);
    },
    
    automateStockResv : function(component, event, helper){        
        var so = component.get("v.sigmaOrder");
        var olData = component.get("v.orderLinesData");       
        var newArry = [];
        for(var i=0;i<olData.length;i++){           
            if(olData[i].orderLines.Name == undefined){
                newArry.push(olData[i]);
            }
            else
            {
                newArry.push(olData[i]);
            }
        }        
        var action = component.get("c.automateStockReservation");
        action.setParams({
            "so": JSON.stringify(so),
            //"sol": JSON.stringify(olData)
            "sol": JSON.stringify(newArry),
            "recordId":component.get("v.recordId"),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();           	                        
            //alert('state==='+state);
            if (state == "SUCCESS"){
                //console.log('auto rev==='+JSON.stringify(response.getReturnValue()));
                var allocStatus = response.getReturnValue()[0].stockExist; 
                var resvStatus = allocStatus.split("_"); 
                if(allocStatus == 'true'){
                    var automateResVal = response.getReturnValue();
                    
                    var olData1 = component.get("v.orderLinesData");
                    //alert('length>>'+JSON.stringify(olData1));
                    for(var i=0;i<automateResVal.length;i++){
                        
                        
                        //olData[i].ilpliData = automateResVal[i].ilpliData;
                        if(component.get("v.recordId") == '' || component.get("v.recordId") == undefined){                            
                            newArry[i].ilpliData = automateResVal[i].ilpliData;
                        }
                        else{                            
                            for(var j=0;j<olData1.length;j++){
                                
                                // alert(olData1[j].orderLines.sigmaerpdev2__IsInventoryUpdated__c)
                                if(olData1[j].orderLines.Name == undefined && i==j){
                                    
                                    var wrap;                                                  
                                    wrap = automateResVal[i].ilpliData;                                    
                                    olData1[j].ilpliData = wrap;
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
                    //console.log('full wrap---'+JSON.stringify(olData1));                    
                    if(component.get("v.recordId") == '' || component.get("v.recordId") == undefined)                       
                        component.set("v.orderLinesData", newArry);
                    else
                        component.set("v.orderLinesData", olData1);                    
                    
                    var updatedOlData = component.get("v.orderLinesData");
                    // alert('updatedOlData>>'+JSON.stringify(updatedOlData));
                    //  return;
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
                var msg ="Error occured : "+JSON.s0tringify(Error); 
                alert(msg);               
                return;
            }
        });
        $A.enqueueAction(action);
    },
    getproductwarranty: function (component, event, helper,ind){
        	var proid = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Product__c;
            var custid = component.get("v.sigmaOrder.sigmaerpdev2__AccountId__c");
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
                    var sdays;		
                    var stotaldays;
                    var product=a.getReturnValue();	
                   // alert('product@@'+JSON.stringify(product));
                    var ProductWarranty= new Object();
                    ProductWarranty.index=ind;
                    ProductWarranty.productstartdate = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Delivary_Date__c; 
                    ProductWarranty.servicestartdate = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Delivary_Date__c;
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
                    
                    if(product.sigmaerpdev2__Service_Warranty_Applicable__c)
                    {
                    	ProductWarranty.servicesduration = product.sigmaerpdev2__Service_Warranty_Duration__c;
                    ProductWarranty.servicesinterval = product.sigmaerpdev2__Service_Warranty_Interval__c;
                    if(ProductWarranty.servicesinterval =='Day')
                    {
                    	sdays = 1;
                    	stotaldays = ProductWarranty.servicesduration * sdays;    
                    }
                     
                    else if(ProductWarranty.servicesinterval == 'Month')
                    {
                    	sdays = 30;
                    	stotaldays = ProductWarranty.servicesduration * sdays;
                    }
                    else if(ProductWarranty.servicesinterval == 'Year')
                    {
                    	sdays = 365;
                    	stotaldays = ProductWarranty.servicesduration * sdays;
                    }
                    var enddate = new Date(ProductWarranty.servicestartdate);
                    enddate.setDate(enddate.getDate() + stotaldays);
                    ProductWarranty.servicesenddate =  enddate.getFullYear()+ "-" +(enddate.getMonth()+1)+ "-" + enddate.getDate();
                        
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
         //alert(orderline[ind].orderLines.sigmaerpdev2__Service_Start_Date__c);
         if(orderline[ind].orderLines.sigmaerpdev2__Service_Start_Date__c ==undefined)
         {
         	Warranty.servicestartdate = orderline[ind].orderLines.sigmaerpdev2__Delivary_Date__c;
             
         }
         else
         {
         	Warranty.servicestartdate = orderline[ind].orderLines.sigmaerpdev2__Service_Start_Date__c;
		     
         }
         Warranty.servicesinterval =orderline[ind].orderLines.sigmaerpdev2__Service_Intervals__c;
     	 Warranty.servicesduration = orderline[ind].orderLines.sigmaerpdev2__Service_Duration__c;
         Warranty.servicesenddate = orderline[ind].orderLines.sigmaerpdev2__Service_End_Date__c;
         component.set('v.Warranty',Warranty);
         //alert('editdata@'+JSON.stringify(component.get('v.Warranty')));
     }
})