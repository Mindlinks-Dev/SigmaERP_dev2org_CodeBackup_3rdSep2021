({
    NoPackageShipment : function(cmp,event,helper)
    { 
        var nopickpackshipment=cmp.get("v.nopickpackshipment");
        var noPackShip=document.getElementById("noPackShip").checked;
        if( document.getElementById("noPackShip").checked==false)
        {
            cmp.set("v.nopickpackshipment",false);
        }
        if( document.getElementById("noPackShip").checked==true)
        {
            cmp.set("v.nopickpackshipment",true);
        }
    },
    doInit : function(component, event, helper) {
     var today = new Date();
            var month = today.getMonth() + 1;
            if(month >= 10){
                month = '';                    	       
            }else{
                month = 0;
            }
            var myDate = today.getDate();
            if(myDate >= 10){
                myDate = '';                    	       
            }else{
                myDate = 0;
            }        
            component.set('v.standOrder.sigmaerpdev2__Delivary_Date__c', today.getFullYear() + "-"+month + (today.getMonth() + 1) + "-"+myDate + today.getDate());            
           
         var recId = component.get("v.recordId")
         helper.fetchConfigDefaultValues(component,event,helper);
         if (recId) {
            helper.getStandOrderDataForEdit(component, event, helper, recId);
        }
         
		 
      },
	 
    cancelStandOrder: function (component, event, helper) {
      //  window.location.href = "/lightning/n/sigmaerpdev2__Orders_Stand"
       // window.history.back();
	   var recId = component.get("v.recordId")
        if(recId != undefined)      
        	window.history.back();
        else
			window.location.reload(); 
    
    },
	
	getAccountData: function (component, event, helper) {
       // alert('value::'+component.get("v.standOrder.AccountId"));
       // alert('record'+component.get("v.recordName"));
        if (!component.get("v.recordName"))
        {
            //alert('false');
            helper.removeAccRelData(component, event, helper);
        }
        if (component.get("v.recordName"))
        {
              //alert('Inside true');
              helper.helperGetAccountData(component,event,helper,component.get("v.standOrder.AccountId"));
        }
    },
    
	 handleAccountIdUpdate : function(cmp, event, helper) {
      //  alert('event2');
        var accountId = event.getParam("sObjectId");
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        if (instanceId === "Supplier,Vendor")
        {
            cmp.set('v.standOrder.AccountId', accountId);
              if (!cmp.get("v.standOrder.AccountId")) 
              {
                 
            	helper.removeAccRelData(cmp, event, helper);
        	  } 
            /*else if (!component.get("v.standOrder.stapp__Shipping_Country__c")) {
            //console.log('account changed');
            var tempRec = component.find("recordLoader");
            tempRec.set("v.recordId", component.get("v.stappOrder.stapp__Account__c"));
            tempRec.reloadRecord();
        }*/
        if (cmp.get("v.standOrder.AccountId"))
        {
          //  alert('inside if>>');
            helper.helperGetAccountDataobject(cmp,event,helper,cmp.get("v.standOrder.AccountId"));

        }
        }
        if(instanceId === "MyContact")
            {
                cmp.set('v.standOrder.sigmaerpdev2__BillingPersonNew__c', accountId);
                //cmp.set('v.CreatedbyName',instanceId);
            }
         
         if(instanceId === "Currency")
         {
           //  alert('Currency');
             cmp.set('v.standOrder.sigmaerpdev2__Currency__c', accountId);
             //cmp.set('v.CreatedbyName',instanceId);
         }
     },  
   
    AddOrderLine: function (component, event, helper) {
        var d = new Date();
        if(!component.get('v.standOrder.AccountId')){
            component.set("v.errorMessage", "Select the Customer Type before adding Order Lines.");
            component.set("v.isError", true);
           // window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
       /* if(!component.get('v.stappOrder.stapp__Tax_Treatment__c')){
            component.set("v.errorMessage", "Select the Tax Treatment before adding Order Lines.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }  */
        var orderLines = component.get("v.orderLinesData");
        /*var idListStr;
        
        for(var i=0;i<orderLines.length;i++)
        {
            if(i==0)
                idListStr=orderLines[i].orderLines.stapp__Product__c;
            else
                idListStr+='\',\''+orderLines[i].orderLines.stapp__Product__c;
        }
        component.set('v.idListStr',idListStr);*/
        orderLines.push({
           'hasBackOrder': false,
            'isDisabled': false,
            'isDisplay': false,
            'productName': '',
            'orderLines': {
                'sobjectType': 'OrderItem',
                'sigmaerpdev2__Net_Quantity__c':0,
                'Quantity':0,
                'sigmaerpdev2__Unit_Price__c':0,
                'sigmaerpdev2__Stock_Fulfilled__c':true,
                 'sigmaerpdev2__Warranty_Created__c':false
               
               // 'sigmaerpdev2__IsBackOrderParent__c':false,
               // 'stapp__Invoiced__c':false,
                //'stapp__Internal_Identifier__c':d.getHours()+''+d.getMinutes()+''+d.getSeconds()+''+d.getDate()
            }
        });
        component.set("v.orderLinesData", orderLines);
       // component.set('v.orderLineIdentifier',component.get('v.orderLineIdentifier')+1);
    },
    
	closeErrorMessage : function(component, event, helper){
        component.set("v.isError",false);
        component.set("v.errorMessage",'');
        component.set("v.isOrderLineError",false);
        component.set("v.errorOLMessage",'');
    },
	
	SAToggle:function (component, event, helper){
        var showSA=component.get("v.showSA");
        component.set("v.showSA",!showSA);
        
        var SATogle = component.find('SATogle');
        if(!showSA)
            $A.util.removeClass(SATogle,  'slds-hide');
        else
            $A.util.addClass(SATogle,  'slds-hide');
    },
	
    handleComponentEvent: function (component, event, helper) {
     //   alert('remove OL');
       if(event.getParam("flag") == 'Viewproductimage')
       {
           helper.viewProductHelper(component, event, helper,event.getParam("data").index);
       }
        
        else if (event.getParam("flag") == 'removeOrderLine') {
            var ind = event.getParam("data").index;
            var orderLn=component.get("v.orderLinesData");
            //var remOL=component.get("v.removedOrderLines");
            //console.log('remOL>>>'+JSON.stringify(remOL));
            //console.log('rem line>>>'+JSON.stringify(orderLn[ind].orderLines.Id));
           
            /*if(orderLn[ind].orderLines.Id!=undefined)
            {
                remOL.push(orderLn[ind].orderLines); 
                component.set("v.removedOrderLines",remOL);
            } */
            
            //console.log('removed lines>>>>'+JSON.stringify(component.get("v.removedOrderLines")));
            helper.removeOrderLinesHelper(component, event, helper, ind);
        }
        else if (event.getParam("flag") == 'backOrderLines') {
            var orderLines = component.get("v.orderLinesData");
            var ind = event.getParam("data").index;
            var available = event.getParam("data").avail;
            var source = event.getParam("data").source;
         /*   if(source==='EditFlow')
            {
                orderLines.push({
                    'hasBackOrder': false,
                    'isDisabled': true,
                    'isDisplay': true,
                    'productName': orderLines[ind].productName,
                    'orderLines': {
                        'sobjectType': 'stapp__Stapp_Order_Lines__c',
                        'stapp__Product__c': orderLines[ind].orderLines.stapp__Product__c,
                        'stapp__Quantity__c': orderLines[ind].orderLines.stapp__Quantity__c - available,
                        'stapp__Status__c': 'Pending',
                        'stapp__Back_Order__c': true,
                        'isStockItem':orderLines[ind].isStockItem,
                        'stapp__Internal_Identifier__c':orderLines[ind].orderLines.stapp__Internal_Identifier__c
                    }
                });
                orderLines[ind].orderLines.stapp__Quantity__c = available;
                orderLines[ind].orderLines.stapp__IsBackOrderParent__c = true;
                orderLines[ind].hasBackOrder = true;
                component.set("v.orderLinesData", orderLines);
            } */
            
                
                orderLines.push({
                    'hasBackOrder': false,
                    'isDisabled': true,
                    'isDisplay': true,
                    'productName': orderLines[ind].productName,
                    'orderLines': {
                        'sobjectType': 'OrderItem',
                        'Product2Id': orderLines[ind].orderLines.Product2Id,
                        'Quantity': orderLines[ind].orderLines.sigmaerpdev2__Net_Quantity__c - available,
                        'sigmaerpdev2__Order_Status__c': 'Pending',
                        'sigmaerpdev2__Back_Order__c': true,
                         'sigmaerpdev2__Stock_Fulfilled__c':false,
						'sigmaerpdev2__TotalPrice__c':((orderLines[ind].orderLines.sigmaerpdev2__Net_Quantity__c - available)*(orderLines[ind].orderLines.sigmaerpdev2__Unit_Price__c))
                       // 'isStockItem':orderLines[ind].isStockItem,
                       // 'stapp__Internal_Identifier__c':orderLines[ind].orderLines.stapp__Internal_Identifier__c
                    }
                });
                orderLines[ind].orderLines.Quantity = available;
				orderLines[ind].orderLines.sigmaerpdev2__TotalPrice__c = (available * orderLines[ind].orderLines.sigmaerpdev2__Unit_Price__c );
            	orderLines[ind].isDisabled = true; 
            //  orderLines[ind].orderLines.stapp__IsBackOrderParent__c = true;
               // orderLines[ind].hasBackOrder = true;
                component.set("v.orderLinesData", orderLines);
				component.set("v.hide", true);
				component.set("v.isbackorder", true);
            	component.set("v.isbackordercheck", true);
            
            
        }
       else if (event.getParam("flag") == 'manualSelectILPLI') {
          // alert('in');
             component.set('v.ManualSelectIndex',event.getParam("data").index);
             component.set('v.ManualSelectAttributeType',event.getParam("data").AttributeType);
             var isConfirm=confirm('Are you sure you want select Manually!');
                 if(isConfirm)
                    helper.getILPLIDataForManSelect(component, event, helper,event.getParam("data").index);
                }
         else if (event.getParam("flag") == 'autoPickILPLI') {
                        component.set('v.ManualSelectIndex',event.getParam("data").index);
                        var isConfirm=confirm('Are you sure you want select Automatically!');
                        if(isConfirm)
                            helper.getILPLIDataForAutopick(component, event, helper,event.getParam("data").index);
                    }
                        else if (event.getParam("flag") == 'splitOrderLine') {
                        var splitList=[];
                        //var backList=[];
                        component.set("v.splitIndex", event.getParam("data").index);
                        var idx=event.getParam("data").index;
                        component.set("v.openSplitModal", true);
                        
                        var sol=component.get("v.orderLinesData");
                        
                        for(var i=0;i<sol.length;i++)
                        {
                            if(sol[i].orderLines.Product2Id==sol[idx].orderLines.Product2Id && i!=idx)
                            {
                                
                                if(sol[i].orderLines.sigmaerpdev2__Splited_Order_Line__c)
                                {
                                    
                                    splitList.push({
                                        'indx':i,
                                        'qty': sol[i].orderLines.Quantity,
                                        'isConfirmed':sol[i].isConfirmedOL? true : false
                                    });
                                    //noOfSOLines.push(sol[i].orderLines.stapp__Quantity__c);
                                }
                                
                            }
                        }
                        var splitBackOrderLines= new Object();
                        splitBackOrderLines.prodName=sol[idx].productName;
                        splitBackOrderLines.parentQty=sol[idx].orderLines.Quantity;
                        splitBackOrderLines.isConfirmed=sol[idx].isConfirmedOL? true : false ;
                        splitBackOrderLines.isStockItem=sol[idx].orderLines.isStockItem;
                        splitBackOrderLines.availQty=event.getParam("data").availQty;
                        splitBackOrderLines.splitList=splitList;
                        //splitBackOrderLines.backList=backList;
                        component.set('v.splitBackOrderLines',splitBackOrderLines);
                        //alert(JSON.stringify(splitBackOrderLines));
                    }
         else if(event.getParam("flag") =='productwarranty')
        {
            //alert('in');
            var idx = event.getParam("data").index;
            if(component.get("v.orderLinesData")[idx].orderLines.sigmaerpdev2__Warranty_Created__c)
            {
                //alert('ifin');
                helper.getorderlinewarranty(component, event, helper,idx); 
            }
            else
            {
                //alert('inelse');
            	helper.getproductwarranty(component, event, helper,idx);    
            }
            
        }
    },
      
	closeSelectManualModal:function(component, event, helper){
        component.set("v.openSelectManual",false);//changed false to true by Sarah
    },
	
	selectedIPPLI:function(component, event, helper){
      //  alert(JSON.stringify(component.get("v.ilpliData")));
       // alert(JSON.stringify(component.get("v.originalILPLIData")));
        var enteredQuant=0;
        var newILPLI=[];
        var ilpliData=component.get("v.originalILPLIData");
        var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
        for(var i=0;i<ilpliData.length;i++){
            if(ilpliData[i].enteredQuant){
               // alert("1st");
                enteredQuant+=parseInt(ilpliData[i].enteredQuant);
                newILPLI.push(ilpliData[i]);
                if(ilpliIdAllocatedQuantMap[ilpliData[i].Id])
                    ilpliIdAllocatedQuantMap[ilpliData[i].Id]=(ilpliIdAllocatedQuantMap[ilpliData[i].Id]+parseInt(ilpliData[i].enteredQuant));
                else
                    ilpliIdAllocatedQuantMap[ilpliData[i].Id]=parseInt(ilpliData[i].enteredQuant);
            }
        }
        var ManualSelectIndex=component.get('v.ManualSelectIndex');
        if(component.get("v.orderLinesData")[ManualSelectIndex].orderLines.Quantity!=enteredQuant){
            alert('Sum of entered quantities should be equal to Ordered Quantity');
            return;
        }
        //var orderLinesData=component.get("v.orderLinesData");
        component.get("v.orderLinesData")[ManualSelectIndex].ilpliData=newILPLI;
        //component.get("v.orderLinesData")[ManualSelectIndex].allocatedAs='Manually';
        component.set('v.ilpliIdAllocatedQuantMap',ilpliIdAllocatedQuantMap);
       // alert("SAVERECORD:"+JSON.stringify(component.get("v.originalILPLIData")));
        
        component.set("v.openSelectManual",false);
        
        var orderLinesData=component.get('v.orderLinesData');
        orderLinesData[ManualSelectIndex].allocatedAs='Manually';
        component.set('v.orderLinesData',orderLinesData);
    },
	
	 handleStatusChange: function (component, event, helper) {
       // alert("insidehandle");
        var olRecord = component.get("v.orderLinesData");
        for (var i = 0; i < olRecord.length; i++) {
			
            if(!olRecord[i].isConfirmedOL && !olRecord[i].orderLines.sigmaerpdev2__Splited_Order_Line__c && (component.get("v.standOrder.sigmaerpdev2__Orders_Status__c")=='Pending' || component.get("v.standOrder.sigmaerpdev2__Orders_Status__c")=='Order Confirmed' ||component.get("v.standOrder.sigmaerpdev2__Orders_Status__c")=='Delivered'))
            {
               
                	olRecord[i].orderLines.sigmaerpdev2__Order_Status__c = component.get("v.standOrder.sigmaerpdev2__Orders_Status__c");
              //  alert("ans"+JSON.stringify(olRecord[i].orderLines.sigmaerpdev2__Order_Status__c));
            }
        }
        component.set("v.orderLinesData", olRecord);
    },
     handleDiscountChange: function (component, event, helper) {
       // alert(component.get("v.discount"));
        var olRecord = component.get("v.orderLinesData");
        for (var i = 0; i < olRecord.length; i++) {
            olRecord[i].orderLines.sigmaerpdev2__Discount__c = component.get("v.discount");
        var totalprice= (olRecord[i].orderLines.Quantity * olRecord[i].orderLines.sigmaerpdev2__Unit_Price__c);   
				    olRecord[i].orderLines.sigmaerpdev2__TotalPrice__c= (totalprice-(totalprice*(olRecord[i].orderLines.sigmaerpdev2__Discount__c)/100));
     
        }
        component.set("v.orderLinesData", olRecord);
    },
	
	 handleAutoSelectCheckBox:function(component, event, helper){
    //     alert('Inside Auto Select');
        var checkBoxValue=component.find('checkbox').get('v.value');
        var tempILPLIData=component.get("v.originalILPLIData");
        //alert(component.find("orderedQuant").get('v.value'));
        var tempQaunt=component.find("orderedQuant").get('v.value');
        for(var i=0;i<tempILPLIData.length;i++){
            if(checkBoxValue){
                if(tempQaunt>=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c && tempQaunt!=0){
                    tempILPLIData[i].enteredQuant=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c;
                    tempQaunt-=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c;
                }
                else if(tempQaunt!=0){
                    tempILPLIData[i].enteredQuant=tempQaunt;
                    tempQaunt-=tempQaunt;
                }
            }
            else{
                tempILPLIData[i].enteredQuant=0;
            }
        }
        component.set("v.originalILPLIData",tempILPLIData);
    },
	
	 saveData: function (component, event, helper) 
    {
       
     //   alert('updateing order records');
        var nopickpackshipment=component.get("v.nopickpackshipment");
        component.set("v.standOrder.sigmaerpdev2__No_Picking_Package_Shipment_Required__c",nopickpackshipment);
		
        var so=component.get("v.standOrder");
      // 	alert('stdandard order>>'+JSON.stringify(component.get("v.standOrder")));
        
        /*if(!(so.Id && !component.get('v.stappOrderIdForClone'))){
            
            so.Id=undefined;
            //component.set("v.standOrder",so);
        }*/
        var olData = component.get("v.orderLinesData");
      //  alert('olData'+JSON.stringify(olData));
      //  alert('length'+olData.length);
        for (var i = 0; i < olData.length; i++) {
            if(!(olData[i].orderLines.Id )){
                olData[i].orderLines.Id=undefined;
            }
        }
       // var soc=component.get("v.defaultConfigValues.StappObjectConfiguration");
        //alert(soc.stapp__SO_Order_Source__c);
      
        var validationFlag = false;
        component.set("v.isError", false);
        component.set("v.isOrderLineError", false);
        var allValid = component.find('fields').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (!allValid) {
            component.set("v.errorMessage", "Review All the Errors!.");
            component.set("v.isError", true);
        } else {
               switch (true) {
                case (!so.AccountId):
                    component.set("v.errorMessage", "Select the Customer.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break;
              /*  case (!so.stapp__Customer_Type__c):
                    component.set("v.errorMessage", "Select the Customer Type.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break; */
                case (!so.sigmaerpdev2__Orders_Status__c):
                    component.set("v.errorMessage", "Select the Status.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break;
                case (so.sigmaerpdev2__Orders_Status__c=='Cancelled' && !component.get('v.recordId')):
                    component.set("v.errorMessage", "'Cancelled' Status is not selectable in new flow.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break;
               /* case (soc.stapp__SO_Due_Date__c && !so.stapp__Due_Date__c):
                    component.set("v.errorMessage", "Select the Due Date.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break; */
               /* case (!so.stapp__Price_Book__c):
                    component.set("v.errorMessage", "Select the Price Book.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break;
                case (soc.stapp__SO_Tax_Treatment__c && (so.stapp__Tax_Treatment__c === '' || so.stapp__Tax_Treatment__c == undefined)):
                    component.set("v.errorMessage", "Select the Tax Treatment.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break; 
                case ((so.sigmaerpdev2__Billing_Contact__c === '' || so.sigmaerpdev2__Billing_Contact__c == undefined)):
                    component.set("v.errorMessage", "Select the Contact.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break; */
               /* case (so.stapp__Shipping_Country__c === '' || so.stapp__Shipping_Country__c == undefined):
                    component.set("v.errorMessage", "Select the Shipping Country.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    break; */
                default:
                    validationFlag = true;
                    
                }
		}
            if (validationFlag) 
			{
                var totalOrderAmount=0;
                var totalorderlineamount=0;
               // var totalTaxRate=0;
                var olData = component.get("v.orderLinesData");
               // var olData = component.get("v.orderLinesData");
                if(olData.length<1)
                {
                    component.set("v.errorMessage", "Please add Orderline before saving.");
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    return; 
                }
                for (var i = 0; i < olData.length; i++) {
                    if(olData[i].orderLines.sigmaerpdev2__Unit_Price__c == 0)
                    {
                       component.set("v.errorOLMessage", "Add Product Price in Product Price book for line item"+(i+1));
                       component.set("v.isOrderLineError", true);
                       window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                       return; 
                    }
                    
                    totalorderlineamount+=olData[i].orderLines.sigmaerpdev2__TotalPrice__c; 
					if(Number.isNaN(olData[i].orderLines.sigmaerpdev2__Total_Price__c)){
						component.set("v.errorOLMessage", "Add Selling Price to the product");
                        component.set("v.isOrderLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                        return;
                    }
                    if (!(olData[i].orderLines.Product2Id && olData[i].orderLines.sigmaerpdev2__Delivery_Date__c && olData[i].orderLines.sigmaerpdev2__Order_Status__c)) {
                        component.set("v.errorOLMessage", "Please fill all the required fields at line "+(i+1));
                        component.set("v.isOrderLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                        return;
                    }
					/*
                    if (!olData[i].orderLines.stapp__Tax_Code__c && !olData[i].orderLines.stapp__Back_Order__c && !olData[i].orderLines.stapp__Splited_Order_Line__c && component.get("v.stappOrder.stapp__Order_Types__c")!='Engineer Stock Transfer')
                    {
                        component.set("v.errorOLMessage", "Please fill all the required fields "+(i+1));
                        component.set("v.isOrderLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                        return;
                    }*/
                //  if(!(component.get("v.isbackorder")))
                //  { 
                    if(!olData[i].isConfirmedOL && (!olData[i].orderLines.Quantity || olData[i].orderLines.Quantity<=0) && (olData[i+1] == undefined || !olData[i+1].orderLines.sigmaerpdev2__Back_Order__c)){
                        component.set("v.errorOLMessage", "Please Enter a Valid Quantity at the Line "+(i+1));
                        component.set("v.isOrderLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                        return;
                    }
                      /*
                      if(!olData[i].isConfirmedOL && (!olData[i].orderLines.Quantity || olData[i].orderLines.Quantity<=0 ||((olData[i].orderLines.Quantity) % 1)!=0 )  &&  !olData[i].orderLines.sigmaerpdev2__Back_Order__c)
                      {
                        component.set("v.errorOLMessage", "Decimal Values are not allowed,Please Enter a valid Quantity at the line "+(i+1));
                        component.set("v.isOrderLineError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                      } */
                 // }
                    
               /*  if((component.get("v.isbackorder")))
                  {
                   if(!olData[i].isConfirmedOL && (!olData[i].orderLines.sigmaerpdev2__Net_Quantity__c || olData[i].orderLines.sigmaerpdev2__Net_Quantity__c<=0 || (olData[i].orderLines.sigmaerpdev2__Net_Quantity__c ) % 1!= 0 ) && component.get('v.recordId')==undefined){
                        
                       component.set("v.errorOLMessage", "Please Enter a valid Quantity at the line "+(i+1));
                        component.set("v.isOrderLineError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                    }
                  }*/
                     if((olData[i].orderLines.sigmaerpdev2__Order_Status__c==='Order Confirmed') && (component.get("v.standOrder.sigmaerpdev2__Orders_Status__c") =='Pending')){
                       
                        component.set("v.errorOLMessage", "To Confirm the Order Line,Order status field should also be Confirmed.");
                        component.set("v.isOrderLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                        return;
                    }
                    //code added  to handle backOrderLines alloate 

                 //   alert('allocate>>'+JSON.stringify(component.get('v.defualtallocate')));
                 //   alert('isbackorder>>'+JSON.stringify(component.get('v.isbackorder')));
                    if(component.get('v.defaultConfigValues') && component.get('v.defualtallocate')!='Allocated' && component.get('v.isbackorder'))
                    {
                     //   alert('inside 1 if');
                         
                        if(olData[i].orderLines.Quantity>0 && (olData[i].ilpliData==undefined || olData[i].ilpliData==='') && component.get('v.isbackorder')!=true){
                        //    alert('Inside 2nd if')
                            component.set("v.errorOLMessage", "Allocation is not done at Order Line "+(i+1));
                            component.set("v.isOrderLineError", true);
                            window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                            return;
                        }
                        if(olData[i].orderLines.Quantity>0 && olData[i].isConfirmedOL!=true &&  component.get('v.isbackorder')!=true){
                         //   alert('Inside 3nd if'+ v.isbackorder);
                            var allocatedQty=0;
                            for(var p=0;p<olData[i].ilpliData.length;p++){
                                allocatedQty+=parseInt(olData[i].ilpliData[p].enteredQuant);
                            }
                          //   alert('allocatedQty>>'+allocatedQty)
                            if(allocatedQty!=olData[i].orderLines.Quantity)
                            {
                                component.set("v.errorOLMessage", "Allocated quantity and ordered quantity are not matching at the order line "+(i+1));
                                component.set("v.isOrderLineError", true);
                                window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                                return;
                            }
                        }
					}
					//code added to restrict duplicate products adding in OrderLines on 11-10-2019
					if(olData.length >1)
					{
						for(var j=i+1;j<olData.length;j++)
						{
							if(olData[i].orderLines.Product2Id == olData[j].orderLines.Product2Id && !olData[j].orderLines.sigmaerpdev2__Back_Order__c && component.get("v.recordId") == undefined && !olData[j].orderLines.sigmaerpdev2__Splited_Order_Line__c )
							{
						      component.set("v.errorOLMessage", "Can not add same product multiple times");
                              component.set("v.isOrderLineError", true);
                              window.scrollTo(0, document.getElementById("LineItemsErrorDiv").offsetTop);
                              return;
							  	
							}
						}
					}
					
                   // alert('backorder>>'+ olData[i].orderLines.sigmaerpdev2__Back_Order__c);
                    if(!olData[i].orderLines.sigmaerpdev2__Back_Order__c ){
                        var totalOrderLineAmount=0;
                        if(olData[i].orderLines.sigmaerpdev2__Discount__c){
                            
                                totalOrderLineAmount=(olData[i].orderLines.sigmaerpdev2__Unit_Price__c-olData[i].orderLines.sigmaerpdev2__Discount__c )* olData[i].orderLines.sigmaerpdev2__Net_Quantity__c;
                            }
                           
                        }
                        
                        totalOrderAmount+=totalOrderLineAmount;
                       // totalTaxRate+=parseInt(olData[i].taxRate);
                    }
                 
                }
              
                if(so.sigmaerpdev2__Orders_Status__c=='Order Confirmed' && so.sigmaerpdev2__Customer_Type__c==='Credit Customer' && (component.get("v.accRelatedData.dueAmount")+totalorderlineamount>component.get("v.accRelatedData.creditLimit"))&& component.get('v.recordId')==undefined)
                {
                   //alert('Inside 2n check');
                    if(component.get("v.standOrder.sigmaerpdev2__Stopped_Order__c")==undefined){
                       // alert('Inside 2n check');
                        component.set("v.standOrder.sigmaerpdev2__Stopped_Order__c",true);
                        so.sigmaerpdev2__Stopped_Order__c=true;
                    }
                }  
        		//alert('Inside 2n check>>.');
        		//alert('Inside 1.'+JSON.stringify(component.get("v.accRelatedData.dueAmount")));
               // alert('Inside 2.'+JSON.stringify(component.get("v.accRelatedData.creditLimit")));
                //alert('Inside 3.'+totalorderlineamount);
                if(so.sigmaerpdev2__Orders_Status__c=='Order Confirmed' && so.sigmaerpdev2__Customer_Type__c==='Credit Customer'  && (component.get("v.accRelatedData.dueAmount")+totalorderlineamount>component.get("v.accRelatedData.creditLimit"))&& component.get('v.recordId')==undefined)
                {
                  //  alert('credit limit'+ JSON.stringify(component.get("v.accRelatedData.dueAmount")+totalorderlineamount>component.get("v.accRelatedData.creditLimit")));
                    var creditLimitConfirm=confirm('This Customer Exceeded the credit limit. Do you want to continue?');
                    if(creditLimitConfirm){
                        if(so.sigmaerpdev2__Stopped_Order__c && so.sigmaerpdev2__Orders_Status__c==='Order Confirmed')
                        {
                            component.set("v.errorMessage", "This Customer Exceeded the credit limit, So cant make 'Confirmed' Order. You can save the Order by 'Uncheck' the 'StoppedOrder' Checkbox.");
                            component.set("v.isError", true);
                            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return;
                        }
                    }
                    else
                        return;
                } 
        	//	alert('Inside 123');
                var spinner=component.find('spinner');
        		$A.util.toggleClass(spinner, 'slds-hide');
        	//	alert('Inside 444');
        		var skipAllocationProcess = component.get("v.autoAllocFlag"); 
        	//	alert('alloca'+skipAllocationProcess);
                if(skipAllocationProcess == false){
                   
                    helper.saveDataHelper(component, event, helper,so,olData);
                }else{
                    helper.automateStockResv(component, event, helper);
                }
        // helper.saveDataHelper(component, event, helper,so,olData);
	},
	
	stoppedOrderValueChange: function(component, event, helper){
        component.set('v.standOrder.sigmaerpdev2__Stopped_Order__c',false);
    },
    addSplitOrderLines:function(component, event, helper){
        var splitBackOrderLines=component.get('v.splitBackOrderLines');
        splitBackOrderLines.splitList.push({
            'qty': 0,
        });
        component.set('v.splitBackOrderLines',splitBackOrderLines);
    },
    splitOrderLine: function (component, event, helper) {
        var ind = component.get("v.splitIndex");
        var orderLinesData = component.get("v.orderLinesData");
        var splitBackOrderLines=component.get('v.splitBackOrderLines');
        var totalOrderedQty=0;
        //var tempIndex=ind+1;
        var tempTotalOrderedQtyForValidation=0;
        for(var i=0;i<splitBackOrderLines.splitList.length;i++)
        {
            if(typeof splitBackOrderLines.splitList[i].qty==="string")
                splitBackOrderLines.splitList[i].qty=parseInt(splitBackOrderLines.splitList[i].qty);
            if(splitBackOrderLines.splitList[i].qty <=0){
                alert('Negative or Zero Values not Allowed.');
                return;
            }
            if(splitBackOrderLines.splitList[i].qty && !splitBackOrderLines.splitList[i].isConfirmed)
            {
                tempTotalOrderedQtyForValidation+=splitBackOrderLines.splitList[i].qty;
            }
        }
      
        if(parseInt(splitBackOrderLines.parentQty)<0 || (typeof splitBackOrderLines.parentQty=='string' && splitBackOrderLines.parentQty==''))
        {
            alert('Negative or null Values not Allowed.');
            return;
        }
        if(parseInt(splitBackOrderLines.parentQty)>splitBackOrderLines.availQty && !splitBackOrderLines.isConfirmed && splitBackOrderLines.isStockItem)
        {
            alert('Parent Qty should not exceed \'Available Qty\'');
            return;
        }
        /*if(tempTotalOrderedQtyForValidation>parseInt(splitBackOrderLines.parentQty))
        {
            alert('Sum of all Split Qty should not exceed \'Parent Qty\'');
            return;
        }*/
        if(parseInt(splitBackOrderLines.parentQty)+tempTotalOrderedQtyForValidation>splitBackOrderLines.availQty && !splitBackOrderLines.isConfirmed)
        {
            alert('Sum of Split Qtys and Parent Qty should not exceed \'Available Qty\'');
            return;
        }
        else if(tempTotalOrderedQtyForValidation>splitBackOrderLines.availQty && splitBackOrderLines.isConfirmed && splitBackOrderLines.isStockItem)
        {
            alert('Sum of Split Qtys should not exceed \'Available Qty\'');
            return;
        }
        for(var i=0;i<splitBackOrderLines.splitList.length;i++)
        {
            //alert(typeof splitBackOrderLines.splitList[i].qty);
            if(typeof splitBackOrderLines.splitList[i].qty==="string")
                splitBackOrderLines.splitList[i].qty=parseInt(splitBackOrderLines.splitList[i].qty);
            if(splitBackOrderLines.splitList[i].qty)
            {
                if(splitBackOrderLines.splitList[i].indx){
                    orderLinesData[splitBackOrderLines.splitList[i].indx].orderLines.sigmaerpdev2__Net_Quantity__c=splitBackOrderLines.splitList[i].qty;
                }
                else
                {
                    
                    orderLinesData.push({
                        'hasBackOrder': false,
                        'isDisabled': true,
                        'isDisplay': true,
                        'productName': orderLinesData[ind].productName,
                        //'productPrices':orderLinesData[ind].productPrices,
                        'orderLines': {
                            'sobjectType': 'OrderItem',
                            'Product2Id': orderLinesData[ind].orderLines.Product2Id,
                            'Quantity': splitBackOrderLines.splitList[i].qty,
                            'sigmaerpdev2__Order_Status__c': 'Pending',
                            'sigmaerpdev2__Splited_Order_Line__c': true,
                            'sigmaerpdev2__Stock_Fulfilled__c':true,
                            'sigmaerpdev2__TotalPrice__c':splitBackOrderLines.splitList[i].qty*orderLinesData[ind].orderLines.sigmaerpdev2__Unit_Price__c,
                           // 'isStockItem':orderLinesData[ind].orderLines.isStockItem,
                            //'stapp__Internal_Identifier__c':orderLinesData[ind].orderLines.stapp__Internal_Identifier__c
                        }
                    });
                }
                //alert('#774'+JSON.stringify(removed));
                totalOrderedQty+=splitBackOrderLines.splitList[i].qty;
                //tempIndex++;
            }
        }
       
        //alert(typeof totalOrderedQty);
        orderLinesData[ind].orderLines.Quantity = parseInt(splitBackOrderLines.parentQty);
        orderLinesData[ind].orderLines.sigmaerpdev2__Net_Quantity__c = totalOrderedQty+parseInt(splitBackOrderLines.parentQty);
        if(orderLinesData[ind].orderLines.sigmaerpdev2__Discount__c !=null)
        {
            var totalprice=(orderLinesData[ind].orderLines.Quantity * orderLinesData[ind].orderLines.sigmaerpdev2__Unit_Price__c);
        	orderLinesData[ind].orderLines.sigmaerpdev2__TotalPrice__c = (totalprice-(totalprice*(orderLinesData[ind].orderLines.sigmaerpdev2__Discount__c/100)));
       
        }
        else
        {
            orderLinesData[ind].orderLines.sigmaerpdev2__TotalPrice__c =orderLinesData[ind].orderLines.Quantity * orderLinesData[ind].orderLines.sigmaerpdev2__Unit_Price__c;
        }
           
          //orderLinesData[ind].isDisabled = true;
        if(splitBackOrderLines.splitList.length>0){
        
            orderLinesData[ind].isDisabled = true;
        }
       
        component.set("v.orderLinesData", orderLinesData);
        component.set("v.openSplitModal", false);
        //helper.netGrossCalculation(component, event, helper);
    },
     closeSplitModal: function (component, event, helper) {
        component.set('v.openSplitModal', false);
         component.set('v.showwarranty', false);
    },
    clearcurrency: function (component, event, helper)
    {
         if(component.get('v.currencyname') == '')
         component.set('v.standOrder.sigmaerpdev2__Currency__c','');  
    },
     handleserviceenddate:function(component, event, helper){
		var ServiceWarranty = component.get("v.Warranty");
        //alert('ServiceWarranty@@'+JSON.stringify(ServiceWarranty));
        var days;		
		var totaldays;
        if(ServiceWarranty.servicesinterval == 'Day')
        {
            days = 1;
            totaldays = ServiceWarranty.servicesduration * days; 
        }
        else if(ServiceWarranty.servicesinterval == 'Month')
        {
            days = 30;
            totaldays = ServiceWarranty.servicesduration * days;
        }
        else if(ServiceWarranty.servicesinterval == 'Year')
        {
            days = 365;
            totaldays = ServiceWarranty.servicesduration * days;
        }
		var enddate = new Date(ServiceWarranty.servicestartdate);
		enddate.setDate(enddate.getDate() + totaldays);
		ServiceWarranty.servicesenddate =  enddate.getFullYear()+ "-" +(enddate.getMonth()+1)+ "-" + enddate.getDate();
		component.set('v.Warranty',ServiceWarranty);
	},
     handleenddate:function(component, event, helper){
		var ProductWarranty = component.get("v.Warranty");
        //alert('ProductWarranty@@'+JSON.stringify(ProductWarranty));
        var days;		
		var totaldays;
        if(ProductWarranty.productinterval == 'Day')
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
		component.set('v.Warranty',ProductWarranty);

    },
    Savewarranty: function (component, event, helper) {
     var warranty = component.get("v.Warranty");
     var ind = warranty.index;
     var orderLinesData = component.get("v.orderLinesData");
     orderLinesData[ind].orderLines.sigmaerpdev2__Product_Warranty_Start_Date__c = warranty.productstartdate ;
     orderLinesData[ind].orderLines.sigmaerpdev2__Product_Duration__c = warranty.productduration;
     orderLinesData[ind].orderLines.sigmaerpdev2__Product_Interval__c = warranty.productinterval;
     orderLinesData[ind].orderLines.sigmaerpdev2__Product_Warranty_End_Date__c =warranty.productenddate;
     if(warranty.servicesenddate != undefined)
     {
     orderLinesData[ind].orderLines.sigmaerpdev2__Service_Start_Date__c =warranty.servicestartdate;
     orderLinesData[ind].orderLines.sigmaerpdev2__Service_Duration__c = warranty.servicesduration;
     orderLinesData[ind].orderLines.sigmaerpdev2__Service_Interval__c = warranty.servicesinterval;
     orderLinesData[ind].orderLines.sigmaerpdev2__Service_End_Date__c = warranty.servicesenddate;
     }
     orderLinesData[ind].orderLines.sigmaerpdev2__Warranty_Created__c = true;
     component.set("v.orderLinesData", orderLinesData);
     //alert('data@@'+JSON.stringify(component.get("v.orderLinesData")));
     component.set("v.showwarranty", false);
    }
    
})