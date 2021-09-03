({
     handleOrderId : function(cmp, event,helper) {
        var orderId2 = event.getParam("orderId");
              if(orderId2!=undefined && JSON.stringify(orderId2)!='""')
            helper.checkDueAmmountOfOrder(cmp,event,helper,orderId2);
        // helper.checkDueAmmountOfOrder(cmp,event,helper,orderId2);
       cmp.set('v.orderId',orderId2);
        //alert('orderId'+JSON.stringify(orderId2)); 
          var packageProductWrap= cmp.get('v.packageProductWrap');
      //   alert('packageProductWrap'+JSON.stringify(packageProductWrap));
    },
    handleCompResetEvent : function(component, event, helper){
        component.set("v.soNameFromBasket", ""); 
        //component.set("v.package.sigmaerpdev2__Customer__c",);
        //alert(component.find("v.AccName").getValue("v.AccName"));
        //if(component.get("v.recordId") == '' || component.get("v.recordId") == undefined)
        //component.set("v.package.stapp__Customer__c", "");         	                  
    },
    closeErrorMsg: function(component, event, helper) {
        component.set("v.errorMessage", "");
        component.set("v.isError", false);
        component.set("v.errorPPMessage", "");
        component.set("v.isPPLineError", false); 
    },
    doInit: function (component, event, helper) {
      
        let packageProductWrap=component.get("v.packageProductWrap");
        if(packageProductWrap!=undefined && JSON.stringify(component.get("v.packageProductWrap"))!='""')
        {
          let orderId2= packageProductWrap[0].SOId;
             if(orderId2!=undefined && JSON.stringify(orderId2)!='""')
            helper.checkDueAmmountOfOrder(component,event,helper,orderId2);
        }
         
      //  alert('in');
        // alert('doinit1 isEditSOrder>>'+JSON.stringify(component.get("v.isEditSOrder")));
       // console.log('doinit1 packageProductWrap>>'+JSON.stringify(component.get("v.packageProductWrap")));
   
        //alert('doinit1 packageProductWrap>>'+JSON.stringify(component.get("v.packageProductWrap")));
      //  alert('doinit1 recordId>>'+JSON.stringify(component.get("v.recordId")));
        component.set("v.package.sigmaerpdev2__PackagedDate__c", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
   		     
        if(!component.get("v.recordId"))
        {
            component.set("v.package.sigmaerpdev2__Status__c","Ready");
        }
        
        var action = component.get("c.fetchDefaultParameters");
        action.setCallback(this, function (response) {
            var state = response.getState();
            //  alert('fetchDefaultParameters for standard order>>'+state )
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                 //  alert(data);
                if(data==false )
                {
                    component.set("v.isPackage",false);
                    var msg = "Dont have Access to Proceed Package , Please Check Inventory Status  in Custom Settings Default Parameters";
                    component.set("v.errorMsg1", msg);
                    component.set("v.isError1",true);
                    return;            
                }
                else{
                   // alert('in');
                    component.set("v.isPackage",true);
                    component.set("v.isError1",false);
                }
            }
        });
        $A.enqueueAction(action);
        
        //code added by rashmi to check order usage on 24-07-2019
        var action1 = component.get("c.SelectOrders");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            //   alert('Is standard order'+state);
            if (state === "SUCCESS") 
            {       
                //    alert('doinit2'+response.getReturnValue());
                component.set('v.isSigmaOrder',response.getReturnValue());       
            }
            //  alert('is sigma order?? '+component.get('v.isSigmaOrder'));
              // alert('isSigmaOrder...........'+component.get('v.isSigmaOrder'));
            // alert('recordId...........'+component.get('v.recordId'));
           // var pak=component.get('v.package')
         // alert('pak...........'+JSON.stringify(pak));
            //component.set("v.recordId",pak.Id)
          //   let  recordId=component.get("v.recordId");
       //// conole.log('recordId PAckage>>>>>>>>>>>>'+JSON.stringify(recordId));
            if(component.get("v.recordId")!== null && component.get("v.recordId")!== undefined)
            {
                //alert('isSigmaOrder...........'+component.get('v.isSigmaOrder'));
                if(component.get('v.isSigmaOrder')==true)
                {
                    helper.fetchPackageDataUpdate(component, event, helper, component.get("v.recordId"));
                }
                else
                {
                   // alert('order');
                    helper.fetchPackageOrdDataUpdate(component, event, helper, component.get("v.recordId"));
                }  
            }
                 
        });
        $A.enqueueAction(action1);  
    },
    SelectedID : function(cmp, event) 
    { 
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");
        
        if(context == 'Supplier,Vendor')
        {  
            cmp.set("v.package.sigmaerpdev2__Customer__c",objectId);
        }
    },
    handleSRComponentEvent: function (component, event, helper) {
        var data = event.getParam("data");
        var flag = event.getParam("flag");
        if (flag == 'removePP') {
            var ppRemoveIdList=new Array();
            var pp = component.get("v.packageProductWrap");
            if(pp[data.index].packageLinItems!=undefined){
                for(var i=0;i<pp[data.index].packageLinItems.length;i++){
                    ppRemoveIdList.push(pp[data.index].packageLinItems[i].ppLineItemRec);
                }
            }
            pp.splice(data.index, 1);
            component.set("v.packageProductWrap", pp);
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
            var ilpliIdAllocatedQuantMap=new Object;
            component.set('v.ilpliIdAllocatedQuantMap',ilpliIdAllocatedQuantMap);
            if(ppRemoveIdList.length>0){
                helper.removePPFromDataBase(component,event,helper,ppRemoveIdList);
            }
        }
        else if (flag == 'fetchPPDataList') {
            if(component.get('v.isSigmaOrder')==true)
            {
                helper.helperFetchSOItems(component, event, helper, data.soID, data.soName, data.index);
            }
            else
            {
                helper.helperFetchOrdItems(component, event, helper, data.soID, data.soName, data.index);  
            }
        }
            else if (flag == 'fetchPPDataListBasedOnBasketBarCodeValue') {
                helper.helperFetchSOItemsOnBasketBarcodeValue(component, event, helper, data.basketBarCodeValue, data.index,data.soID, data.soName);
            }
                else if (flag == 'fetchPPDataListBasedOnBasket') {
                    helper.helperFetchSOItemsOnBasket(component, event, helper, data.basketId, data.basketName, data.index);
                }
        /*else if (flag == 'autoPickFlag'){
            var productIdAvailableQuantMap=component.get('v.productIdAvailableQuantMap');
            var productIdRemainILPLIMap=component.get('v.productIdRemainILPLIMap');
            //alert(JSON.stringify(productIdAvailableQuantMap));
            if(productIdAvailableQuantMap[data.prodId]==undefined)
            {
                productIdAvailableQuantMap[data.prodId]=data.availQuant;
                productIdRemainILPLIMap[data.prodId]=data.tempILPLIData;
            }
            //for (var key in productIdAvailableQuantMap){
                //alert(key);
            //}
            component.set('v.productIdAvailableQuantMap',productIdAvailableQuantMap);
            component.set('v.productIdRemainILPLIMap',productIdRemainILPLIMap);
            //alert('last '+JSON.stringify(component.get('v.productIdAvailableQuantMap')));
        }*/
    },
    cancelPackage: function (component, event, helper) {
       // alert('cancelPackage');
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Package__c"
        });
        homeEvent.fire();*/
        
        //commented above line and added below line on 6-2-2020 to show in SalesOrderModules UI page after cancel button is pressed	    
       // window.history.back();
         var packageProductWrap= component.get('v.packageProductWrap');
         console.log('packageProductWrap>>>>'+JSON.stringify(packageProductWrap));
        
         var orderId= component.get('v.orderId');
         console.log('orderId>>>>'+JSON.stringify(orderId));
         console.log('orderId>>>>'+orderId);
        if(JSON.stringify(orderId)!='undefined' && orderId!=undefined)
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
      
        // alert('packageProductWrap'+JSON.stringify(packageProductWrap));
        //alert('orderId'+JSON.stringify(orderId));
       // alert('objectFound'+JSON.stringify(objectFound));
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:SalesOrderModules",
            componentAttributes: {
                from : 'PKG'
            }
        });
        evt.fire();
         $A.get('e.force:refreshView').fire();
        //component.set("v.showModules", true);        
         //  		component.set("v.showPackage", true);
         //  		component.set("v.showIcons", false); 
        //ends here
        
        
        
        
       // window.history.back();
        /* var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/sigmaerpdev2__PackageAndShipmentPage"
        });        
        urlEvent.fire();  */  
        /*  var event = $A.get("e.force:navigateToComponent");
        event.setParams({
            componentDef : "c:PackageAndShipmentPage",
            componentAttributes: {
                //from : 'SigmaOrder'
            }
        });
         event.fire();*/
    },
    handleStatusChange:function(component,event,helper){
       // alert('package'+JSON.stringify(component.get("v.package")));
        
        if(component.get("v.package.sigmaerpdev2__Status__c")!=undefined)
        {
            
            var packageProductWrap=component.get("v.packageProductWrap");
        if(component.get("v.package.sigmaerpdev2__Status__c")==='Ready' || component.get("v.package.sigmaerpdev2__Status__c") ==='In Progress'){
            for(var i=0;i<packageProductWrap.length;i++){
                for(var j=0;j<packageProductWrap[i].packageLinItems.length;j++){
                    //alert(packageProductWrap[i].packageLinItems[j].StockSelectedAs);
                    //alert(JSON.stringify(packageProductWrap[i].packageLinItems[j].ppLineItemRec.stapp__Status__c));
                    if(!(packageProductWrap[i].packageLinItems[j].ppLineItemRec.Id!=null && packageProductWrap[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Status__c=='Ready') && !packageProductWrap[i].packageLinItems[j].StockSelectedAs && packageProductWrap[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Status__c!=undefined)
                        packageProductWrap[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Status__c=component.get("v.package.sigmaerpdev2__Status__c");
                    //alert(JSON.stringify(packageProductWrap[i].packageLinItems[j].stapp__Status__c));
                }
            }
            component.set("v.packageProductWrap",packageProductWrap);
        }
        }
    },
    saveData: function (component, event, helper) {
        
        var buttton = event.getSource().getLocalId();
      //alert('buttton>>' +buttton);
        //return;
        var pck=component.get("v.package");
        
        component.set("v.isError", false);
        component.set("v.isPPLineError", false);
        
        if(!pck.sigmaerpdev2__Customer__c || !pck.sigmaerpdev2__PackagedDate__c){
            component.set("v.errorMessage", "Please Fill All the Required fields.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(pck.sigmaerpdev2__Status__c=='Un-Package' && (component.get('v.oldStatus')=='Delivered' || component.get('v.oldStatus')=='In Shipment')){
            component.set("v.errorMessage", "'In Shipment' or 'Delivered' Packages cant be Un-Package.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        var pp = component.get("v.packageProductWrap");
       // alert('pp>>>>>>>>>>>>>>>>'+JSON.stringify(pp));
        //saveData 
        if(pp.length>0){
            for(var i=0;i<pp.length;i++){
               // var OQty=pp[i].orderedQuantity;
                /*if(pp[i].SOId==='' || pp[i].SOId==undefined){
                    component.set("v.errorPPMessage", "Atleast One Line Item is Required.");
                    component.set("v.isPPLineError", true);
                    window.scrollTo(0, document.getElementById("LineItemErrorDiv").offsetTop);
                    return;
                }*/
                if(pp[i].packageLinItems.length==0){
                    component.set("v.errorPPMessage", "Atleast One Line Item is Required.");
                    component.set("v.isPPLineError", true);
                    window.scrollTo(0, document.getElementById("LineItemErrorDiv").offsetTop);
                    return;
                }
                for(var j=0;j<pp[i].packageLinItems.length;j++){
                     var OQty=pp[i].packageLinItems[j].orderedQuantity;
                    var packQty=pp[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Quantity__c;
                    // alert(pp[i].packageLinItems[j].isSerialCodeMandatory);
                    //alert(JSON.stringify(pp[i].packageLinItems[j].solData));
                    if(pp[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Quantity__c==='' || pp[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Quantity__c ==undefined ||
                       pp[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Status__c ==='' || pp[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Status__c == undefined){ 
                        component.set("v.errorPPMessage", "Please Fill All the Required fields.");
                        component.set("v.isPPLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemErrorDiv").offsetTop);
                        return;
                    }
                    //alert(JSON.stringify(pp[i].packageLinItems[j].ilpliData));
                    //if(!component.get('v.configValues.stappConfigCustomSetting.stapp__Allocation_Inside_Stapp_Order__c') && pp[i].packageLinItems[j].ppLineItemRec.stapp__Status__c=='Ready' 
                    //   && !pp[i].packageLinItems[j].ppLineItemRec.stapp__IsInventoryUpdated__c && !component.get("v.autoAllocFlag") && pp[i].packageLinItems[j].ilpliData==undefined)
                    // {
                    // component.set("v.errorPPMessage", "Stock Should be selected for the Ready Package Products.");
                    // component.set("v.isPPLineError", true);
                    //   window.scrollTo(0, document.getElementById("LineItemErrorDiv").offsetTop);
                    //   return;
                    //  }
                    if(pp[i].packageLinItems[j].ppLineItemRec.sigmaerpdev2__Status__c ==='In Progress' && pck.sigmaerpdev2__Status__c=='Ready')
                    {
                        component.set("v.errorPPMessage", "To make Package Ready, All the Lines should be ready.");
                        component.set("v.isPPLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemErrorDiv").offsetTop);
                        return;
                    }
                    //   if(pp[i].packageLinItems[j].isSerialCodeMandatory && !pp[i].packageLinItems[j].ppLineItemRec.stapp__Serial_Code__c && component.get('v.configValues.StappObjectConfiguration.stapp__PP_Serial_Code__c')==true)
                    //   {
                    //     component.set("v.errorPPMessage", "Serial code is needed for the product '"+ pp[i].packageLinItems[j].productName+"'");
                    //    component.set("v.isPPLineError", true);
                    //     window.scrollTo(0, document.getElementById("LineItemErrorDiv").offsetTop);
                    //     return;
                    //  }
                    if(component.get('v.oldStatus')=='In Progress' && pck.sigmaerpdev2__Status__c=='Ready' && pp[i].packageLinItems[i].orderedQuantity==0){
                        component.set("v.errorPPMessage", "This Order is already packaged");
                        component.set("v.isPPLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemErrorDiv").offsetTop);
                        return;
                    }
                    //alert('OQty'+OQty);
                    // alert('packQty'+packQty);
                    
                    if(OQty!=packQty)
                    {
                       // alert('OQty inside if'+OQty);
                        component.set("v.errorPPMessage", " PACKAGED QUANTITY should be equal to ORDERED QUANTITY ");
                        component.set("v.isPPLineError", true);
                        window.scrollTo(0, document.getElementById("LineItemErrorDiv").offsetTop);
                        return;
                        
                    }
                }
            }
        }
        else
        {
            component.set("v.errorMessage", "Atleast One Line Item is Required.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        
        var spinner=component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
         console.log('buttton>>>'+buttton);
             console.log('isSigmaOrder>>>'+component.get('v.isSigmaOrder'));
        if(buttton=='ProceedToShipment')
        {
             console.log('buttton>>>'+buttton);
             console.log('isSigmaOrder>>>'+component.get('v.isSigmaOrder'));
            // alert(component.get('v.isSigmaOrder'));
            if(component.get('v.isSigmaOrder')==true)
            {
                
                helper.saveDataHelper(component, event, helper,event.getSource().getLocalId());
            }
            else
            {
                helper.saveOrdDataHelper(component, event, helper,event.getSource().getLocalId());
            }	
        }
        else if(buttton=='saveAndDeliveryNote'){
            helper.savePackAndDeliveryNote(component, event, helper,event.getSource().getLocalId());
        }
            else{
                if(component.get('v.isSigmaOrder')==true)
                {
                    helper.saveDataHelper(component, event, helper,event.getSource().getLocalId());
                }
                else
                {
                    helper.saveOrdDataHelper(component, event, helper,event.getSource().getLocalId());
                }
            }
    },
})