({
    loadPurchaseOrderDetails : function(cmp,event,purchaseOrderId)
    {
      //  alert('load pop');
        var action1 = cmp.get("c.getPODetails");
        action1.setParams
        ({
            "PurchaseOrderId" : purchaseOrderId
        });
        
        action1.setCallback(this, function(a1) 
                            {
                                
                                var savedOrderDetails1 = a1.getReturnValue();
                               //  alert('savedOrderDetails1'+JSON.stringify(savedOrderDetails1));
                              //   alert(JSON.stringify(savedOrderDetails1.sigmaerpdev2__Currency__r.Name));
                                cmp.set("v.NewPurchaseOrder.Name", savedOrderDetails1.Name); 
                               // cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Order_Date__c", savedOrderDetails1.sigmaerpdev2__Order_Date__c);  
                               // cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Expected_Date__c", savedOrderDetails1.sigmaerpdev2__Expected_Date__c);
                                cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Order_Date__c",' ');  
                                cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Expected_Date__c",' ');
                                cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Product_Supplier__c", savedOrderDetails1.sigmaerpdev2__Product_Supplier__r.Id);
                                cmp.set("v.vendorid", savedOrderDetails1.sigmaerpdev2__Product_Supplier__r.Id);
                                cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Approved__c", savedOrderDetails1.sigmaerpdev2__Approved__c);
                                cmp.set("v.NewPurchaseOrder.sigmaerpdev2__sub_Approval__c", savedOrderDetails1.sigmaerpdev2__sub_Approval__c);
                                cmp.set("v.NewPurchaseOrder.sigmaerpdev2__POSubmitted__c", savedOrderDetails1.sigmaerpdev2__POSubmitted__c);
                               // cmp.set("v.selectedStatus", savedOrderDetails1.sigmaerpdev2__Status__c);
                                cmp.set("v.selectedStatus", 'Open');
                                cmp.set("v.NewPurchaseOrder.Id",purchaseOrderId);
                                cmp.set("v.SupplierName", savedOrderDetails1.sigmaerpdev2__Product_Supplier__r.Name);
                                
                                if(savedOrderDetails1.sigmaerpdev2__Currency__c!=undefined || savedOrderDetails1.sigmaerpdev2__Currency__c!=null  )
                                {
                                    cmp.set("v.recordName1", savedOrderDetails1.sigmaerpdev2__Currency__r.sigmaerpdev2__Display_Name__c);
                                    cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Currency__c", savedOrderDetails1.sigmaerpdev2__Currency__c);
                                }                                
                                cmp.set("v.flag", true);
                                
                                var approval = cmp.set("v.Approved",savedOrderDetails1.sigmaerpdev2__Approved__c);
                                cmp.set("v.ReqApprov",savedOrderDetails1.sigmaerpdev2__sub_Approval__c);
                                
                                var flag= cmp.get("v.flag");
                                var status=cmp.get("v.selectedStatus");
                                var Approv =  savedOrderDetails1.sigmaerpdev2__Approved__c;
                                var ApprovReq = savedOrderDetails1.sigmaerpdev2__sub_Approval__c;
                               // var PoSubmitted = savedOrderDetails1.sigmaerpdev2__POSubmitted__c;
                                if(status!='Open'&& flag==true)
                                {
                                    var addPOrderitem = cmp.find("addPOrderitem");
                                     
                                    $A.util.addClass(addPOrderitem,'slds-hide');
                                }
                                if(Approv){
                                    var addPOrderitem = cmp.find("addPOrderitem");
                                     
                                    $A.util.addClass(addPOrderitem,'slds-hide');
                                }
                                if(ApprovReq){
                                    var addPOrderitem = cmp.find("addPOrderitem");
                                    
                                    $A.util.addClass(addPOrderitem,'slds-hide');
                                }
                              /*  if(PoSubmitted){
                                    var addPOrderitem = cmp.find("addPOrderitem");
                                    $A.util.addClass(addPOrderitem,'slds-hide');
                                }
                                */
                                this.loadPOStatus(cmp,event);
                            });
        $A.enqueueAction(action1);
        var action2 = cmp.get("c.editPackageProducts");
        action2.setParams
        ({
            "PurchaseOrderId1" : purchaseOrderId
        });
        action2.setCallback( this, function(a2) 
                            {
                                var state = a2.getState();
                                //alert('state>>>'+state);
                                if (state === "SUCCESS") 
                                {
                                    var resp = a2.getReturnValue();
                                    //alert('resp'+JSON.stringify(resp));
                                    var tempSIP = [];
                                    //alert('status>>>'+cmp.get("v.selectedStatus"));
                                    var status=cmp.get("v.selectedStatus");
                                    
                                    if(status=='Approved' || status=='Rejected' || status=='Open' || status=='Submitted') //status=='Submitted' added to show line item products in edit flow
                                    {
                                        for(var i=0;i<resp.length;i++)
                                        {
                                          // alert('resp>>>>>>>'+resp[i]);
                                            cmp.set("v.TempPurchaseOrderProducts",resp[i]);
                                            var sipIndiv = cmp.get("v.TempPurchaseOrderProducts");
                                           // console.log(JSON.stringify(sipIndiv));
                                            sipIndiv.Product_name = resp[i].sigmaerpdev2__Product__r.Name;
                                            sipIndiv.sigmaerpdev2__Buying_Price__c = resp[i].sigmaerpdev2__Buying_Price__c;
                                            sipIndiv.sigmaerpdev2__VendorPrice__c = resp[i].sigmaerpdev2__VendorPrice__c;
                                            sipIndiv.sigmaerpdev2__Total_Buying_Price__c = resp[i].sigmaerpdev2__Total_Buying_Price__c;
                                            sipIndiv.sigmaerpdev2__Expected_Delivery_Date__c = resp[i].sigmaerpdev2__Expected_Delivery_Date__c;
                                            sipIndiv.sigmaerpdev2__Quantity__c = resp[i].sigmaerpdev2__Quantity__c;
                                            //sipIndiv.sigmaerpdev2__Status__c = resp[i].sigmaerpdev2__Status__c;
                                            sipIndiv.sigmaerpdev2__Status__c = 'Open';
                                            sipIndiv.sigmaerpdev2__Discount__c = resp[i].sigmaerpdev2__Discount__c;
                                            tempSIP.push(sipIndiv);
                                        }
                                    }
                                    cmp.set("v.NewPurchaseOrderProducts", tempSIP);
                                    console.log(JSON.stringify(cmp.get("v.NewPurchaseOrderProducts")));
                                    cmp.set("v.IntialProductSize",cmp.get("v.NewPurchaseOrderProducts").length); 
                                }
                            });
        $A.enqueueAction(action2);
        
        var PurchaseOrderProductsList = cmp.get("v.NewPurchaseOrderProducts");
         //alert('PurchaseOrderProductsList--->'+PurchaseOrderProductsList);
        var len = PurchaseOrderProductsList.length;
        PurchaseOrderProductsList.push
        ({
            'sigmaerpdev2__Product__c':'',
            'sigmaerpdev2__Buying_Price__c':'',
            'sigmaerpdev2__Expected_Delivery_Date__c':'',
            'sigmaerpdev2__Quantity__c':'',
            'sigmaerpdev2__Status__c':''
        });
        cmp.set("v.NewPurchaseOrderProducts",PurchaseOrderProductsList);
        
    },
    viewProductHelper: function (component, event, helper,ind) {
      //  alert('calling viewProductHelper');
       // var prodId = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev__Product__c;
     //   alert('prodId>>>'+prodId);
     
        var action = component.get("c.getproductimage");
        action.setParams({
            "prodId": ind,
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState();
            //alert('state::'+state);
            if (state == "SUCCESS") {
                var productimage=a.getReturnValue();
                component.set('v.ProductImageData',productimage);
                component.set('v.productimageexist',true);
            }
           else
           {
             component.set('v.productimageexist',false); 
           }   
             component.set('v.ProductView',true);
        });
        $A.enqueueAction(action);
    },
    helperGetAccountDataobject : function (component, event, helper,accid)
    {
        var action = component.get("c.fetchPurchanse");
        
        action.setParams({
            "vendor": accid
        });	
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                if(a.getReturnValue()!=null)
                {
                    var accountaddress=a.getReturnValue();
                    //alert('accountaddress>>'+JSON.stringify(accountaddress));
                    if(accountaddress.sigmaerpdev2__Exchange_Currency__c !=null || accountaddress.sigmaerpdev2__Exchange_Currency__c!=undefined ){
                        //if(accountaddress.sigmaerpdev2__Exchange_Currency__r.sigmaerpdev2__Display_Name__c !=undefined)
                        component.set("v.recordName1",accountaddress.sigmaerpdev2__Exchange_Currency__r.sigmaerpdev2__Display_Name__c);
                        //alert(accountaddress.sigmaerpdev2__Exchange_Currency__c);
                        component.set("v.NewPurchaseOrder.sigmaerpdev2__Currency__c", accountaddress.sigmaerpdev2__Exchange_Currency__c);
                    }
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    loadPOStatus : function (cmp,event)
    {
        //code added by rashmi on 05-05-2020
        var CheckApprFlag = cmp.get("c.getApprDetails");
        CheckApprFlag.setCallback(this, function(a) {
            //alert('response>>'+a.getReturnValue().sigmaerpdev2__Approval_Process_Not_Needed__c);
            cmp.set("v.CheckAppflag",a.getReturnValue().sigmaerpdev2__Approval_Process_Not_Needed__c);
            //code ends here
            var action = cmp.get("c.getPOStatus");
            var inputsel = cmp.find("InputSelectDynamic");
            var opts=[];
            action.setCallback(this, function(a) 
                               {
                                   var savedOrderDetails = a.getReturnValue();
                                   //code added by rashmi on 05-05-2020
                                   if(cmp.get("v.CheckAppflag")!= true)
                                   {
                                       for(var i=0;i< savedOrderDetails.length;i++)
                                       {
                                           if((cmp.get("v.selectedStatus") == 'Approved' || cmp.get("v.selectedStatus") == 'Rejected' ) || (savedOrderDetails[i]!='Approved' && savedOrderDetails[i]!='Rejected'))
                                               opts.push({"class": "optionClass", label: savedOrderDetails[i], value: savedOrderDetails[i]});
                                       }
                                       inputsel.set("v.options", opts);
                                       cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Status__c","Open");
                                   }
                                   else{
                                       for(var i=0;i< savedOrderDetails.length;i++)
                                       {
                                           
                                           if((cmp.get("v.selectedStatus") == 'Open' || cmp.get("v.selectedStatus") == 'Closed' || cmp.get("v.selectedStatus")  == 'Approved' || cmp.get("v.selectedStatus")  == 'Rejected') || (savedOrderDetails[i]!='Open' && savedOrderDetails[i]!='Closed' && savedOrderDetails[i]!='Approved' && savedOrderDetails[i]!='Rejected' ))
                                               opts.push({"class": "optionClass", label: savedOrderDetails[i], value: savedOrderDetails[i]});
                                       }
                                       inputsel.set("v.options", opts);
                                       
                                       cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Status__c","Submitted");
                                       cmp.set("v.NewPurchaseOrder.sigmaerpdev2__POSubmitted__c",true);

                                   }
                                   //code ends here
                                   
                                   //cmp.set("v.NewPurchaseOrder.sigmaerpdev__Status__c","Approved");
                                   //cmp.set("v.NewPurchaseOrder.sigmaerpdev__Status__c","Rejected");
                               });
            $A.enqueueAction(action);
        });
        $A.enqueueAction(CheckApprFlag);
        // end   
    },
    createPO : function(component,event,purchaseOrderId)
    {
        component.set("v.NewPurchaseOrder.sigmaerpdev2__Status__c", component.get("v.selectedStatus"));
        
        
        var newPackage = component.get("v.NewPurchaseOrder");
        var purProduct = component.get("v.NewPurchaseOrderProducts");
        for(var i=0;i<purProduct.length;i++)
        {
            if(newPackage.sigmaerpdev2__Order_Date__c >=purProduct[i].sigmaerpdev2__Expected_Delivery_Date__c&&((newPackage.sigmaerpdev2__Order_Date__c !== '') &&(purProduct[i].sigmaerpdev2__Expected_Delivery_Date__c !== '')))
            {
                var msg = "Expected date should be greater than order date "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }
            else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
        }
        var action = component.get("c.CreatePO");
        
        action.setParams
        ({ 
            "POObject": newPackage,
            "POProductObject" : JSON.stringify(component.get("v.NewPurchaseOrderProducts"))//$A.util.json.encode(component.get("v.packageProducts"))
        });
        action.setCallback( this, function(a) 
                           {
                               var state = a.getState();
                               if (state === "SUCCESS") 
                               {
                                   
                                   component.set("v.curRecordID",a.getReturnValue());
                                   
                                   if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one)) 
                                   {
                                       var successAlert = component.find("successAlert");
                                       $A.util.removeClass(successAlert,'slds-hide');
                                       // window.location.href = "/one/one.app#/sObject/" + a.getReturnValue();
                                       window.setTimeout(
                                           $A.getCallback(function () {
                                               var successAlert = component.find("successAlert");
                                               $A.util.addClass(successAlert,'slds-hide');
                                               sforce.one.navigateToSObject(component.get("v.curRecordID")); 
                                           }), 2000
                                       );
                                   }
                                   else
                                   {
                                       
                                       //window.location.href = "/" + a.getReturnValue();
                                       //commented above line and added below lines on 6-2-2020 to show in PurchaseOrderModules page after record is saved	                                           
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"success",
                                           "title": "Success!",
                                           "message": "Purchase Order record saved successfully!"
                                       });
                                       toastEvent.fire();                                       
                                       
                                       var evt = $A.get("e.force:navigateToComponent");
                                       evt.setParams({
                                           componentDef : "c:PurachaseOrderModules",
                                           componentAttributes: {
                                               from : 'PO'
                                           }
                                       });
                                       evt.fire();
                                       //ends here
                                   }    
                               }
                               else
                               {
                                   var successAlert = component.find("successAlert");
                                   $A.util.removeClass(successAlert,'slds-hide');
                                   var successAlertTheme = component.find("successAlertTheme");
                                   $A.util.removeClass(successAlertTheme,'slds-theme--success');
                                   $A.util.addClass(successAlertTheme,'slds-theme--error');
                                   var iconsuccess=component.find("iconsuccess");
                                   $A.util.addClass(iconsuccess,'slds-hide');
                                   var iconwarning=component.find("iconwarning");
                                   $A.util.removeClass(iconwarning,'slds-hide');
                                   var recordCreatedHeader = component.find("recordCreatedHeader");
                                   $A.util.addClass(recordCreatedHeader,'slds-hide');
                                   var recordNotCreatedHeader = component.find("recordNotCreatedHeader");
                                   $A.util.removeClass(recordNotCreatedHeader,'slds-hide');
                                   var recordCreatedOK = component.find("recordCreatedOK");
                                   $A.util.addClass(recordCreatedOK,'slds-hide');
                                   var recordCreatedCancel = component.find("recordCreatedCancel");
                                   $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                               }
                           });
        $A.enqueueAction(action);
    },
    removeProductItem : function(component, index) 
    {
        var PurchaseOrderProductsList = component.get("v.NewPurchaseOrderProducts");
        PurchaseOrderProductsList.splice(index, 1);
        component.set("v.NewPurchaseOrderProducts", PurchaseOrderProductsList);
    },    
    UpdatePO : function (component,event,purchaseOrderId)
    {
        
        component.set("v.NewPurchaseOrder.sigmaerpdev2__Status__c", component.get("v.selectedStatus"));
        var newPackage = component.get("v.NewPurchaseOrder");
        var purProduct = component.get("v.NewPurchaseOrderProducts");
         // alert('inside edit flow>>'+ JSON.stringify(component.get("v.NewPurchaseOrder.sigmaerpdev2__Status__c")));
        for(var i=0;i<purProduct.length;i++)
        {
            if(newPackage.sigmaerpdev2__Order_Date__c >=purProduct[i].sigmaerpdev2__Expected_Delivery_Date__c&&((newPackage.sigmaerpdev2__Order_Date__c !== '') &&(purProduct[i].sigmaerpdev2__Expected_Delivery_Date__c !== '')))
            {
                var msg = "Expected Date Should be Greater than Order Date in the Line Item "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }
            else if(newPackage.sigmaerpdev2__Status__c=='Rejected')
            {
                var msg = "You can not edit the Purchase order once it is Approved and Submitted.";
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }
                else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                }
        }
        var action = component.get("c.UpdatePO");
        action.setParams
        ({ 
            "POObj": newPackage,
            "POProducts": JSON.stringify(component.get("v.NewPurchaseOrderProducts"))//$A.util.json.encode(component.get("v.packageProducts"))
        });
        action.setCallback( this, function(a) 
                           {
                               var state = a.getState();
                               if (state === "SUCCESS") 
                               {
                                   var tempPurchaseOrderId = component.get("v.Id");
                                   component.set("v.curRecordID",tempPurchaseOrderId);
                                   if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) 
                                   {
                                       var successAlert = component.find("successAlert");
                                       $A.util.removeClass(successAlert,'slds-hide');
                                       var recordCreatedHeader = component.find("recordCreatedHeader");
                                       $A.util.addClass(recordCreatedHeader,'slds-hide');
                                       var recordUpdtatedHeader = component.find("recordUpdtatedHeader");
                                       $A.util.removeClass(recordUpdtatedHeader,'slds-hide');
                                       
                                   }
                                   else
                                   {
                                       //window.location.href = "/" + tempPurchaseOrderId;
                                       //commented above line and added below lines on 6-2-2020 to show in PurchaseOrderModules UI page after record is updated	                                           
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"success",
                                           "title": "Success!",
                                           "message": "Purchase Order record updated successfully!"
                                       });
                                       toastEvent.fire();                                       
                                       
                                       var evt = $A.get("e.force:navigateToComponent");
                                       evt.setParams({
                                           componentDef : "sigmaerpdev:PurachaseOrderModules",
                                           componentAttributes: {
                                               from : 'PO'
                                           }
                                       });
                                       evt.fire();
                                       //ends here
                                   }    
                                   
                               }
                               else
                               {
                                   var successAlert = component.find("successAlert");
                                   $A.util.removeClass(successAlert,'slds-hide');
                                   var successAlertTheme = component.find("successAlertTheme");
                                   $A.util.removeClass(successAlertTheme,'slds-theme--success');
                                   $A.util.addClass(successAlertTheme,'slds-theme--error');
                                   var iconsuccess=component.find("iconsuccess");
                                   $A.util.addClass(iconsuccess,'slds-hide');
                                   var iconwarning=component.find("iconwarning");
                                   $A.util.removeClass(iconwarning,'slds-hide');
                                   var recordCreatedHeader = component.find("recordCreatedHeader");
                                   $A.util.addClass(recordCreatedHeader,'slds-hide');
                                   var recordNotUpdtatedHeader = component.find("recordNotUpdtatedHeader");
                                   $A.util.removeClass(recordNotUpdtatedHeader,'slds-hide');
                                   var recordCreatedOK = component.find("recordCreatedOK");
                                   $A.util.addClass(recordCreatedOK,'slds-hide');
                                   var recordCreatedCancel = component.find("recordCreatedCancel");
                                   $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                               }
                           });
        $A.enqueueAction(action);
    },
    /*viewProductHelper:function (component, event, helper,editIndex) {
      alert('calling viewProductHelper');
		  var purProduct = component.get("v.NewPurchaseOrderProducts");
        var prodId = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev2__Product__r.Name;
        component.set('v.ProductView',true);
       alert('prodId>>>'+prodId);
    
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
                alert('dataaaa'+JSON.stringify(component.get('v.ProductImageData')));
                
            }
             component.set('v.ProductView',true);
        });
        $A.enqueueAction(action);
    },*/
    
})