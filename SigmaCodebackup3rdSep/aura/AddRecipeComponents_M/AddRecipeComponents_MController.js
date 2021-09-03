({
    SelectedID : function(component, event, helper) {
        var objectId = event.getParam("recordByEvent");
        //alert('M objectId : '+objectId);
        var APIName = event.getParam("objectAPIName");
       // alert('M APIName : '+APIName);
        var context = event.getParam("context");
        //alert('M context : '+context);
       //alert('inside if 1');
        if(context=='recipeCompany'){
            
            component.set("v.recipeObject.sigmaerpdev2__Company__c",objectId.Id);
        }else if(context=='ProductComp'){
            component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Product__c",objectId.Id);
            component.set("v.message",null);
            component.set("v.showMessage",false);
        }else if(context=='RecpProduct'){
        	component.set("v.recipeObject.sigmaerpdev2__Product__c",objectId.Id);
            component.set("v.message",null);
            component.set("v.showMessage",false);
        }else if(context=='DependentRecipe'){
        	component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Dependent_Recipe__c",objectId.Id);
            component.set("v.message",null);
            component.set("v.showMessage",false);  
        }else if(context=='MRProductInstance'){
        	component.set("v.MRProduct.sigmaerpdev2__Product__c",objectId.Id);
            component.set("v.message",null);
            component.set("v.showMessage",false);
        }
        
        if(context=='ProductComp' || context=='RecpProduct' || context=='MRProductInstance')
        {
            //alert('inside if 2');
            var msg = '';
            var alreadyExists = false;
            var srcProdAdded = false;
            var flag = component.get("v.flag");
            var flgMsg = '';
            if(flag == 'productcomponent')
                flgMsg = 'Product Component';
            else if(flag == 'additionalproduct')
                flgMsg = 'Additional Product';
            else if(flag == 'packagingMaterial')
                flgMsg = 'Packaging Material';
            
            if(component.get("v.recipeChildData")!= null){
                //alert('inside if 3');
                var producedProdId = component.get("v.recpProdID");//'01t2x000002748mAAA';
              // alert('msg new--------->'+producedProdId);                
                if(objectId.Id == producedProdId){            		
                    srcProdAdded = true; 
                    // alert('msg--------->'+srcProdAdded);
                	msg = 'Recipe end product cannot be added as a '+flgMsg+'.'; 
                   // alert('msg--------->'+msg);
                }                                   
                
                if(srcProdAdded){     
                   // alert('inside if 4');
                    component.set("v.showMessage",true);
                	component.set("v.message",msg);  
                	component.set("v.disableSubmitBtn",true);
                    return;
                }                
                
                var prodList = component.get("v.recipeChildData.recipeProdList"); 
                for(var i=0;i<prodList.length;i++){  
                    if((component.get("v.Edit")==false && objectId.Id==prodList[i].sigmaerpdev2__Product__r.Id) || (component.get("v.Edit")==true && component.get("v.recipeProductsObject.oldID")!=component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Product__c") && objectId.Id==prodList[i].sigmaerpdev2__Product__r.Id)){
                        alreadyExists = true; 
                        msg = 'Selected product has already been added in product components. Cannot be added again.';
                    }
                }        
                var packMatList = component.get("v.recipeChildData.recipePackagingMatList");  
                for(var i=0;i<packMatList.length;i++){                    
                    if((component.get("v.Edit")==false && objectId.Id == packMatList[i].sigmaerpdev2__Product__r.Id) || (component.get("v.Edit")==true && component.get("v.recipeProductsObject.oldID")!=component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Product__c") && objectId.Id==packMatList[i].sigmaerpdev2__Product__r.Id)){
                        alreadyExists = true; 
                        msg = 'Selected product has already been added in packaging materials.Cannot be added again.';
                    }
                }
                var addProdList = component.get("v.recipeChildData.recipeAddProdList");        
                for(var i=0;i<addProdList.length;i++){                 
                    if((component.get("v.Edit")==false && objectId.Id == addProdList[i].sigmaerpdev2__Product__r.Id) || (component.get("v.Edit")==true && component.get("v.recipeProductsObject.oldID")!=component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Product__c") && objectId.Id==addProdList[i].sigmaerpdev2__Product__r.Id)){
                        alreadyExists = true; 
                        msg = 'Selected product has already been added in non stock items.Cannot be added again.';
                    }
                }             
            }
            
            if(alreadyExists){ 
                component.set("v.showMessage",true);
                component.set("v.message",msg);  
                component.set("v.disableSubmitBtn",true);
            }else{                
                component.set("v.disableSubmitBtn",false);
                component.set("v.showMessage",false);
                component.set("v.message",'');
                if (objectId.Id!=null) {
                    var decide;
                    var recordId;
                    if(context=='ProductComp' || context=='RecpProduct')
                    {
                        recordId=component.get("v.recipeID");
                        decide=false;
                    }    
                    else if(context=='MRProductInstance')
                    {
                        //recordId=component.get("v.companyID");
                        decide=true;
                    }   
                    var action = component.get('c.getProductDetails');
                    action.setParams({ "prodID" : objectId.Id, 
                                      "recID" : recordId,
                                      "decider" : decide});
                    action.setCallback(this, $A.getCallback(function (response) {
                        var state = response.getState(); 
						                      
                        var fromFlag = component.get("v.flag");                        
                        var selNonStock = response.getReturnValue().product.sigmaerpdev2__Stock_Item__c;                      
                        var decider = response.getReturnValue().isStockAvailable;
                        var avgBuyingprice=response.getReturnValue().ProductPrice;
                        
                        if(fromFlag == 'productcomponent' || fromFlag == 'packagingMaterial' || fromFlag == 'MRpackagingMaterial'){
                            var msg1 = '';
                            if(selNonStock == false){
                                if(fromFlag == 'productcomponent')
                                    msg1 = 'Non stock item cannot be added in product component.';
                                else if(fromFlag == 'packagingMaterial' || fromFlag == 'MRpackagingMaterial')
                                    msg1 = 'Non stock item cannot be added in packaging material.';
                                
                                component.set("v.showMessage",true);
                                component.set("v.message",msg1);
                                component.set("v.disableSubmitBtn",true);
                            }                           
                        }
                        if(fromFlag == 'additionalproduct' || fromFlag =='MRadditionalproduct'){
                            var msg2 = '';
                            if(selNonStock == true){                            
                                msg2 = 'Stock item cannot be added in non stock items list.';
                                component.set("v.disableSubmitBtn",true);
                                component.set("v.showMessage",true);
                                component.set("v.message",msg2);      
                            }
                            else
                            {
                                if(avgBuyingprice==null || avgBuyingprice==0 || avgBuyingprice==undefined)
                                {
                                    msg2 = 'No price is defined for the selected product.';
                                    component.set("v.disableSubmitBtn",true);
                                    component.set("v.showMessage",true);
                                    component.set("v.message",msg2);
                                }
                            }
                        }                   
                        if (state === "SUCCESS") {                            
                            if (response.getReturnValue().ProductPrice!=null){
                                if(component.get("v.flag")=='productcomponent' || component.get("v.flag")=='additionalproduct' || component.get("v.flag")=='packagingMaterial')
                                {
                                    component.set('v.recipeProductsObject.recipeProduct.sigmaerpdev2__Cost__c',response.getReturnValue().ProductPrice);                        
                                    component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Average_Buying_Price__c",response.getReturnValue().ProductPrice);                                
                                }
                                else if(component.get("v.flag")=='MRadditionalproduct' || component.get("v.flag")=='MRpackagingMaterial')
                                {
                                    component.set('v.MRProduct.sigmaerpdev2__Cost__c',response.getReturnValue().ProductPrice);                        
                                }
                                
                            }                               
                            
                            if(response.getReturnValue().product.sigmaerpdev2__Product_UOM__c!=null){
                                component.set('v.unitOfMeasure', response.getReturnValue().product.sigmaerpdev2__Product_UOM__c);
                                if(component.find("Unit_of_Measure") != undefined){
                                    component.find("Unit_of_Measure").set("v.value", response.getReturnValue().product.sigmaerpdev2__Product_UOM__c);        
                                }                            
                            }                            
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            console.error(errors);
                        }
                    }));
                    $A.enqueueAction(action);
                }    
            }   
        } 
    },
    
    ClearID : function(component, event, helper) {
        var context = event.getParam("instanceId");  
        if(context=='recipeCompany')
            component.set("v.recipeObject.sigmaerpdev2__Company__c",null);
        if(context=='RecpProduct')
        {
            component.set("v.recipeObject.sigmaerpdev2__Product__c",null);
            component.set("v.recipeObject.sigmaerpdev2__Unit_of_Measure__c",null);
            component.set("v.showMessage",false);
            component.set("v.message",null);
            component.set("v.disableSubmitBtn",false);
        }
        
        if(context=='ProductComp')
        {
            component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Product__c",null);
            component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Unit_of_Measure__c",null);
            component.set("v.showMessage",false);
            component.set("v.message",null);
            component.set("v.disableSubmitBtn",false);
        }
        
        if(context=='MRProductInstance')
        {
            component.set("v.MRProduct.sigmaerpdev2__Product__c",null);
            component.set("v.MRProduct.sigmaerpdev2__Unit_of_measure__c",null);
            component.set("v.showMessage",false);
            component.set("v.message",null);
            component.set("v.disableSubmitBtn",false);
        }
    },
    
    saveRecipe : function(component, event, helper){
        var recipdData=component.get("v.recipeObject");
        if(recipdData.Name=='' || recipdData.Name==null || recipdData.Name==undefined)
        {
            component.set("v.message",'Please enter the recipe name');
            component.set("v.showMessage",true);
            return;
        }        
        if(recipdData.sigmaerpdev2__Product__c=='' || recipdData.sigmaerpdev2__Product__c==null || recipdData.sigmaerpdev2__Product__c==undefined)
        {
            component.set("v.message",'Please select the product');
            component.set("v.showMessage",true);
            return;
        }
        if(recipdData.sigmaerpdev2__Quantity__c=='' || recipdData.sigmaerpdev2__Quantity__c==null || recipdData.sigmaerpdev2__Quantity__c==undefined)
        {
            component.set("v.message",'Please enter the quantity');
            component.set("v.showMessage",true);
            return;
        }
        if(recipdData.sigmaerpdev2__Unit_of_Measure__c=='' || recipdData.sigmaerpdev2__Unit_of_Measure__c==null || recipdData.sigmaerpdev2__Unit_of_Measure__c==undefined)
        {
            component.set("v.message",'Product UOM is mandatory');
            component.set("v.showMessage",true);
            return; 
        }
        if(recipdData.sigmaerpdev2__Recipe_Type__c!='Raw Material' && recipdData.sigmaerpdev2__Recipe_Type__c!='Intermediate' && recipdData.sigmaerpdev2__Recipe_Type__c!='Finished')
        {
            component.set("v.message",'Please select the recipe type');
            component.set("v.showMessage",true);
            return; 
        }
        
        //added newly on 17/3/2020 to fix BUG-04204
        var recpIdEdited = component.get("v.recID");
        var selProd = component.get("v.recipeObject.sigmaerpdev2__Product__c");        
        if(recpIdEdited != '' && recpIdEdited != undefined){ //edit flow            
        	var action1 = component.get("c.checkProdAddedEditFlow");
            action1.setParams({
                recipeId : recpIdEdited,
                selProdId : selProd
            });
            action1.setCallback(this, function(response) {                
                var state = response.getState();
                var result = response.getReturnValue();               
                if(state === "SUCCESS") {
                    if(result == true){
                        component.set("v.message",'Selected product has already been added in Product Components / Packaging Materials.');
                        component.set("v.showMessage",true);
                        return;
                    }else{
                        var action = component.get("c.saveRecipeObject");
                        action.setParams({ recipe : JSON.stringify(component.get("v.recipeObject"))});
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var callEve = $A.get("e.c:RecipeManagementEvent");
                                callEve.setParams({
                                    "objectdata": response.getReturnValue(),"flag": "updaterecipelist"
                                });
                                callEve.fire();
                                component.find("popupmodal").notifyClose();
                            }
                            else if (state === "INCOMPLETE") {
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
                    }                
                }
                else if (state === "INCOMPLETE") {
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
            $A.enqueueAction(action1);
            //ends here    
        }else{ //add flow            
        	var action = component.get("c.saveRecipeObject");
            action.setParams({ recipe : JSON.stringify(component.get("v.recipeObject"))});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var callEve = $A.get("e.c:RecipeManagementEvent");
                    callEve.setParams({
                        "objectdata": response.getReturnValue(),"flag": "updaterecipelist"
                    });
                    callEve.fire();
                    component.find("popupmodal").notifyClose();
                }
                else if (state === "INCOMPLETE") {
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
        }        
    },
    
    saveRecipeProds : function(component, event, helper){
        if(component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Product__c")==null || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Product__c")==undefined || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Product__c")=='')
        {
            component.set("v.message",'Please choose the product');
            component.set("v.showMessage",true);
            return;
        }
        if(component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Quantity__c")==null || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Quantity__c")==undefined || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Quantity__c")=='')
        {
            component.set("v.message",'Please enter the quantity');
            component.set("v.showMessage",true);
            return;
        } 
        
        if(component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Unit_of_Measure__c")==null || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Unit_of_Measure__c")==undefined || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Unit_of_Measure__c")=='')
        {
            component.set("v.message",'Product UOM is mandatory');
            component.set("v.showMessage",true);
            return;
        }
        component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Recipe__c",component.get("v.recipeID"));
        //component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Cost__c",component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Average_Buying_Price__c")*component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Quantity__c"));
        //alert('orig===='+component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Cost__c"));
        var cost = (component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Average_Buying_Price__c")) * 10000;
        
        if(cost == 0){
        	var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "Warning!",
                "message": "Average Buying Price is not set for the selected product."
            });
            toastEvent.fire();    
        }
        var qn = component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Quantity__c");        
        var finalPrice = (cost * qn) / 10000;
        
        //var srcVal = component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Cost__c").toString();        
        //var newVal = srcVal.substr(0,8);
        //var updatedVal = parseFloat(newVal);
        component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Cost__c", finalPrice);
                
        var action=component.get("c.saveRecipeProduct");
        action.setParams({recipeproduct : JSON.stringify(component.get("v.recipeProductsObject.recipeProduct")),
                          recordType : component.get("v.flag")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var callEve = $A.get("e.c:RecipeManagementEvent");
                callEve.setParams({
                    "objectdata": response.getReturnValue(),"flag": "refreshchild"
                });
                callEve.fire();
                component.find("popupmodal").notifyClose();
            }
            else if (state === "INCOMPLETE") {
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
    
    close : function(component)
    {
        component.find("popupmodal").notifyClose();
    },
    
    callChange : function(component)
    {
        var flg=component.get('v.flag');
        if((flg=='productcomponent' || flg=='additionalproduct' || flg=='packagingMaterial') && (component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Quantity__c")!=null || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Quantity__c")!=undefined || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Quantity__c")!=''))
        {
            component.set("v.message",null);
            component.set("v.showMessage",false);
        }
        else if(flg=='createrecipe' && (component.get("v.recipeObject.sigmaerpdev2__Quantity__c")!=null || component.get("v.recipeObject.sigmaerpdev2__Quantity__c")!=undefined || component.get("v.recipeObject.sigmaerpdev2__Quantity__c")!=''))
        {
            component.set("v.message",null);
            component.set("v.showMessage",false);
        }
            else if((flg=='MRadditionalproduct' || flg=='MRpackagingMaterial') && (component.get("v.MRProduct.sigmaerpdev2__Quantity__c")!=null || component.get("v.MRProduct.sigmaerpdev2__Quantity__c")!=undefined || component.get("v.MRProduct.sigmaerpdev2__Quantity__c")!=''))
            {
                component.set("v.message",null);
                component.set("v.showMessage",false);
            }
    },
    
    saveDependenetRecipe : function(component)
    {
        if(component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Dependent_Recipe__c")==null || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Dependent_Recipe__c")==undefined || component.get("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Dependent_Recipe__c")=='')
        {
            component.set("v.message",'Please choose the dependent recipe');
            component.set("v.showMessage",true);
            return;
        }
        
        component.set("v.recipeProductsObject.recipeProduct.sigmaerpdev2__Recipe__c",component.get("v.recipeID"));
        var callAction = component.get("c.saveRecipeProduct");
        callAction.setParams({recipeproduct:JSON.stringify(component.get("v.recipeProductsObject")),
                              recordType:component.get("v.flag")});
        callAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var callEve = $A.get("e.c:RecipeManagementEvent");
                callEve.setParams({
                    "objectdata": response.getReturnValue(),"flag": "refreshchild"
                });
                callEve.fire();
                component.find("popupmodal").notifyClose();
            }
            else if (state === "INCOMPLETE") {
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
        $A.enqueueAction(callAction);
    },
    
    getDetails : function(component)
    {
        if(component.get("v.Edit")==undefined)
            component.set("v.Edit",false);

        if(component.get("v.recID")!=null && component.get("v.recID")!=undefined && component.get("v.recID")!='')
        {
            if(component.get("v.flag")=='addrecipes' || component.get("v.flag")=='productcomponent' || component.get("v.flag")=='additionalproduct' || component.get("v.flag")=='packagingMaterial')
            {
                var action = component.get("c.getRecordInfo");
                action.setParams({ recID : component.get("v.recID")});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.recipeProductsObject.recipeProduct",response.getReturnValue());
                        component.set("v.recipeProductsObject.oldID",response.getReturnValue().sigmaerpdev2__Product__c);
                    }
                    else if (state === "INCOMPLETE") {
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
            }
            else if(component.get("v.flag")=='createrecipe')
            {
                var action = component.get("c.getRecipeRecord");
                action.setParams({ recID : component.get("v.recID")});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.recipeObject",response.getReturnValue());
                    }
                    else if (state === "INCOMPLETE") {
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
            }
        }
        
        if(component.get("v.Edit")==true && (component.get("v.flag")=='MRadditionalproduct' || component.get("v.flag")=='MRpackagingMaterial'))
        {
            component.set("v.MRProduct.sigmaerpdev2__Product__r.Name",component.get("v.Editingdata.ProductName"));
            component.set("v.MRProduct.sigmaerpdev2__Product__c",component.get("v.Editingdata.productID"));
            component.set("v.MRProduct.sigmaerpdev2__Description__c",component.get("v.Editingdata.Description"));
            component.set("v.MRProduct.sigmaerpdev2__Quantity__c",component.get("v.Editingdata.Quantity"));
            component.set("v.MRProduct.sigmaerpdev2__Unit_of_measure__c",component.get("v.Editingdata.UnityOfMeasure"));
        }
    },
    
    saveMRProds : function(component, event, helper)
    {        
        var saveData=component.get("v.MRProduct");
        
        //added newly on 19/2/2020 to restrict adding Manf. Prod as Packaging Material.
        var mrProd = component.get("v.mrProdProductId");        
        if(saveData.sigmaerpdev2__Product__c == mrProd)
        {
            component.set("v.message",'Manufacturing Product cannot be added as a Packaging Material.');
            component.set("v.showMessage",true);
            return;
        }
        //ends here 
        
        if(saveData.sigmaerpdev2__Product__c=='' || saveData.sigmaerpdev2__Product__c==null || saveData.sigmaerpdev2__Product__c==undefined)
        {
            component.set("v.message",'Please choose the product');
            component.set("v.showMessage",true);
            return;
        }
        
        
        if(saveData.sigmaerpdev2__Product__c=='' || saveData.sigmaerpdev2__Product__c==null || saveData.sigmaerpdev2__Product__c==undefined)
        {
            component.set("v.message",'Please choose the product');
            component.set("v.showMessage",true);
            return;
        }
        if(saveData.sigmaerpdev2__Unit_of_measure__c=='' || saveData.sigmaerpdev2__Unit_of_measure__c==null || saveData.sigmaerpdev2__Unit_of_measure__c==undefined)
        {
            component.set("v.message",'Product UOM is mandatory');
            component.set("v.showMessage",true);
            return;
        }
        if(saveData.sigmaerpdev2__Quantity__c=='' || saveData.sigmaerpdev2__Quantity__c==null || saveData.sigmaerpdev2__Quantity__c==undefined)
        {
            component.set("v.message",'Please enter the quantity');
            component.set("v.showMessage",true);
            return;
        }
        
        var action = component.get("c.getProductDetails");   
        //action.setParams({"prodID":saveData.sigmaerpdev2__Product__c,"recID":component.get("v.companyID"),"decider":true});       
        action.setParams({"prodID":saveData.sigmaerpdev2__Product__c,"decider":true});       
        action.setCallback(this,function(response) {
            var state = response.getState();
            var resp = response.getReturnValue();
            console.log('resp==='+JSON.stringify(resp));
            var flg=component.get("v.flag");
            var decider;
            var isproductChanged=false;
            var oldProdID;
            
            if(flg=='MRadditionalproduct')
                decider='updateExtraProdList';
            else if(flg=='MRpackagingMaterial')
                decider='updateProdMatList';
            
            if(component.get("v.Edit")==true)
            {
                if(component.get("v.Editingdata.productID")==saveData.sigmaerpdev2__Product__c)
                    isproductChanged=false;
                else if(component.get("v.Editingdata.productID")!=saveData.sigmaerpdev2__Product__c)
                    isproductChanged=true;
            }
            
            if (state === "SUCCESS") {
                var prodMatData=component.get("v.data");
                
                prodMatData.ProdID=saveData.sigmaerpdev2__Product__c;
                prodMatData.ProdName = response.getReturnValue().product.Name;
                
                var avgCost = response.getReturnValue().ProductPrice;
                if(avgCost == 0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "warning",
                        "title": "Warning!",
                        "message": "Average Buying Price is not set for the selected product."
                    });
                    toastEvent.fire();    
                }
                
                prodMatData.UnitPrice = (response.getReturnValue().ProductPrice*saveData.sigmaerpdev2__Quantity__c).toFixed(2);
                prodMatData.ModifiedQuantity = saveData.sigmaerpdev2__Quantity__c;
                prodMatData.ModifiedUnitPrice = (response.getReturnValue().ProductPrice*saveData.sigmaerpdev2__Quantity__c).toFixed(2);
                //prodMatData.StockItem = response.getReturnValue().product.s2cor__Stock_Item__c;
                prodMatData.StockItem = response.getReturnValue().product.sigmaerpdev2__Stock_Item__c;                
                prodMatData.UnityOfMeasure = response.getReturnValue().product.sigmaerpdev2__Product_UOM__c;
                prodMatData.Quantity=saveData.sigmaerpdev2__Quantity__c;
                if(component.get("v.Edit")==true)
                    prodMatData.oldProdID=component.get("v.Editingdata.oldProductID");
                //console.log('stock item==='+response.getReturnValue().product.s2cor__Stock_Item__c);
                component.set('v.data', prodMatData);
                
                var ManufactureApplicationEvent = $A.get("e.c:ManufactureApplicationEvent");
                ManufactureApplicationEvent.setParams({
                    "data": component.get('v.data'),"flag": decider,"Edit":component.get("v.Edit"),"isprodChanged":isproductChanged
                });
                ManufactureApplicationEvent.fire();
                component.find("popupmodal").notifyClose();
            }
            
            else if (state === "INCOMPLETE") {
            }else if (state === "ERROR") {
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
    }   
})