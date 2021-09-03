({
    
    // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function  
      
        //helper.createObjectData(component, event);
        helper.fetchUser(component, event,helper);
        
      //  helper.loadData(component, event, helper);
        
        var today = new Date();
        component.set('v.ProductItem.AsOfDate', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        
    },
    populateCode : function(component, event, helper){
       // alert('18');
        var pid=component.get("v.ProductItem.sigmaerpdev2__Product_Name__c");
        if(pid==null || pid==undefined || pid==''){
            component.set('v.productcode','');
            component.set('v.LocationWrapper','');
        }
        else{
        var action = component.get("c.getCode");
            action.setParams({
                pid:pid
            
        		});
           
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                   // alert('state>>'+state);
                    // if response if success then reset/blank the 'productList' Attribute 
                    // and call the common helper method for create a default Object Data to Contact List 
                    component.set("v.productcode", response.getReturnValue());
                    
                }
            });
      // helper.loadData(component, event, helper,pid);
            // enqueue the server side action  
            $A.enqueueAction(action);
        helper.loadData(component, event, helper,pid);
        }
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {
       // alert('Save');
        
        
       // alert('42>>>'+JSON.stringify(component.get("v.VPlistparam")));
        
        
        //alert('Index>>'+component.get("v.rowIndex"));
        
       // var ProductName= component.get("v.ProductItem.sigmaerpdev2__Product_Name__r.Name");
       // var CurrentStock= component.get("v.VPlistparam");
       // alert('CurrentStock>>'+CurrentStock);
      // alert('ProductName>>'+ProductName);
        
        
      // var ProductName = component.find("productsLocationInput").get("v.value");
        var ProductName= component.get("v.ProductItem.sigmaerpdev2__Product_Name__r.Name");
       
        //alert('ProductName>>>>'+ProductName)
          var resultdata = component.get("v.VPlistparam"); 
        
       console.log('58>> '+JSON.stringify(resultdata));
        var validdata = [];
        if(ProductName == null || ProductName == ''){
            alert('Please Enter New Product');
            return;
        }
         for(var i=0; i<resultdata.length; i++)
        {
         console.log('loop : '+JSON.stringify(resultdata[i]));
         /*if(resultdata[i].sigmaerpdev2__Current_Stock__c != 0 && (resultdata[i].sigmaerpdev2__Buying_Price__c  == null || resultdata[i].sigmaerpdev2__Buying_Price__c == '')){
                //alert('bp'); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please enter price for "+ resultdata[i].sigmaerpdev2__Vendor_Location__r.Name+'.',
                    "type": "error"
                });
                toastEvent.fire();
                return; 
         }*/
         if( resultdata[i].sigmaerpdev2__Current_Stock__c > 0 &&  resultdata[i].sigmaerpdev2__Buying_Price__c > 0){
         
             validdata.push(resultdata[i]);
            component.set("v.VPlistparam",validdata);
         }
         
  
        }
       
        if(validdata.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Enter atleast one product\'s current stock and price  ." , 
                "type": "error"
            });
            toastEvent.fire();
            return;
        }
 else{
            
            var prodtolocList = component.get("v.VPlistparam");
           console.log('VPlistparam inside  save : '+JSON.stringify(prodtolocList));
        
            helper.saveProduct(component, event, helper,prodtolocList);
 }
    },
    
    
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    // function for delete the row 
   /* removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        alert(index);
        var AllRowsList = component.get("v.LocationWrapper");
       // alert('AllRowsList>>'+JSON.stringify(AllRowsList))
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.LocationWrapper", AllRowsList);
     
    },*/
     removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
         var AllRowsList =component.get("v.LocationWrapper");
        alert(index);
         alert(JSON.stringify(AllRowsList));
       
             AllRowsList.splice(index, 1);
       
        component.set("v.LocationWrapper", AllRowsList);
    },
    getValues:function(component, event, helper){
        var productData=event.getParam("ProductItem");
        var locData=event.getParam("LocationInstanceInner");
        component.set("v.LocationfromEvent",locData);
        component.set("v.ProductFromEvent",productData);
    },
  /* addNewProduct1: function(component, event, helper) {        
        
        console.log('addNewproduct');
        var validProduct = component.find('productsInput').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        var ProductName=component.get('v.ProductItem');
        if(!(ProductName.ProductName))
        {
            alert('Please select product.');
            return;
        }
        helper.checkLocationExists(component, event, helper);
        
        if(validProduct){
            console.log('validProduct');
            var newProductItem = component.get("v.ProductItem");
            //helper.createCamping(component,newCampingItem);
            var items = component.get("v.ProductWrapper");
            var item = JSON.parse(JSON.stringify(newProductItem));
            console.log('item : '+JSON.stringify(newProductItem));
            items.push(item);
            
            component.set("v.ProductWrapper",items);
            console.log('ProductWrapper : '+JSON.stringify(component.get("v.ProductWrapper")));*/
            /*component.set("v.newItem",
                          { 'sobjectType': 'isvplus_123__Employee__c','Name': '','isvplus_123__Phone_Number__c': 0,
                          });
                          */
     /*   }
        
    },
    addNewLocation: function(component, event, helper) {
        //call apex class method
        var LocationName = component.find("productsLocationInput").get("v.value");
        if(LocationName == null || LocationName == ''){
            alert('Enter New Location');
            return;
        }
        else{
            var newProductItem = component.get("v.ProductItem");
            var action = component.get('c.fetchProductForNewLocationWrapper');
            console.log('Location NAme '+JSON.stringify(newProductItem.LocationName));
            
            action.setParams({
                "LocationName": LocationName
            });
            action.setCallback(this, function(response) {
                //store state of response
                var state = response.getState();
                console.log(state);
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    //set response value in wrapperList attribute on component.
                    
                    component.set('v.ProductWrapper', response.getReturnValue());
                    console.log('ProductWrapper fetchProductForNewLocationWrapper : '+JSON.stringify(component.get('v.ProductWrapper')));
                }
                else if(state === "ERROR") {
                    
                    var errors = response.getError();
                    console.log('Error Details : '+JSON.stringify(errors));
                }
            });
            $A.enqueueAction(action);
            
        }
    }*/
   
})