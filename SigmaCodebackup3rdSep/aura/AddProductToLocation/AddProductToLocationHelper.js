({
    createObjectData: function(component, event) { 
        var RowItemList = component.get("v.ProductWrapper");
        
        RowItemList.push({
            'sobjectType': 'sigmaerpdev2__Vendor_Product__c',
            'sigmaerpdev2__Product_Name__r.Name': '',
            'sigmaerpdev2__VendorProductCode__c':'',
            'sigmaerpdev2__Vendor_Location__r.Name': '',
            'sigmaerpdev2__current_stock__c': '',
            'sigmaerpdev2__Last_Updated_Date__c': ''
        });  
        component.set("v.ProductWrapper", RowItemList);
        //alert(JSON.stringify(component.get("v.ProductWrapper")));
    },
    
    
    validateRequired: function(component, event) {
        var isValid = true;
        var allContactRows = component.get("v.ProductWrapper");
        for (var indexVar = 0; indexVar < allContactRows.length; indexVar++) {
            if (allContactRows[indexVar].FirstName == '') {
                isValid = false;
                alert('First Name Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }
        return isValid;
    },
    saveProduct : function(component, event, helper,prodtolocList){
       // alert('helper called');
       // alert('Inside save method'+JSON.stringify(component.get("v.VPlistparam")));
        
        //console.log('Inside save method'+JSON.stringify(component.get("v.VPlistparam")));
        
        
        var action = component.get("c.saveData");
        
        action.setParams({
            VPlistparamParam: JSON.stringify(component.get("v.VPlistparam"))            
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
             //alert('state : '+state);
            if (component.isValid() && state === "SUCCESS"){
                // var response = JSON.stringify(result.getReturnValue());
                //alert('response : '+response);
                if(state === "SUCCESS")  
                {
                    component.set("v.Spinner",true); 
                    //alert('Product Added Succesfully');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The new product has been added successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.LocationWrapper",response); 
                    //$A.get('e.force:refreshView').fire();
                    
                }
                else
                {
                    //alert('Else');
                    
                }   
                
            }
            //  $A.get('e.force:refreshView').fire();
            //  component.set('v.addNewProduct',false);
        });
        $A.enqueueAction(action);    
        
    },
    
    saveProduct1: function(component, event, helper){
        
        alert('Inside save method'+JSON.stringify(component.get("v.LocationWrapper")));
        alert('69>>>'+component.get("v.ProductItem.sigmaerpdev2__Product_Name__r.Name"))
        alert('70>>>'+component.find("productsCodeLocationInput").get("v.value"))
        alert('72>>>'+JSON.stringify(component.get("v.LocationfromEvent")));
        alert('73>>>'+JSON.stringify(component.get("v.ProductFromEvent")));
        
        var action = component.get("c.saveData");
        action.setParams({
            LocationWrapperParam: JSON.stringify(component.get("v.LocationWrapper")),  
            productName:component.get("v.ProductItem.sigmaerpdev2__Product_Name__r.Name"),
            productCode:component.find("productsCodeLocationInput").get("v.value"),
            currentstockanddate:component.get("v.ProductFromEvent")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            alert('state : '+state);
            if (component.isValid() && state === "SUCCESS"){
                // var response = JSON.stringify(result.getReturnValue());
                //alert('response : '+response);
                if(state === "SUCCESS")  
                {
                    //alert('Product Added Succesfully');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The new product has been added successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                    component.set("v.LocationWrapper",response);  
                    
                }
                else
                {
                    //alert('Else');
                    
                }   
                
            }
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
    checkProductExists : function(component, event, helper) {
        
        //call apex class method
        var action = component.get('c.fetchLocationForNewProductWrapper');
        
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                
                //set response value in wrapperList attribute on component.
                component.set('v.LocationWrapper', response.getReturnValue());
                console.log('LocationWrapper  fetchLocationForNewProductWrapper: '+component.get('v.LocationWrapper'));
            }
        });
        $A.enqueueAction(action);
    },
    checkProductExists1 : function(component, event, helper) {
        var newProductItem = component.get("v.ProductItem");
        var items = component.get("v.locationWrapper");
        var item = JSON.parse(JSON.stringify(newProductItem));
        console.log('item ProductName : '+JSON.stringify(newProductItem.ProductName));
        var action = component.get("c.checkProductExists");
        
        action.setParams({
            ProductName: JSON.stringify(newProductItem.ProductName),
            LocationId:JSON.stringify(newProductItem.LocationId)
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            alert('state : '+state);
            if (component.isValid() && state === "SUCCESS"){
                var response = result.getReturnValue();
                if(response.Status === 'Product Exist')  
                {
                    //alert('Location Added Succesfully');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Product Exist.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                }
                else
                {
                    //alert('Else');
                    
                }   
                
            }
        });
        $A.enqueueAction(action);
    },
    loadData: function(component, event, helper,pid){   
        //alert('191');
        var action = component.get('c.fetchLocationForNewProductWrapper');
        action.setParams({
            ProductName:pid
            
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
           // alert('138>>>'+state);
           // alert(JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //set response value in wrapperList attribute on component.
               // alert('205');
                component.set('v.LocationWrapper', response.getReturnValue());
              
              
              // alert('locationWrapper fetchLocationForNewProductWrapper : '+JSON.stringify(component.get('v.LocationWrapper')));
               // alert('189>>>'+JSON.stringify(response.getReturnValue().lStrings))
            }
            else if(state === "ERROR") {
                
                var errors = response.getError();
                alert('Error Details : '+JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    }
    
})