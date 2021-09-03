({
    createObjectData: function(component, event) { 
        var action = component.get('c.fetchProductWrapper');        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                alert('success');
                
                component.set('v.ProductWrapper', response.getReturnValue());
                console.log('ProductWrapper ProductWrapper : '+JSON.stringify(component.get('v.ProductWrapper')));
                component.set('v.numberOfRecordsToDisplay',response.getReturnValue().numberOfRecordsOnLoadMoreClick);
                component.set('v.numberOfRecordsOnLoadMoreClick',response.getReturnValue().numberOfRecordsToDisplay);
                component.set('v.totalRowCount',response.getReturnValue().numOfRec);  
                alert('numberOfRecordsToDisplay : '+component.get('v.numberOfRecordsToDisplay'));
				alert('numberOfRecordsOnLoadMoreClick : '+component.get('v.numberOfRecordsOnLoadMoreClick'));
                alert('totalRowCount : '+component.get('v.totalRowCount'));
            }
        });
        $A.enqueueAction(action);
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
    saveProduct : function(component, event, helper){
        //alert(JSON.stringify(component.get("v.ProductWrapper")));
        var action = component.get("c.saveData");        
        action.setParams({
            ProductWrapperParam: JSON.stringify(component.get("v.ProductWrapper"))
            
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log(JSON.stringify(result.getReturnValue()));
            //alert('state : '+state);
            if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Save failed !",
                    "message": "Please reach out your business administrator.",
                    "type": "error"
                });
                toastEvent.fire();
                setTimeout(function(){
                    location.reload();
                },2200)  
            }  
            var response = result.getReturnValue();
            if(response.ErrorMessage== 'Location already exists'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Location already exists for "+response.ProductNameMessage+'.',
                    "type": "error"
                });
                toastEvent.fire();
                component.set("v.spinner",false);
            }
            else 
            {
                if(component.isValid() && state === "SUCCESS"){                    
                    var response = result.getReturnValue();     
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "New location has been added successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                    component.set("v.ProductWrapper",response);
                    
                    setTimeout(function(){
                        location.reload();
                    },2000)                    
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
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    loadMoreContent : function(component, event, helper) {
        var action = component.get('c.loadMoreFetchProductWrapper');  
        action.setParams({             
           'numberOfRecordsToDisplay':component.get('v.numberOfRecordsToDisplay')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.ProductWrapper', response.getReturnValue());
                console.log('ProductWrapper ProductWrapper : '+JSON.stringify(component.get('v.ProductWrapper')));
                component.set("v.numberOfRecordsOnLoadMoreClick",response.getReturnValue().numberOfRecordsOnLoadMoreClick);
                   
            }
        });
        $A.enqueueAction(action);
    }
})