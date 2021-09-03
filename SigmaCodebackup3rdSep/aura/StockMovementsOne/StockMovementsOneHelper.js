({

    fetchILPdata : function(component, event, helper){
        // var il = component.get("v.FormLocId");
        var il = component.get("v.recID");
        var binId = component.get("v.binId");
     //   alert('il'+il);
       //  alert('binId'+binId);
      //  return;
       component.set("v.isError",false);
        component.set("v.errorMsg",null);
       
        var action = component.get("c.fetchILP");
        action.setParams({ "ilId":il,
                          "BId" :component.get("v.binId")});
        action.setCallback( this, function(a) 
                           {
                               var state = a.getState();
                               console.log('state'+state);
                               if (state === "SUCCESS") 
                               {
                                   console.log('a.getReturnValue()>>'+a.getReturnValue());
                                   if(a.getReturnValue() !== null)
                                   {
                                       
                                       var temp = a.getReturnValue();
                                     //  alert('temp>>'+JSON.stringify(temp));
                                       console.log('temp>>'+JSON.stringify(temp));
                                       component.set("v.ILPlist", temp);
                                   } else{
                                       alert('Fetching ILP data Failed');
                                   }   
                               }
                               else
                               {
                                   alert('Fetching ILP data Failed');
                               }
                           });  
        //document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action);        
    },
 SaveStockMovement :function(component, event, helper){
     component.set("v.loaded",'false');
        
        setTimeout(function(){         
                            component.set("v.loaded",'true');  
                             }, 5000);
     	        var fromId = component.get("v.recID");
        //var fromId = component.get("v.FromLocId");
        var ILPdata = component.get("v.ILPlist");
     	var binId = component.get("v.binId");
     console.log('befor save stock movement fromId>>'+JSON.stringify(fromId));
     console.log('befor save stock movement ILPdata>>'+JSON.stringify(ILPdata));
     console.log('befor save stock movement binId>>'+JSON.stringify(binId));
       // console.log('JSON.stringify(ILPdata) '+JSON.stringify(ILPdata));
        var action = component.get("c.SaveStockMovementdata");
		action.setParams({ 
            "fromId": fromId,
            "binId":binId,
            "ILPdata": JSON.stringify(ILPdata)
        });
        
        action.setCallback( this, function(a) 
                           {	
                               var state = a.getState();
                               if (state === "SUCCESS") {
								   component.set("v.curRecordID",a.getReturnValue().Id);
                                   
                                   if(a.getReturnValue() !== null){
                                       
                                       if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one)) {
                                          
											var successAlert = component.find("successAlert");
											$A.util.removeClass(successAlert,'slds-hide');
                                          
                                       }else{
                                           //window.location.href = "/" + a.getReturnValue().Id;
                                           //commented above line and added below line on 7/2/2020 to open newly created SM record in new tab 
                                           //and also show StkManangementModule new UI page after submit is clicked 
                                           
                                           alert('Stock Movement record created successfully.');
                                           
                                           var evt = $A.get("e.force:navigateToComponent");
                                           evt.setParams({
                                               componentDef : "c:StockManagementModules",
                                               componentAttributes: {
                                                   from : 'StkMvM',
                                                   stkMId : a.getReturnValue().Id
                                               }
                                           });
                                           evt.fire();                                           
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
                               }else{
                                  
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
    }
})