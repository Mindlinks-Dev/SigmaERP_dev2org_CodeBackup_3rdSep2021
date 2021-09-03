({
	createStockIn: function(component, newStockIn) {
   
         this.upsertExpense(component, newStockIn, function(a) {
             newStockIn = component.get("v.StockIn");
            newStockIn.push(a.getReturnValue());
            component.set("v.StockIn", newStockIn);
        });  
	}
     ,
    upsertExpense : function(component, newStockIn, callback) {
        var action = component.get("c.saveStockIn");
          newStockIn.sigmaerpdev__Vendor__c=component.get("v.VendorId");
          newStockIn.sigmaerpdev__Location__c=component.get("v.RLocationId");
          newStockIn.sigmaerpdev__Delivery_Person__c=component.get("v.DeliveryPersonId");
         var valStockInProd=component.get("v.StockInProduct");
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
               for(var j=i+1;j<valStockInProd.length;j++)
                  {
                       if(valStockInProd[i].Pur_Order_Name==valStockInProd[j].Pur_Order_Name && valStockInProd[i].PO_Name==valStockInProd[j].PO_Name&& valStockInProd[i].Loc_Name==valStockInProd[j].Loc_Name)
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
     
           action.setParams
            ({ 
                "StockInObj": newStockIn,
                "packageProduts" : JSON.stringify(component.get("v.StockInProduct")),
                "proSerNumber"   : JSON.stringify(component.get("v.ProductSerNumberList")) //$A.util.json.encode(component.get("v.packageProducts"))
            });
          action.setCallback( this, function(a) 
                           {
                               var state = a.getState();
                              
                               if (state === "SUCCESS") 
                               {
                                   component.set("v.curRecordID",a.getReturnValue().Id);
                                   if(a.getReturnValue() !== null)
                                   {
                                       if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one)) 
                                       {
                                           
                                           var successAlert = component.find("successAlert");
                                           $A.util.removeClass(successAlert,'slds-hide');
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
         document.getElementById("Accspinner").style.display = "block";
          $A.enqueueAction(action);
          
    },
	
    
    
})