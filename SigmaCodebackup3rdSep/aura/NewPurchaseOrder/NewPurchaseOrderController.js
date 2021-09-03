({  
    
     save : function(component, event, helper){
        // alert('here>>>'+Expdate)
        //alert('hiii');
        //component.set("v.NewPurchaseOrder.sigmaerpdev2__Status__c",Open);
        var PurchaseOrderData = component.get("v.NewPurchaseOrder");
        var lineItem = component.get("v.NewPurchaseOrderProducts");
        
        var Expdate = component.get("v.NewPurchaseOrder.sigmaerpdev2__Expected_Date__c");
         var sizeOfProductsAdded = component.get("v.NewPurchaseOrderProducts").length;
        
         //var purchaseOrderRecord = component.get("v.NewPurchaseOrder");
       
        // alert('appproved>>>'+NewPurchaseOrderProducts.sigmaerpdev2__Expected_Delivery_Date__c);
        // alert('status>>>'+component.get("v.selectedStatus"));
        var flag = component.get("v.flag");
        var status=component.get("v.selectedStatus");
        
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var todaydate = new Date( component.get('v.today'));
        
        var someDate = new Date(PurchaseOrderData.sigmaerpdev2__Order_Date__c);
        component.set('v.Orderdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
          var someDate1 = new Date(PurchaseOrderData.sigmaerpdev2__Expected_Date__c);
        component.set('v.Expdate', someDate1.getFullYear()+ "-" +(someDate1.getMonth() + 1)+ "-" + someDate1.getDate() );
        
        var orderdate = new Date(component.get("v.Orderdate"));
         //var Expdate = new Date(component.get("v.Expdate"));
          
         if(sizeOfProductsAdded > 0)
         { 
              for(var i=0;i<sizeOfProductsAdded;i++)
              {
                    if(Expdate != lineItem[i].sigmaerpdev2__Expected_Delivery_Date__c   )
                       {
                           //alert('inside if i')
                 		var msg4 = "Line Item Expected Delivery Date Must Be Equal To PO Expected Delivery Date."+(i+1);
                            component.set("v.errorMsg", msg4);
                            component.set("v.isError",true);
                            return; 
                
                           }
                  
              }
         }
       
        if(orderdate < todaydate)
        {
            var msg = "Order Date Should be greater than or Equal to Today's date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;            
        }
         
         if(sizeOfProductsAdded > 0)
        { 
            if(PurchaseOrderData.sigmaerpdev2__Product_Supplier__c === null || PurchaseOrderData.sigmaerpdev2__Product_Supplier__c === '')
            {
                var msg = "Please Select the Purchase Order Vendor";
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }
           
             
            else
            {
                
                for(var i=0;i<sizeOfProductsAdded-1;i++)
                {
                    for(var j=i+1;j<sizeOfProductsAdded;j++)
                    {
                      
                        if(lineItem[i].sigmaerpdev2__Product__c == lineItem[j].sigmaerpdev2__Product__c)
                        {
                            var msg1 = "Adding Duplicate Product at line "+(i+1) ;
                            component.set("v.errorMsg", msg1);
                            component.set("v.isError",true);
                            return; 
                        }
                        else if(lineItem[i].sigmaerpdev2__Product__c==lineItem[j].sigmaerpdev2__Product__c && lineItem[i].sigmaerpdev2__Expected_Delivery_Date__c==lineItem[j].sigmaerpdev2__Expected_Delivery_Date__c)
                        {
                            var msg1 = "Same product having same Expected Delivery Date. edit the existing line item."+(i+1);
                            component.set("v.errorMsg", msg1);
                            component.set("v.isError",true);
                            return; 
                        }
                      
                    
                      /* else if(Expdate != lineItem[i].sigmaerpdev2__Expected_Delivery_Date__c   )
                       {
                           alert('inside else i')
                 		var msg2 = "Line Item Expected Delivery Date Must Be Equal To PO Expected Delivery Date."+(i+1);
                            component.set("v.errorMsg", msg2);
                            component.set("v.isError",true);
                            return; 
                
                           }
                         else if(Expdate != lineItem[j].sigmaerpdev2__Expected_Delivery_Date__c  )
                       {
                          alert('inside else j')
                 		var msg3 = "Line Item Expected Delivery Date Must Be Equal To PO Expected Delivery Date."+(j+1);
                            component.set("v.errorMsg", msg3);
                            component.set("v.isError",true);
                            return; 
                
                           }*/
                            else
                            {
                                component.set("v.isError",false);
                                component.set("v.errorMsg", "");
                            }  
                    }
                }
                
            }
            
          
            
        }
      
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
         if( Expdate< today){
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Expected Date  must be future date."
            });
            toastEvent.fire();
            return;
        }
          //component.set("v.NewPurchaseOrder.sigmaerpdev2__Order_Date__c", component.get("v.selectedOrderdate"));
        // alert(">>>"+JSON.stringify(PurchaseOrderData));
        console.log(JSON.stringify(PurchaseOrderData));
        console.log(JSON.stringify(lineItem));
        var action= component.get("c.ClonePO");
        //alert(JSON.stringify(action));
        action.setParams({
            po:JSON.stringify(PurchaseOrderData),
            pop:JSON.stringify(lineItem)
        });
        //alert(JSON.stringify(action));
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert("state>>>>>>>>>>>>>>>>>>>>>>>>>"+state);
            var respo = response.getReturnValue();
            //alert("respo>>>>>>>>>>>>>>>>"+JSON.stringify(respo));
            if (component.isValid() && state === "SUCCESS"){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type":"success",
                    "message": "Purchase order saved successfully."
                });
                toastEvent.fire();
                
                
               
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": respo,
                    "slideDevName": "related"
                });
                navEvt.fire();
                
            }
            
        });
         $A.enqueueAction(action);
     
     },
    handlepoList: function(component, event, helper) {
        //alert('event fired');
        var siList = event.getParam("poList");
        var editflag = event.getParam("isEdit");
        var editIndex = event.getParam("rowIndex");
        var sip =  component.get("v.NewPurchaseOrderProducts");
        if(editflag == true && editIndex!=null)
        {
            sip[editIndex] = siList[0];
            component.set("v.NewPurchaseOrderProducts",sip);
        }
        else if(editIndex!=null)
        {
            //alert('calling helper');
            //  helper.viewProductHelper(component, event, helper,editIndex);
        }else
        {
            if(sip == '' || sip == 'undefined')
            {
                component.set("v.NewPurchaseOrderProducts",siList);
            }else
            {
                sip.push(siList[0]);
                component.set("v.NewPurchaseOrderProducts",sip);
            }
        }
        
        
        
    },
    handleComponentEvent: function (component, event, helper) {
        if (event.getParam("flag") == 'Viewproductimage') {
            
            // component.set('v.ViewProductIndex',event.getParam("data").index);
            // alert(component.get('v.ViewProductIndex'));
            helper.viewProductHelper(component, event, helper,event.getParam("data").ProductID);
        }
    },
    
    doInit : function(component, event, helper)
    {
        
        var tempPurchaseOrderId = component.get("v.Id");
        var poCloneId = component.get("v.POIdForClone");
        if(poCloneId){
            if(poCloneId === 'undefined' || poCloneId === null || poCloneId === '' || poCloneId === undefined )
            {
                var popover = component.find("TempDispalyForAccountLookupTest");
                $A.util.removeClass(popover,'slds-hide');
                var popover3 = component.find("TempToDisplayStatus");
                $A.util.removeClass(popover3,'slds-hide');
                helper.loadPOStatus(component,event);
            }
            else
            {
               // alert('else>>');
                //component.set("v.NewPurchaseOrder.sigmaerpdev2__Expected_Date__c",' ');
                //  alert('tempPurchaseOrderId2>>'+JSON.stringify(tempPurchaseOrderId));
                component.set("v.isOpenprodTable", true); 
                var popover4 = component.find("TempToDisplayStatus");
                $A.util.removeClass(popover4,'slds-hide');
                var popover1 = component.find("TempToDisplayName");
                $A.util.removeClass(popover1,'slds-hide');
                var popover2 = component.find("TempDispalyForAccountText");
                $A.util.removeClass(popover2,'slds-hide');
                helper.loadPurchaseOrderDetails(component,event,poCloneId);   
            }
        }
        //alert('tempPurchaseOrderId>>'+JSON.stringify(tempPurchaseOrderId));
        
        if(tempPurchaseOrderId === 'undefined' || tempPurchaseOrderId === null || tempPurchaseOrderId === '' || tempPurchaseOrderId === undefined )
        {
            // alert('tempPurchaseOrderId1>>'+JSON.stringify(tempPurchaseOrderId));
            var popover = component.find("TempDispalyForAccountLookup");
            $A.util.removeClass(popover,'slds-hide');
            var popover3 = component.find("TempToDisplayStatus");
            $A.util.removeClass(popover3,'slds-hide');
            helper.loadPOStatus(component,event);
        }
        else
        {
            //  alert('tempPurchaseOrderId2>>'+JSON.stringify(tempPurchaseOrderId));
            component.set("v.isOpenprodTable", true); 
            var popover4 = component.find("TempToDisplayStatus");
            $A.util.removeClass(popover4,'slds-hide');
            var popover1 = component.find("TempToDisplayName");
            $A.util.removeClass(popover1,'slds-hide');
            var popover2 = component.find("TempDispalyForAccountText");
            $A.util.removeClass(popover2,'slds-hide');
            helper.loadPurchaseOrderDetails(component,event,tempPurchaseOrderId);   
        }
        
        
        
    },
    addContact : function(component, event, helper)
    {
        var purchaseOrderRecord = component.get("v.NewPurchaseOrder");
        if(purchaseOrderRecord.sigmaerpdev2__Product_Supplier__c === null || purchaseOrderRecord.sigmaerpdev2__Product_Supplier__c === '')
        {
            alert('Please Select Vendor before adding products');
        }
        else
        {
            var PurchaseOrderProductsList = component.get("v.NewPurchaseOrderProducts");
            var len = PurchaseOrderProductsList.length;
            PurchaseOrderProductsList.push({
                'sigmaerpdev2__Product__c':'',
                'sigmaerpdev2__Buying_Price__c':'',
                'sigmaerpdev2__Expected_Delivery_Date__c':'',
                'sigmaerpdev2__Quantity__c':'',
                'sigmaerpdev2__Status__c':''
            });
            component.set("v.NewPurchaseOrderProducts",PurchaseOrderProductsList);    
        }
    },
    handleRemoveProductItemClick : function(component, event, helper) 
    {
        var self = this;  
        var index = event.target.dataset.index;
        helper.removeProductItem(component, index);
        
        
    },
    SelectedIDForAccount : function(cmp, event,helper) 
    {
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");
        //alert('objectId'+objectId);
        // alert('sObjectId'+sObjectId);
        if(context === 'MyAccount')
        {
            //alert('inside if1');   
            cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Product_Supplier__c", objectId);
            cmp.set("v.vendorid", objectId);
            if (cmp.get("v.NewPurchaseOrder.sigmaerpdev2__Product_Supplier__c"))
            {
                //alert('inside if2'+JSON.stringify(cmp.get("v.NewPurchaseOrder.sigmaerpdev__Product_Supplier__c")));   
                helper.helperGetAccountDataobject(cmp,event,helper,cmp.get("v.NewPurchaseOrder.sigmaerpdev2__Product_Supplier__c"));
            }
        }
        if(context === 'Currency')
        {
            //alert('inside if1');
            //  alert(cmp.set("v.NewPurchaseOrder.sigmaerpdev__Currency__c"));
            cmp.set("v.NewPurchaseOrder.sigmaerpdev2__Currency__c", objectId);
            
            //cmp.set("v.vendorid", objectId);
        }
        
    },
    savePO : function(cmp, event, helper)
    {
        
        //alert('save PO>>>'+JSON.stringify(cmp.get("v.NewPurchaseOrderProducts")));
        var sizeOfProductsAdded = cmp.get("v.NewPurchaseOrderProducts").length;
        var purchaseOrderProductRecord = cmp.get("v.NewPurchaseOrderProducts");
        var purchaseOrderRecord = cmp.get("v.NewPurchaseOrder");
        
        var validatedFlag = true;
        var productFlag = false;
        var quantityFlag = false;
        
        //validation code for Approval ,added by sandhya
        //alert('purchaseOrderRecord.sigmaerpdev__Approved__c-->'+purchaseOrderRecord.sigmaerpdev__POSubmitted__c);
        // alert('selectedStatus'+JSON.stringify(cmp.get("v.selectedStatus")));
        
        if((!(purchaseOrderRecord.sigmaerpdev2__Approved__c || purchaseOrderRecord.sigmaerpdev2__Approved__c == '') && (!purchaseOrderRecord.sigmaerpdev2__POSubmitted__c || purchaseOrderRecord.sigmaerpdev2__POSubmitted__c=='') )&&  (cmp.get("v.selectedStatus") == 'Submitted') ) // || cmp.get("v.selectedStatus") == 'Approved' ||  cmp.get("v.selectedStatus") == 'Rejected'
        {
            var msg = "Not Approved, Cannot do Purchase Order";
            cmp.set("v.errorMsg", msg);
            cmp.set("v.isError",true);
            return;
        }
        else{
            cmp.set("v.isError",false);
            cmp.set("v.errorMsg", "");
        } 
        
        //ends here
        //alert('sizeOfProductsAdded-->>>'+sizeOfProductsAdded);
        if(sizeOfProductsAdded > 0)
        {   
            if(purchaseOrderRecord.sigmaerpdev2__Product_Supplier__c === null || purchaseOrderRecord.sigmaerpdev2__Product_Supplier__c === '')
            {
                var msg = "Please Select the Purchase Order Vendor";
                cmp.set("v.errorMsg", msg);
                cmp.set("v.isError",true);
                return;
            }
            else
            {
                for(var i=0;i<sizeOfProductsAdded-1;i++)
                {
                    for(var j=i+1;j<sizeOfProductsAdded;j++)
                    {
                        if(purchaseOrderProductRecord[i].sigmaerpdev2__Product__c == purchaseOrderProductRecord[j].sigmaerpdev2__Product__c)
                        {
                            var msg1 = "Adding Duplicate Product at line "+(i+1) ;
                            cmp.set("v.errorMsg", msg1);
                            cmp.set("v.isError",true);
                            return; 
                        }
                        else if(purchaseOrderProductRecord[i].sigmaerpdev2__Product__c==purchaseOrderProductRecord[j].sigmaerpdev2__Product__c && purchaseOrderProductRecord[i].sigmaerpdev2__Expected_Delivery_Date__c==purchaseOrderProductRecord[j].sigmaerpdev2__Expected_Delivery_Date__c)
                        {
                            var msg1 = "Same product having same Expected Delivery Date. edit the existing line item."+(i+1);
                            cmp.set("v.errorMsg", msg1);
                            cmp.set("v.isError",true);
                            return; 
                        }
                            else
                            {
                                cmp.set("v.isError",false);
                                cmp.set("v.errorMsg", "");
                            }  
                    }
                }
                if(validatedFlag)
                {
                    var tempPurchaseOrderId = cmp.get("v.Id");
                    if(tempPurchaseOrderId === 'undefined' || tempPurchaseOrderId === null || tempPurchaseOrderId === '' || tempPurchaseOrderId === undefined)
                    {
                        //  alert('inside validation flag');
                        var vendorid=cmp.get("v.NewPurchaseOrder.sigmaerpdev2__Product_Supplier__c");
                        //   var currid=cmp.get("v.NewPurchaseOrder.sigmaerpdev__Currency__c");
                        var actionproname =cmp.get("c.editvendorvalidation");
                        var error;
                        actionproname.setParams
                        ({ 
                            "Venderid":vendorid
                            //,"Currencyid":currid
                        });
                        actionproname.setCallback( this, function(a) 
                                                  {
                                                      
                                                      var vendorpro=a.getReturnValue();
                                                      cmp.set("v.vendorpro",vendorpro);
                                                      var purchaseorderpro=cmp.get("v.NewPurchaseOrderProducts");
                                                      
                                                      var pro=cmp.get("v.vendorpro");
                                                      
                                                      var flag=false;
                                                      // alert('purchaseorderpro>>>'+JSON.stringify(purchaseorderpro));
                                                      for(var i=0;i<purchaseorderpro.length;i++)
                                                      {
                                                          
                                                          //   alert('purchaseorderpro[i].Product_name>>>'+purchaseorderpro[i].Product_name);
                                                          for(var j=0;j<pro.length;j++)
                                                          {
                                                              
                                                              //   alert('purchaseorderpro[i].Product_name>>>'+pro[j].sigmaerpdev2__Product_Name__r.Name);
                                                              if(purchaseorderpro[i].Product_name == pro[j].sigmaerpdev2__Product_Name__r.Name)
                                                              {
                                                                  
                                                                  flag=true;
                                                              }
                                                              
                                                          }
                                                          if(flag==false)
                                                          {
                                                              var msg1 = "vendor is not having product in line Item "+(i+1);
                                                              cmp.set("v.errorMsg", msg1);
                                                              cmp.set("v.isError",true);
                                                              return;
                                                          }
                                                          else
                                                          {
                                                              cmp.set("v.isError",false);
                                                              cmp.set("v.errorMsg", "");
                                                          }  
                                                      }
                                                      error=cmp.get("v.isError");
                                                      if(error==false)
                                                      {
                                                          helper.createPO(cmp,event,tempPurchaseOrderId);   
                                                      }
                                                  });
                        $A.enqueueAction(actionproname); 
                    }
                    else
                    {
                        
                        var vendorid=cmp.get("v.NewPurchaseOrder.sigmaerpdev2__Product_Supplier__c");
                        
                        var actionproname =cmp.get("c.editvendorvalidation");
                        var error;
                        actionproname.setParams
                        ({ 
                            "Venderid":vendorid
                            
                        });
                        actionproname.setCallback( this, function(a) 
                                                  {
                                                      var vendorpro=a.getReturnValue();
                                                      cmp.set("v.vendorpro",vendorpro);
                                                      var purchaseorderpro=cmp.get("v.NewPurchaseOrderProducts");
                                                      var pro=cmp.get("v.vendorpro");
                                                      var flag=false;
                                                      for(var i=0;i<purchaseorderpro.length;i++)
                                                      {
                                                          
                                                          for(var j=0;j<pro.length;j++)
                                                          {
                                                              //alert(pro[j].sigmaerpdev__Product_Name__r.Name);
                                                              if(purchaseorderpro[i].Product_name==pro[j].sigmaerpdev2__Product_Name__r.Name)
                                                              {
                                                                  flag=true;
                                                              }
                                                          }
                                                          if(flag==false)
                                                          {
                                                              var msg1 = "vendor is not having product in line Item "+(i+1);
                                                              cmp.set("v.errorMsg", msg1);
                                                              cmp.set("v.isError",true);
                                                              return;
                                                          }
                                                          else
                                                          {
                                                              cmp.set("v.isError",false);
                                                              cmp.set("v.errorMsg", "");
                                                          }  
                                                      }
                                                      error=cmp.get("v.isError");
                                                      if(error==false)
                                                      {
                                                          helper.UpdatePO(cmp,event,tempPurchaseOrderId);
                                                      }
                                                  });
                        $A.enqueueAction(actionproname); 
                    }
                }
                
            }
        }
        else if(sizeOfProductsAdded == 0 && ((purchaseOrderRecord.sigmaerpdev2__Approved__c || purchaseOrderRecord.sigmaerpdev2__Approved__c !='' )&& (!purchaseOrderRecord.sigmaerpdev2__POSubmitted__c || purchaseOrderRecord.sigmaerpdev2__POSubmitted__c=='')))
        {
            var msg11 = "You can not edit the Purchase order once it is Approved and Submitted.";
            cmp.set("v.errorMsg", msg11);
            cmp.set("v.isError",true);
            return;
        }
            else 
            {
                var msg11 = "Please add Purchase Order Products .";
                cmp.set("v.errorMsg", msg11);
                cmp.set("v.isError",true);
                return;
            }
        var spinner=cmp.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        //document.getElementById("Accspinner").style.display = "block";
        
    },
    saveRecord: function(component,event,helper)
    {
        //alert('Running inside save record '+JSON.stringify(component.get("v.selectedStatus")));
    },
    
    
    cancelButton: function(component,event)
    { 
        if(component.get("v.modeOfEdit") == 'component')
        {
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
        
    },	
    
    
    
    addPOrderitem : function(component,event,helper)
    {
        
        var purchaseOrderRecord = component.get("v.NewPurchaseOrder");
        // alert('appproved>>>'+purchaseOrderRecord.sigmaerpdev__Approved__c);
        // alert('status>>>'+component.get("v.selectedStatus"));
        var flag = component.get("v.flag");
        var status=component.get("v.selectedStatus");
        
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var todaydate = new Date( component.get('v.today'));
        
        var someDate = new Date(purchaseOrderRecord.sigmaerpdev2__Order_Date__c);
        component.set('v.Orderdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
        
        var orderdate = new Date(component.get("v.Orderdate"));
        
        if(orderdate < todaydate)
        {
            var msg = "Order Date Should be greater than or Equal to Today's date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(purchaseOrderRecord.sigmaerpdev2__Product_Supplier__c === null || purchaseOrderRecord.sigmaerpdev2__Product_Supplier__c === '')
        {
            var msg = "Please Select the Purchase Order Vendor.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        //commented - sandhya - but code needed
        if(((!purchaseOrderRecord.sigmaerpdev2__Approved__c || purchaseOrderRecord.sigmaerpdev2__Approved__c == '')&& (!purchaseOrderRecord.sigmaerpdev2__POSubmitted__c || purchaseOrderRecord.sigmaerpdev2__POSubmitted__c == '') )&&  component.get("v.selectedStatus") == 'Submitted')
        {
            var msg = "Not Approved, Cannot do Purchase Order.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } 
        
        
        
        if(purchaseOrderRecord.sigmaerpdev2__Expected_Date__c === null || purchaseOrderRecord.sigmaerpdev2__Expected_Date__c === '')
        {
            var msg = "Please Select the Expected Date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if((purchaseOrderRecord.sigmaerpdev2__Order_Date__c >= purchaseOrderRecord.sigmaerpdev2__Expected_Date__c) &&((purchaseOrderRecord.sigmaerpdev2__Order_Date__c !== '') &&(purchaseOrderRecord.sigmaerpdev2__Expected_Date__c !== '')))
        {
            var msg = "Expected Date should be greater than the Order Date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        //   alert('flag>>>'+flag);
        //   alert('status>>>'+status);
        if(flag == true && status=='Submitted' )
        {
            var msg = "Can not Add PO for Submitted Status.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(flag == true && status=='Closed' )
        {
            var msg = "Can not Add PO for Closed Status.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
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
    /*waiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "block";
    },
    
    doneWaiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "none";
    },*/
    closePO : function(component, event, helper){
        //added below line on 6-2-2020 to PurchaseOrdeModules page after new flow is closed
        //alert(component.get("v.modeOfEdit"));
        if(component.get("v.modeOfEdit") == 'component')
        {
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
})