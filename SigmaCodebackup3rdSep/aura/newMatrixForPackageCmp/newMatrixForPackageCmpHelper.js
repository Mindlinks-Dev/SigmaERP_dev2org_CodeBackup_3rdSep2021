({
	getTransLineItems: function(component) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "slds-hide");
        var action = component.get("c.fetchLineItems");
        action.setParams({"transIdObj": component.get("v.transId")});
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            component.set("v.transLineList",response.getReturnValue());
           	console.log('inside transChange helper'+JSON.stringify(component.get("v.transLineList")));
            var spinner = component.find('spinner');
        	$A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);                 
    },
    
    createPackage: function(component){
        var newPackage = component.get("v.package");        
        component.set("v.package.sigmaerpdev__Status__c",component.get("v.status"));
        
       
        var interimList = component.get("v.transLineList");
        var interimListUpdated = JSON.stringify(interimList).replace(/""/g, '"0"'); //convert to JSON string
		
        console.log('after====>'+interimListUpdated);
        
        var action = component.get("c.saveFastEntryMatrixPackage"); 
        action.setParams
            ({  
                "packageObj" : newPackage,
                "packageProducts" : interimListUpdated               
            });
        action.setCallback( this, function(a) 
            {
			  var state = a.getState();	
               if(a.getReturnValue() != null){
                    alert('Package Created Successfully.');
                    if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                        sforce.one.navigateToSObject(a.getReturnValue().Id);
                    }else{
                        
                        var packID =a.getReturnValue().Id;
                       
                        window.location.href = "/" + a.getReturnValue().Id;
                     }    
                }else{
                    alert('Package Creation Failed.');
                }  
                   
            });        	
			$A.enqueueAction(action); 
    },
    //added on 13/11/2017
    hidePopupHelper: function(component, componentId, className){ 
       
        var modal = component.find(componentId); 
        alert('hidePopupHelper....'+modal);
        $A.util.addClass(modal, className+'hide'); 
        $A.util.removeClass(modal, className+'open');        
    },
})