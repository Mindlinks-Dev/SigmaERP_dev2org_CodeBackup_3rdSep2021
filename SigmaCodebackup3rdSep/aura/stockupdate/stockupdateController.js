({        
     fetchproducts : function(component, event, helper) {
         console.log('fetchproducts');
        
         var spinner = component.find('spinner');
         $A.util.toggleClass(spinner, "slds-hide");
         helper.toGetcustomerData(component, event,helper); 
        /*
         var action = component.get("c.fetchproductRecords");
         var pageSize = component.get("v.pageSize").toString();
         var pageNumber = component.get("v.pageNumber").toString();
         
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber
        });
          
        
         action.setCallback(this, function(response){
              var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success');
                var resultData = response.getReturnValue();
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultData.length);
             
             alert('response>>>'+JSON.stringify(response.getReturnValue()));
             
             component.set("v.productList",response.getReturnValue());
            }
            
         });
         component.set('v.mycolumn', [
             {label: 'Product Name', fieldName: 'sigmaerpdev2__Product_Name__r.name', type: 'text'},
             {label: 'Product Code', fieldName: 'sigmaerpdev2__Product_Name__r.ProductCode', type: 'Text'},
             {label: 'Current Vendor Stock', fieldName: 'sigmaerpdev2__Product_Name__r.sigmaerpdev2__CurrentVendorStock__c', type: 'number',editable: true},
             {label: 'Location', fieldName: '', type: 'lookup',editable: true}
            

         ]);
                                   
         
         $A.enqueueAction(action);*/
     },
   handleSave : function(component, event, helper) {
        
        debugger;    
        var draftValues = event.getParam('draftValues');
        console.log('draftValues-> ' + JSON.stringify(draftValues));
        //alert('draftValues-> ' + JSON.stringify(draftValues))
        var action = component.get('c.updateproductrecords');
       // action.setParams({"productsList": draftValues});
        action.setParams({"updatedproductList": draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               // alert('state>>>>>>'+state)
               // helper.fireSuccessToast(component); 
                 var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                     "title": "Success!",
                     "message": "The record has been updated successfully."
                       });
                      toastEvent.fire(); 
                    $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                //helper.fireFailureToast(component); 
                var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                     "title": "Success!",
                     "message": "The record updation has been  failed."
                        });
                      toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
     handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        this.fetchproducts(component, helper);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        this.fetchproducts(component, helper);
    },
    
    
 })