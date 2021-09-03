({
    createPackage: function(component, event, helper, newPackage) { 
        //Save the expense and update the view
        this.upsertExpense(component, newPackage, function(a) {
            var packages = component.get("v.packages");
            packages.push(a.getReturnValue());//alert('Package Creation Failed'+a.getReturnValue());
            if(a.getReturnValue() != null){
                alert('Package Created Successfully.');
                
                if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                    
                    sforce.one.navigateToSObject(a.getReturnValue().Id);
                }else{
                    
                    var packID =a.getReturnValue().Id;
                    component.get("v.PackageID",packID)
                    window.location.href = "/" + a.getReturnValue().Id;
                 }    
            } else{
                alert('Package Creation Failed.');
            }   
            component.set("v.packages", packages);
            
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, "slds-hide");
            
        });
    },
    createPackageAutoShip: function(component, event, helper, newPackage) {
        //Save the expense and update the view
        this.upsertExpense(component, newPackage, function(a) {
            var packages = component.get("v.packages");
            packages.push(a.getReturnValue());//alert('Package Creation Failed'+a.getReturnValue());
            if(a.getReturnValue() != null){
                alert('Package Created Successfully.');
                if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                    // Manage navigation in Lightning Experience & Salesforce1
                    sforce.one.navigateToSObject(a.getReturnValue().Id);
                }else{
                    var packID =a.getReturnValue().Id;
                    var createAutoShipmentFlag = event.getParam("message");
                    if(createAutoShipmentFlag ==='True')
                    {
                        component.get("v.PackageID",packID)
                         var passPackageID = $A.get("e.stapplink:PassPackgeIdToShipmentByPassPackageComponent");
                        passPackageID.setParams({
                            "PackageObj" : a.getReturnValue()});
                        passPackageID.fire();
                         }
                    else
                    {	window.location.href = "/" + a.getReturnValue().Id;
                    }
                }    
            } else{
                alert('Package Creation Failed.');
            }   
            component.set("v.packages", packages);
            
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, "slds-hide");
            
        });
    },
    upsertExpense : function(component, newPackage, callback) {
        var action = component.get("c.savePackage");
        
        var inputstatus = component.find("status");
        var sts = inputstatus.get("v.value");
        var pkgPrdts = component.get("v.packageProducts");
        
        var flag = false;
      
            
            action.setParams({ 
                "packageObj": newPackage,
                "status" : sts,
                "packageProduts" : JSON.stringify(component.get("v.packageProducts")),//$A.util.json.encode(component.get("v.packageProducts"))
                "orderlLines" : JSON.stringify(component.get("v.productList"))
            });
            if (callback) {
                action.setCallback(this, callback);
                var res = action.getReturnValue();
               
            }
            var spinner = component.find('spinner');
            $A.util.removeClass(spinner, "slds-hide");
            $A.enqueueAction(action);
    },
    removeProductItem : function(component, index) {
      var packageProdList = component.get("v.packageProducts");
      var mainWrapperListVal = component.get("v.mainWrapperList"); //changed for new autopick flow      
      var action = component.get("c.deletePackageProduct");        
       
        action.setParams({ 
           "packageProduts" : JSON.stringify(mainWrapperListVal),
            "index":index
        });
        mainWrapperListVal.splice(index, 1);	        
        component.set("v.mainWrapperList", mainWrapperListVal);
      $A.enqueueAction(action);        
    },
    updatePackageProductHelper: function(component, event, helper) 
    {        
        
        //validation Start
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
            if(pkPrdLst[i].sigmaerpdev__Transaction__c == ""){
                var msg = "Select Order for package Product "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
            
           
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
         
            
        }
        
        var ProdSelList = component.get("v.productList");
        var flag = false;
        for(var i=0;i<ProdSelList.length;i++){
             if(ProdSelList[i].isSelected == true){
                flag = true;
            }            
        }
        
        //validation Ends
        
        var spinner2 = component.find('spinner');
        $A.util.removeClass(spinner2, "slds-hide");
        
        component.set("v.package.sigmaerpdev__Status__c",component.find("status").get("v.value"));    
        var Package = component.get("v.package");
        var PackageProd = component.get("v.packageProducts");
        var action = component.get("c.updatePackage");
        var ol = JSON.stringify(component.get("v.productList"));
        if(flag == false)
        {
            var msg = "Select atleast one Product ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            
            var spinner2 = component.find('spinner');
            $A.util.addClass(spinner2, "slds-hide");
            
        }
        else
        {    
            action.setParams
            ({ 
                "packageObj": Package,
                "packageProduts" : JSON.stringify(component.get("v.packageProducts")),//$A.util.json.encode(component.get("v.packageProducts"))
                "orderlLines" : ol//JSON.stringify(component.get("v.productList"))  
                
            });        
            action.setCallback(this, function(a) {
                if(a.getReturnValue() != null){
                    alert('Updated Successfully');
                    if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                       sforce.one.navigateToSObject(a.getReturnValue().Id);
                    }else{
                        window.location.href = "/" + a.getReturnValue().Id;
                    }                 
                }else{
                    alert('Updated Failed');
                }
                var spinner2 = component.find('spinner');
                $A.util.addClass(spinner2, "slds-hide");
                
            });                
            $A.enqueueAction(action);
        }    
    },
    updatePackageProductHelperEdit: function(component, event, helper) 
    {        
        
        //validation Start
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
            if(pkPrdLst[i].sigmaerpdev__Transaction__c == ""){
                var msg = "Select Order for package Product "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
           
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
        
            
        }
        
        var ProdSelList = component.get("v.productList");
        var flag = false;
        for(var i=0;i<ProdSelList.length;i++){
            if(ProdSelList[i].isSelected == true){
                flag = true;
            }            
        }
        
        //validation Ends
        
        var spinner2 = component.find('spinner');
        $A.util.removeClass(spinner2, "slds-hide");
        
        component.set("v.package.sigmaerpdev__Status__c",component.find("status").get("v.value"));    
        var Package = component.get("v.package");
        var PackageProd = component.get("v.packageProducts");
        var action = component.get("c.updatePackage");
        var ol = JSON.stringify(component.get("v.productList"));
        if(flag == false)
        {
            var msg = "Select atleast one Product ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            
            var spinner2 = component.find('spinner');
            $A.util.addClass(spinner2, "slds-hide");
            
        }
        else
        {    
            action.setParams
            ({ 
                "packageObj": Package,
                "packageProduts" : JSON.stringify(component.get("v.packageProducts")),//$A.util.json.encode(component.get("v.packageProducts"))
                "orderlLines" : ol//JSON.stringify(component.get("v.productList"))  
                
            });        
            action.setCallback(this, function(a) {
                if(a.getReturnValue() != null){
                    alert('Updated Successfully');
                    if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                        // Manage navigation in Lightning Experience & Salesforce1
                        sforce.one.navigateToSObject(a.getReturnValue().Id);
                    }else{
                        
                        var createAutoShipmentFlag = event.getParam("message");
                        if(createAutoShipmentFlag ==='True')
                        {
                           var passPackageID = $A.get("e.stapplink:PassPackgeIdToShipmentByPassPackageComponent");
                            passPackageID.setParams({
                                "PackageObj" : a.getReturnValue()});
                            passPackageID.fire();
                             }
                        else
                        {	window.location.href = "/" + a.getReturnValue().Id;
                        }
                        
                    }                 
                }else{
                    alert('Updated Failed');
                }
                var spinner2 = component.find('spinner');
                $A.util.addClass(spinner2, "slds-hide");
                
            });                
            $A.enqueueAction(action);
        }    
    },
    //added for fast entry matrix on 28-9-2017
	fastEntryFlow: function(component, event, helper){
		if(component.get("v.id") != '')
        {
            var spinner = component.find('spinner');
            $A.util.removeClass(spinner, "slds-hide");
            
            var action1 = component.get("c.editFastEntryPackage");
            action1.setParams({ "packageObj": component.get("v.id") });
            action1.setCallback( this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {                   
                    component.set("v.isFromFastEntryMatrix",response.getReturnValue().sigmaerpdev__isFromFastEntryMatrix__c);
                    component.set("v.package", response.getReturnValue());
                    if(response.getReturnValue().sigmaerpdev__Customer__c != undefined){
                        component.set("v.recordName", response.getReturnValue().sigmaerpdev__Customer__r.Name);
                        component.set("v.customerId", response.getReturnValue().sigmaerpdev__Customer__c);
                        
                    }
                    if(response.getReturnValue().sigmaerpdev__Location__c != undefined){
                        component.set("v.location", response.getReturnValue().sigmaerpdev__Location__r.Name);
                    }
                    if(response.getReturnValue().sigmaerpdev__PackagedBy__c != undefined){
                        component.set("v.packagedBy", response.getReturnValue().sigmaerpdev__PackagedBy__r.Name);
                    }
                   component.find("status").set("v.value", response.getReturnValue().sigmaerpdev__Status__c);                    
        			component.set("v.hideAutoShipButtonInChild",response.getReturnValue().sigmaerpdev__Status__c);
                }
            });
            $A.enqueueAction(action1);
            
            
            var action2 = component.get("c.getDataForFastEntry");
            action2.setParams({"packageId": component.get("v.id") });
            action2.setCallback( this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();					
                     if(res != ''){
                        component.set("v.packageProductsFastEntry", response.getReturnValue());
                    }   
                }                
				console.log('cONSOLE==='+JSON.stringify(component.get("v.packageProductsFastEntry")));
                var spinner = component.find('spinner');
                $A.util.addClass(spinner, "slds-hide");
            });
            $A.enqueueAction(action2);
        }
	},
    normalEntryFlow: function(component, event, helper){
		if(component.get("v.id") != '')
        {
            var spinner = component.find('spinner');
            $A.util.removeClass(spinner, "slds-hide");
            
            var action1 = component.get("c.editPackage");
            action1.setParams({ "packageObj": component.get("v.id") });
            action1.setCallback( this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.package", response.getReturnValue());
                    if(response.getReturnValue().sigmaerpdev__Customer__c != undefined){
                        component.set("v.recordName", response.getReturnValue().sigmaerpdev__Customer__r.Name);
                        component.set("v.customerId", response.getReturnValue().sigmaerpdev__Customer__c);
                       
                    }
                    if(response.getReturnValue().sigmaerpdev__Location__c != undefined){
                        component.set("v.location", response.getReturnValue().sigmaerpdev__Location__r.Name);
                    }
                    if(response.getReturnValue().sigmaerpdev__PackagedBy__c != undefined){
                        component.set("v.packagedBy", response.getReturnValue().sigmaerpdev__PackagedBy__r.Name);
                    }
                     component.find("status").set("v.value", response.getReturnValue().sigmaerpdev__Status__c);
                   component.set("v.hideAutoShipButtonInChild",response.getReturnValue().sigmaerpdev__Status__c);
                }
            });
            $A.enqueueAction(action1);
            
            
            var action2 = component.get("c.editPackageProducts");
            action2.setCallback( this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    if(res != ''){
                        component.set("v.packageProducts", response.getReturnValue());
                    }   
                }
                var spinner = component.find('spinner');
                $A.util.addClass(spinner, "slds-hide");
            });
            $A.enqueueAction(action2);
        }
	},
    //ends here
	
    //new flow for update of autopick or manual
    updatePackageforAutoPickManual : function(component){
       var newPackage = component.get("v.package");        
        var interimList = component.get("v.mainWrapperList");
        console.log('mainWrapperList====>'+JSON.stringify(interimList)); 
        var interimListUpdated = JSON.stringify(interimList).replace(/""/g, '"0"'); //convert to JSON string
		
        var action = component.get("c.saveEditedAutoPickorManualPackage"); 
        action.setParams
            ({  
                "packageObj" : newPackage,                              
                "packageProducts" : interimListUpdated            
            });
        action.setCallback( this, function(a) 
            {
			  var state = a.getState();	
               if(a.getReturnValue() != null){
                    alert('Package Updated Successfully.');
                    if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                        sforce.one.navigateToSObject(a.getReturnValue().Id);
                    }else{                        
                        var packID =a.getReturnValue().Id;
                        window.location.href = "/" + a.getReturnValue().Id;
                     }    
                }else{
                    alert('Package Updation Failed.');
                }  
            });        	
			$A.enqueueAction(action); 
    },
    //ends here
    upsertExpenseforAutoPickManual : function(component, newPackage, callback) {
        var newPackage = component.get("v.package");        
        var interimList = component.get("v.mainWrapperList");        
        var interimListUpdated = JSON.stringify(interimList).replace(/""/g, '"0"'); //convert to JSON string
        
        var action = component.get("c.saveAutoPickorManualPackage"); 
        action.setParams
            ({  
                "packageObj" : newPackage,                              
                "packageProducts" : interimListUpdated            
            });
		if (callback) {
			action.setCallback(this, callback);
			var res = action.getReturnValue();		   
		}
		var spinner = component.find('spinner');
		$A.util.removeClass(spinner, "slds-hide");
		$A.enqueueAction(action);
    },
    
    savePackageforAutoPickManual: function(component, event, helper, newPackage) {
        //Save the expense and update the view
        this.upsertExpenseforAutoPickManual(component, newPackage, function(a) {
            var packages = component.get("v.packages");
            packages.push(a.getReturnValue());//alert('Package Creation Failed'+a.getReturnValue());
            if(a.getReturnValue() != null){
                alert('Package Created Successfully.');
                if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                    //alert('sjdsj');
                    sforce.one.navigateToSObject(a.getReturnValue().Id);
                }else{
                   
                    var packID =a.getReturnValue().Id;
                    component.get("v.PackageID",packID)
                    window.location.href = "/" + a.getReturnValue().Id;
                 }    
            } else{
                alert('Package Creation Failed.');
            }   
            component.set("v.packages", packages);
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, "slds-hide");
        });
    },
    //auto shipment flow starts here for New Autopick or manual flow of package
    createPackageAutoShipforAutoPickManual: function(component, event, helper, newPackage) {
        //Save the expense and update the view
        this.upsertExpenseforAutoPickManual(component, newPackage, function(a) {
            var packages = component.get("v.packages");
            packages.push(a.getReturnValue());
            if(a.getReturnValue() != null){
                alert('Package Created Successfully.');
                if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                    sforce.one.navigateToSObject(a.getReturnValue().Id);
                }else{
                   var packID =a.getReturnValue().Id;
                   var createAutoShipmentFlag = event.getParam("message");
                    var sAddress = event.getParam("sAddress");
                    
                    if(createAutoShipmentFlag ==='True')
                    {
                        component.get("v.PackageID",packID)
                        var passPackageID = $A.get("e.sigmaerpdev:PassPackgeIdToShipmentByPassPackageComponent");
                        passPackageID.setParams({
                            "PackageObj" : a.getReturnValue(),
                            "sAddress" : sAddress
                        });
                        passPackageID.fire();
                         }
                    else
                    {	window.location.href = "/" + a.getReturnValue().Id;
                    }
                }    
            } else{
                alert('Package Creation Failed.');
            }   
            component.set("v.packages", packages);
            
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, "slds-hide");
            
        });
    },
    //ends here
    //Auto shipment flow during update package
    updatePackageProductHelperEditForAutoPickOrManual: function(component, event, helper) 
    {        
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
        var mainWrapperListVal = component.get("v.mainWrapperList");
       for(var i=0;i<mainWrapperListVal.length;i++){            
            if(mainWrapperListVal[i].transId == "" || mainWrapperListVal[i].transId == undefined){
                var msg = "Select Transaction for Package Product "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
        }
        //ends here
        
        var spinner2 = component.find('spinner');
        $A.util.removeClass(spinner2, "slds-hide");
        
        component.set("v.package.sigmaerpdev__Status__c",component.find("status").get("v.value"));    
        var newPackage = component.get("v.package");        
        var interimList = component.get("v.mainWrapperList");
        console.log('mainWrapperList====>'+JSON.stringify(interimList)); 
        var interimListUpdated = JSON.stringify(interimList).replace(/""/g, '"0"'); //convert to JSON string
		
        var action = component.get("c.saveEditedAutoPickorManualPackage"); 
        action.setParams
            ({  
                "packageObj" : newPackage,                              
                "packageProducts" : interimListUpdated            
            });
        action.setCallback(this, function(a) {
                if(a.getReturnValue() != null){
                    alert('Package Updated Successfully.');
                    if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                       sforce.one.navigateToSObject(a.getReturnValue().Id);
                    }else{
                        
                        var createAutoShipmentFlag = event.getParam("message");
                        if(createAutoShipmentFlag ==='True')
                        {
                           var passPackageID = $A.get("e.sigmaerpdev:PassPackgeIdToShipmentByPassPackageComponent");
                            passPackageID.setParams({
                                "PackageObj" : a.getReturnValue()});
                            passPackageID.fire();
                           }
                        else
                        {	window.location.href = "/" + a.getReturnValue().Id;
                        }
                        
                    }                 
                }else{
                    alert('Package Updation Failed.');
                }
                var spinner2 = component.find('spinner');
                $A.util.addClass(spinner2, "slds-hide");
                
            });       	
			$A.enqueueAction(action); 
        }    
   
    
})