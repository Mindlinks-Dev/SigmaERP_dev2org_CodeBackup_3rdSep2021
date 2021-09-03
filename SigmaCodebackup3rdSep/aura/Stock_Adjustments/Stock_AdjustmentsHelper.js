({
    fetchProductInventory : function(component, event) 
    {		       
        var recordInvId = component.get("v.recordIDILP.Id");
        //alert(recordInvId);
        var action;
        
          action = component.get("c.fectchILP");
        
        action.setParams({
            "invLocPrdId" : recordInvId
        });
        
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               
                               if (state=== 'SUCCESS')
                               {
                                   //alert('success 4');
                                  var ILPObj = response.getReturnValue();
                                  // alert('ILPObj::'+JSON.stringify(ILPObj));
                                   console.log('ILPObj::'+JSON.stringify(ILPObj));
                                   component.set('v.inventoryObj',ILPObj);
                                   var stockAdjustmentObj = component.get('v.StockAdjustmentObj');
                                   stockAdjustmentObj.sigmaerpdev2__Original_Qty__c = ILPObj.sigmaerpdev2__Net_Quantity__c;
                                   stockAdjustmentObj.sigmaerpdev2__Inventory_Location_Product__c = ILPObj.Id;
                                   component.set('v.StockAdjustmentObj',stockAdjustmentObj);
                                   component.set('v.ilpName',ILPObj.Name);
                                  
                               }
                               else
                               { 
                               var errors = response.getError();
                                   if (errors) {
                                       if (errors[0] && errors[0].message) {
                                           alert('Error message: '+errors[0].message);
                                       }
                                   } else {
                                       alert('Unknown error');
                                   }
                                  
                                   
                               }
                               
                           });
        
        $A.enqueueAction(action);   
       
    },
    adjustmentsHelperMethod : function(component, event) 
    {
        var selectedToLoad = new Array();
        var invObj = component.get("v.inventoryObj");
        var stockAdjustments = component.get("v.StockAdjustmentObj");
         var product = component.get('v.inventoryObj.sigmaerpdev2__Products__c');
        var stockAdjustItems = component.get("v.Ilplidata");
         var stockAdjustlot = component.get("v.AddIlpli");
         for(var i=0 ;i < stockAdjustlot.length;i++)
            {
                if(stockAdjustlot.sigmaerpdev2__Lot__c=='')
                component.set("v.AddIlpli.sigmaerpdev2__Lot__c",null);
            }
        var stockAdjustItems1 = component.get("v.AddIlpli"); 
      
        /*//added
        if(AdjsType == 'Increase Stock' ){
            var action = component.get("c.saveStockAdjustment");
            action.setParams({
                "stockAdjustments" : stockAdjustments,
                "sapItems" : JSON.stringify(stockAdjustItems1),
                "ILP" : invObj
            });
            action.setCallback(this, function(response) 
                               {
                                   var state = response.getState();
                                   if (state=== 'SUCCESS')
                                   {
                                       //alert('success-1');
                                       component.set("v.successAlert",true);
                                       component.set('v.Accspinner', false);
                                       
                                   }
                                   else
                                   {
                                       var errors = response.getError();
                                       
                                       if(errors[0].pageErrors[0].message)
                                       {
                                           component.set("v.errorMsg", JSON.stringify(errors[0].pageErrors[0].message));
                                           component.set("v.isError",true);
                                       } 
                                       else if(errors[0])
                                       {
                                           component.set("v.errorMsg", JSON.stringify(errors[0]));
                                           component.set("v.isError",true);
                                       }
                                           else 
                                           {
                                               component.set("v.errorMsg", JSON.stringify(errors));
                                               component.set("v.isError",true);
                                           }
                                       
                                   }
                               });
            //document.getElementById("Accspinner").style.display = "block";
            $A.enqueueAction(action); 
        }
        //added*/
        
        
        
        var proType = component.get('v.inventoryObj.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c');
        var AdjsType = component.find('AdjustType').get('v.value');         
        var reasonSel = component.find('reasons').get('v.value');         
        var adjustedQty = component.find('adjustedQty').get('v.value');
        var saDate = component.find('dateField').get('v.value');
        var dat = component.get("v.StockAdjustmentObj.sigmaerpdev2__Date__c");
       // alert(AdjsType);
        
 
        for (var i = 0; i < stockAdjustItems.length; i ++ )
        {
           if(stockAdjustItems[i].sigmaerpdev2__bucket_field__c != undefined || stockAdjustItems[i].sigmaerpdev2__bucket_field__c != 0){
              selectedToLoad.push(stockAdjustItems[i]);
            }
        } 
        
        if(adjustedQty < 1){      
            component.set("v.Accspinner",false);
            component.find("adjustedQty").set("v.errors", [{message:"Please enter valid value for adjusted quantity."}]);
            return;
        } 
        
        if(adjustedQty == 'undefined'){ 
            component.set("v.Accspinner",false);
            component.find("adjustedQty").set("v.errors", [{message:"Please enter value for adjusted quantity."}]);
            return;
        }
        
        if(reasonSel === "--None--"){         
            component.set("v.Accspinner",false);
            component.find("reasons").set("v.errors", [{message:"Please select reason code."}]);
            return;
        }
        
        if(saDate == ''){
            component.set("v.Accspinner",false);
            component.find("dateField").set("v.errors", [{message:"Please select adjusted date."}]);
            return;
        } 
          var someDate = new Date(component.get('v.StockAdjustmentObj.sigmaerpdev2__Date__c'));
         var orderdate = new Date( someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate());
       var today = new Date();
         var todaydate = new Date(today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate());
        if(orderdate < todaydate)
        {
            component.set("v.Accspinner",false);
			 component.find("dateField").set("v.errors", [{message:"Adjusted date Should be greater than or Equal to Today Date.."}]);
            return;            
        }
          
       /* for (var i = 0; i < stockAdjustItems.length; i++ )
        {
            if(stockAdjustItems[i].sigmaerpdev2__Available_Quantity__c!=stockAdjustItems[i].sigmaerpdev2__bucket_field__c)
            {
                  component.set('v.isError', true);
            component.set('v.errorMsg', 'Available Quantity and Quantity are mismatched ');
            }
        }*/
         // alert(AdjsType); alert("proType"+proType);
          var serStr = [];        
        for(var i=0 ;i < stockAdjustItems1.length;i++){
            serStr.push(stockAdjustItems1[i].sigmaerpdev2__ILid__c);
        }       
         if(proType =='SERIALIZED' && AdjsType == 'Increase Stock'){
          var action1 = component.get("c.checkDuplicateProductPSN"); 
       		// action1.setParams({"validatePSN":JSON.stringify(stockAdjustItems1),"ProductID":product});
       		 action1.setParams({"validatePSN":JSON.stringify(serStr),"ProductID":product});
       		 action1.setCallback(this, function(a) {
            var state = a.getState();
            var valipsn=a.getReturnValue();
                 
                 if(state === "SUCCESS"){ 
             for(var i=0 ;i < stockAdjustItems1.length;i++)
            {		
                for(var k=0;k<valipsn.length;k++)
                {    
                    if((parseInt(stockAdjustItems1[i].sigmaerpdev2__ILid__c) == valipsn[k].sigmaerpdev2__Serial_Number__c || stockAdjustItems1[i].sigmaerpdev2__ILid__c == valipsn[k].sigmaerpdev2__Serial_Number__c) && stockAdjustItems1[i].Id == undefined) 
                    {
                        //document.getElementById("Accspinner").style.display = "none";
                        component.set('v.Accspinner', false);
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Duplicate serial number detected at line number : '+(i+1));
                         component.set("v.Accspinner",false);
                        return;
                    }
                }
            }
            
      //  console.log('json SAP'+JSON.stringify(stockAdjustItems1));
              //   alert('json SAP'+JSON.stringify(stockAdjustItems1));
                // var stockAdjustItems2=[];
           /* for(var i=0;i<stockAdjustItems1.length;i++)
                {
                   
                     if(JSON.stringify(stockAdjustItems1[i].sigmaerpdev2__Bin__c)==='""')
                    {
                        component.set("v.Accspinner",false);
                          component.set('v.isError', true);
            			component.set('v.errorMsg', 'Please select Bin at row '+(i+1));
                        return;
                    }
                     if(JSON.stringify(stockAdjustItems1[i].sigmaerpdev2__ILid__c)==='""')
                    { 
                        component.set("v.Accspinner",false);
                          component.set('v.isError', true);
            			component.set('v.errorMsg', 'Please select Bin at row '+(i+1));
                        return;
                    }
                 
                }*/
                   // component.set("v.Accspinner",false);
               //  return;
        var action = component.get("c.saveStockAdjustment");
        
        if(AdjsType == 'Increase Stock' ){
			
			//stockAdjustments,stockAdjustItems1
			 for(var i=0 ;i < stockAdjustItems1.length;i++)
            {
				if(stockAdjustments.sigmaerpdev2__Unit_Price__c!=undefined && JSON.stringify(stockAdjustments.sigmaerpdev2__Unit_Price__c)!='""')
				{
					stockAdjustItems1[i].sigmaerpdev2__Unit_Price__c=stockAdjustments.sigmaerpdev2__Unit_Price__c;
				}
				
			}
			// component.set("v.Accspinner",false);       
			//alert('stockAdjustItems1'+JSON.stringify(stockAdjustItems1));
			//return;
			console.log('JSON.stringify(stockAdjustItems1)>>>'+JSON.stringify(stockAdjustItems1));
            action.setParams({
                "stockAdjustments" : stockAdjustments,
                "sapItems" : JSON.stringify(stockAdjustItems1),
                "ILP" : invObj
            });
            
        }else{
            
            action.setParams({
                "stockAdjustments" : stockAdjustments,
                "sapItems" : JSON.stringify(selectedToLoad),
                "ILP" : invObj
            });
        }
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                                                                //  alert('success-1'+state);
                               if (state=== 'SUCCESS')
                               {                                   
                                   component.set("v.Accspinner",false);                                 
                                   component.set("v.successAlert",true);
                                   component.set('v.Accspinner', false);
                                   
                                   window.setTimeout(function(){  
                                         component.set("v.successAlert",true);   
                                   }, 200);
                                 
                                   window.setTimeout(function(){  
                                       component.set("v.Accspinner",false);     
                                   }, 1000);
                                   component.set("v.Accspinner",true);
                                   
                                   /*setTimeout(function(){ 
                                       var urlEvent = $A.get("e.force:navigateToURL");
                                       urlEvent.setParams({
                                           "url": "/lightning/n/sigmaerpdev2__Stock_Management"
                                       });        
                                       urlEvent.fire();   }, 3000);*/
                                   //commented above lines and added below line on 7/2/2020                                   
                                   //commented above line and added below line on 3-2-2020 to show in ManufacturingModules page after delete is completed	    
                                   
                                   setTimeout(function(){ 
                                      var evt = $A.get("e.force:navigateToComponent");
                                           evt.setParams({
                                           componentDef : "c:StockManagementModules",
                                           componentAttributes: {
                                               from : 'StkAdj'
                                           }
                                       });
                                       evt.fire();
                                   }, 1000);
                                   
                                   
                                   
                                   
                                   //ends here

                                   
                               }
                               else
                               {
                                   var errors = response.getError();
                                 
                                   if(errors[0].pageErrors[0].message)
                                   {
                                       component.set("v.errorMsg", JSON.stringify(errors[0].pageErrors[0].message));
                                       component.set("v.isError",true);
                                   } 
                                   else if(errors[0])
                                   {
                                       component.set("v.errorMsg", JSON.stringify(errors[0]));
                                       component.set("v.isError",true);
                                   }
                                   else 
                                   {
                                       component.set("v.errorMsg", JSON.stringify(errors));
                                       component.set("v.isError",true);
                                   }
                                  
                               }
                           });
        //document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action); 
                     }else if (state === "ERROR") {                    
                    var errors = response.getError();
                    alert(errors);
                }
             });
           //  component.set('v.Accspinner', true);
			//document.getElementById("Accspinner").style.display = "block";
            $A.enqueueAction(action1);
            
              }
        else
        {
          //  alert('selectedToLoad'+JSON.stringify(selectedToLoad));
           //  console.log('selectedToLoad'+JSON.stringify(selectedToLoad));
          
            
       // return; 
            var action3 = component.get("c.saveStockAdjustment");
        
        if(AdjsType == 'Increase Stock' ){
              var stockAdjustItems2=[];
            for(var i=0;i<stockAdjustItems1.length;i++)
                {
                    /*if(JSON.stringify(stockAdjustItems1[i].sigmaerpdev2__Lot__c)==='""')
                    {
                        component.set("v.Accspinner",false);
                        component.find("adjustedQty").set("v.errors", [{message:"Please select lot."}]);
                        return;
                        
                    }*/
                     if(JSON.stringify(stockAdjustItems1[i].sigmaerpdev2__Bin__c)==='""')
                    {
                        component.set("v.Accspinner",false);
                          component.set('v.isError', true);
            			component.set('v.errorMsg', 'Please select Bin');
                        //component.find("adjustedQty").set("v.errors", [{message:"Please select Bin."}]);
                        return;
                    }
                
                     /*if(JSON.stringify(stockAdjustItems1[i].sigmaerpdev2__Product_Expiry_Date__c)==='""')
                    {
                        component.set("v.Accspinner",false);
                          component.set('v.isError', true);
            			component.set('v.errorMsg', 'Please select expiredate.');
                       // component.find("adjustedQty").set("v.errors", [{message:"Please select expiredate."}]);
                        return;
                        
                    }*/
                   // stockAdjustItems2.
                }
			//stockAdjustments,stockAdjustItems1
			 for(var i=0 ;i < stockAdjustItems1.length;i++)
            {
				if(stockAdjustments.sigmaerpdev2__Unit_Price__c!=undefined && JSON.stringify(stockAdjustments.sigmaerpdev2__Unit_Price__c)!='""')
				{
					stockAdjustItems1[i].sigmaerpdev2__Unit_Price__c=stockAdjustments.sigmaerpdev2__Unit_Price__c;
				}
			}
              //component.set("v.Accspinner",false);       
			//alert('stockAdjustItems1'+JSON.stringify(stockAdjustItems1));
			//return;
           // alert('json SAP'+JSON.stringify(stockAdjustItems1));
          
           
            
            action3.setParams({
                "stockAdjustments" : stockAdjustments,
                "sapItems" : JSON.stringify(stockAdjustItems1),
                "ILP" : invObj
            });
            
        }else{
            
            action3.setParams({
                "stockAdjustments" : stockAdjustments,
                "sapItems" : JSON.stringify(selectedToLoad),
                "ILP" : invObj
            });
        }
        //alert('1');
        action3.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (state=== 'SUCCESS')
                               {                                                                       
                                   
                                   window.setTimeout(function(){  
                                         component.set("v.successAlert",true);   
                                   }, 200);
                                 
                                   window.setTimeout(function(){  
                                       component.set("v.Accspinner",false);     
                                   }, 1000);
                                   component.set("v.Accspinner",true);
                                   
                                   
                                   /*setTimeout(function(){ 
                                        
                                       var urlEvent = $A.get("e.force:navigateToURL");
                                       urlEvent.setParams({
                                           "url": "/lightning/n/sigmaerpdev2__Stock_Management"
                                       });        
                                       urlEvent.fire();   }, 3000);*/
                                   
                                   setTimeout(function(){ 
                                      var evt = $A.get("e.force:navigateToComponent");
                                           evt.setParams({
                                           componentDef : "c:StockManagementModules",
                                           componentAttributes: {
                                               from : 'StkAdj'
                                           }
                                       });
                                       evt.fire();
                                   }, 1000);
                                   //ends here
                                  
                                   
                                    //component.set("v.Accspinner",false);
                                   //alert('success-2');
                                   //var recid=component.get("v.recordId");
                                  
                                  
                                 /*  var navEvt = $A.get("e.force:navigateToSObject");
                                   navEvt.setParams({
                                       "recordId": component.get("v.recordId"),
                                       "slideDevName": "related"
                                   });
                                   navEvt.fire();*/
                                    //window.location.href = "/one/one.app#/sObject/" + recid;
                               }
                               else
                               {
                                   var errors = response.getError();
                                  
                                      
                                   if(errors[0].pageErrors[0].message)
                                   {
                                       component.set("v.errorMsg", JSON.stringify(errors[0].pageErrors[0].message));
                                       component.set("v.isError",true);
                                   } 
                                   else if(errors[0])
                                   {
                                       component.set("v.errorMsg", JSON.stringify(errors[0]));
                                       component.set("v.isError",true);
                                   }
                                   else 
                                   {
                                       component.set("v.errorMsg", JSON.stringify(errors));
                                       component.set("v.isError",true);
                                   }
                                  
                               }
                           });
           // component.set('v.Accspinner', true);
        //document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action3); 
           
        }
    },
    fetchIlplidata : function(component, event) 
    {		       
       var recordInvId = component.get("v.recordIDILP.Id");
        //alert(recordInvId);
        var action = component.get("c.fetchILPLI");  
        action.setParams({
            "invLocPrdId" : recordInvId
        });
        
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (state=== 'SUCCESS')
                               {
                                   //alert('success-3');
                                   var ILPLIdata = response.getReturnValue();
                                  // alert('value'+JSON.stringify(ILPLIdata));
                                   component.set('v.Ilplidata',ILPLIdata);
                                   
                               }
                               else
                               {
                                   var errors = response.getError();
                                   if (errors) {
                                       if (errors[0] && errors[0].message) {
                                           alert("Error message: " + 
                                                 errors);
                                       }
                                   } else {
                                       alert("Unknown error");
                                   }
                                   
                               }
                               
                           });
        
        $A.enqueueAction(action); 
    }
})