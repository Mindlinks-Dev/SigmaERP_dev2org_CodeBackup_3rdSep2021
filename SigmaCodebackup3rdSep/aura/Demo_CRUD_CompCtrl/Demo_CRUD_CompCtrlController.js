({
    
   
    // updating Inventory
    callUpdateRecord : function(component, event, helper){	
        
        if(component.get("v.view.sigmaorder"))
        {
            var currentRecordId = component.get("v.view.orderLne.Id");
        }
        else
        {
            var currentRecordId = component.get("v.view.orderlineproduct.Id");
        }
       
		var comment = component.get("v.comment");
        var checkCmp = component.find("checkbox");
        var checkvalue = checkCmp.get("v.value");
       //alert('checkCmp-->'+checkvalue);
        if(checkvalue == false){
            //alert('Release Status should be checked to release the Inventory.');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": 'Release Status should be checked to release the Inventory.'
            });
            toastEvent.fire();
            return null;
        }
        //alert('comment-->'+comment);
        // resultCmp = component.find("checkResult");
        // resultCmp.set("v.pickvalue", ""+checkCmp.get("v.pickvalue"));
		//var pickvalue = component.get("v.pickvalue");
        //alert('pickvalue->'+resultCmp);
        var currentRecord = component.get("v.view.orderLne");
        //alert('I am inside Save method');
        
        // ,comment : comment ,pickvalue : pickvalue
         
         var action = component.get("c.updateOrderLine");
         //alert('action is-->'+action);
        action.setParams({ recordId : currentRecordId ,comment : comment ,pickvalue : checkvalue });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert('-->'+JSON.stringify(response.getReturnValue()));
            //var chk = JSON.stringify(response.getReturnValue());
            //alert('check::' +chk[0].sigmaerpdev2__Inventory_Release_Comment__c);
            //component.set("v.pickvalue", response.getReturnValue().sigmaerpdev2__Is_Inventory_Release__c);
            //component.set("v.comment", response.getReturnValue().sigmaerpdev2__Inventory_Release_Comment__c);
            //alert('state is'+state);
            if (state === "SUCCESS") {
                //alert('Record updated successfully');
              /*  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                 
                 message: "Record is Updated Successfully",
                 type : 'success'
                 });
                 toastEvent.fire();
				
                */
                var spinner=component.find('spinner');
    $A.util.toggleClass(spinner, 'slds-hide');
                alert("Record  Updated Successfully");
                location.reload();
            }
            
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            
            
        });
        
       
        $A.enqueueAction(action);
       
    }
    
    
    
    
})