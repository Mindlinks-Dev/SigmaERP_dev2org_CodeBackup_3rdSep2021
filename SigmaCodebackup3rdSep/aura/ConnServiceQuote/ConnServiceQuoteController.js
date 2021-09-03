({
    doInit : function(component, event, helper) {
       
        var recordIdFromUi = component.get("v.recordId");
        var quote = component.get("v.proposalObject");
        var action = component.get("c.getProposalStatus");
        
        action.setCallback(this, function(a) 
        {
           
             component.set("v.status", a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        var action1 = component.get("c.getProducts");
         action1.setParams({
                "workorderid" : recordIdFromUi
            });
        action1.setCallback(this, function(response) 
                            {
                                var state = response.getState();
                                if (state == 'SUCCESS')
                                {
                                    var proposalObject = response.getReturnValue();
                                    if(proposalObject.sigmaerpdev2__Work_Order_Lines__r != undefined)
                                    {
                                    component.set('v.customername',proposalObject.sigmaerpdev2__Account__r.Name);
                                    component.set('v.workorder',proposalObject.Name);
                                  //  component.set('v.Asset',proposalObject.sigmaerpdev2__Asset__c);
                                     quote.sigmaerpdev2__Account__c=proposalObject.sigmaerpdev2__Account__c;
                                     quote.sigmaerpdev2__Work_Order__c=recordIdFromUi;
                                     component.set('v.proposalObject',quote);
                                     component.set('v.orderlinelist',proposalObject.sigmaerpdev2__Work_Order_Lines__r);   
                                    }
                                    else
                                    {
                                       
                                        component.set('v.istrue', true);
                                        component.set('v.mainerrorMsg', 'There is NO Product to Quote in the Work Order Line Item.');
                                       
                                               return; 
                                        
                                    }
                                  
                                   
                                }
                            });
        
        $A.enqueueAction(action1); 
       
    },
     saveStatus : function(cmp,event,helper)
    {
        cmp.set("v.proposalObject.sigmaerpdev2__Status__c",cmp.find("status").get("v.value")); 
    },
    handleorderList : function(component, event, helper) {
        var orderinfo = event.getParam("orderinfo");
        var editIndex = event.getParam("rowIndex");
        var wrapperListInsertLineItems = component.get("v.quotelinelist");
        if(editIndex!=undefined)
        {
            
            wrapperListInsertLineItems[editIndex]=orderinfo;
            component.set("v.quotelinelist",wrapperListInsertLineItems);
           
        }
        else
        { 
           
            if(wrapperListInsertLineItems == '' || wrapperListInsertLineItems == 'undefined')
            {
                
                component.set("v.quotelinelist",orderinfo);
              
            }else
            {
              var flag=true;
                for(var i=0;i<wrapperListInsertLineItems.length;i++)
                {
                     if(orderinfo.proname!=undefined ){
                        if(wrapperListInsertLineItems[i].proname==orderinfo.proname)
                    {
                         flag=false;
                        wrapperListInsertLineItems[i]=orderinfo;
                    
                    }
                    }
                    
                }
                if(flag==true)
                { 
                    
                    wrapperListInsertLineItems.push(orderinfo);
                 
                }
                
                component.set("v.quotelinelist",wrapperListInsertLineItems);
              }
            
        }
        
    },
    handleShowModal : function(component,event,helper)
    {
        
        var quoteline = component.get("v.quoteline");
        var orderlinelist = component.get("v.orderlinelist");
        var selectedval=component.find('select').get('v.value');
       
        if(selectedval ==''){ 
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Choose any product from the list');            
            return;
        }       
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
       	
        var proid=component.find('select').get('v.value');
        var custid=component.get("v.proposalObject.sigmaerpdev2__Account__c");
        var assetid=component.get("v.Asset");
        var action = component.get("c.quoteforproductdetails");
      	action.setParams({
            "Proid" : proid,
            "account" : custid,
            "assetid":assetid
         });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                              
                               if (state == 'SUCCESS')
                               {
                                   var wraplist = response.getReturnValue();
                                   for(var i=0;i<orderlinelist.length;i++)
                                       {
                                            
                                           if(orderlinelist[i].sigmaerpdev2__Product__c==proid)
                                            {
                                               quoteline.sigmaerpdev2__Product__c=orderlinelist[i].sigmaerpdev2__Product__c;
                                              quoteline.sigmaerpdev2__Quantity__c=orderlinelist[i].sigmaerpdev2__Quantity__c; 
                                              quoteline.sigmaerpdev2__Covered_under_Contract_Y_N__c=wraplist.sigmaerpdev2__Covered_under_Contract_Y_N__c; 
                                              if(quoteline.sigmaerpdev2__Covered_under_Contract_Y_N__c==true)
                                              {
                                                
                                                  quoteline.sigmaerpdev2__Unit_Price__c=0;
                                                  quoteline.sigmaerpdev2__Price__c=wraplist.sigmaerpdev2__Price__c;
                                                  quoteline.sigmaerpdev2__Service_Contract__c='';
                                                  quoteline.contractname='';
                                              }
                                              else
                                               {                                                   
                                                   quoteline.sigmaerpdev2__Unit_Price__c=wraplist.sigmaerpdev2__Price__c;
                                                   quoteline.sigmaerpdev2__Price__c=wraplist.sigmaerpdev2__Price__c* quoteline.sigmaerpdev2__Quantity__c;
                                                   quoteline.sigmaerpdev2__Service_Contract__c='';
                                                   quoteline.contractname='';
                                               }
                                                quoteline.proname=orderlinelist[i].sigmaerpdev2__Product__r.Name;
                                            }
                                       }
                                   component.set('v.isOpen',true);
                                   component.set('v.quoteline',quoteline);
                                   var spinner = component.find("mySpinner");
                                   $A.util.toggleClass(spinner, "slds-hide");
                                }
                           });
        
        $A.enqueueAction(action); 
                
    },
    changeDiscount : function(component, event, helper) {
        var discountMethodContent = component.find('discountMethodContent');
        $A.util.toggleClass(discountMethodContent, 'slds-hide');
        
    },
    handleClick : function(component,event,helper)
    {
        var rate_value;
        var wrapperListInsertLineItems=component.get("v.wrapperListInsertLineItems");
       
        if(document.getElementById('radio-1').checked)
        {
            //alert('Discount method "None" is applied.');
            rate_value = document.getElementById('radio-1').value;
            for(var j=0;j<wrapperListInsertLineItems.length;j++)
            {
                if(wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c!= 0)
                {
                  
                    wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c=0;
                   
                }
                
            }
          
            var discountMethodContent = component.find('discountMethodContent');
            var proposalid = component.find('proposalid');
            $A.util.addClass(discountMethodContent, 'slds-hide');
            $A.util.addClass(proposalid, 'slds-hide');
            component.set("v.proposalObject.sigmaerpdev2__Field_Discount_Amount__c", 0);
            component.set("v.proposalObject.sigmaerpdev2__Discount_Method__c", 'None');
        }
        else if(document.getElementById('radio-2').checked)
        {
            //alert('Discount method "Product" is applied.');
            rate_value = document.getElementById('radio-2').value;
            var discountMethodContent = component.find('discountMethodContent');
            var proposalid = component.find('proposalid');
            $A.util.addClass(discountMethodContent, 'slds-hide');
            $A.util.addClass(proposalid, 'slds-hide');
            component.set("v.proposalObject.sigmaerpdev2__Field_Discount_Amount__c", 0);
             component.set("v.proposalObject.sigmaerpdev2__Discount_Method__c", 'Product');
        }
            else if(document.getElementById('radio-4').checked)
            {
                //alert('Discount method "Proposal" is applied.');
                rate_value = document.getElementById('radio-4').value;  
                 for(var j=0;j<wrapperListInsertLineItems.length;j++)
            {
                if(wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c!= 0)
                {
                  
                    wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c=0;
                   
                }
                
            }
                var discountMethodContent = component.find('discountMethodContent');
                var proposalid = component.find('proposalid');
                $A.util.addClass(discountMethodContent, 'slds-hide');
                $A.util.toggleClass(proposalid, 'slds-hide');
                 component.set("v.proposalObject.sigmaerpdev2__Discount_Method__c", 'Proposal');
            }
         component.set("v.wrapperListInsertLineItems",wrapperListInsertLineItems);
        
        component.set("v.disval", rate_value);
        
    },
    saveStatus : function(cmp,event,helper)
    {
        
        cmp.set("v.proposalObject.sigmaerpdev2__Status__c",cmp.find("status").get("v.value")); 
    },
    handleAccountIdUpdate : function(cmp, event, helper) {
        var accountId = event.getParam("sObjectId");
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        if (instanceId === "Supplier,Vendor")
        {
            
            cmp.set('v.proposalObject.Account__c',accountId);
            
        }else if(instanceId === "MyContact")
        {
            cmp.set('v.proposalObject.sigmaerpdev2__Billing_Contact__c', accountId);
            
        }
        
            else if(instanceId === "SalesExec1")
            {
                
                cmp.set('v.proposalObject.sigmaerpdev2__Account_Executive_1_acc__c', accountId);
                
            }
               else if(instanceId === "Workorder")
                {
                    cmp.set('v.proposalObject.sigmaerpdev2__Work_Order__c', accountId);
                    
                }
                    else if(instanceId === "SerCon")
                    {
                        cmp.set('v.proposalObject.sigmaerpdev2__Service_Contract__c', accountId);
                        
                    }
    },
    cancelButton:function(cmp, event){ 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire(); 
       
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
    Save: function(component, event, helper)
    {
        var wrapperListInsertLineItems = component.get("v.quotelinelist");
        var proposalObject = component.get("v.proposalObject");
        var oldstatus = component.get("v.oldstatus");
       
       
        if(wrapperListInsertLineItems.length<=0)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Choose Products and add line item to save an order.');
            return; 
            
        } 
        
        
        else if(proposalObject.sigmaerpdev2__Status__c == '--Select--')
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Please select status');
            return; 
            
        } 
        
     
        
        
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        var recordtyflag = component.get("v.isOpenchild");
        var actionsave = component.get("c.Savequote");
        actionsave.setParams({
            "proposalObject": proposalObject,
           
            "orderline": JSON.stringify(wrapperListInsertLineItems)
          
        });
        actionsave.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               component.set("v.curRecordID",response.getReturnValue());
                               
                               if (state == 'SUCCESS')
                               {
                                
                                   var prolist = response.getReturnValue();
                                   
                                   if(response.getReturnValue() !== null)
                                   {
                                       if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one)) 
                                       {
                                           
                                           var successAlert = component.find("successAlert");
                                           $A.util.removeClass(successAlert,'slds-hide');
                                       }else{
                                              component.set("v.toastSuccess",true);                                           
                                            window.setTimeout(
                                            $A.getCallback(function() {
                                               window.location.href = "/" + response.getReturnValue();
                                            }), 600
                                            );
                                          
                                       }    
                                   } else{
                                       
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
                                   
                                   
                               }
                               else
                               {
                                   component.set("v.toastError",true);
                                   
                               }
                           });
        component.set("v.spinner",true);
        $A.enqueueAction(actionsave); 
    }, 
    canceldiscount : function(component, event, helper)
    {
        var discountMethodContent = component.find('discountMethodContent');
        $A.util.addClass(discountMethodContent, 'slds-hide');
        
        document.getElementById('radio-1').checked=false;
        document.getElementById('radio-2').checked=false;
        document.getElementById('radio-3').checked=false;
        
    },
    closeToast : function(component, event, helper)
    {
        location.reload();
    }
    
})