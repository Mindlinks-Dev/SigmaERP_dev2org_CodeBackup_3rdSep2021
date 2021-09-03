({ 
	removeProductItem : function(component, index) {      
   		var mainWrapperListVal = component.get("v.mainWrapperList");     
        var action = component.get("c.deletePackageProduct"); 
        action.setParams({
        	"packageProduts" : JSON.stringify(mainWrapperListVal),
            "index":index
        });
        mainWrapperListVal.splice(index,1);	        
        component.set("v.mainWrapperList", mainWrapperListVal);      
        $A.enqueueAction(action);        
    },
    /*openModalHelper : function(component, event, helper,data) { 
        var oldVal = component.get("v.serials"); 
        var srlLength = component.get("v.manfObj.sigmaerpdev__Produced_Quantity__c");
		if(oldVal.length > 0){
            component.set('v.serials',oldVal);	//restore old value
        }else{
        	var serialList = [];
           	for(var i=0;i < srlLength; i++){
           		serialList[i] = {'SerialNo':''};
           	}        
           	component.set('v.serials',serialList);	  
         }      
        component.set('v.openModal',true);
    }*/
    
    openModalHelper : function(component, event, helper,data) {
        var srlLength = component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c");        
        var serialList = [];
        for(var i=0;i < srlLength; i++){
            serialList[i] = {'SerialNo':''};
        }        
        component.set('v.serials',serialList);
        component.set('v.openModal',true);
    },
    
    //code to be moved back
    checkBCAvailabilityH : function(component, event, helper){        
        var bcVal = component.get("v.barCodeVal");     
        var action = component.get("c.checkBarCodeAvailable"); 
        action.setParams({
        	"barCodeVal" : bcVal
        });
        action.setCallback(this, function (response) {
            var state = response.getState();                
            if(state == "SUCCESS"){                
                if(response.getReturnValue() == true){
                    var msg = ' '+bcVal+' is already taken.';
                    component.set("v.showReply", msg);
                    component.set("v.barCodeVal", "");
                }else{
                	component.set("v.showReply", "Available");                      
                }                    
            }else{
                var error = response.getError();
                console.log('Error: ' + JSON.stringify(error));
            }
        });
        $A.enqueueAction(action);    
    }
    
})