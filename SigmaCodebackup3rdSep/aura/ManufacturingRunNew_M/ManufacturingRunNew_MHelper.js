({
    calculateRecipeH : function(cmp, event, helper) {
       // cmp.set("v.isAddResources",true); 
        var ManufacRunObj = cmp.get("v.ManufacRunObj");        
        var manfID = '';
        if(ManufacRunObj.Id != ''){
            manfID = ManufacRunObj.Id;
        }  
        /*var companyId = '';
        if(cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != '' && cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != undefined)            
            companyId = cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c");
        else
            companyId = cmp.get("v.compName"); */
        
        if(ManufacRunObj.sigmaerpdev2__Manufacturing_Name__c == '' || ManufacRunObj.sigmaerpdev2__Product__c == '' || ManufacRunObj.sigmaerpdev2__Status__c == '' || ManufacRunObj.sigmaerpdev2__Run_Date__c == '' || ManufacRunObj.sigmaerpdev2__Recipe__c == '' || ManufacRunObj.sigmaerpdev2__Required_Quantity__c == '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": "Fill all the mandatory fields."
            });
            toastEvent.fire();
            return;
        }
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var action = cmp.get('c.calculateMan');
        action.setParams({ recipeID : ManufacRunObj.sigmaerpdev2__Recipe__c,
                          selectedQuantity : ManufacRunObj.sigmaerpdev2__Required_Quantity__c,
                          manfId : manfID});
        //action.setParams({ recipeID : ManufacRunObj.sigmaerpdev2__Recipe__c,selectedQuantity : ManufacRunObj.sigmaerpdev2__Required_Quantity__c, manfId : ManufacRunObj.Id});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();            
            if (state === "SUCCESS") {
                cmp.set("v.isResult",true);
                cmp.set('v.manufacturingRunDetails', response.getReturnValue());
                var saveManuRun = cmp.find("saveManuRun");
                if(ManufacRunObj.Id == '') //enable save button only during add flow                	
                    $A.util.removeClass(saveManuRun, "slds-hide");    
                else
                    $A.util.addClass(saveManuRun, "slds-hide");                    
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            var spinner = cmp.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        }));
        $A.enqueueAction(action);
    },
    
    saveManuRunH : function(cmp, event, helper) {
        var fullDataList = cmp.get("v.manufacturingRunDetails");
        var ManufacRunObj = cmp.get("v.ManufacRunObj");        
        var action = cmp.get('c.saveManufacturingRun');       
        
        action.setParams({ data : JSON.stringify(fullDataList),
                          manfacData : JSON.stringify(ManufacRunObj)});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState(); 
            //alert('state=='+state);
            if (state === "SUCCESS") {                
                if(response.getReturnValue().message == 'success')
                {                  
                    cmp.set('v.ManufacRunObj',response.getReturnValue().mr);                    
                    cmp.set('v.isDataChanged',false);     
                    cmp.set("v.isAddResources",true); // enables Add resource 4-02-2020
                    var saveManuRun = cmp.find("saveManuRun");
                    var updateManuRun = cmp.find("updateManuRun");
                    $A.util.removeClass(updateManuRun, "slds-hide");
                    $A.util.addClass(saveManuRun, "slds-hide");
                    var skipAllocationProcess = cmp.find("selectorBox").get("v.value");
                    if(skipAllocationProcess == false){                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Success!",
                            "message": "Manufacturing Run record saved successfully!"
                        });
                        toastEvent.fire();
                    }else{ //reserve the stock automatically based on the skip allocation process toggle button
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Success!",
                            "message": "Manufacturing Run record saved successfully!"
                        });
                        toastEvent.fire();
                        helper.AutoReserveStock(cmp, event, helper);   
                    }                                        
                }else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": response.getReturnValue()
                    });
                    toastEvent.fire();
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            var spinner = cmp.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        }));
        $A.enqueueAction(action);        
    },    
    
    AutoReserveStock : function(component, event, helper){
        var fromSkipAllocFlow = false;
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var ManufacRunObj = component.get("v.ManufacRunObj");        
        var manRunID = component.get("v.ManufacRunObj.Id");
        var skipAllocationProcess = component.find("selectorBox").get("v.value");        
        if(skipAllocationProcess == true){
            fromSkipAllocFlow = true;
                            
            var action2 = component.get("c.AutoReserveStockForManufactureRun");
            action2.setParams({        	         
                "manRunID" : manRunID,
                "manufactureRunObj" : ManufacRunObj,
                "data" : JSON.stringify(component.get("v.manufacturingRunDetails")),
                "fromSkipAllocFlow" : fromSkipAllocFlow
            });
            action2.setCallback(this, function(response1){
                var responseState = response1.getState();
                var state = response1.getReturnValue();             
                var res = state.split("_"); 
                if(state == 'true'){ 
                    component.set("v.isStockReserved",true);                
                    component.set("v.isAddResources",true); 
                    var calcRunDisb = component.find("calcRun");                    
                    calcRunDisb.set("v.disabled",true); //added on 2/8/2018
                    
                    
                    //commented above section and added below two lines on 3/4/2020 
                    //to restrict changing to status to produced - to make the changes as suggested by QA                
                    component.set('v.status','Stock Reserved');
                    component.set('v.ManufacRunObj.sigmaerpdev2__Status__c','Stock Reserved');
                    //ends here                
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Stock required for this recipe has been auto reserved successfully."
                    });
                    toastEvent.fire();
                    
                    var action12 = component.get("c.fetchUnitPrice");
                    action12.setParams({					
                        "manfRunId": component.get("v.ManufacRunObj.Id")
                    });
                    action12.setCallback(this, function (response11) {
                        var response = response11.getReturnValue();                                        
                        component.set("v.ManufacRunObj.sigmaerpdev2__Unit_Price__c",response.sigmaerpdev2__Unit_Price__c);                    
                        component.set("v.ManufacRunObj.sigmaerpdev2__Total_Cost__c",response.sigmaerpdev2__Total_Cost__c);                    
                    });
                    $A.enqueueAction(action12);				
                }else if(res[0] == 'false'){
                    component.set("v.isStockReserved",false);  //added on 2/8/2018
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Stock quantity is low for the Product(s) '"+res[1]+"'. System cannot continue with the Auto Reserve-Stock process."                    
                    });
                    toastEvent.fire();
                }else if(responseState == "ERROR"){                             
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Error occured : "+JSON.stringify(Error)
                    });
                    toastEvent.fire();
                }
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
            });        
            $A.enqueueAction(action2);
            //ends here            
        }          
    },
    
    editManufRunH : function(cmp, event, helper) {                	
        var saveManuRun = cmp.find("saveManuRun");
        var updateManuRun = cmp.find("updateManuRun");
        $A.util.removeClass(updateManuRun, "slds-hide");
        $A.util.addClass(saveManuRun, "slds-hide");
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var recID = event.getParam("recID");                
        var action = cmp.get('c.editManufac');
        action.setParams({
            recordID : recID
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();			            
            if (state === "SUCCESS") {
                //added on 11/4/2019 
                //code added to Display Resourcces in MR Edit Flow For Gantt purpose---Starts here-----
                cmp.set('v.isAddResources', true);// enables Add resource 4-02-2020
                var res = response.getReturnValue();
                cmp.set("v.resourceList", res.manfRunResList); 
                //code added to Display Resourcces in MR Edit Flow For Gantt purpose---Ends here-----
                cmp.set("v.prodName", response.getReturnValue().manfRun.sigmaerpdev2__Product__r.Name);                
                //ends here
                cmp.set('v.manufacturingRunDetails', response.getReturnValue());                
                if(response.getReturnValue().manfRun != null){                     
                    cmp.set('v.ManufacRunObj', response.getReturnValue().manfRun);                    
                }              
                
                //cmp.set("v.compName",response.getReturnValue().manfRun.sigmaerpdev2__Company__c); 
                //cmp.set("v.ManufacRunObj.sigmaerpdev2__Company__c",cmp.get("v.compName"));
                //cmp.find("compNameId").set("v.value",cmp.get("v.compName")); 
                
                cmp.set('v.status',response.getReturnValue().manfRun.sigmaerpdev2__Status__c);                                
                cmp.set("v.ManufacRunObj.sigmaerpdev2__Recipe__c", response.getReturnValue().manfRun.sigmaerpdev2__Recipe__c);
                cmp.set("v.recipeName", response.getReturnValue().manfRun.sigmaerpdev2__Recipe__r.Name);
                if(response.getReturnValue().manfRun.sigmaerpdev2__Status__c == 'Stock Reserved' || response.getReturnValue().manfRun.sigmaerpdev2__Status__c == 'Produced')
                {
                    cmp.set("v.isStockReserved",true);
                    
                    var calcRunDisb = cmp.find("calcRun");
                    calcRunDisb.set("v.disabled",true); 
                }                
                cmp.set("v.isResult",true);                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            var spinner = cmp.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        }));
        $A.enqueueAction(action);        
    },
    
    
    updateManuRunH : function(cmp, event, helper) {
        var stockReserved = cmp.get("v.isStockReserved");  
        var skipAllocationProcess = false;                 
        
        //the above section has been replaced with the below line to fix component error during update[if status selected to Stock Reserved without actually reserving stock and then pressing update.]
        skipAllocationProcess = cmp.get("v.autoAllocFlag"); 
        
        var fullDataList = cmp.get("v.manufacturingRunDetails");
        var ManufacRunObj = cmp.get("v.ManufacRunObj");
        //  var resourceList = cmp.get("v.resourceList");
        //  alert('resourceList-->'+JSON.stringify(resourceList));
        var action = cmp.get('c.updateManufacturingRun');        
        action.setParams({
            data : JSON.stringify(fullDataList),
            manfacData : JSON.stringify(ManufacRunObj),
            // resData : JSON.stringify(resourceList),
            resvFlg : stockReserved
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();            
            if(state === "SUCCESS"){
                if(response.getReturnValue().message == 'success')
                {                    
                    cmp.set('v.isDataChanged',false);
                    cmp.set('v.isAddResources', true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Updated Successfully."
                    });
                    toastEvent.fire();
                    if(stockReserved == false && skipAllocationProcess == true){
                        helper.AutoReserveStock(cmp, event, helper);    
                    }
                }else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": response.getReturnValue()
                    });
                    toastEvent.fire();
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            var spinner = cmp.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        }));
        $A.enqueueAction(action);        
    },    
    
    addPackagingMaterialsH: function(cmp, event, helper,header,flag,MRid,Edit,info) {        
        var mrProdId = cmp.get("v.ManufacRunObj.sigmaerpdev2__Product__c");
        var modalBody;        
        $A.createComponent("c:AddRecipeComponents", 
                           {
                               "flag":flag,"MRobjectID":MRid,"Edit":Edit,"Editingdata":info,
                               "mrProdProductId" : mrProdId 
                           },
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;                                   
                                   cmp.find('popupmodal').showCustomModal({
                                       header: header,
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "mymodal"
                                   })                                   
                               }                               
                           });
    },
    addResourcesH: function(cmp, event, helper,MRid,Edit,info) {  
        var modalBody;   
      
        
        $A.createComponent("c:AddResources",{ 
            // "flag":flag,
            "MRResID":MRid, 
            "Edit":Edit,
            "Editingdata":info
        },
       
                           
                           function(content, status,errorMessage) {
                               
                               if (status == "SUCCESS") {
								   modalBody = content;                                   
                                   cmp.find('popupmodal1').showCustomModal({
                                       //header: header,
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "mymodal"
                                   })                                   
                               } 
                               else if (status == "ERROR") {
                                   console.log("Error: " + errorMessage);
                                   // Show error message
                               }
                           });
        
    },
    
    updateExtraProdList: function(cmp, event, helper) {
        var data = event.getParam("data");
        var Editing = event.getParam("Edit");
        var prdChange = event.getParam("isprodChanged");
        var addProddata = cmp.get("v.manufacturingRunDetails.AdditionalProductList");
        var alreadyExists = false;
        var newlySelProdID = data.ProdID;
        var msg = '';
        if(Editing==true && prdChange==false)
        {
            var pkgAddData=cmp.get("v.manufacturingRunDetails.AdditionalProductList");
            for(var i=0;i<pkgAddData.length;i++)
            {
                if(pkgAddData[i].ProdID==newlySelProdID)
                {
                    pkgAddData[i].Description=data.Description;
                    pkgAddData[i].Quantity=data.Quantity;
                    pkgAddData[i].UnitPrice=data.UnitPrice;
                }
            }
            cmp.set("v.manufacturingRunDetails.AdditionalProductList",pkgAddData);
        }
        else if((Editing==true && prdChange==true) || Editing==false)
        {
            var prodList = cmp.get("v.manufacturingRunDetails.productCompList");
            for(var i=0;i<prodList.length;i++){
                if(newlySelProdID == prodList[i].ProdID){
                    alreadyExists = true; 
                    msg = 'Selected Product has already been added in Product Components.Cannot be added again.';
                }
            }
            var addProdList = cmp.get("v.manufacturingRunDetails.AdditionalProductList");
            for(var i=0;i<addProdList.length;i++){
                if(newlySelProdID == addProdList[i].ProdID){
                    alreadyExists = true;  
                    msg = 'Selected Product has already been added.Cannot be added again.';
                }
            }
            var packMatList = cmp.get("v.manufacturingRunDetails.packagingMatList");
            for(var i=0;i<packMatList.length;i++){
                if(newlySelProdID == packMatList[i].ProdID){
                    alreadyExists = true;
                    msg = 'Selected Product has already been added in Packaging Materials.Cannot be added again.';
                }
            }        
            if(alreadyExists){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"warning",
                    "title": "Warning!",
                    "message": msg
                });
                toastEvent.fire();
                return;    
            }
            else{
                if(Editing==true && prdChange==true)
                {
                    var pkgMatData=cmp.get("v.manufacturingRunDetails.AdditionalProductList");
                    for(var i=0;i<pkgMatData.length;i++)
                    {
                        if(pkgMatData[i].ProdID==data.oldProdID)
                        {
                            pkgMatData[i].ProdName=data.ProdName;
                            pkgMatData[i].ProdID=newlySelProdID;
                            pkgMatData[i].Description=data.Description; 
                            pkgMatData[i].Quantity=data.Quantity;
                            pkgMatData[i].UnitPrice=data.UnitPrice;
                        }
                    }
                    cmp.set("v.manufacturingRunDetails.AdditionalProductList",pkgMatData);
                }
                else if(Editing==false)
                {
                    addProddata.push(data);
                    cmp.set("v.manufacturingRunDetails.AdditionalProductList",addProddata); 
                }
            } 
        }
    },
    
    updateProdMatList: function(cmp, event, helper) {            
        var data = event.getParam("data");
        var Editing = event.getParam("Edit");
        var prdChange = event.getParam("isprodChanged");
        var newlySelProdID = data.ProdID;
        var alreadyExists = false;
        var msg = '';
        if(Editing==true && prdChange==false)
        {
            var pkgMatData=cmp.get("v.manufacturingRunDetails.packagingMatList");
            for(var i=0;i<pkgMatData.length;i++)
            {
                if(pkgMatData[i].ProdID==newlySelProdID)
                {
                    pkgMatData[i].Description=data.Description;
                    pkgMatData[i].Quantity=data.Quantity;
                    pkgMatData[i].UnitPrice=data.UnitPrice;                                        
                }
            }
            cmp.set("v.manufacturingRunDetails.packagingMatList",pkgMatData);
        }
        else if((Editing==true && prdChange==true) || Editing==false)
        {
            var prodList = cmp.get("v.manufacturingRunDetails.productCompList");
            for(var i=0;i<prodList.length;i++){
                if(newlySelProdID == prodList[i].ProdID){
                    alreadyExists = true; 
                    msg = 'Selected Product has already been added in Product Components.Cannot be added again.';
                }
            }
            var addProdList = cmp.get("v.manufacturingRunDetails.AdditionalProductList");
            for(var i=0;i<addProdList.length;i++){
                if(newlySelProdID == addProdList[i].ProdID){
                    alreadyExists = true;  
                    msg = 'Selected Product has already been added in Additional Products.Cannot be added again.';
                }
            }
            var packMatList = cmp.get("v.manufacturingRunDetails.packagingMatList");
            for(var i=0;i<packMatList.length;i++){
                if(newlySelProdID == packMatList[i].ProdID){
                    alreadyExists = true;
                    msg = 'Selected Product has already been added.Cannot be added again.';
                }
            }
            if(alreadyExists){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"warning",
                    "title": "Warning!",
                    "message": msg
                });
                toastEvent.fire();
                return;    
            }
            else{
                if(Editing==true && prdChange==true)
                {
                    var pkgMatData=cmp.get("v.manufacturingRunDetails.packagingMatList");
                    for(var i=0;i<pkgMatData.length;i++)
                    {
                        if(pkgMatData[i].ProdID==data.oldProdID)
                        {
                            pkgMatData[i].ProdName=data.ProdName;
                            pkgMatData[i].ProdID=newlySelProdID;
                            pkgMatData[i].Description=data.Description; 
                            pkgMatData[i].Quantity=data.Quantity;
                            pkgMatData[i].UnitPrice=data.UnitPrice;                            
                        }
                    }
                    cmp.set("v.manufacturingRunDetails.packagingMatList",pkgMatData);
                }
                else if(Editing==false)
                {
                    var prodmat = cmp.get("v.manufacturingRunDetails.packagingMatList");                                              
                    prodmat.push(data);
                    cmp.set("v.manufacturingRunDetails.packagingMatList",prodmat); 
                }
            }
        }
        
    },
    
    movementTabH: function(component, event, helper) {
        var status = component.get('v.ManufacRunObj.sigmaerpdev2__Status__c')           
        var mRid = component.get('v.ManufacRunObj');        
        var isStockResv = component.get("v.isStockReserved");         
        var msg = 'Reserve the Stock first before proceeding to Post Production activities.';
        var msg1 = 'Status should be Produced before proceeding to Post Production activities';
       
        //new code added on 23-8-2019 to handle autopicked stock revert when full stock reserve is not done yet.
        var valFromChild = component.get("v.orderItemNewFromChild");
        var autoPickedStock = false;
        if(valFromChild != null){
            var innerList = valFromChild[0].mainWrapProdList;        
            for(var i=0;i<innerList.length;i++){                            	
                if(innerList[i].allocatedViaAutopickOrManual == true){
                    autoPickedStock = true;    
                }                	              
            }    
        }        
        if(isStockResv == false && autoPickedStock == true){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": msg
            });
            toastEvent.fire();
            return;  //new code added on 23-8-2019 ends here
        }else{
            if(isStockResv == false){           
                if(status != 'Stock Reserved' || status != 'Produced'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"warning",
                        "title": "Warning!",
                        "message": msg1
                    });
                    toastEvent.fire();
                    component.set('v.ManufacRunObj.sigmaerpdev2__Status__c','Planning');
                    return;
                }
            }else if(isStockResv == true && status != 'Produced'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"warning",
                    "title": "Warning!",
                    "message": 'Status should be set to Produced before proceeding to Post Production activities.'
                });
                toastEvent.fire();                
                return;            
            }      
            
            //get the newly calculated unit price after editing reserved stock
            var action11 = component.get("c.fetchUnitPrice");
            action11.setParams({					
                "manfRunId": component.get("v.ManufacRunObj.Id")
            });
            action11.setCallback(this, function (response11) {
                var response = response11.getReturnValue();                        
                var perunitprice = response.sigmaerpdev2__Unit_Price__c;            
                if(perunitprice != undefined){
                    perunitprice = Number(perunitprice).toFixed(2);    
                }            
                component.set('v.unitPrice',perunitprice);            
                var totalCost = Number(response.sigmaerpdev2__Total_Cost__c).toFixed(4);   
                component.set('v.totalCost',totalCost);
                //commented below line to fix bug id -BUG-02777
                /*if(response11.getReturnValue().sigmaerpdev2__PI_updated__c == false)
                    component.set("v.ManufacRunObj.sigmaerpdev2__Produced_Quantity__c",response.sigmaerpdev2__Produced_Quantity__c); */           
                
            });
            $A.enqueueAction(action11);                        
            //ends here    
            
            var tab1 = component.find('calculationId');
            var TabOnedata = component.find('calTabDataId');
            
            var tab2 = component.find('ReserveId');
            var TabTwoData = component.find('reserveTabDataId');
            
            var tab3 = component.find('MovementId');
            var TabThreeData = component.find('movementTabDataId');
            
            //show and Activate Movement Tab
            $A.util.addClass(tab3, 'slds-active');
            $A.util.removeClass(TabThreeData, 'slds-hide');
            $A.util.addClass(TabThreeData, 'slds-show');
            
            // Hide and deactivate others tab
            $A.util.removeClass(tab1, 'slds-active');
            $A.util.removeClass(TabOnedata, 'slds-show');
            $A.util.addClass(TabOnedata, 'slds-hide');            
            $A.util.removeClass(tab2, 'slds-active');
            $A.util.removeClass(TabTwoData, 'slds-show');
            $A.util.addClass(TabTwoData, 'slds-hide');
            
            var saveManuRun = component.find("saveManuRun");
            var updateManuRun = component.find("updateManuRun");
            $A.util.addClass(saveManuRun, "slds-hide");
            $A.util.addClass(updateManuRun, "slds-hide");
        }
    },
    
    cancelMR : function(component, event, helper){
        var manRunID = component.get("v.ManufacRunObj.Id");
        var action = component.get('c.cancelManfRun');
        action.setParams({"manfRunId" : manRunID});
        action.setCallback(this, $A.getCallback(function (response) {
            var resp = response.getReturnValue();
            if(resp == true){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Manufacturing Run has been cancelled and its associated reserved stock has been reverted."
                });
                toastEvent.fire(); 
                $A.get('e.force:refreshView').fire();   
            }else if(resp == null){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"warning",
                    "title": "Warning!",
                    "message": "Error occured during cancellation of Manufacturing Run."
                });
                toastEvent.fire(); 
            }               
        }));            
        $A.enqueueAction(action);
    },
    
    deleteAddedProdH : function(component, event, helper, flag){
        var ManufacRunObj = component.get("v.ManufacRunObj");
        var prodId = event.target.id;		                
        var manfRunId = ManufacRunObj.Id;		
        if(flag == 'PackageMaterials'){
            var packMatList = component.get("v.manufacturingRunDetails.packagingMatList");            
            for(var i=0;i<packMatList.length;i++){			                
                if(prodId == packMatList[i].ProdID){
                    packMatList.splice(i,1);                    
                }
            }
            component.set("v.manufacturingRunDetails.packagingMatList", packMatList);            
        }else if(flag == 'AdditionalProd'){           
            var addProdList = component.get("v.manufacturingRunDetails.AdditionalProductList");          	
            for(var i=0;i<addProdList.length;i++){			                
                if(prodId == addProdList[i].ProdID){
                    addProdList.splice(i,1);                    
                }
            }
            component.set("v.manufacturingRunDetails.AdditionalProductList", addProdList);    
        }        
    },
     deleteAddedResH : function(component, event, helper){
        var ManufacRunObj = component.get("v.ManufacRunObj");
       	var resId =event.target.id;
        var manfRunId = ManufacRunObj.Id;		
        var addResList = component.get("v.resourceList");  
       
            for(var i=0;i<addResList.length;i++){	
                if(resId == addResList[i].Id){
                    addResList.splice(i,1);                    
                }
            }
            component.set("v.resourceList", addResList); 
            //alert('addResList-->'+ JSON.stringify(component.get("v.resourceList")));
         
            var action = component.get('c.deleteAllocResources');
            action.setParams({
                'resId' : resId,
                'manfRunId' : manfRunId
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();            
                if (state === "SUCCESS") {     
					component.set('v.resourceList', response.getReturnValue());                
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                    alert('error while refreshing tab'+JSON.stringify(errors));
                }
            }));
            $A.enqueueAction(action);
        
         
    },
    showDetailsTabH : function(component, event, helper){
        component.set('v.refreshResvStockTab', false);
        var status = component.get('v.status');
        if (status == 'Stock Reserved') {
            var updateManuRun = component.find("updateManuRun");
            $A.util.removeClass(updateManuRun, "slds-hide");
        }
        
        var tab1 = component.find('calculationId');
        var TabOnedata = component.find('calTabDataId');
        
        var tab2 = component.find('ReserveId');
        var TabTwoData = component.find('reserveTabDataId');
        
        var tab3 = component.find('MovementId');
        var TabThreeData = component.find('movementTabDataId');
        
        //show and Active details tab
        $A.util.addClass(tab1, 'slds-active');
        $A.util.addClass(TabOnedata, 'slds-show');
        $A.util.removeClass(TabOnedata, 'slds-hide');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        //added on 1/8/2019        
        var resvFlag = component.get("v.isStockReserved");
        if(resvFlag){
            var action = component.get('c.editManufac');
            action.setParams({
                recordID : component.get("v.ManufacRunObj.Id") 
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();            
                if (state === "SUCCESS") {                    
                    component.set('v.manufacturingRunDetails', response.getReturnValue());                
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                    alert('error while refreshing tab'+JSON.stringify(errors));
                }
            }));
            $A.enqueueAction(action);
        }
        //ends here
    },
    showResourcesH : function(component, event, helper){
		var ResourceAction = component.get("c.fetchMRResource");
        ResourceAction.setParams({					
            "manfRunId": component.get("v.ManufacRunObj.Id")
        });
        ResourceAction.setCallback(this, function (response) {
            var state = response.getState();	

            if(state == 'SUCCESS'){

                component.set("v.resourceList",response.getReturnValue());
                //alert('response.getReturnValue>>'+JSON.stringify(response.getReturnValue())); 
                
               /*     var sizeOfResourcesAdded = component.get("v.resourceList").length;
                    
                    var selNewResID = component.get("v.resourceList"); 
                    
                    if(sizeOfResourcesAdded>0)
                    {
                        for(var i=0;i<sizeOfResourcesAdded-1;i++)
                        {
                            for(var j=i+1;j<sizeOfResourcesAdded;j++)
                            {
                                if(selNewResID[i].sigmaerpdev2__Resource__c == selNewResID[j].sigmaerpdev2__Resource__c)
                                {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "type":"warning",
                                        "title": "warning!",
                                        "message": " Selected Resource already has been added to the Resource Planning."
                                    });
                                    toastEvent.fire(); 
									return;
                                }
                            }
                        }
                    }else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"warning",
                            "title": "Warning!",
                            "message": "Error occured during Adding Resource in Resource Planning."
                        });
                        toastEvent.fire(); 
                    }    */ 
                                       
            }else{
				var errors = response.getError();
                console.error(errors);
                alert('error while reverting auotpicked stock:'+JSON.stringify(errors));
                return;
            }                            
        });
        $A.enqueueAction(ResourceAction); 
        
    },
    getRecpProductH : function(component, event, helper){ 
        var ManufacRunId = component.get("v.ManufacRunObj.Id");        
        var recpId = component.get("v.ManufacRunObj.sigmaerpdev2__Recipe__c");
                
        
        	if(recpId != '' && recpId != undefined){
                var action = component.get('c.getProdFromRecp');
                action.setParams({
                    recpID : recpId 
                });
                action.setCallback(this, $A.getCallback(function (response) {
                    var state = response.getState();  
                    
                    if(state === "SUCCESS"){                                        
                        component.set('v.ManufacRunObj.sigmaerpdev2__Product__c', response.getReturnValue().product.Id);                                
                        component.set('v.prodName', response.getReturnValue().product.Name);
                    }else if(state === "ERROR"){
                        var errors = response.getError();                    
                        alert('error while getting product from recipe'+JSON.stringify(errors));
                    }
                }));
                $A.enqueueAction(action);    
            }else{
                component.set('v.ManufacRunObj.sigmaerpdev2__Product__c', "");                                
                component.set('v.prodName', "");
            }     
            
    }
    
})