({
    getCustomerRegistryDetails : function (component,event, helper){    
        var action = component.get("c.GetCustomerRegistryDetails");
        var myArray = [ ];
        action.setParams({  
            currentRecordId : component.get('v.recordId') 
        });
        action.setCallback(this, function(response) {
            var state =  response.getState();
            if (component.isValid() && state == 'SUCCESS') 
            {   
                component.set('v.ActivationWrapper',response.getReturnValue());
                //alert('ActivationWrapper>>>>'+JSON.stringify(component.get('v.ActivationWrapper')));
               
                component.set('v.custRegistry',component.get('v.ActivationWrapper').brewerRegistry);
                //alert('ActivationWrapper.brewerRegistry'+JSON.stringify(component.get('v.brewerRegistry')));
                //alert('ActivationWrapper.brewerRegistry>>>>>>'+component.get('v.brewerRegistry').sigmaerpdev2__Registration_Status__c);
                component.set('v.message',component.get('v.ActivationWrapper').responseMessage);
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
            } else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action); 
    },
})