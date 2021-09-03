({
	fetchUser : function(component, event, helper) {
        
        var action = component.get("c.fetchUser");
        // alert('12')
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               //alert('123')
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
     loadData: function(component, event, helper,pid){   
       // alert('191>>>'+pid);
        var action = component.get('c.fetchVendProdlist');
        action.setParams({
            ProductId:pid
            
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
          // alert('138>>>'+state);
           // alert(JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
             // alert('storeResponse>>>>'+JSON.stringify(storeResponse))
            
                //set response value in wrapperList attribute on component.
              
                component.set('v.Vplist', response.getReturnValue());
              
              
              // alert('locationWrapper fetchLocationForNewProductWrapper : '+JSON.stringify(component.get('v.LocationWrapper')));
               // alert('189>>>'+JSON.stringify(response.getReturnValue().lStrings))
            }
            else if(state === "ERROR") {
                
                var errors = response.getError();
                alert('Error Details : '+JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
     saveProduct : function(component, event, helper,prodtolocList){
        //alert('helper called');
       var ProductName= component.get("v.Vplist1.sigmaerpdev2__Product_Name__c");
       var ProductCode= component.get("v.productcode");
       // alert('Inside save method'+JSON.stringify(component.get("v.VPlistparam")));
        
        //console.log('Inside save method'+JSON.stringify(component.get("v.VPlistparam")));
        
        
        var action = component.get("c.saveData2");
        
        action.setParams({
            VPlistparamParam: JSON.stringify(component.get("v.Vplist2")) ,
            ProductName:ProductName,
            ProductCode:ProductCode
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            // alert('state : '+state);
            if (component.isValid() && state === "SUCCESS"){
                 var response = JSON.stringify(result.getReturnValue());
               // alert('response : '+response);
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
                    component.set("v.Vplist",response); 
                    $A.get('e.force:refreshView').fire();
                    
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
     /*fetchVendProds : function(component, event, helper) {
       var action = component.get("c.fetchVendProdlist");
     
       action.setCallback(this, function(response){
           var state = response.getState();
           console.log('state>>>>'+response.getReturnValue());
           if (state === "SUCCESS") {
               component.set("v.Vplist", response.getReturnValue());
              // alert('Vplist>>>'+component.set("v.Vplist"));
           }
       });
       $A.enqueueAction(action);
   },*/
})