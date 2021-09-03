({
     getAccountData: function (component, event, helper) {
        if (!component.get("v.Pur_Order.sigmaerpdev2__Product_Supplier__c")) {
            helper.removeAccData(component, event, helper);
        }
         else{
             var vendorid=component.get("v.Pur_Order.sigmaerpdev2__Product_Supplier__c");
             component.set("v.vendorId",vendorid);
             helper.helperGetTaxData(component,event,helper);
         }
             
     },
     getCompanyData: function (component, event, helper) {
        if (!component.get("v.Pur_Order.sigmaerpdev2__Company__c")) {
           // alert('in controller')
            helper.removeComData(component, event, helper);
        }
     },
     doInit : function(component, event,helper) {
      // alert ('hii')
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.todayDate', today);
        component.set('v.Pur_Order.sigmaerpdev2__Order_Date__c',today);
        /* var result = new Date();
        result.setDate(result.getDate() + 30);
        var today = $A.localizationService.formatDate(result, "MMMM dd yyyy");
        alert(today);*/
        //helper.getConfigurationValues(component, event,helper);
        
        var recId = component.get("v.recordId");
       // alert('id'+component.get("v.recordId"));
        if(recId == null && recId == undefined){
         component.set('v.rec',true);   
        }
       
        if (recId != null && recId != undefined){
           // alert('20')
             
            var action2 = component.get("c.getPurchaseOrderData");
            action2.setParams({
                "PoId": recId
            });
            action2.setCallback(this, function (response){
                var state = response.getState();
                if (state === "SUCCESS"){
                   // alert('state'+state)
                    var completeWrapp = response.getReturnValue();
                    component.set("v.orderLinesData",completeWrapp.polineWrap);
                    component.set("v.isOpen",true);
                    console.log('completeWrapp.po>>>'+JSON.stringify(completeWrapp.po));
                    component.set("v.Pur_Order", completeWrapp.po);
                    if(completeWrapp.po.sigmaerpdev2__Status__c=='Submitted'){
                        component.set('v.isConfirmed',true);
                    component.set('v.Status',completeWrapp.po.sigmaerpdev2__Status__c);
                        }
                    else if(completeWrapp.po.sigmaerpdev2__Status__c=='Cancelled'){
                         component.set('v.isCancelled',true);
                    component.set('v.Status',completeWrapp.po.sigmaerpdev2__Status__c);
                    }
                    if(completeWrapp.sop==true){
                        component.set('v.issrp',true);
                    }
                    //component.set("v.Pur_Order.stapperptra__Status__c", completeWrapp.po.stapperptra__Status__c);
                    component.set("v.Pur_Order.AccountName",completeWrapp.po.sigmaerpdev2__Account__r.Name);
                    component.set("v.Pur_Order.ContactName",completeWrapp.po.sigmaerpdev2__Contact__r.Name);
                    component.set("v.Pur_Order.CompanyName",completeWrapp.po.sigmaerpdev2__Company__r.Name);
                    
					
                   //(commented) helper.getConfigurationValues(component, event,helper);
                    if(completeWrapp.po.sigmaerpdev2__Tax_Treatment__c)
                    {
                        component.set("v.Pur_Order.TaxTreatmentName",completeWrapp.po.sigmaerpdev2__Tax_Treatment__r.Name);
                        helper.taxTreatmentChangeHandler(component, event, helper);
                    }
                    //alert('completeWrapp.polineWrap>>>'+JSON.stringify(completeWrapp));
                    // component.set("v.orderLinesData.ProductName",completeWrapp.polineWrap[0].ProductName);
                    helper.getTaxDetailsHelper(component, event, helper);
                }
            });
            $A.enqueueAction(action2);
        }
      
    },
      errorHide: function(component, event, helper){
        if(component.get("v.isError"))
        {
            setTimeout(function(){
                component.set("v.isError", false);
            }, 5000);
        }
    },
	 handleChange: function(component) {
        var selected = component.get("v.tabId");
        component.find("tabs").set("v.selectedTabId", selected);
    },
     handleLookupValueselected: function (component, event, helper) {
        //alert('hii')
        if(event.getParam("objectAPIName")==='Account'){
            helper.helperGetAccountData(component,event,helper,component.get("v.Pur_Order.sigmaerpdev2__Product_Supplier__c"));
        }
        else if(event.getParam("objectAPIName")==='sigmaerpdev2__Company__c'){
           // alert('in controller')
          // component.set("v.Pur_Order.sigmaerpdev2__Tax_Treatment__c", '');
          //  component.set("v.Pur_Order.TaxTreatmentName", '');
            helper.helpergetConfigurationValues(component, event, helper);
             helper.helpergetcompanyrelatedtaxtreatment(component, event, helper);
           
        }
        else if(event.getParam("objectAPIName")==='sigmaerpdev2__Tax_Treatment__c'){
            helper.taxTreatmentChangeHandler(component, event, helper);
        }
      
    },
     addProduct: function (component, event, helper) {
         //alert('inside add product')
      // var purchaseOrderRecord = component.get("v.Pur_Order");
       // alert('inside add product'+JSON.stringify(purchaseOrderRecord))
        if(!component.get('v.Pur_Order.sigmaerpdev2__Product_Supplier__c')){
            component.set("v.errorMessage", "Select the Vendor before adding Purchase Order Product Line Item.");
            component.set("v.isError", true);
            
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
           
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Contact__c')){
            component.set("v.errorMessage", "Select the Contact before adding Purchase Order Product Line Item.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Company__c')){
            component.set("v.errorMessage", "Select the Company before adding Purchase Order Product Line Item.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
       
        
        if(!component.get('v.Pur_Order.sigmaerpdev2__Order_Date__c')){
            component.set("v.errorMessage", "Select Date before adding Purchase Order Product Line Item.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        var DateOrg=component.get('v.Pur_Order.sigmaerpdev2__Order_Date__c');
        var DueDate=component.get('v.Pur_Order.sigmaerpdev2__Expected_Date__c');
          if(DateOrg>=DueDate){
            component.set("v.errorMessage", "Due Date Must be Greater than Purchase Order Date");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Expected_Date__c')){
            component.set("v.errorMessage", "Select Due Date before adding Purchase Order Product Line Item.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Status__c')){
            component.set("v.errorMessage", "Select Status before adding Purchase Order Product Line Item.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Tax_Treatment__c') ){
            component.set("v.errorMessage", "Select Tax Treatment before adding Purchase Order Product Line Item.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        var Prord = component.get('v.Pur_Order');
       
        var poId = component.get("v.recordId");
      
        var RowItemList = component.get("v.orderLinesData");
        
        
        var taxTreatmentData=component.get('v.taxTreatmentData');
        if (poId != null && poId != undefined){
       
            RowItemList.push({'pop':{
                'sobjectType': 'sigmaerpdev2__Purchase_Order_Product__c',

                'sigmaerpdev2__Product__c':'',
                'sigmaerpdev2__Unit_Price__c':0,
                'sigmaerpdev2__Description__c':'',
                'sigmaerpdev2__Quantity__c':0,
                'sigmaerpdev2__Discount__c':0,
                'sigmaerpdev2__Tax_Amount__c':0,
                'sigmaerpdev2__Total_Buying_Price__c':0,
                 'sigmaerpdev2__Total_Amount__c':0,
                'sigmaerpdev2__Net_Amount__c':0,
                'sigmaerpdev2__Tax_Code__c': ''
            },
                              'TaxCodeName':''
            });
            
        }else{
           
            RowItemList.push({'pop':{
                'sobjectType': 'sigmaerpdev2__Purchase_Order_Product__c',
                'sigmaerpdev2__Product__c':'',
                'sigmaerpdev2__Unit_Price__c':0,
                'sigmaerpdev2__Description__c':'',
                'sigmaerpdev2__Quantity__c':0,
                'sigmaerpdev2__Discount__c':0,
                'sigmaerpdev2__Tax_Amount__c':0,
                 'sigmaerpdev2__Total_Amount__c':0,
                'sigmaerpdev2__Net_Amount__c':0,
                'sigmaerpdev2__Total_Buying_Price__c':0,
                
                'sigmaerpdev2__Tax_Code__c': ''
            },
                              'TaxCodeName': ''
            });
        }
       
       // alert('RowItemList>>>'+JSON.stringify(RowItemList))
        component.set("v.isOpen", true);
        component.set("v.orderLinesData", RowItemList);
    },
     closeErrorMessage : function(component, event, helper){
        component.set("v.isError",false);
        component.set("v.errorMessage",'');
    },
    handleComponentEvent: function (component, event, helper) {
        if (event.getParam("flag") == 'TaxFlag') {
            //alert('inside handleComponentEvent')
            helper.getTaxDetailsHelper(component, event, helper);
        }
        else if(event.getParam("flag") == 'clearLookup')
        {
            if(event.getParam("data").objectAPIName == 'sigmaerpdev2__Company__c')
            {
                component.set('v.Pur_Order.sigmaerpdev2__Tax_Treatment__c','');
                component.set('v.Pur_Order.TaxTreatmentName','');
            }
        }
    },
     onClickCancel: function (component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Purchase_Order__c"
        });
        homeEvent.fire();
        $A.get("e.force:refreshView").fire();
    },
     onClickSave: function(component, event, helper){
         
      var lineItem = component.get("v.orderLinesData");
        
         var sizeOfProductsAdded = component.get("v.orderLinesData").length;
       var Orderdate = component.get("v.Pur_Order.sigmaerpdev2__Order_Date__c");
        // alert('Orderdate>>>'+Orderdate)
        if(sizeOfProductsAdded > 0)
        { 
             for(var i=0;i<sizeOfProductsAdded-1;i++)
                {
                    for(var j=i+1;j<sizeOfProductsAdded;j++)
                    {
                     
                        if(lineItem[i].pop.sigmaerpdev2__Product__c==lineItem[j].pop.sigmaerpdev2__Product__c)
                        {
                           // alert('inside if')
                            component.set("v.errorMessage","Adding Duplicate Product at line "+(i+1));
                            component.set("v.isError",true);
                             window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return; 
                        }}}
        }
          if(sizeOfProductsAdded > 0)
         { 
              for(var i=0;i<sizeOfProductsAdded;i++)
              {
                  if(lineItem[i].pop.sigmaerpdev2__Expected_Delivery_Date__c){
                    if(Orderdate > lineItem[i].pop.sigmaerpdev2__Expected_Delivery_Date__c)
                       {
                          //alert('inside if date')
                 		//var msg4 = "Line Item Expected Delivery Date Must Be Greater Than PO Order Date."+(i+1);
                         var msg4=  "Expected Delivery Date  must be greater than Purchase Order Date at line item"+(i+1);
                            component.set("v.errorMessage", msg4);
                            component.set("v.isError",true);
                           window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return; 
                
                       }
                  }
                  else {
                      //alert('inside else if date')
                     // var msg5 = "Please Enter Line Item Expected Delivery Date at"+(i+1);
                      var msg5 ="Please Enter the Expected Delivery Date at line item "+(i+1);
                            component.set("v.errorMessage", msg5);
                            component.set("v.isError",true);
                           window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return; 
                  }
                      
              }
         }
         
        if(!component.get('v.Pur_Order.sigmaerpdev2__Product_Supplier__c')){
            component.set("v.errorMessage", "Select the Vendor.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Contact__c')){
            component.set("v.errorMessage", "Select the Contact.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Company__c')){
            component.set("v.errorMessage", "Select the Company.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        
        if(!component.get('v.Pur_Order.sigmaerpdev2__Order_Date__c')){
            component.set("v.errorMessage", "Select Date.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        
        var DateOrg=component.get('v.Pur_Order.sigmaerpdev2__Order_Date__c');
        var DueDate=component.get('v.Pur_Order.sigmaerpdev2__Expected_Date__c');
        if(DateOrg>=DueDate){
            component.set("v.errorMessage", "Due Date Must be Greater than Purchase Order Date");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Expected_Date__c')){
            component.set("v.errorMessage", "Select Due Date.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        
        /*if(component.get('v.Pur_Order.sigmaerpdev2__Order_Date__c')<component.get('v.todayDate') && !component.get('v.recordId')){
            component.set("v.errorMessage", "Purchase Order Date can not be past date.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }*/
        if(!component.get('v.Pur_Order.sigmaerpdev2__Status__c')){
            component.set("v.errorMessage", "Select Status.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        if(!component.get('v.Pur_Order.sigmaerpdev2__Tax_Treatment__c') && component.get('v.configData.stappConfg.sigmaerpdev2__Is_Stapp_Stand_alone__c')){
            component.set("v.errorMessage", "Select Tax Treatment.");
            component.set("v.isError", true);
            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
            return;
        }
        var valve=component.get("v.orderLinesData");
        for(var i=0; i< valve.length; i++)
        {
            if(valve[i].pop == null || valve[i].pop == '' || valve[i].pop == undefined){
                
                component.set("v.errorMessage", 'Please Enter Data at Line '+(i+1));
                component.set("v.isError", true);
                window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                return;
            }
            
            else{
                
                if(valve[i].pop.sigmaerpdev2__Product__c == null || valve[i].pop.sigmaerpdev2__Product__c == '' || valve[i].pop.sigmaerpdev2__Product__c == undefined)
                {
                    
                    component.set("v.errorMessage", "Select the product at Line"+(i+1));
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    return;
                }
                else if(valve[i].pop.sigmaerpdev2__Quantity__c == null || valve[i].pop.sigmaerpdev2__Quantity__c == '' || valve[i].pop.sigmaerpdev2__Quantity__c == undefined)
                {
                    component.set("v.errorMessage", 'Please Enter Quantity at Line '+(i+1));
                    component.set("v.isError", true);
                    window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                    return;
                }
                  /*  else if(!valve[i].pop.sigmaerpdev2__Price_Book__c && !component.get('v.configData.overrideUnitPrice') && !component.get('v.UsingVendorProductPrice'))
                    {
                        console.log('inside validation of price book');
                        component.set("v.errorMessage", 'Please Enter Price Book at Line '+(i+1));
                        component.set("v.isError", true);
                        window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                        return;
                    }
                        else if(valve[i].pop.sigmaerpdev2__Unit_Price__c == null || valve[i].pop.sigmaerpdev2__Unit_Price__c == '' || valve[i].pop.sigmaerpdev2__Unit_Price__c == undefined)
                        {
                            component.set("v.errorMessage", 'Please Enter Unit Price at Line '+(i+1));
                            component.set("v.isError", true);
                            window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                            return;
                        }*/
                            else if(!valve[i].pop.sigmaerpdev2__Tax_Code__c )
                            {
                                component.set("v.errorMessage", 'Please select Tax Code at line '+(i+1));
                                component.set("v.isError", true);
                                window.scrollTo(0, document.getElementById("HeaderErrorDiv").offsetTop);
                                return;
                            }
                 
                               
            }
            
        }
        
        
        
        var spinner=component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        var poli = {};
        poli.po = component.get("v.Pur_Order");
        poli.polineWrap = component.get("v.orderLinesData");
        poli.deletedList = component.get("v.deletedList");
        var polij = JSON.stringify(poli);
       
        //alert('eee'+polij);
        var action = component.get("c.savePurOrder2");
        action.setParams({
            "pdata": polij 
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('state>>>'+state)
            if (state === "SUCCESS")                
            {
               
                var returnData=response.getReturnValue();
                if(returnData.status=='SUCCESS')
                {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "The Purchase Order '"+returnData.poData.Name+"' has been saved successfully."
                    });
                    toastEvent.fire();
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "sigmaerpdev2__Purchase_Order__c"
                    });
                    homeEvent.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else
                {
                    var spinner=component.find('spinner');
                    $A.util.toggleClass(spinner, 'slds-hide');
                    alert('Something went wrong..!');
                }
            }
            else
            {
                var errors = response.getError();
                alert(JSON.stringify(errors));
                if(errors){
                    if(errors[0] && errors[0].message)
                    {
                        alert("Unknown error>>> "+errors[0].message);
                    }
                }else{
                    alert("Unknown error");
                }
                var spinner=component.find('spinner');
                $A.util.toggleClass(spinner, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
        
    },

     })