({
    doInit : function(component, event, helper)
    { 
        var action = component.get("c.getProducts");
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (state == 'SUCCESS')
                               {
                                   var prolist = response.getReturnValue();
                                   component.set('v.options',prolist);
                               }
                           });
        
        $A.enqueueAction(action); 
    },
    
    handleorderList : function(component, event, helper) {
        var orderinfo = event.getParam("orderinfo");
        var editIndex = event.getParam("rowIndex");
        var Promap=event.getParam("Promap");
        
        var maplist=component.get("v.Promap");
        //  component.set("v.orderline",orderinfo);
        
        
        var wrapperListInsertLineItems = component.get("v.wrapperListInsertLineItems");
        if(editIndex!=undefined)
        {
            // alert('inside');
            wrapperListInsertLineItems[editIndex]=orderinfo[0];
            maplist[editIndex]=Promap;
            component.set("v.wrapperListInsertLineItems",wrapperListInsertLineItems);
            component.set("v.Promap",maplist);
            
        }
        else
        { //alert('wrapperListInsertLineItems::11111111111'+wrapperListInsertLineItems);
            if(wrapperListInsertLineItems == '' || wrapperListInsertLineItems == 'undefined')
            {
                // alert('wrapperListInsertLineItems::'+JSON.stringify(wrapperListInsertLineItems));
                component.set("v.wrapperListInsertLineItems",orderinfo[0]);
                component.set("v.Promap",Promap);
            }else
            {
                var flag=true;
                for(var i=0;i<wrapperListInsertLineItems.length;i++)
                {
                    if(wrapperListInsertLineItems[i].LineItem.sigmaerpdev2__Product__c==orderinfo[0].LineItem.sigmaerpdev2__Product__c)
                    {
                        flag=false
                        wrapperListInsertLineItems[i]=orderinfo[0];
                        maplist[i]=Promap;
                    }
                }
                if(flag==true)
                {
                    wrapperListInsertLineItems.push(orderinfo[0]);
                    maplist.push(Promap);  
                }
                
                component.set("v.wrapperListInsertLineItems",wrapperListInsertLineItems);
                component.set("v.Promap",maplist);
            }
            
        }
        //alert('wrapperListInsertLineItems:::'+JSON.stringify(component.get("v.wrapperListInsertLineItems")));
        
    },
    changeDiscount : function(component, event, helper) {
        var discountMethodContent = component.find('discountMethodContent');
        $A.util.toggleClass(discountMethodContent, 'slds-hide');
        
    },
    onChange: function (cmp, evt, helper) {
        var selectedval=cmp.find('select').get('v.value');
        
    },
    handleShowModal : function(component,event,helper)
    {
        var DateIlp = component.get("v.DateIlp");
        //var selectedval=component.find('select').get('v.value');
        var selectedval = component.get("v.productId");
        
        if(selectedval == '' || selectedval == undefined || selectedval == null){ 
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Choose Product to be added.'); 
            return;             
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(DateIlp.sigmaerpdev2__Start_Date__c ==''){ 
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Select Start date.');
            return; 
            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(DateIlp.sigmaerpdev2__End_Date__c ==''){
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Select End date.');
            return; 
            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(DateIlp.sigmaerpdev2__Start_Date__c > DateIlp.sigmaerpdev2__End_Date__c)
        {
            component.set('v.isError', true);
            //component.set('v.errorMsg', 'Select valid Start date and End date.');
            component.set('v.errorMsg', 'Start date must be lesser than the End date.');
            return; 
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        //var proid=component.find('select').get('v.value');
      
        var action = component.get("c.productdetails");
        action.setParams({
            "Proid" : selectedval,
            "DateIlp" : DateIlp
        });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               
                               if (state == 'SUCCESS')
                               {
                                   var wraplist = response.getReturnValue();
                                   
                                   component.set('v.wrapper',wraplist);
                                   /* var wrapplist=component.get('v.wrapperList');
                                    alert("state:::"+JSON.stringify(wrapplist[0]));
                                    component.set('v.wrapper',wrapplist);
                                   alert("state11111:::"+JSON.stringify(component.get('v.wrapper')));
                                   */component.set("v.isOpen", true);
                                   
                               }
                           });
        
        $A.enqueueAction(action); 
        
        
    },
    handleClick : function(component,event,helper)
    {
        var rate_value;
          var wrapperListInsertLineItems=component.get("v.wrapperListInsertLineItems");
        var discountMethodContent = component.find('discountMethodContent');
       //  var wrapper = component.get("v.wrapper");        
       // alert('wrapper>>>'+JSON.stringify(wrapper));
        if(document.getElementById('radio-1').checked)
        {
            alert("Discount Method 'None' is applied.");
            rate_value = document.getElementById('radio-1').value; 
            for(var j=0;j<wrapperListInsertLineItems.length;j++)
            {
               
                if(wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c!= 0)
                {
                   
                    wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c=0;
                   //alert('discount'+ wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c); 
                }
                for(var i=0;i<wrapperListInsertLineItems[j].locqty.length;i++)
                {
                    if(wrapperListInsertLineItems[j].locqty[i].locdis!=0)
                    {
                        wrapperListInsertLineItems[j].locqty[i].locdis=0;
                    }
                }
               // alert('discountproduct'+ wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c);
			
            }
            $A.util.addClass(discountMethodContent, 'slds-hide');
            component.set("v.salesorderObject.sigmaerpdev2__Discount_Method__c", 'None');            
        }
        else if(document.getElementById('radio-2').checked)
        {
            alert("Discount Method 'Product' is applied.");
            rate_value = document.getElementById('radio-2').value;  
            for(var j=0;j<wrapperListInsertLineItems.length;j++)
            {
               
                for(var i=0;i<wrapperListInsertLineItems[j].locqty.length;i++)
                {
                    if(wrapperListInsertLineItems[j].locqty[i].locdis!=0)
                    {
                        wrapperListInsertLineItems[j].locqty[i].locdis=0;
                    }
                }
            }
            $A.util.addClass(discountMethodContent, 'slds-hide');
            component.set("v.salesorderObject.sigmaerpdev2__Discount_Method__c", 'Product');
        }
        else 
        {
            alert("Discount Method 'Location' is applied.");
            rate_value = document.getElementById('radio-3').value;  
             for(var j=0;j<wrapperListInsertLineItems.length;j++)
                {
                    if(wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c!= 0)
                    {
                        
                        wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c=0;
                        
                    }
                    
                }
                
            $A.util.addClass(discountMethodContent, 'slds-hide');
            component.set("v.salesorderObject.sigmaerpdev2__Discount_Method__c", 'Location');
        }
        component.set("v.disval", rate_value);        
    },
    handleAccountIdUpdate : function(cmp, event, helper) {
        var accountId = event.getParam("sObjectId");
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        if (instanceId === "Supplier,Vendor")
        {
            
            cmp.set('v.salesorderObject.sigmaerpdev2__AccountId__c',accountId);
            
        }else if(instanceId === "MyContact")
        {
            cmp.set('v.salesorderObject.sigmaerpdev2__BillingPersonNew__c', accountId);
            
        }
    },
    Save : function(component, event, helper)
    {
        var wrapperListInsertLineItems = component.get("v.wrapperListInsertLineItems");
        
        var salesorderObject = component.get("v.salesorderObject");
        if(salesorderObject.sigmaerpdev2__AccountId__c=='')
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Enter Customer.');
            return;  
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(salesorderObject.sigmaerpdev2__BillingPersonNew__c=='')
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Enter Billing Contact.');
            return;  
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(salesorderObject.sigmaerpdev2__Start_Date__c == '' || salesorderObject.sigmaerpdev2__End_Date__C == '' )
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Please select Order Start Date and End Date.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(salesorderObject.sigmaerpdev2__Start_Date__c >= salesorderObject.sigmaerpdev2__End_Date__C  )
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Order Start Date must be lesser than End Date.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(salesorderObject.sigmaerpdev2__Other_Discount__c<0)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Negetive values are not allowed in Other Discount.');
            return;  
        }
         else if(salesorderObject.sigmaerpdev2__Other_Charges__c<0)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Negetive values are not allowed in Other Charges.');
            return;  
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        
        
        
        if(wrapperListInsertLineItems.length<=0)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Choose Products and add line item to save an order.');
            return; 
            
        }else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        //alert('data>>'+JSON.stringify(wrapperListInsertLineItems));
        var action = component.get("c.SaveChange");
        action.setParams({
            "SalesOrderObject": salesorderObject,
            "orderline": JSON.stringify(wrapperListInsertLineItems)
        });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (state == 'SUCCESS')
                               {
                                   component.set("v.spinner",false);
                                   // var prolist = response.getReturnValue();
                                   //alert('record saved sucessfully');
                                   component.set("v.curRecordID",response.getReturnValue());
                                   
                                   if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one)) 
                                   {
                                       var successAlert = component.find("successAlert");
                                       $A.util.removeClass(successAlert,'slds-hide');
                                       // window.location.href = "/one/one.app#/sObject/" + a.getReturnValue();
                                       
                                   }
                                   else
                                   {
                                       alert('Record Saved Sucessfully');
                                       window.location.href = "/" + response.getReturnValue();
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
        component.set("v.spinner",true);
        $A.enqueueAction(action); 
    },
    cancelButton:function(cmp, event){ 
        //window.history.back();
        //window.location.reload();
        //commented above line and added below line on 3-2-2020 to show in ManufacturingModules page after delete is completed	    
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:SalesOrderModules",
            componentAttributes: {
                from : 'SigmaOrder'
            }
        });
        evt.fire();
        //ends here
    },
    recordCreatedOK: function(component, event, helper) 
    {
        sforce.one.navigateToSObject(component.get("v.curRecordID"));        
    },
    recordCreatedCancel: function(component, event, helper) 
    {
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');        
    },
    canceldiscount : function(component, event, helper)
    {
        var discountMethodContent = component.find('discountMethodContent');
        $A.util.addClass(discountMethodContent, 'slds-hide');
        
        document.getElementById('radio-1').checked=false;
        document.getElementById('radio-2').checked=false;
        document.getElementById('radio-3').checked=false;
        
    }
})