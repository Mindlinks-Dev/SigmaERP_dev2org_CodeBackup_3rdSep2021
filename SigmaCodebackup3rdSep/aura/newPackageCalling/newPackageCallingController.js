({
	doInit : function(component, event, helper) {
        //code added by sandhya,validation for checking Order Usage in custom settings
        var orderaction = component.get("c.CheckOrder");
        orderaction.setCallback(this,function(a){
        var state = a.getState();
        if(state === "SUCCESS"){
            var orderresult = a.getReturnValue();{
                if(orderresult.sigmaerpdev__Standard_object__c){
                    alert("Sigma Order is not checked in Custom Settings, Please select Sigma Order");
                         component.set("v.isOpen",false);
                            
                        
                        var backdrop1 = component.find('backdrop1');
           				 $A.util.removeClass(backdrop1, "slds-hide");
                    
                }else{
                   component.set("v.isOpen",true);
               
                }
            }
        }
            
        });
    $A.enqueueAction(orderaction);
        
        //ends here
         var sid = component.get("v.recordId");
       
         var action3 = component.get("c.validationforAllocated");
             action3.setCallback( this, function(response1) {
                var state = response1.getState();
              
                if (state === "SUCCESS") {
                    var res = response1.getReturnValue();
                    if(res.sigmaerpdev__Inventory_Status__c=='Allocated')
                    {
                        alert("Package Can not be Done For This Order.");
                         component.set("v.isOpen",false);
                            
                        
                        var backdrop1 = component.find('backdrop1');
           				 $A.util.removeClass(backdrop1, "slds-hide");
                    }
                }
                  });
            $A.enqueueAction(action3);
         //set header status to ready by default
        var inputCmp = component.find("status");
        var value = inputCmp.get("v.value");        
        if(component.get("v.id") == undefined && value == undefined){           
            inputCmp.set("v.value","Ready");
            value = inputCmp.get("v.value"); 
            //alert('value::'+value);
            component.set("v.hideAutoShipButtonInChild",value);
            component.set("v.PackSelectedStatus",value);        
            component.set("v.package.sigmaerpdev__Status__c",value);  
        }                
        //ends here

        var action = component.get("c.getPackageStatus");        
        action.setCallback(this, function(a) { 
           
         component.set("v.status", a.getReturnValue());
            //alert('stst::'+JSON.stringify(component.get("v.status", a.getReturnValue()))); 
        });
        $A.enqueueAction(action);
        
        var actionDetails = component.get("c.getorderdetails");
        actionDetails.setParams
        ({ 
            "Ids": sid            
        });
         actionDetails.setCallback( this, function(a){ 
             
               var state = a.getState();
              if (state === "SUCCESS")
                    {                
                        var sigmaOrder = a.getReturnValue(); 
                       
                        
                        if(sigmaOrder.sigmaerpdev__Order_Created_Via__c=='Time Based Inventory')
                        {
                             alert("Can not do Package for Time Base Inventory Order");      
                            component.set("v.isOpen",false);
                            var backdrop1 = component.find('backdrop1');
                            $A.util.removeClass(backdrop1, 'slds-hide');
                        }
                        else if(sigmaOrder.sigmaerpdev__Orders_Status__c=='Pending')
                        {
                            alert("Not possible to make package with order status PENDING,so please confirm the order");      
                            component.set("v.isOpen",false);
                            var backdrop1 = component.find('backdrop1');
                            $A.util.removeClass(backdrop1, 'slds-hide');   
                        }
                         else if(sigmaOrder.sigmaerpdev__Orders_Status__c=='Canceled')
                        {
                            alert("Not possible to make package with order status CANCEL");      
                            component.set("v.isOpen",false);
                            var backdrop1 = component.find('backdrop1');
                            $A.util.removeClass(backdrop1, 'slds-hide');   
                        }
                        else if(sigmaOrder.sigmaerpdev__Orders_Status__c=='Order Confirmed')
                        {
                         component.set("v.recordName",sigmaOrder.sigmaerpdev__AccountId__r.Name);
                         component.set("v.record1",sigmaOrder.Name);
                        component.set("v.package.sigmaerpdev__Customer__c",sigmaOrder.sigmaerpdev__AccountId__r.Id); //commented by chandana
                        component.set("v.customername",sigmaOrder.sigmaerpdev__AccountId__r.Name);
                       	 //component.set("v.package.sigmaerpdev__Customer__c",sigmaOrder.Name);
                        //component.set("v.status",'Ready'); 
                        //component.set("v.package.sigmaerpdev__Status__c",'Ready'); 
                        //component.set("v.PackSelectedStatus",'Ready');
                        component.set("v.isOpen",true);
                        }
                    }
                 });
       
	 $A.enqueueAction(actionDetails);
 
      var action17 = component.get("c.getpackageproddetails");
        action17.setParams
        ({ 
            "Id": sid            
        });
        action17.setCallback( this, function(res){ 
            
            
            var state = res.getState();
           
            if(state==="SUCCESS")
            {
                component.set("v.getPKPro",res.getReturnValue());
                var getPKPro=component.get("v.getPKPro");
                
                if (getPKPro.length > 0)
                { 
                  
                    alert("Package is already created for this order, Refer the related list");      
                    component.set("v.isOpen",false);
                    var backdrop1 = component.find('backdrop1');
                    $A.util.removeClass(backdrop1, 'slds-hide');
                } 
                else
                {
                    
                    component.set("v.isOpen",true);
                }
            }
         });
       
	 $A.enqueueAction(action17);   
        
        if(component.get("v.id") != undefined || component.get("v.id") == "" || component.get("v.id") == undefined){ 
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
        component.set('v.package.sigmaerpdev__PackagedDate__c', today.getFullYear() + "-"+month + (today.getMonth() + 1) + "-"+myDate + today.getDate());            
       }
       if(component.get("v.id") == undefined || component.get("v.id") == ""){
            
        	var wrap = [{
                    'transId' : '',
                    'status' : '',
                    'lineItemsList' : 
                    [
                        		
                    ]
                }]; 
            component.set("v.mainWrapperList",wrap);
        }
            
	},

    createPackage : function(component, event, helper) 
    {
        
        var tempCUstomerId = component.find("v.customer");
        var newPackage = component.get("v.package");
        
        var myOutput = component.find("outColor");
        if(newPackage.sigmaerpdev__Customer__c == ""){            
            $A.util.addClass(myOutput , "textClass");
            myOutput.set("v.value", "Select Customer"); 
            return;
        }else{
            myOutput.set("v.value", " ");
        }
        
        var inputCmp = component.find("status");
        var value = inputCmp.get("v.value");
       
        if(value == undefined || value == "--Select--"){
            inputCmp.set("v.errors", [{message:"Select Status"}]);
            return;
        }else{
            inputCmp.set("v.errors", null);
        }
        
        var inputCmp2 = component.find("packagedDate");
        var date = inputCmp2.get("v.value");
        
        if(date == ""){
            inputCmp2.set("v.errors", [{message:"Select Packaged Date"}]);
            return;
        }else{
            inputCmp2.set("v.errors", null);
        }
        
        var pkPrdLst = component.get("v.packageProducts");
        for(var i=0;i<pkPrdLst.length;i++){
            if(pkPrdLst[i].sigmaerpdev__Sigma_Order__c == ""){
                var msg = "Select Order for package Product "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
            
          
            
        }
        
        helper.createPackage(component, event, helper, newPackage);     
    },
    handleApplicationEvent : function(cmp, event) {
        var productList = event.getParam("productList");
        var old = cmp.get("v.productList");
       if(typeof productList != "undefined")
        {
            for(var i=0;i<productList.length; i++)
            {
                old.push(productList[i]);
            }
            cmp.set("v.productList",old);
        }
    },
    updatePackageProduct : function(component, event, helper)
    {   
        helper.updatePackageProductHelper(component, event, helper);
    },
     makeStatusReadOnly : function(cmp, event){
         
       cmp.find("status").set("v.disabled", false);
    },
   
    addContact : function(component, event, helper){
		if(component.get("v.mainWrapperList") == null){
        	component.find("addMoreButton").set("v.disabled", true);    
        }else{
        	var wrap = {
                    'transId' : '',
                    'status' : '',
                    'lineItemsList' : 
                    [                      		
                    ]
                }; 
            var temp = component.get("v.mainWrapperList");
            temp.push({
                wrap
            });
            component.set("v.mainWrapperList",temp);    
        }
        
       
    },
    
    handleRemoveProductItemClick : function(component, event, helper) {        
       var self = this;  // safe reference
       var index = event.target.dataset.index;
         helper.removeProductItem(component, index);        
    },
                    
    handleRemoveRow : function(cmp, event, helper) {
        
        var index = event.target.dataset.index;
        var packageProductList = cmp.get("v.packageProducts");
        packageProductList.splice(index,1);
        cmp.set("v.packageProducts", packageProductList);
       
    },
    
    SelectedID : function(cmp, event) 
    {
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");
        var pack = cmp.get("v.package");
       
        if(context == "MyAccount"){
            pack.sigmaerpdev__Customer__c = objectId;
            cmp.set("v.package.sigmaerpdev__Customer__c",objectId);
            cmp.set("v.customerId",objectId);
        }
        if(context == "MyAccount2"){
            pack.sigmaerpdev__Location__c = objectId;
            cmp.set("v.package.sigmaerpdev__Location__c",objectId);
        }
        if(context == "MyContact"){
            pack.sigmaerpdev__PackagedBy__c = objectId;
            cmp.set("v.package.sigmaerpdev__PackagedBy__c",objectId);
        }
    },
    cancelButton:function(cmp, event){
       window.history.back();
    },
    
     createShipmentByPass:function(component, event, helper)
    {
       
        var pop = component.find("newAccountSectionId1");
        $A.util.removeClass(pop, "slds-fade-in-close");
        $A.util.removeClass(pop, "slds-hide");
        $A.util.addClass(pop, "slds-fade-in-open");
        
        var popback = component.find("backGroundSectionId");
        $A.util.removeClass(popback, "slds-backdrop--close");
        $A.util.addClass(popback, "slds-backdrop--open");
    },
    
	 hidecreateShipmentByPass : function(component) {
		var pop = component.find("newAccountSectionId1");
        $A.util.removeClass(pop, "slds-fade-in-open");
        $A.util.addClass(pop, "slds-fade-in-close");
        $A.util.addClass(pop, "slds-hide");
        
        var popback = component.find("backGroundSectionId");
        $A.util.removeClass(popback, "slds-backdrop--open");
        $A.util.addClass(popback, "slds-backdrop--close");
       
	},
    

    
    handleCreateAutoShipmentEvent : function(component, event, helper)
    {
        var tempCUstomerId = component.find("v.customer");
        var newPackage = component.get("v.package");
        
        var myOutput = component.find("outColor");
        if(newPackage.sigmaerpdev__Customer__c == ""){            
            $A.util.addClass(myOutput , "textClass");
            myOutput.set("v.value", "Select Customer"); 
            return;
        }else{
            myOutput.set("v.value", " ");
        }
        
        var inputCmp = component.find("status");
        var value = inputCmp.get("v.value");
    
        if(value == undefined || value == "--Select--"){
            inputCmp.set("v.errors", [{message:"Select Status"}]);
            return;
        }else{
            inputCmp.set("v.errors", null);
        }
        
      
        var pkPrdLst = component.get("v.packageProducts");
        for(var i=0;i<pkPrdLst.length;i++){
            if(pkPrdLst[i].sigmaerpdev__Sigma_Order__c == ""){
                var msg = "Select Order for package Product "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }

        }
        if(event.getParam("isEdit") == true)
        {
            helper.updatePackageProductHelperEdit(component, event, helper);
        }else
        {
            helper.createPackageAutoShip(component, event, helper, newPackage); 
        }
         
    },
    
    onSingleSelectChange : function(component, event, helper)
    {
        var inputCmp = component.find("status");
        var value = inputCmp.get("v.value");
       
        component.set("v.hideAutoShipButtonInChild",value);
        component.set("v.PackSelectedStatus",value);        
        component.set("v.package.sigmaerpdev__Status__c",value);        
        if(value != 'Ready' && value != 'In Progress'){
            value = 'Ready';
        }
        var appEvent1 = $A.get("e.c:setStatusValFromParentSO");
        appEvent1.setParams({
            "statusFrmParent" : value});
        appEvent1.fire();               
        //ends here        
    },
    
    toggle : function(component, event, helper) {        
        if(document.getElementById('showNormalFlow').style.display == 'block')
        {
            document.getElementById('showEntryMatr').style.display = 'block';
            document.getElementById('showNormalFlow').style.display = 'none';            
        }else{
            document.getElementById('showEntryMatr').style.display = 'none';
            document.getElementById('showNormalFlow').style.display = 'block'; 
        }        
    },
    
    //added for autopick or manual flow
    createPackageforAutoPickManual : function(component, event, helper){
        var newPackage = component.get("v.package");
      
        var myOutput = component.find("outColor");
        if(newPackage.sigmaerpdev__Customer__c == ""){            
            $A.util.addClass(myOutput , "textClass");
            myOutput.set("v.value", "Select Customer"); 
            return;
        }else{
            //myOutput.set("v.value", " ");
        }
        
        var inputCmp = component.find("status");
        var value = inputCmp.get("v.value");
       
        if(value == undefined || value == "--Select--"){
            inputCmp.set("v.errors", [{message:"Select Status"}]);
            return;
        }else{
            //inputCmp.set("v.errors", null);
        }
        
        var inputCmp2 = component.find("packagedDate");
        var date = inputCmp2.get("v.value");
         var today = new Date();
        	var orderdate = new Date(today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate());

        var packdate= new Date(newPackage.sigmaerpdev__PackagedDate__c);
         var todaydate = new Date(packdate.getFullYear()+ "-" +(packdate.getMonth() + 1)+ "-" + packdate.getDate());
       
        if(date == ""){
            inputCmp2.set("v.errors", [{message:"Select Packaged Date"}]);
            return;
        }else{
            //inputCmp2.set("v.errors", null);
        }
         if(todaydate<orderdate )
        {
            inputCmp2.set("v.errors", [{message:"Package Date Should be greater than Today."}]);
            return;        
        }
        else
        {
            //inputCmp2.set("v.errors", null);
        }
        var checkBoxSel = false;
        var mainWrapperListVal = component.get("v.mainWrapperList");

        for(var i=0;i<mainWrapperListVal.length;i++){ 
            if(mainWrapperListVal[i].transId == "" || mainWrapperListVal[i].transId == undefined){
                var msg = "Select Stapp Order for Package Product "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
            
           if(mainWrapperListVal[i].status == "" || mainWrapperListVal[i].status == "--Select--" || mainWrapperListVal[i].status == undefined){
                var msg = "Select Status for Package Product "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
             	return;        
            }else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }  
            //ends here
            
            //check if package quantity is greater than 0 or not
            for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){
                if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && mainWrapperListVal[i].lineItemsList[j].allocatedQnty == 0){
                    var msg = "Package Quantity cannot be 0 for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;            
                }else{
                     component.set("v.isError",false);
               		 component.set("v.errorMsg", "");
                }                
            }
            //ends here
              
            for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){                
                if(mainWrapperListVal[i].lineItemsList[j].isSelected == true){
                    checkBoxSel = true;
                }
            }
            if(checkBoxSel == false){
                var msg = "Select atleast one product for Packaging.";
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
             	return;        
            }else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            } 
            //ends here
            
            //check whether autopick or select is done before packaging            
            for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){                 
                if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && mainWrapperListVal[i].lineItemsList[j].prodwrap.length == 0 && mainWrapperListVal[i].lineItemsList[j].packProd.sigmaerpdev__Auto_allocate__c == false){
                    var msg = "Autopick or Select Stock for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;            
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }
                //check in the select popup list selected quantity is there or not - validation                  
                for(var k=0;k<mainWrapperListVal[i].lineItemsList[j].prodwrap.length;k++){                                                                                                                      
                    var counter = 0;
                    for(var l=0;l<mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList.length;l++){                             
                        if(mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != '' && mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != undefined){                         
                            counter = counter + mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity;
                        }                            
                    }
                    if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && counter == 0){
                        var msg = "Select Stock for Manual Selection for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;    
                    }                                                 
                } //validation ends here                       
            }//ends here            
            
        }  
  	helper.savePackageforAutoPickManual(component);    

    
        //ends here
		
    },
    //ends here   
    //added for update flow of autopick or manual
    updatePackageforAutoPickManual  : function(component, event, helper){
        //validations starts from here
       var newPackage = component.get("v.package");
        
        var myOutput = component.find("outColor");
        if(newPackage.sigmaerpdev__Customer__c == ""){            
            $A.util.addClass(myOutput , "textClass");
            myOutput.set("v.value", "Select Customer"); 
            return;
        }else{
            myOutput.set("v.value", " ");
        }
        
        var inputCmp = component.find("status");
        var value = inputCmp.get("v.value");
       
        if(value == undefined || value == "--Select--"){
            inputCmp.set("v.errors", [{message:"Select Status"}]);
            return;
        }else{
            inputCmp.set("v.errors", null);
        }
        
        var inputCmp2 = component.find("packagedDate");
        var date = inputCmp2.get("v.value");
        
        if(date == ""){
            inputCmp2.set("v.errors", [{message:"Select Packaged Date"}]);
            return;
        }else{
            inputCmp2.set("v.errors", null);
        }
        var checkBoxSel = false;
        var mainWrapperListVal = component.get("v.mainWrapperList");

        if(mainWrapperListVal != null){
            for(var i=0;i<mainWrapperListVal.length;i++){            
                if(mainWrapperListVal[i].transId == "" || mainWrapperListVal[i].transId == undefined){
                    var msg = "Select Sigma Order for Package Product "+(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }
                
                //check if Status is selected or not
                if(mainWrapperListVal[i].status == "" || mainWrapperListVal[i].status == "--Select--" || mainWrapperListVal[i].status == undefined){
                    var msg = "Select Status for Package Product "+(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;        
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }  
                //ends here
                
                //check if package quantity is greater than 0 or not
                for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){
                    if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && mainWrapperListVal[i].lineItemsList[j].allocatedQnty == 0){
                        var msg = "Package Quantity cannot be 0 for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;            
                    }else{
                         component.set("v.isError",false);
                         component.set("v.errorMsg", "");
                    }                
                }
                //ends here
                  
                //check if atleast one checkbox is checked or not during submit
                for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){                
                    if(mainWrapperListVal[i].lineItemsList[j].isSelected == true){
                        checkBoxSel = true;
                    }
                }
                if(checkBoxSel == false){
                    var msg = "Select atleast one product for Packaging.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;        
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                } 
                //ends here
                
                //check whether autopick or select is done before packaging            
                for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){                 
                    if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && mainWrapperListVal[i].lineItemsList[j].prodwrap.length == 0 && mainWrapperListVal[i].lineItemsList[j].packProd.sigmaerpdev__Auto_allocate__c == false){
                        var msg = "Autopick or Select Stock for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;            
                    }else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    }
                    //check in the select popup list selected quantity is there or not - validation                  
                    for(var k=0;k<mainWrapperListVal[i].lineItemsList[j].prodwrap.length;k++){                                                                                                                      
                        var counter = 0;
                        for(var l=0;l<mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList.length;l++){                             
                            if(mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != '' && mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != undefined){                         
                                counter = counter + mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity;
                            }                            
                        }
                        if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && counter == 0){
                            var msg = "Select Stock for Manual Selection for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;    
                        }                                                 
                    } //validation ends here                       
                }//ends here
            }
    	}
        //ends here
		helper.updatePackageforAutoPickManual(component);
    },
    //ends here
    
    //auto shipment from New Package Flow
    handleCreateAutoShipmentEventFromNewPackageFlow : function(component, event, helper)
    {
        var newPackage = component.get("v.package");
        newPackage.sigmaerpdev__Is_Stapp_Order_Package__c = true;
        var myOutput = component.find("outColor");
        if(newPackage.sigmaerpdev__Customer__c == ""){            
            $A.util.addClass(myOutput , "textClass");
            myOutput.set("v.value", "Select Customer"); 
            return;
        }else{
            myOutput.set("v.value", " ");
        }
        
        var inputCmp = component.find("status");
        var value = inputCmp.get("v.value");
       
        if(value == undefined || value == "--Select--"){
            inputCmp.set("v.errors", [{message:"Select Status"}]);
            return;
        }else{
            inputCmp.set("v.errors", null);
        }
        
        var inputCmp2 = component.find("packagedDate");
        var date = inputCmp2.get("v.value");
        
        if(date == ""){
            inputCmp2.set("v.errors", [{message:"Select Packaged Date"}]);
            return;
        }else{
            inputCmp2.set("v.errors", null);
        }
        var mainWrapperListVal = component.get("v.mainWrapperList");       
        
        //new updated validations starts from here - added on 22/12/2017
        var checkBoxSel = false;
        for(var i=0;i<mainWrapperListVal.length;i++){            
                if(mainWrapperListVal[i].transId == "" || mainWrapperListVal[i].transId == undefined){
                    var msg = "Select Sigma Order for Package Product "+(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }
                
                //check if Status is selected or not
                if(mainWrapperListVal[i].status == "" || mainWrapperListVal[i].status == "--Select--" || mainWrapperListVal[i].status == undefined){
                    var msg = "Select Status for Package Product "+(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;        
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }  
                //ends here
                
                //check if package quantity is greater than 0 or not
                for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){
                    if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && mainWrapperListVal[i].lineItemsList[j].allocatedQnty == 0){
                        var msg = "Package Quantity cannot be 0 for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;            
                    }else{
                         component.set("v.isError",false);
                         component.set("v.errorMsg", "");
                    }                
                }
                //ends here
                  
                //check if atleast one checkbox is checked or not during submit
                for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){                
                    if(mainWrapperListVal[i].lineItemsList[j].isSelected == true){
                        checkBoxSel = true;
                    }
                }
                if(checkBoxSel == false){
                    var msg = "Select atleast one product for Packaging.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;        
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                } 
                //ends here
                
                //check whether autopick or select is done before packaging            
                for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++){                 
                    if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && mainWrapperListVal[i].lineItemsList[j].prodwrap.length == 0 && mainWrapperListVal[i].lineItemsList[j].packProd.sigmaerpdev__Auto_allocate__c == false){
                        var msg = "Autopick or Select Stock for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;            
                    }else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    }
                    //check in the select popup list selected quantity is there or not - validation                  
                    for(var k=0;k<mainWrapperListVal[i].lineItemsList[j].prodwrap.length;k++){                                                                                                                      
                        var counter = 0;
                        for(var l=0;l<mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList.length;l++){                             
                            if(mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != '' && mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != undefined){                         
                                counter = counter + mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity;
                            }                            
                        }
                        if(counter == 0){
                            var msg = "Select Stock for Manual Selection for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;    
                        }                                                 
                    } //validation ends here                       
                }//ends here
                  
                if(mainWrapperListVal[i].status == "In Progress"){
                    var msg = "Auto Shipment is not possible when Order line status is In Progress @ row :"+(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;        
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }  
                //ends here                             
            }

                        if(event.getParam("isEdit") == true)
                        {
                            helper.updatePackageProductHelperEditForAutoPickOrManual(component, event, helper);            
                        }else
                        {
                           helper.createPackageAutoShipforAutoPickManual(component, event, helper, newPackage); 
                        } 
                    
  
           
    },
    
})