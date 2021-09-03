({
    doInit: function (component, event, helper)
    {
      
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
            
            component.set("v.LightView",true);
        } 
        
        else {
            
            component.set("v.LightView",false);
        }
    },
    dropdown : function (component, event, helper)
    { 
        var dropdownContent = component.find('dropdownContent');
        $A.util.toggleClass(dropdownContent, 'slds-is-open');
    }, 
    Navigate : function(component, event, helper) {
        
        var temp = component.get("v.sigmaList");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": temp.Id
        });
        editRecordEvent.fire();       
        
    },
    editSODetails : function(component, evt, helper) { 
        //alert(' in if');
         // alert('editSODetails->>'+JSON.stringify(component.get("v.sigmaList")));
        //component.set("v.iseditPackage",true);
        var salesorderId=component.get("v.sigmaList").Id;
        
        if(salesorderId!=undefined )
        {
           //alert('came in if'); 
            var salesOrderevent = component.getEvent("salesOrderevent");
            salesOrderevent.setParams({
                "soId" : salesorderId
            });
            salesOrderevent.fire();
        }
        else
        {
          // alert('came in');
            var salesOrderevent = component.getEvent("salesOrderevent");
            salesOrderevent.setParams({
                "salesorderId" : ""
            } );
            salesOrderevent.fire();
        }
        
        /*var evt = $A.get("e.force:navigateToComponent");
    evt.setParams({
        componentDef : "c:Package",
        componentAttributes: {
            recordId : packId,
        }
    });
    evt.fire();*/         
    },
    
    openRecords : function(component, event, helper){
        
        /* var temp = component.get("v.sigmaList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
        */
        var sigmalist =  component.get("v.sigmaList.Id");
        
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
            
            sforce.one.navigateToSObject(sigmalist, 'detail');
        } 
        // Desktop Navigation
        else {
            
            window.location.href = "/"+sigmalist;
        }
        /*   var temp = component.get("v.sigmaList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();*/
    },
    
    handleDeleteRecord : function(component, event, helper) {        
        var orderId = component.get("v.sigmaList");
        var result = confirm("Are you sure you want to delete this record ?");
        if (result) {            
            var action = component.get("c.deleteSigmaOrder"); 
            action.setParams({
                "SigmaOrderId" : orderId.Id
            });
            action.setCallback( this, function(response2) {
                var state2 = response2.getState();                
                if (state2 === "SUCCESS"){
                    alert('Record deleted Successfully.');
                     window.location.reload();
                    // $A.get('e.force:refreshView').fire();
                   
                    
                }
            });
            $A.enqueueAction(action);
        }            
    }
})