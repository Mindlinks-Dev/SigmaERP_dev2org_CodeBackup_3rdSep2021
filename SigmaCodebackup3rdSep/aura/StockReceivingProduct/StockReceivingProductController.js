({
    handleStockinList: function(component, event, helper) 
    {
        var siList = event.getParam("siList");
        var srlList = event.getParam("srlList");
     	 var editflag = event.getParam("isEdit");
        var editIndex = event.getParam("rowIndex");
        var index = event.getParam("index");
        var sip =  component.get("v.StockInProduct");
        var srl =  component.get("v.ProductSerNumberList");
        var isserial;
		  for(var i=0;i<srlList.length;i++)
          {
               if(srlList[i].sigmaerpdev__Product_Code__c=='')
                {
                    srlList.splice(i, 1);
                   // component.set("v.ProductSerNumberList",srl);
                   
                    i--;  
                }
            }
  	 
		 if(editflag == true && editIndex!=null)
        {
            sip[editIndex] = siList[0];
            component.set("v.StockInProduct",sip);
		if(srlList.length==0)
        {
            component.set("v.isserial",true);
            for(var j=0;j<srl.length;j++)
            {
              
             if(srl[j].sigmaerpdev__Product_Code__c == siList[0].sigmaerpdev__Product__c && srl[j].sigmaerpdev__Purchase_Order_Product__c==siList[0].sigmaerpdev__Purchase_Order__c && srl[j].sigmaerpdev__Location__c==siList[0].sigmaerpdev__Putaway_location__c )
                {
                    srl.splice(j, 1);
                    component.set("v.ProductSerNumberList",srl);
                    j--;  
                } 
            }
           
              
            if((srl == '' || srl == 'undefined') )
            {
              
                component.set("v.ProductSerNumberList",srlList);
                
            }else 
            {
              
                for(var i=0;i<srlList.length;i++)
                {
                    srl.push(srlList[i]);
                }
                component.set("v.ProductSerNumberList",srl);
                
            }
          
        }
        else
        {
            component.set("v.isserial",false);
        
        isserial=component.get("v.isserial");
       
            var count=0;
            var count1=1;
            if(editflag == true && srlList.length>0)
            {
               
                for(var i=0;i<srlList.length;i++)
                {
                   count++;
				    
                    //alert('srlpsn::'+srl.length); 
                        for(var j=0;j<srl.length;j++)
                    {
                      // alert('i::'+i); 
                       if(i<srlList.length && isserial==false)
                        {
                           if(srl[j].sigmaerpdev__Product_Code__c == siList[0].sigmaerpdev__Product__c && srl[j].sigmaerpdev__Purchase_Order_Product__c==siList[0].sigmaerpdev__Purchase_Order__c && srl[j].sigmaerpdev__Location__c==siList[0].sigmaerpdev__Putaway_location__c 
             				 &&count1<= siList[0].sigmaerpdev__Quantity_Received__c && i+1==count1)
                            {
                                srl[j] = srlList[i];
                                 //srl.push(srlList[i]);
                                i++;
                               count1++;
                                component.set("v.ProductSerNumberList",srl);
                              //alert('srl::'+JSON.stringify(srl[j]));
                            }
                            else if(i!=0)
							
                            {
                              srl.push(srlList[i]);
                               component.set("v.ProductSerNumberList",srl);
                                i++;
                               
                            }
                        }
                       
                     
		else if((srl[j].sigmaerpdev__Product_Code__c == siList[0].sigmaerpdev__Product__c && srl[j].sigmaerpdev__Purchase_Order_Product__c==siList[0].sigmaerpdev__Purchase_Order__c && srl[j].sigmaerpdev__Location__c==siList[0].sigmaerpdev__Putaway_location__c )
             			&& i>=srlList.length&&count1-1== siList[0].sigmaerpdev__Quantity_Received__c)
           
                        {
                           
                            srl.splice(j, 1);
                            component.set("v.ProductSerNumberList",srl);
                              j--;
                        }
                      
                    } 
                       // i--;
                   if(j>=srl.length && i<srlList.length)
                    {
                       // alert('inside if::s'+JSON.stringify(srlList[i]));
                        srl.push(srlList[i]);
                       j++;
                    
                        component.set("v.ProductSerNumberList",srl);
                        //srl.pop(srlList[i]);
                    }
                 
                  
                }
                
                
            }
            
       
        }
		}
		else
        {
            if(sip == '' || sip == 'undefined')
            {
                component.set("v.StockInProduct",siList);
                // component.set("v.ProductSerNumberList",srlList);
            }else
            {
                sip.push(siList[0]);
                component.set("v.StockInProduct",sip);
                
            }
            if((srl == '' || srl == 'undefined') )
            {
              
                component.set("v.ProductSerNumberList",srlList);
                
            }else 
            {
              
                for(var i=0;i<srlList.length;i++)
                {
                    srl.push(srlList[i]);
                }
                component.set("v.ProductSerNumberList",srl);
                
            }
        }

		//alert('serial'+JSON.stringify(component.get("v.ProductSerNumberList")));
       },
    
    doInit : function(component, event, helper) {
        
        if(component.get("v.Id") != '')
        {
            component.set("v.isOpenprodTable", true); 
            
            var action1 = component.get("c.editStockIn");
            action1.setParams({ 
                "stockInObj": component.get("v.Id") 
            });
            
            action1.setCallback( this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                  
                    component.set("v.StockIn", response.getReturnValue());
                   if(response.getReturnValue().sigmaerpdev__Vendor__c!=undefined)
                    {
                        component.set("v.recordId",response.getReturnValue().sigmaerpdev__Vendor__c);
                        component.set("v.VendorId",response.getReturnValue().sigmaerpdev__Vendor__c);
                        
                    }
                    if(response.getReturnValue().sigmaerpdev__Vendor__r.Name!=undefined)
                    {
                        component.set("v.recordName", response.getReturnValue().sigmaerpdev__Vendor__r.Name);
                        
                    }
                    if(response.getReturnValue().sigmaerpdev__Delivery_Person__r.Name!=undefined)
                    {
                        component.set("v.recordName1", response.getReturnValue().sigmaerpdev__Delivery_Person__r.Name);
                        component.set("v.DeliveryPersonId", response.getReturnValue().sigmaerpdev__Delivery_Person__r.Id);
                        
                    }
                    if(response.getReturnValue().sigmaerpdev__Location__r.Name!=undefined)
                    {
                        component.set("v.recordName2", response.getReturnValue().sigmaerpdev__Location__r.Name);
                        component.set("v.RLocationId", response.getReturnValue().sigmaerpdev__Location__r.Id);
                    }
                   }
                
            });
            $A.enqueueAction(action1);
            
            var action2 = component.get("c.editStProducts");
          
            action2.setCallback( this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    var tempSIP = [];
                   
                    for(var i=0;i<resp.length;i++)
                    {
                        component.set("v.tempStockInProduct",resp[i]);
                        var sipIndiv = component.get("v.tempStockInProduct");
                       sipIndiv.Pur_Order_Name = resp[i].sigmaerpdev__Pur_Order__r.Name;
                        sipIndiv.PO_Name = resp[i].sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__r.Name;
                        sipIndiv.sigmaerpdev__Return_Quantity_Comment__c = resp[i].sigmaerpdev__Return_Quantity_Comment__c;
                        
                        if(resp[i].sigmaerpdev__Putaway_location__c == undefined || resp[i].sigmaerpdev__Putaway_location__c == "")
                        {
                            sipIndiv.Loc_Name = '';
                            
                        }
                        else
                        {
                            sipIndiv.Loc_Name = resp[i].sigmaerpdev__Putaway_location__r.Name;
                        }
                       if(resp[i].sigmaerpdev__Lot__c === undefined || resp[i].sigmaerpdev__Lot__c === "")
                        {
                            sipIndiv.sigmaerpdev__Lot_Name = '';
                        }
                        else
                        {
                            sipIndiv.Lot_Name = resp[i].sigmaerpdev__Lot__r.Name; 
                        }
                        sipIndiv.sigmaerpdev__Quantity_Received__c = resp[i].sigmaerpdev__Quantity_Received__c;
                        sipIndiv.sigmaerpdev__Status__c = resp[i].sigmaerpdev__Status__c;
                        sipIndiv.Attribute_type = resp[i].sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c;
                        tempSIP.push(sipIndiv);
                    }
                    component.set("v.StockInProduct", tempSIP);
                       
                }
            });
            $A.enqueueAction(action2);
            
            
            
            var action3= component.get("c.editProductSerialNumber");
            action3.setCallback( this, function(response) {
                var state = response.getState();
                 if (state === "SUCCESS") {
                    component.set("v.ProductSerNumberInit", response.getReturnValue());
                    component.set("v.ProductSerNumberList", response.getReturnValue());
                   component.set("v.isflag",true);
                   }
            });
            $A.enqueueAction(action3);
            
        }
        
        
    },
    createStockReciving :function(component,event,helper)
    {    
        var newStockIn=component.get('v.StockIn');
        var Vendor = component.find('Vendor');        
        var vendorName = Vendor.get('v.searchString');       
        
        var DPName = component.find('Delivery_Person');        
        var logName = DPName.get('v.searchString');  
        if(vendorName == '' || vendorName == null)
        { 
         
            alert("Please Select the  Vendor.");
            return null;
        }
      
        if(logName == '' || logName == null)
        {                      
                	                	 
            alert("Please enter delivery person name.");
           
            return null; 
        }
        var RLName = component.find('ReceivingLocation');        
        var logName = RLName.get('v.searchString');       
        if(logName == '' || logName == null)
        {                      
                 	                	 
            alert("Please enter receiving location name.");
            return null; 
        }
        var today = new Date();
         var todaydate = new Date(today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate());
        var someDate = new Date(newStockIn.sigmaerpdev__Received_Date_Time__c);
        if(newStockIn.sigmaerpdev__Received_Date_Time__c==''||newStockIn.sigmaerpdev__Received_Date_Time__c==undefined)
        {
              var msg11 = "Please Enter Receiving Date .";
                component.set("v.errorMsg", msg11);
                component.set("v.isError",true);
                return;
        }
        else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            } 
         var orderdate = new Date( someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate());
       
           if(orderdate < todaydate)
        {
			 var msg = "Receiving  Date Should be greater than or Equal to Today Date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;            
        }
        else
        {
             component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        var porSeri = component.get('v.PSERIALIZED');
        var prodSN=component.get("v.ProductSerNumberList")
        if(porSeri=='SERIALIZED' && prodSN.length == 0 )
        {
            alert("Please add product serialized.");
            return null;  
        }
        
        helper.createStockIn(component, newStockIn); 
    },
    updateStockReciving:function(component,event,helper)
    {
        var updateStockIn = component.get("v.StockIn");
        
        updateStockIn.sigmaerpdev__Vendor__c=component.get("v.VendorId");
        updateStockIn.sigmaerpdev__Location__c=component.get("v.RLocationId");
        updateStockIn.sigmaerpdev__Delivery_Person__c=component.get("v.DeliveryPersonId");
        var StockInProd = component.get("v.StockInProduct");
        var  psn=component.get("v.ProductSerNumberList");
        var action = component.get("c.updateStockInProduct");
        var valStockInProd=component.get("v.StockInProduct");
        var today = new Date();
         var todaydate = new Date(today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate());
        var someDate = new Date(updateStockIn.sigmaerpdev__Received_Date_Time__c);
         var Vendor = component.find('Vendor');        
		var vendorName = Vendor.get('v.searchString'); 
 		if(vendorName == '' || vendorName == null)
        { 
         alert("Please Select the  Vendor.");
            return null;
        }
        if(updateStockIn.sigmaerpdev__Received_Date_Time__c==''||updateStockIn.sigmaerpdev__Received_Date_Time__c==undefined)
        {
              var msg11 = "Please Enter Receiving Date .";
                component.set("v.errorMsg", msg11);
                component.set("v.isError",true);
                return;
        }
        else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
         var orderdate = new Date( someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate());
        if(orderdate < todaydate)
        {
			 var msg = "Receiving  Date Should be greater than or Equal to Today Date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;            
        }
        else
        {
             component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
         var quntlist=[];
        var Quantitylist=component.get("v.POPQuantity");
        if(valStockInProd.length <1) 
        {
            
            var msg11 = "Please add Stock Receiving Products .";
            component.set("v.errorMsg", msg11);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }  
        for(var i=0;i<valStockInProd.length;i++)
        {  
            if(valStockInProd[i].Id ==undefined || valStockInProd[i].Id == "")
            {
                valStockInProd[i].sigmaerpdev__Product__c = valStockInProd[i].sigmaerpdev__Product__c;
            }
            else{
             
                valStockInProd[i].sigmaerpdev__Product__c = valStockInProd[i].sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__c;
              
            }
            
            
            
            if(parseInt(Quantitylist[i]) < parseInt(valStockInProd[i].sigmaerpdev__Quantity_Received__c))
            { 
                
                var msg = "Please check the Quantity "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else
            {
                
                component.set("v.isError",false);
                component.set("v.errorMsg", "");  
            }
            
            if(parseInt(valStockInProd[i].sigmaerpdev__Returned_Quantity__c) > parseInt(valStockInProd[i].sigmaerpdev__Quantity_Received__c))
            { 
                
                var msg = "Please Enter  Returned Quantity less  than Recevied Quantity"+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else
            {
                
                component.set("v.isError",false);
                component.set("v.errorMsg", "");  
            }
            
            if(parseInt(valStockInProd[i].sigmaerpdev__Returned_Quantity__c) < 0 )
            { 
                
                var msg = "Should not take negative returned quantity at line number "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else
            {
                
                component.set("v.isError",false);
                component.set("v.errorMsg", "");  
            }
            if(parseInt(valStockInProd[i].sigmaerpdev__Quantity_Received__c) < 0)
            { 
                
                var msg = "Should not take negative received quantity at line number "+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else
            {
                
                component.set("v.isError",false);
                component.set("v.errorMsg", "");  
            }
            if(isNaN(valStockInProd[i].sigmaerpdev__Quantity_Received__c) )
            { 
                
                var msg = "Should not take charecter Quantity Received"+(i+1);
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
            }else
            {
                
                component.set("v.isError",false);
                component.set("v.errorMsg", "");  
            }
            
            
        }
         for(var i=0;i<StockInProd.length;i++)
          {
               for(var j=i+1;j<StockInProd.length;j++)
                  {
                       if(StockInProd[i].Pur_Order_Name==StockInProd[j].Pur_Order_Name && StockInProd[i].PO_Name==StockInProd[j].PO_Name&& valStockInProd[i].Loc_Name==valStockInProd[j].Loc_Name)
                       {
                           
                            var msg11 = "Duplicate Purchase Order Exist for same location.";
                            component.set("v.errorMsg", msg11);
                            component.set("v.isError",true);
                            return;
                       }
                      else{
                            component.set("v.isError",false);
                            component.set("v.errorMsg", "");
            			}  
                  }
          }

        
        
        action.setParams({ 
            "stockInObj": updateStockIn,
            "stockInProduts" : JSON.stringify(component.get("v.StockInProduct")),
            "psn":JSON.stringify(psn) 
        });
        
        action.setCallback( this, function(a) 
                           {
                              
                               var state = a.getState();
                             
                               if (state === "SUCCESS") 
                               {
                                   component.set("v.curRecordID",a.getReturnValue().Id);
                                   if(a.getReturnValue() != null)
                                   {
                                       if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) 
                                       {
                                          
                                           var successAlert = component.find("successAlert");
                                           $A.util.removeClass(successAlert,'slds-hide');
                                           var recordCreatedHeader = component.find("recordCreatedHeader");
                                           $A.util.addClass(recordCreatedHeader,'slds-hide');
                                           var recordUpdtatedHeader = component.find("recordUpdtatedHeader");
                                           $A.util.removeClass(recordUpdtatedHeader,'slds-hide');
                                         
                                       }else{
                                          window.location.href = "/" + a.getReturnValue().Id;
                                           
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
                                       var recordNotUpdtatedHeader = component.find("recordNotUpdtatedHeader");
                                       $A.util.removeClass(recordNotUpdtatedHeader,'slds-hide');
                                       var recordCreatedOK = component.find("recordCreatedOK");
                                       $A.util.addClass(recordCreatedOK,'slds-hide');
                                       var recordCreatedCancel = component.find("recordCreatedCancel");
                                       $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                                   }   
                                   
                               }
                               else
                               {
                                   //alert('Package Creation Failed');
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
        document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action);
    },
    SelectedID : function(cmp, event) 
    {
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");
        var counts=cmp.get("v.count");
        var count=0;
        if(context == 'MyVendor')
        {  
            cmp.set("v.VendorId",objectId);  
           
            
            cmp.set("v.StockIn.sigmaerpdev__Vendor__c",objectId);
           
            counts++;
            cmp.set("v.count",counts);
            
           
        }else if(context =='MyAccount2')
        { 
           
            cmp.set("v.RLocationId",objectId); 
            var two= cmp.get("v.count");
         
            two++;
            cmp.set("v.count",two);
        }
            else if(context =='MyContact')
            {
                cmp.set("v.DeliveryPersonId",objectId); 
                var Three= cmp.get("v.count");
                Three++;
                cmp.set("v.count",Three);
            }else if(context =='POrder')
            {
                cmp.set("v.POrder",objectId); 
                var Four= cmp.get("v.count");
                Four++;
               cmp.set("v.count",Four);
            }else if(context== 'POProduct')
            {
                cmp.set("v.POProduct",objectId); 
                var Five= cmp.get("v.count");
                Five++;
                cmp.set("v.count",Five);
                
                var action = cmp.get("c.getSerialized"); 
                action.setParams({"Id":objectId});
                action.setCallback(this, function(a) {
                    var res = a.getReturnValue();  
                    if(res == 'SERIALIZED'){
                        
                        cmp.set("v.PSERIALIZED",res);
                        
                    }else{
                        var pSE='No'; 
                        cmp.set("v.PSERIALIZED",pSE);  
                    }
                }) 
                $A.enqueueAction(action);
                
                var action1 = cmp.get("c.getOrderedQuantity"); 
                action1.setParams({"Id":objectId});
                action1.setCallback(this, function(a) {
                    var res = a.getReturnValue();
                   var popQ=cmp.get("v.POPQuantity");
                    popQ.push(res);
                     
                }) 
                
                $A.enqueueAction(action1); 
                
            }else if(context== 'MyAccount3')
            {
                cmp.set("v.ActualLocation",objectId); 
                
                var Six= cmp.get("v.count");
                Six++;
                cmp.set("v.count",Six);
            }
        var FCount =cmp.get("v.count");
        var SRow   =cmp.get("v.VendorId");
        if(FCount == '3' || FCount == '6')
        {
           
            cmp.set("v.recordId",SRow);           
        }
        else
        {
           
            cmp.set("v.recordId",objectId);
            
            
            
        }
        
      
    }
    ,
    addContact : function(component, event, helper)
    {
        if(component.get("v.VendorId") =='')
        {
            //alert('vendor id null');
            component.set("v.recordId",component.get("v.recordId"));
        }else
        { 
            component.set("v.recordId",component.get("v.VendorId"));
        }
        var StockInProductList = component.get("v.StockInProduct");
       StockInProductList.push({
            'sigmaerpdev__Pur_Order__c': '',
            'sigmaerpdev__Purchase_Order__c': '',
            'sigmaerpdev__Quantity_Received__c': '',
            'sigmaerpdev__Returned_Quantity__c': '',
            'sigmaerpdev__Putaway_location__c': '',
            'sigmaerpdev__Status__c': '',
            'sigmaerpdev__Return_Quantity_Comment__c': ''
        });
        component.set("v.StockInProduct",StockInProductList);
         var evetlist=[];
        component.set("v.PSerialNumber",evetlist); 
    },
    
    GenerateProductSerialNumbers : function(component,event)
    {
        var proSN = event.getParam("ProductSerialNumber");
        var old = component.get("v.ProductSerNumberList");
        for(var i=0;i<proSN.length;i++)
        {
            old.push(proSN[i]);
        }
        component.set("v.ProductSerNumberList",proSN);
        
    },
    cancelButton:function(cmp, event){ 
        window.history.back();
    },
    hidenotification:function(component,event,helper)
    {
        // alert('hide notifiction'); 
    },
    
    submit : function(component, event, helper) {
        
        var addprod = component.find("modal");
        var backdrop = component.find("slds-backdrop");
        var prodTable=component.find("prodTable");
        
        $A.util.addClass(addprod, " slds-fade-in-close");
        $A.util.removeClass(addprod, " slds-fade-in-open"); 
        
        $A.util.addClass(backdrop, " slds-backdrop--close");
        $A.util.removeClass(backdrop, " slds-backdrop--open");
        
        $A.util.removeClass(prodTable, " slds-hide");
    },
    close : function(component,event,helper)
    {
       
        var addprod = component.find("modal");
        var backdrop = component.find("slds-backdrop");
        
        $A.util.addClass(addprod, " slds-fade-in-close");
        $A.util.removeClass(addprod, " slds-fade-in-open"); 
        
        $A.util.addClass(backdrop, " slds-backdrop--close");
        $A.util.removeClass(backdrop, " slds-backdrop--open");
    },
    addProducts : function(component,event,helper)
    {
       
        var VendorName = component.find('Vendor');        
        var logName = VendorName.get('v.searchString');       
        if(logName == '' || logName == null)
        { 
            var msg = "Please Select the  Vendor";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var todaydate = new Date( component.get('v.today'));
        var stockin=component.get("v.StockIn");
        var someDate = new Date(stockin.sigmaerpdev__Received_Date_Time__c);
        component.set('v.Orderdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
        var orderdate = new Date(component.get("v.Orderdate"));
        //alert("date:::::");
        if(orderdate < todaydate)
        {
            var msg = "Received Date Should be greater than Today.";
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
    
    likenClose: function(component, event, helper) {
       component.set("v.isOpen", false);
    },
    recordCreatedOK: function(component, event, helper) 
    {
        //alert('inside recordCreatedOk'+component.get("v.curRecordID"));
        sforce.one.navigateToSObject(component.get("v.curRecordID"));        
    },
    recordCreatedCancel: function(component, event, helper) 
    {
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');        
    },
    waiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "block";
    },
    
    doneWaiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "none";
    },
    
    
})