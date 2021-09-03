({
    getProductDetailsHelper1: function(component, event, helper,sortField,ascDesc) {
       // alert('inside helper>>');
       // alert('sortField>>'+sortField);
        // call the apex class method and fetch Product wrapper
         var searchKey = component.find("searchKey").get("v.value");
        console.log('searchKey:::::'+searchKey); 
       //  alert('searchKey>>'+searchKey);
        
        var action = component.get("c.fetchProductforloadmore");
         action.setParams({             
           'numberOfRecordsToDisplay':component.get('v.numberOfRecordsToDisplay'),
            'sortField':sortField,
            'ascDesc':ascDesc,
            'searchKey': searchKey
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('State : '+state);
            if (state === "SUCCESS") {
                //alert(' inside State : '+state); 
                var storeResponse = response.getReturnValue();
              // alert(JSON.stringify(storeResponse.lstOfProduct));
                
                //component.set("v.ProductList", storeResponse);
                
                    /*component.set("v.PageNumber", storeResponse.pageNumber);
                     component.set("v.TotalRecords", storeResponse.totalRecords);
                     component.set("v.RecordStart", storeResponse.recordStart);
                     component.set("v.RecordEnd", storeResponse.recordEnd);
                     component.set("v.TotalPages", Math.ceil(storeResponse.totalRecords / pageSize));*/
                  // component.set("v.numberOfRecordsOnLoadMoreClick",storeResponse.numberOfRecordsOnLoadMoreClick);
  
                component.set("v.ProductList", storeResponse.lstOfProduct);
               component.set("v.numberOfRecordsOnLoadMoreClick",storeResponse.numberOfRecordsOnLoadMoreClick);
                  
                this.fetchUser(component, event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    searchKeyChangehelper: function(component,event, helper) {
         var searchKey = component.find("searchKey").get("v.value");
        
   // alert('searchKey:::::'+searchKey);
        var action = component.get("c.FindBySearchQuery1");
        action.setParams({
            "searchKey": searchKey,
            "numberOfRecordsToDisplay":component.get("v.numberOfRecordsToDisplay")
            
        });
        action.setCallback(this, function(response) {
             var storeResponse = response.getReturnValue();
             //alert('storeResponse:::::'+JSON.stringify(storeResponse));
            component.set("v.ProductList", storeResponse.lstOfProduct);
           
        });
        $A.enqueueAction(action);
        
    },
    
   fetchUser : function(component, event, helper) {
	var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    getArrowUpHelper:function(component, event, helper) {
         var action = component.get("c.fetcharrowupdata");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('State : '+state);
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                //alert(JSON.stringify(storeResponse));
                
                component.set("v.ProductList", storeResponse); 
                console.log('ProductList >>'+JSON.stringify(component.get("v.ProductList")));
               
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
    getArrowdownHelper:function(component, event, helper) {
         var action = component.get("c.fetcharrowdowndata");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('State : '+state);
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                //alert(JSON.stringify(storeResponse));
                
                component.set("v.ProductList", storeResponse); 
                console.log('ProductList >>'+JSON.stringify(component.get("v.ProductList")));
               
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
    getArrowUpHelperforLocation:function(component, event, helper) {
         var action = component.get("c.fetcharrowupdataforLocation");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('State : '+state);
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                //alert(JSON.stringify(storeResponse));
                
                component.set("v.ProductList", storeResponse); 
                console.log('ProductList >>'+JSON.stringify(component.get("v.ProductList")));
               
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
    getArrowdownHelperforLocation:function(component, event, helper) {
        //alert('inside location down helper');
         var action = component.get("c.fetcharrowdowndataforLocation");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('State : '+state);
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                //alert(JSON.stringify(storeResponse));
                
                component.set("v.ProductList", storeResponse); 
                console.log('ProductList >>'+JSON.stringify(component.get("v.ProductList")));
               
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
    getproductDetailsHelper : function(component, pageNumber, pageSize,lstProduct){
      //alert("inside productdetailshelper")

        var action = component.get("c.fetchProductforpagination");
        action.setParams({ 
            
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "lstProduct":lstProduct
           
        });
        action.setCallback( this, function(response){
            var state = response.getState();
            var datacheck=response.getReturnValue();
            if (state === "SUCCESS"){
                //alert('state>>'+state)
                if(response.getReturnValue()){
                    var result  = response.getReturnValue();
                  // alert(JSON.stringify(response.getReturnValue()));
                  // alert(JSON.stringify(result.totalRecords));
                  
                     component.set("v.PageNumber", result.pageNumber);
                     component.set("v.TotalRecords", result.totalRecords);
                     component.set("v.RecordStart", result.recordStart);
                     component.set("v.RecordEnd", result.recordEnd);
                     component.set("v.TotalPages", Math.ceil(result.totalRecords / pageSize));
                     component.set("v.ProductList", result.lstOfProduct);
                     //component.set("v.ProductList", lstProduct);
                                            }
                    
                        }
        });
        $A.enqueueAction(action);
    },
    
    getproductlist : function(component, event, helper,page) 
    {
        page = page || 1;
        var action = component.get("c.fetchProduct");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('State : '+state);
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                console.log(JSON.stringify(storeResponse));
                console.table(storeResponse);
               // alert(JSON.stringify(storeResponse));
                // set productList list with return value from server.
                component.set('v.total', storeResponse.totalSigma);
                component.set('v.page', storeResponse.pageSigma);
                component.set('v.pages', Math.ceil(storeResponse.totalSigma/storeResponse.pageSizeSigma));
                component.set("v.ProductList", storeResponse);
            }
        });
        $A.enqueueAction(action);
    }
})