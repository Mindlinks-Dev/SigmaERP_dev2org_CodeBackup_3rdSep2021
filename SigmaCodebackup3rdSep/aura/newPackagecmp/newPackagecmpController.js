({
    doInit : function(component, event, helper) {
        
        // By-forgation in standard and custom setting by chandana 
        var ordertype = component.get("c.CheckOrder");
        ordertype.setCallback( this, function(response1) {
            var state = response1.getState();
            
            if (state === "SUCCESS") {
                var res = response1.getReturnValue();
                if(res.sigmaerpdev__Standard_object__c== true)
                {
                    component.set("v.isStandardOrder",true);
                    //for edit flow 
                    if(component.get("v.id") != '' && component.get("v.id") != undefined)
                    {
                        var editPackageId = component.get("v.id");
                        var actionedit26 = component.get("c.getPackageProductsstandForEditAutoPickOrManual"); //calling edit flow - added on 22/11/2017
                        actionedit26.setParams({ 
                            "packageId": editPackageId
                        });
                        actionedit26.setCallback( this, function(response) {
                            var state = response.getState();
                            
                            if (state === "SUCCESS") {
                                var res = response.getReturnValue();
                                console.log('response=='+JSON.stringify(response.getReturnValue()));
                                if(res != ''){
                                    component.set("v.mainWrapperList", response.getReturnValue());
                                    
                                }
                                //alert('mainwrap in edit flow ::'+JSON.stringify(component.get("v.mainWrapperList")));
                                
                            }
                            
                        });            
                        $A.enqueueAction(actionedit26); 
                    }
                }
            }
        });
        $A.enqueueAction(ordertype);
        
        //new code to restrict the acces of package if allocated invetory status 
        var actionallocate = component.get("c.validationforAllocated");
        
        actionallocate.setCallback( this, function(response1) {
            var state = response1.getState();
            if (state === "SUCCESS") {
                var res = response1.getReturnValue();
                if(res.sigmaerpdev__Inventory_Status__c=='Allocated')
                {
                    component.set("v.isOpen",false);
                    alert("Package Can not be Done.");
                    var backdrop = component.find('backdrop');
                    $A.util.removeClass(backdrop, 'slds-hide');
                    
                }
            }
        });
        $A.enqueueAction(actionallocate);
        
        if(component.get("v.id") == undefined || component.get("v.id") == ""){ 
            
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
        //ends here
        
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
            //alert('package status::'+JSON.stringify(component.get("v.status")));
        });
        $A.enqueueAction(action); 
        
        
        
        var packageProductList = component.get("v.packageProducts");                
        packageProductList.push({
            'sigmaerpdev__Order__c':'',
            'sigmaerpdev__Sigma_Order__c':'',
            'sigmaerpdev__Product__c':'',
            'sigmaerpdev__Location__c':'',
            'sigmaerpdev__Instructions__c':'',
            'sigmaerpdev__Package_Date__c':'',
            'sigmaerpdev__Status__c':'Ready'
            
        });		
        
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
        console.log('Data ::' + packageProductList);
        
        if(component.get("v.id") != '' && component.get("v.id") != undefined){
            var spinner = component.find('spinner');
            $A.util.removeClass(spinner, "slds-hide");
            var PackageId = component.get("v.id");
            var action21 = component.get("c.editPackageforAutopickorManual"); //calling edit flow - added on 22/11/2017
            action21.setParams({ 
                "packageId": PackageId
            });
            action21.setCallback( this, function(response) {
                var state = response.getState();                    
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    if(res != ''){
                        component.set("v.package", response.getReturnValue());
                    }                         
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
                    
                    //added to set header status so that the same value can be passed on to orderline items[child]
                    component.set("v.PackSelectedStatus",response.getReturnValue().sigmaerpdev__Status__c);                        
                }
                var spinner = component.find('spinner');
                $A.util.addClass(spinner, "slds-hide");
            });
            $A.enqueueAction(action21); 
        }
        //ends here
        
        if(component.get("v.id") != '' && component.get("v.id") != undefined){            
            var editPackageId = component.get("v.id");
            
            var action25 = component.get("c.getPackageProductsForEditAutoPickOrManual"); //calling edit flow - added on 22/11/2017
            action25.setParams({ 
                "packageId": editPackageId
            });
            action25.setCallback( this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    console.log('response=='+JSON.stringify(response.getReturnValue()));
                    if(res != ''){
                        component.set("v.mainWrapperList", response.getReturnValue());
                        
                    }
                    
                }
                
            });            
            $A.enqueueAction(action25);   
            
        }
        //ends here
        
        
    },
    makeStatusReadOnly : function(component, event, helper)
    {
        
        component.set("v.isCancel",true);
        
    },
    createPackage : function(component, event, helper) 
    {
        
        var tempCUstomerId = component.find("v.customer");
        var newPackage = component.get("v.package");
        var localvar = component.get("v.isStandardOrder");
        //alert('localvar::'+localvar);
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
        
        if(localvar == true)
        {
            //alert('in isStandardOrder loop ::');
            for(var i=0;i<pkPrdLst.length;i++){
                if(pkPrdLst[i].sigmaerpdev__Order__c == ""){
                    var msg = "Select Order for package Product "+(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }  
            }
            
        }
        else{
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
        }
        if(localvar == true)
        {
            for(var i=0;i<pkPrdLst.length;i++){
                if(pkPrdLst[i].sigmaerpdev__Order__c == ""){
                    var msg = "Select Order for package Product "+(i+1);
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }
                
            }
        }
        else{
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
    
    
    
    //added newly for package autopick or manual on 22/11/2017
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
            //alert('temp::: in addcontact::'+JSON.stringify(component.get("v.mainWrapperList")));
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
                    
                    // Create the UpdateLookupId event
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
                    
                    var inputCmp2 = component.find("packagedDate");
                    var date = inputCmp2.get("v.value");
                    
                    if(date == ""){
                        inputCmp2.set("v.errors", [{message:"Select Packaged Date"}]);
                        return;
                    }else{
                        inputCmp2.set("v.errors", null);
                    }
                    
                    var pkPrdLst = component.get("v.packageProducts");
                    var localvar = component.get("v.isStandardOrder");
                    //alert('localvar::'+localvar);
                    if(localvar == true)
                    {
                        for(var i=0;i<pkPrdLst.length;i++){
                            if(pkPrdLst[i].sigmaerpdev__Order__c == ""){
                                var msg = "Select Order for package Product "+(i+1);
                                component.set("v.errorMsg", msg);
                                component.set("v.isError",true);
                                return;
                            }else{
                                component.set("v.isError",false);
                                component.set("v.errorMsg", "");
                            }
                        }
                    }
                    else{
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
                    //validations starts from here
                    var newPackage = component.get("v.package");
                    var temparray = [];
                    
                    var today = new Date();
                    component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
                    var date = component.get("v.today");
                    
                    var someDate = new Date(component.get("v.package.sigmaerpdev__PackagedDate__c"));
                    component.set('v.Orderdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
                    
                    var orderdate = component.get("v.Orderdate");
                    if(orderdate < date)
                    {
                        var msg = "Package Date Should be greater than Today.";
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;            
                    }
                    else
                    {
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    }
                    
                    
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
                   for(var i=0;i<mainWrapperListVal.length;i++){ 
                        if(mainWrapperListVal[i].transId == "" || mainWrapperListVal[i].transId == undefined){
                            var msg = "Select Order for Package Product "+(i+1);
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
                        for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++)
                        {
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
                        for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++)
                        {                
                            if(mainWrapperListVal[i].lineItemsList[j].isSelected == true){
                                checkBoxSel = true;
                            }
                        }
                        if(checkBoxSel == false)
                        {
                            var msg = "Select atleast one product for Packaging.";
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;        
                        }
                        else{
                            component.set("v.isError",false);
                            component.set("v.errorMsg", "");
                        } 
                        //ends here
                        
                        //check whether autopick or select is done before packaging 
                        for(var j=0;j<mainWrapperListVal[i].lineItemsList.length;j++)
                        { 
                            if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && mainWrapperListVal[i].lineItemsList[j].prodwrap.length == 0 && mainWrapperListVal[i].lineItemsList[j].packProd.sigmaerpdev__Auto_allocate__c == false){
                                var msg = "Autopick or Select Stock for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                                component.set("v.errorMsg", msg);
                                component.set("v.isError",true);
                                return;            
                            }
                            else{
                                component.set("v.isError",false);
                                component.set("v.errorMsg", "");
                            }
                            
                            //check in the select popup list selected quantity is there or not - validation                  
                            for(var k=0;k<mainWrapperListVal[i].lineItemsList[j].prodwrap.length;k++)
							{                                                                                                                      
                                var counter = 0;
                                for(var l=0;l<mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList.length;l++)
                                {
                                    if(mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != '' && mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != undefined)
                                    {                         
                                        counter = counter + mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity;
										var temp=mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].ilpliId;
                                        temparray.push(temp);
                                    }
                                }
                                if(mainWrapperListVal[i].lineItemsList[j].isSelected == true && counter == 0){
                                    var msg = "Select Stock for Manual Selection for the Product : "+mainWrapperListVal[i].lineItemsList[j].prodName + "@ row : "+ parseInt(i+1);
                                    component.set("v.errorMsg", msg);
                                    component.set("v.isError",true);
                                    return;
                                }
                            }
                        }
                        if(mainWrapperListVal[i].transId == "" || mainWrapperListVal[i].transId == undefined){
                          
                            var msg = "Select Sigma Order for Package Product "+(i+1);
                            component.set("v.errorMsg", msg);
                            component.set("v.isError",true);
                            return;
                        }
                        else{
                            component.set("v.isError",false);
                            component.set("v.errorMsg", "");
                        }
                    }
                    // new code to verify the same ilpli for diffrent SO by surendra 
                    var sorted_arr = [];
                    sorted_arr = temparray.sort();
                    if(sorted_arr.length > 1)
                    {
                        if(mainWrapperListVal.length > 1)
                        {
                            for (var i = 0; i < sorted_arr.length; i++) 
                            {
                                if (sorted_arr[i+1] == sorted_arr[i]) 
                                {
                                    var msg = "Found Duplicate ILPLI for Package, select diffrent ILPLI";
                                    component.set("v.errorMsg", msg);
                                    component.set("v.isError",true);
                                    return;
                                }
                                else{
                                    component.set("v.isError",false);
                                    component.set("v.errorMsg", "");
                                }
                            }
                        }
                    }
                    helper.savePackageforAutoPickManual(component);
                    //ends here
                    
                },
                //ends here   
                //added for update flow of autopick or manual
                updatePackageforAutoPickManual  : function(component, event, helper){
                    
                    var newPackage = component.get("v.package");
                    var temparray = [];
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
                                var msg = "Select Order for Package Product "+(i+1);
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
                                for(var k=0;k<mainWrapperListVal[i].lineItemsList[j].prodwrap.length;k++)
								{                                                                                                                      
                                    var counter = 0;
                                    for(var l=0;l<mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList.length;l++){                             
                                        if(mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != '' && mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity != undefined){                         
                                            counter = counter + mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].selQuantity;
                                        	//alert('wrapProdList[l].ilpliId !=null'+temp);
                                        	var temp=mainWrapperListVal[i].lineItemsList[j].prodwrap[k].wrapProdList[l].ilpliId;
                                            temparray.push(temp);
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
                    var sorted_arr = [];
                    sorted_arr = temparray.sort();
                    if(sorted_arr.length>1)
                    {
                        if(mainWrapperListVal.length > 1)
                        {
                            for (var i = 0; i < sorted_arr.length; i++) 
                            {
                                if (sorted_arr[i + 1] == sorted_arr[i]) 
                                {
                                    var msg = "Found Duplicate ILPLI for Package, select diffrent ILPLI for "+mainWrapperListVal[i].lineItemsList[j].prodName +"Product";
                                    component.set("v.errorMsg", msg);
                                    component.set("v.isError",true);
                                    return;
                                }
                                else{
                                    component.set("v.isError",false);
                                    component.set("v.errorMsg", "");
                                }
                            }
                        }
                    }
                    helper.updatePackageforAutoPickManual(component);
                },
                //ends here
                
                //auto shipment from New Package Flow
                handleCreateAutoShipmentEventFromNewPackageFlow : function(component, event, helper)
                {
                    //validation starts from here
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
                            var msg = "Select sigma Order for Package Product "+(i+1);
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
                                //alert('temp1::::'+JSON.stringify(component.get(mainWrapperListVal.lineItemsList.prodwrap)));
                                
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
                        
                        //added on 25/12/2017 to stop auto shipment if the line items status is inprogress
                        //check if Status is selected or not
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