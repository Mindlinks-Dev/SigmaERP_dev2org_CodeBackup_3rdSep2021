({
    doInit : function(component, event, helper) {
        
        var oneshotflag = component.get("v.isoneshot");
      
        // By-forgation in standard and custom setting by chandana 
		var ordertype = component.get("c.CheckOrder");
		ordertype.setCallback( this, function(response1) {
            var state = response1.getState();
             if (state === "SUCCESS") {
                var res = response1.getReturnValue();
                // alert('stand is true'+res);
                if(res.sigmaerpdev__Standard_object__c== true)
                {
                  //  alert('stand is true');
                    component.set("v.isStandardOrder",true);
                    //component.set("v.isoneshot",true);
                }
            }
        });
        $A.enqueueAction(ordertype);
        var standorderflag = component.get("v.isStandardOrder");
       // alert('OrderTypeusage>>>>'+standorderflag);
        //added on 5/1/2018 to stop same transaction from being selected twice        
        if(component.get("v.AddOrEditFlow") != undefined){
           var tempTransArray = [];                      
           var mainWrapperListVal = component.get("v.lineItemsLength");		
           for(var i=0;i<mainWrapperListVal.length;i++){
           	tempTransArray.push(mainWrapperListVal[i].transId); 
          } 
		   component.set("v.dupTransIdListFromEditFlow",tempTransArray);           
          //alert('tempTransArray::'+JSON.stringify(component.get("v.dupTransIdListFromEditFlow")));           	   
        }
        //ends here
        
        //added on 9/1/2018 to set orderline default status to "Ready" as per change request        
        var inputCmp = component.find("status");
        var value = inputCmp.get("v.value"); 
       
        if(component.get("v.AddOrEditFlow") == undefined && value == undefined){
            inputCmp.set("v.value",component.get("v.parentStatus"));        	
            value = inputCmp.get("v.value");
            component.set("v.productListNew1.status",value);
           
        }else if(component.get("v.AddOrEditFlow") != undefined){ 
            
            inputCmp.set("v.value",component.get("v.parentStatus"));
            value = inputCmp.get("v.value"); 
           
            component.set("v.productListNew1.status",value);
        }        
       //commented by chandana to remove the ready status in one shot flow  
         if(oneshotflag==true)
        {	
            component.set("v.status", 'Ready');
           // alert('status::'+JSON.stringify(component.get("v.status")));
            component.set("v.packageProduct.sigmaerpdev__Status__c",'Ready');
             //alert('status::'+JSON.stringify(component.get("v.packageProduct.sigmaerpdev__Status__c")));
             //component.set("v.productListNew1.status",'Ready');  
             //alert('status::'+JSON.stringify(component.get("v.productListNew1.status")));
           
            var z = component.get('c.SelectedID');
           	$A.enqueueAction(z);
            var action = component.get("c.getPackageProductStatus");
       		action.setCallback(this, function(a) {
            component.set("v.status", a.getReturnValue());
        });        
        $A.enqueueAction(action); 
        }
        else{
            var action = component.get("c.getPackageProductStatus");
            action.setCallback(this, function(a) 
            {
            	component.set("v.status", a.getReturnValue());
            });        
            $A.enqueueAction(action); 
        }
    },
    
    updateLocation : function(cop, event, helper)
    {
        var a = comp.find("index");  
       
    },
    getLocation : function(comp, event, helper) {
        
        var a = comp.find("idnx");
        //.get("v.value");
       
        if(a != undefined){
            var v = comp.get("v.productList");
            for(var i=0;i<a.length;i++){
               
                if(i == a[i].get("v.value")){
                    var obj = v[i];
                    obj.isselectedLoc = comp.find("statusss")[i].get("v.value");
                   
                }    
            }
        }else{
            var v = comp.get("v.productList");
            for(var i=0;i<v.length;i++){            
                
                var obj = v[i];
                if(v.length===1){
                	obj.isselectedLoc = comp.find("statusss").get("v.value");
                }
                else{
                    obj.isselectedLoc = comp.find("statusss")[i].get("v.value");
                }
                 
            }
        }  
      
        var appEvent = $A.get("e.c:packageViewEvent");
        appEvent.setParams({"productList" : comp.get("v.productList") });
        appEvent.fire();
       
         
     },
    
    
    getLocation1 : function(comp, event, helper) {
        var a = comp.find("inx");
      
        var v = comp.get("v.productList");
      
        for(var i=0;i<a.length;i++){ 
           
            if(i == a[i].get("v.value")){
               
                var obj = v[i];
              
                obj.isselectedLoc = comp.find("LocationId").get("v.value");
              
            }    
        }
       
        
    },
   
    getStatus :function(component, event){
       
         var oneshotflag = component.get("v.isoneshot");
    	var inputCmp = component.find("status");
        var value = inputCmp.get("v.value"); 
        component.find("status").set("v.value", value);
        component.set("v.productListNew1.status",value);  
        
    },    
    SelectedID : function(cmp, event) 
    {	
        
        var oneshotselectid=cmp.get("v.isoneshot");
        
        if(oneshotselectid==true)
        {
          var context = "MyOrder";
         
          var objectId = cmp.get("v.oneshotrecid");
          //cmp.set("v.customerId",objectId);
            //alert('objectId::'+objectId);
    	}
        else
        {
            var context = event.getParam("instanceId");
        	var objectId = event.getParam("sObjectId");     
        }
           
        cmp.set("v.selTransId",objectId); //used to pass transid to inner component - added on 3/12/2017
       
        var mainWrapperList = cmp.get("v.lineItemsLength");
        var transName = cmp.get("v.productListNew1.transName");
       
        var mainWrapperListVal = cmp.get("v.productListNew1.lineItemsList");
       
        var interimArray = new Array();   
        var initialArray;
        
        if(cmp.get("v.AddOrEditFlow") != undefined || cmp.get("v.AddOrEditFlow") != ""){  
            
           initialArray =  cmp.get("v.dupTransIdListFromEditFlow");
        }else{ 
        	initialArray = cmp.get("v.dupTransIdList");
            }
        //alert('initialArray@182::'+initialArray);
        var alreadySelected = false;
        if(initialArray.length == 0){ 
          
            interimArray.push(objectId);
            cmp.set("v.dupTransIdList",interimArray);
            
        }else if(mainWrapperList.length > 1){ 
            if(cmp.get("v.AddOrEditFlow") != undefined){
            	interimArray = cmp.get("v.dupTransIdListFromEditFlow");   
            }else{
                interimArray = cmp.get("v.dupTransIdList");  
            }
         //alert('interimArray @195::'+JSON.stringify(cmp.get(interimArray)));
            for(var i=0;i<interimArray.length;i++){				               
                if(objectId == interimArray[i]){
                  
                    alreadySelected = true;
                }
            }
            if(alreadySelected){                                
                            
                alert('Duplicate sigma Order found."SO-'+transName+'" has been selected more than once.');               
                return;

            }else{
                if(cmp.get("v.AddOrEditFlow") == undefined){
                   
                    
                    //commented following line on 8/2/2018 to avoid maximum call stack size exceeded error
                   
                    interimArray.push(objectId);                  
                    cmp.set("v.dupTransIdList",interimArray);
                   // alert('dupTransIdList in selectid@216::'+JSON.stringify(cmp.get("v.dupTransIdList")));
                }else if(cmp.get("v.AddOrEditFlow") != undefined){                                        
                    //commented following line on 8/2/2018 to avoid maximum call stack size exceeded error
                             
                    interimArray.push(objectId);
                    cmp.set("v.dupTransIdListFromEditFlow",interimArray); 
                    //alert('dupTransIdListFromEditFlow in selectid@222::'+JSON.stringify(cmp.get("v.dupTransIdListFromEditFlow")));
                }                 
            }			            
        }               
        //ends here
        
        //added to provide validation for sigma orders which have different shipping address and they are being used in the same package
        var stappOrderIdList = cmp.get("v.dupTransIdList");
      	if(cmp.get("v.AddOrEditFlow") != undefined){
        	stappOrderIdList = cmp.get("v.dupTransIdListFromEditFlow"); 
         }
        /*var action84 = cmp.get("c.validatAddress"); 
        action84.setParams ({  
                "stappId" : stappOrderIdList                             
            });
        action84.setCallback(this, function(a) {            
                if(a.getReturnValue() == null){                   
                    if(a.getReturnValue() == 'false'){                                                 
                        alert('Selected Sigma Orders shipment addresses are different.');
                        return;
                    }else{ 
					---------------------*/
                      var pack = cmp.get("v.packageProduct");
                     // alert('pack @227::'+JSON.stringify(cmp.get("v.packageProduct")));
                        if(context == "MyOrder"){
                            //alert('line 249=='+context);
                            var spinner = cmp.find('spinner');
                            $A.util.removeClass(spinner, "slds-hide");            
                            pack.sigmaerpdev__Sigma_Order__c = objectId;      
                           var OderName=cmp.get("v.OrderName");
                           //alert('context@229::'+JSON.stringify(cmp.get("v.OrderName")));
                            
                            cmp.set("v.productListNew1.transId",objectId); 
                            if(OderName != undefined)
                            {
                                 cmp.set("v.productListNew1.transName",OderName);
                            }
                            var localvar= cmp.get("v.isStandardOrder");
                           // alert('local var::'+localvar);
                            if(localvar == true)
                            {
                              var action = cmp.get("c.getstandPackageProductsForAutoPickOrManual"); //calling new autopick flow - added on 16/11/2017
                            action.setParams({ 
                                "orderId": objectId                
                            });            
                            action.setCallback( this, function(response) 
                                {
									
                                    var state = response.getState();
                                   
                                    var spinner = cmp.find('spinner');
                                    $A.util.addClass(spinner, "slds-hide");   
																
                                    cmp.set("v.productListNew1.lineItemsList",response.getReturnValue());
                                    console.log('in if 277=='+JSON.stringify(response.getReturnValue()));
                                    //alert('after altered class::'+JSON.stringify(cmp.get("v.productListNew1.lineItemsList",response.getReturnValue())))
                                    var pl = JSON.stringify(cmp.get("v.packageProduct"));
                                                                
                                    var spinner = cmp.find('spinner');
                                    $A.util.addClass(spinner, "slds-hide");
                                });            
                            $A.enqueueAction(action);  
                            }
                            else
                            {
                                var action = cmp.get("c.getPackageProductsForAutoPickOrManual"); //calling new autopick flow - added on 16/11/2017
                            action.setParams({ 
                                "orderId": objectId                
                            });            
                            action.setCallback( this, function(response) 
                                {
									
                                    var state = response.getState();
                                    var spinner = cmp.find('spinner');
                                    $A.util.addClass(spinner, "slds-hide");   
																
                                    cmp.set("v.productListNew1.lineItemsList",response.getReturnValue());
                                    console.log('in else 300=='+JSON.stringify(response.getReturnValue()));
                                   // alert('after altered class::'+JSON.stringify(cmp.get("v.productListNew1.lineItemsList",response.getReturnValue())))
                                    var pl = JSON.stringify(cmp.get("v.packageProduct"));
                                                                
                                    var spinner = cmp.find('spinner');
                                    $A.util.addClass(spinner, "slds-hide");
                                });            
                            $A.enqueueAction(action);
                            }
                        }  
/*-----------------------------------						
                    }//should remove
                }//should remove
        });//should remove
        $A.enqueueAction(action84);//should remove
        //ends here*/
               
    },
    getpackageDate : function(cmp, event){
      
        var pack = cmp.get("v.packageProduct");
        
        var dateField = cmp.find("packagedDate");
        var date = dateField.get("v.value");
       
        cmp.set("v.packageProduct.sigmaerpdev__Package_Date__c", date);
        pack.sigmaerpdev__Package_Date__c = date;
      
    },
    setLotValue : function(cmp, event){
        var pack = cmp.get("v.packageProduct");
        var lotId = event.getParam("LotId");
        var index = parseInt(event.getParam("index"));
       
        var a = cmp.find("lotId");
       
        if(a != undefined){
            var v = cmp.get("v.productList");
            for(var i=0;i<a.length;i++){
               
                if(i == index){
                    var obj = v[i];
                   
                    obj.lotId = lotId;
                   
                }    
            }
           
        }else{
            var v = cmp.get("v.productList");
            for(var i=0;i<v.length;i++){            
                if(i == index){
                    var obj = v[i];
                    obj.lotId = lotId;
                   
                }    
            }
           
        }
    },
    showOppmodal: function(component, event, helper) 
    {
        var self = this;  // safe reference
       
        var action = component.get("c.getSerialNumber");
        action.setParams({ "ProductId": PrdId, "ID" :'Test' });
        action.setCallback( this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            }
        });
        
        $A.enqueueAction(action);
        
        helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
        
    },
    hidePopup:function(component, event, helper)
    {
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--'); 
    },
    saveProductSerialNumber:function(component,event,helper)
    {
       
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');   
       
        
        
        
    },
    passingProdIdToVF : function(component, event, helper)
    {
        var prodList=component.get("v.productList.sigmaerpdev__Product__c");
      
    },
    openpopup: function(component, event, helper) {
        
        var index=event.currentTarget.name;
       
        var pl = component.get("v.productList");
        var pID=pl[index].orderLine.sigmaerpdev__Product__c;
        var pName=pl[index].orderLine.sigmaerpdev__Product__r.Name;
         var action = component.get("c.getInventoryId");
        action.setParams({ "prodId": pID });
        action.setCallback( this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var response= action.getReturnValue();
              
                component.set("v.InventoryID",response.Id);
               
                if(response!==null){
                  
                    helper.VBOMwindow(component, event, helper);
                }
                
            }
            else{
                //alert('Fail');
            }
        });
        
        $A.enqueueAction(action);
       
    },
    
    closeModel: function(component, event, helper) {    
        component.set("v.isOpen", false);       
    },
    getInvQuant:function(component, event, helper){
        
        var temp = event.getSource().get("v.name");
       
        var indexArray=[];
      
        var pl = component.get("v.productListNew1"); // new product list for autopick
       
        var pID=pl[temp].lineItemsList.prodId;        
       
        var pName=pl[temp].lineItemsList.prodName;        
        var pickQuant=pl[temp].orderLine.sigmaerpdev__Quantity__c;
        
        if(pl[temp].isSelected===true)
        {
            var action = component.get("c.getInventoryId");
            action.setParams({ "prodId": pID });
            action.setCallback( this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response= action.getReturnValue();
                    component.set("v.InventoryID",response.Id);
                   
                    component.set("v.InventoryQuant",response.sigmaerpdev__Available_Qty__c);
                    
                    if(response.sigmaerpdev__Available_Qty__c<0)
                    {	
                        var vbin =  component.get("v.VBOMIndex");
                        if(vbin != null || vbin != undefined)
                        {
                           
                            var flag =0;
                            for(var i=0;i<vbin.length;i++){
                                if(vbin[i]===temp){
                                    flag=1;
                                }
                            }
                            if(flag===0){
                                vbin.push(temp);
                                component.set("v.VBOMIndex",vbin);
                            }
                        }else
                        {
                            indexArray.push(temp);
                            component.set("v.VBOMIndex",indexArray);
                        }
                       
                    }
                }
                else{
                    //alert('Invntory is not less than zero');
                }
            });
            
            $A.enqueueAction(action);
            
        }
        else{
            //alert('Nothing');
        }
        
    },
    
    //added for select box popup
    onSelectChange : function(component, event, helper) {     
       
        var selected = event.getSource().get('v.value');        
        var res = selected.split("_");        
        var isMan = false;
        if(res[0] == 'Manual'){
            isMan = true; 
        }         
        component.set("v.isManual",isMan);        
		
        if(isMan){            			            
			helper.showPopupHelper(component, 'modaldialogFastEntry', 'slds-fade-in-'); 
            component.set("v.selTransLineItemId",res[1]);
           
            var spinner = component.find('spinner');
        	$A.util.addClass(spinner, "slds-hide");
        }        
		
    },
    //ends here
     handleSampleEvent : function(cmp,event,helper){                
        helper.hidePopupHelper(cmp,'modaldialogFastEntry', 'slds-fade-in-');
        helper.hidePopupHelper(cmp,'backdrop', 'slds-backdrop--');  
    },
   
    setStatusValueFromParentComp :function(cmp, event){
        var statusFromParent = event.getParam("statusFrmParent");        
        cmp.find("status").set("v.value", statusFromParent);
      	cmp.set("v.productListNew1.status",statusFromParent); 
    },
    
    makeStatusReadOnly : function(cmp, event){
       cmp.find("status").set("v.disabled", true);
    }
  
    
})