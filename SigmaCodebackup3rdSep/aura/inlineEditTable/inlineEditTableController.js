({
     fetchStock: function(component, event, helper) {
      
        var action = component.get("c.fetchDefaultValues");
         
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if (a.getReturnValue()) {
                    var result  = a.getReturnValue();
                    console.log(JSON.stringify(a.getReturnValue()));
                   // alert(JSON.stringify(result));
                    if(result.numOfRec>0){
                        component.set("v.ProductList",result.lstOfProduct);
                        
                        component.set('v.numberOfRecordsToDisplay',result.numberOfRecordsOnLoadMoreClick);
                        component.set('v.numberOfRecordsOnLoadMoreClick',result.numberOfRecordsToDisplay);
                        component.set('v.totalRowCount',result.numOfRec);

                    }
                      } 
                 helper.fetchUser(component, event,helper);
            }   
        });
        $A.enqueueAction(action);
    },
     sortProductName:  function(component, event,helper) {
       var spinner=component.find('spinner');
        $A.util.removeClass(spinner, 'slds-hide');
        
        $A.util.toggleClass(component.find('dueDateArrowup'),'slds-hide');
        $A.util.toggleClass(component.find('dueDateArrowdown'),'slds-hide');
        if(component.get('v.ProductNameSort')!='desc')
            component.set('v.ProductNameSort','desc');
        else
            component.set('v.ProductNameSort','asc');
        helper.getProductDetailsHelper1(component, event, helper,'sigmaerpdev2__Product_Name__r.Name',component.get('v.ProductNameSort'));
   },
    sortLocationName:  function(component, event,helper) {
       var spinner=component.find('spinner');
        $A.util.removeClass(spinner, 'slds-hide');
        
        $A.util.toggleClass(component.find('dueDateArrowup'),'slds-hide');
        $A.util.toggleClass(component.find('dueDateArrowdown'),'slds-hide');
        if(component.get('v.LocationNameSort')!='desc')
            component.set('v.LocationNameSort','desc');
        else
            component.set('v.LocationNameSort','asc');
        helper.getProductDetailsHelper1(component, event, helper,'sigmaerpdev2__Vendor_Location__r.Name',component.get('v.LocationNameSort'));
   },
     loadMoreContent:function (component, event, helper) {
        var spinner=component.find('spinner');
        $A.util.removeClass(spinner, 'slds-hide');
        if(component.get('v.numberOfRecordsToDisplay') && component.get('v.numberOfRecordsOnLoadMoreClick'))
            component.set('v.numberOfRecordsToDisplay',component.get('v.numberOfRecordsToDisplay')+component.get('v.numberOfRecordsOnLoadMoreClick'));
        else
        component.set('v.numberOfRecordsToDisplay',component.get('v.numberOfRecordsToDisplay')+20);
       // this.fetchStock(component, event, helper);
      // alert('98>>>>'+component.get('v.ActualAvailabilityQtySort'));
        
     // alert('100'+component.get('v.ActualAvailabilityQtySort'));
        if(component.get('v.ProductNameSort')==undefined){
            helper.getProductDetailsHelper1(component, event, helper);
        }
        else  if(component.get('v.LocationNameSort')==undefined){
            helper.getProductDetailsHelper1(component, event, helper);
        }
          else  if(component.get('v.LocationNameSort')!==undefined){
            helper.getProductDetailsHelper1(component, event, helper,'sigmaerpdev2__Vendor_Location__r.Name',component.get('v.LocationNameSort'));
            
        }
        // alert('alert>>>>'+component.find("searchKey").get("v.value"));
      
   
           else if(component.get('v.ProductNameSort')!=undefined){
        helper.getProductDetailsHelper1(component, event, helper,'sigmaerpdev2__Product_Name__r.Name',component.get('v.ProductNameSort'));
            }
           else if(component.find("searchKey").get("v.value")!=undefined){
            helper.searchKeyChangehelper(component, event, helper);     
           }
               else{
                   System.debug('error');
               }
       
 },
    initRecords: function(component, event, helper,page,pageNumber, pageSize) {
        // call the apex class method and fetch Product wrapper
         var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        var action = component.get("c.fetchProductforpagination");
         action.setParams({             
            "pageNumber": pageNumber,
            "pageSize": pageSize
           
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('State : '+state);
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
               //alert(JSON.stringify(storeResponse.lstOfProduct));
                
                //component.set("v.ProductList", storeResponse);
                
                    component.set("v.PageNumber", storeResponse.pageNumber);
                     component.set("v.TotalRecords", storeResponse.totalRecords);
                     component.set("v.RecordStart", storeResponse.recordStart);
                     component.set("v.RecordEnd", storeResponse.recordEnd);
                     component.set("v.TotalPages", Math.ceil(storeResponse.totalRecords / pageSize));
                    component.set("v.ProductList", storeResponse.lstOfProduct);
               
                  
                helper.fetchUser(component, event,helper);
            }
        });
        $A.enqueueAction(action);
    },
     sortArrowup:  function(component, event,helper) {
        // alert('up');
        var sortArrowup = component.find("sortArrowup");
        // alert('sortArrowup>>'+sortArrowup);
          //var pageNumber = component.get("v.PageNumber");  
        //var pageSize = component.find("pageSize").get("v.value");
        $A.util.toggleClass(sortArrowup, 'slds-hide');
        var sortArrowdown = component.find("sortArrowdown");
        $A.util.toggleClass(sortArrowdown, 'slds-hide');
        helper.getArrowUpHelper(component, event, helper);
         
    },
    sortArrowdown:  function(component, event,helper) {
        //alert('down');
        var sortArrowup = component.find("sortArrowup");
        $A.util.toggleClass(sortArrowup, 'slds-hide');
        var sortArrowdown = component.find("sortArrowdown");
        $A.util.toggleClass(sortArrowdown, 'slds-hide');
        helper.getArrowdownHelper(component, event, helper);
    },
    sortArrowupforLocation:function(component, event,helper) {
         //alert('up');
        var sortArrowupforLocation = component.find("sortArrowupforLocation");
        // alert('sortArrowupforLocation>>'+sortArrowupforLocation);
          //var pageNumber = component.get("v.PageNumber");  
        //var pageSize = component.find("pageSize").get("v.value");
        $A.util.toggleClass(sortArrowupforLocation, 'slds-hide');
        var sortArrowdownforLocation = component.find("sortArrowdownforLocation");
        $A.util.toggleClass(sortArrowdownforLocation, 'slds-hide');
        helper.getArrowUpHelperforLocation(component, event, helper);
         
    },
    sortArrowdownforLocation:  function(component, event,helper) {
        //alert('down1');
        var sortArrowupforLocation = component.find("sortArrowupforLocation");
        $A.util.toggleClass(sortArrowupforLocation, 'slds-hide');
        var sortArrowdownforLocation = component.find("sortArrowdownforLocation");
        $A.util.toggleClass(sortArrowdownforLocation, 'slds-hide');
        helper.getArrowdownHelperforLocation(component, event, helper);
    },
    
         
       
    initRecords1: function(component, event, helper,page) {
        page = page || 1; 
        // call the apex class method and fetch Product list  
        var action = component.get("c.fetchProduct");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('State : '+state);
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                console.log(JSON.stringify(storeResponse));
                // set productList list with return value from server.
                component.set('v.total', storeResponse.totalSigma);
                component.set('v.page', storeResponse.pageSigma);
                component.set('v.pages', Math.ceil(storeResponse.totalSigma/storeResponse.pageSizeSigma));
                
                component.set("v.ProductList", storeResponse);
                console.log('ProductList >>'+JSON.stringify(component.get("v.ProductList")));
            }
        });
        $A.enqueueAction(action);
    },
    Save: function(component, event, helper) {
       component.set("v.Spinner",true);
       // alert('inside save');
        // Check required fields(Name) first in helper method which is return true/false
        //if (helper.requiredValidation(component, event)){
        // call the saveAccount apex method for update inline edit fields update 
        // console.log('After save 1>>'+JSON.stringify(component.get("v.wrapperList")));    
        var action = component.get("c.saveProduct");
          var lstProduct = component.get('v.ProductList');
       // alert('111>>>'+JSON.stringify(lstProduct))
        action.setParams({
            'lstProduct':lstProduct
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert('101'>>+state);
            if (state === "SUCCESS") {
                
                console.log("Success lstProduct");
                component.set("v.spinner",true);
                var storeResponse =response.getReturnValue();
                // set AccountList list with return value from server.
               
                component.set("v.ProductList", storeResponse);
                // Hide the save and cancel buttons by setting the 'showSaveCancelBtn' false 
               //component.set("v.Spinner",true);
                //component.set("v.showSaveCancelBtn",true);
               
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "The stocks has been updated successfully."
                });
                toastEvent.fire();
                component.set("v.Spinner",false); 
            }
             
           // component.set("v.showSaveCancelBtn",false);
        });
        $A.enqueueAction(action);
       
        /*} */
    },
    Save1: function(component, event, helper) {
        component.set("v.spinner",true);
        //alert('inside save');
        // Check required fields(Name) first in helper method which is return true/false
        //if (helper.requiredValidation(component, event)){
        // call the saveAccount apex method for update inline edit fields update 
        
        var lstProduct = component.get('v.wrapperList');
        console.log('After save>>'+JSON.stringify(component.get("v.lstProduct")));
        var action = component.get("c.saveProduct");
        action.setParams({ "lstProduct": JSON.stringify(lstProduct)});
        
        /*action.setParams({
                'lstProduct': component.get("v.ProductList")
            });*/
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                component.set("v.spinner",false);
                var storeResponse = response.getReturnValue();
                // set AccountList list with return value from server.
                component.set("v.ProductList", storeResponse);
                // Hide the save and cancel buttons by setting the 'showSaveCancelBtn' false 
                component.set("v.showSaveCancelBtn",false);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "The stocks has been updated successfully."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        /*} */
    },
    cancel : function(component,event,helper){
        // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    },
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getproductlist(component, event, helper,page);
    },
    onSelectChange: function(component, event, helper) {
        //alert('1>>')
        var page = 1
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.find("pageSize").get("v.value");
        //alert('pageSize>>'+pageSize)
        //alert('pageNumber>>'+pageNumber)
        helper.getproductDetailsHelper(component, pageNumber, pageSize);
    },
     handleNext: function(component, event, helper) {
          //alert('2>>')
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        var lstProduct= component.get('v.ProductList');
        alert(JSON.stringify(lstProduct));
        helper.getproductDetailsHelper(component, pageNumber, pageSize,lstProduct);

    },
     
    handlePrev: function(component, event, helper) {
         //alert('3>>')
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        var lstProduct= component.get('v.ProductList');
        alert(JSON.stringify(lstProduct));
        helper.getproductDetailsHelper(component, pageNumber, pageSize,lstProduct);

    },
     searchKeyChangeForLoadmore: function(component, event,helper) {
       // component.set("v.isErrorHead", false);
        helper.searchKeyChangehelper(component, event, helper);     
    },
    searchKeyChange: function(component, event) {
        var searchKey = component.find("searchKey").get("v.value");
        
    // alert('searchKey:::::'+searchKey);
        var action = component.get("c.FindBySearchQuery");
        action.setParams({
            "searchKey": searchKey
            
        });
        action.setCallback(this, function(response) {
             var storeResponse = response.getReturnValue();
             //alert('storeResponse:::::'+storeResponse.lstOfProduct);
            component.set("v.ProductList", storeResponse.lstOfProduct);
        });
        $A.enqueueAction(action);
    },
   AddProductToLocationfunction:function(component,event,helper){
        //alert('hi')
    component.set("v.addNewProduct",true);
       
       component.set("v.currentComp",false);
       
},
     //Call by aura:waiting event  
    handleShowSpinner: function(component, event, helper) {
        component.set("v.isSpinner", true); 
    },
     
    //Call by aura:doneWaiting event 
    handleHideSpinner : function(component,event,helper){
        component.set("v.isSpinner", false);
    }
                                             
    
})