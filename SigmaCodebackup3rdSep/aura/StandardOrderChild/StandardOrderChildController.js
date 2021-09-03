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
      switch(event.getParam('value')) {
            case "Edit": helper.editSODetails(component, event, helper); break;
            case "Delete": helper.OrderDeleteRecord(component, event, helper); break;
        }
        
       
        /*var dropdownContent = component.find('dropdownContent');
        $A.util.toggleClass(dropdownContent, 'slds-is-open');
		*/       
    }, 
    Navigate : function(component, event, helper) {
        
        var temp = component.get("v.OrderList");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": temp.Id
        });
        editRecordEvent.fire();       
        
    },
    
    openRecords : function(component, event, helper){
        
        /*  var temp = component.get("v.OrderList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
        */
        var Orderlist =  component.get("v.OrderList.Id");
        //alert(Orderlist);
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
            //alert('if');
            sforce.one.navigateToSObject(Orderlist, 'detail');
        } 
        // Desktop Navigation
        else {
            // alert('else');
            window.location.href = "/"+Orderlist;
        }
    },
    OrderDeleteRecord : function(component, event, helper) {        
        var standorderId = component.get("v.OrderList");
        var result = confirm("Are you sure to delete this Record?");
        if (result) {            
            var action29 = component.get("c.deleteOrder"); 
            action29.setParams({
                "OrderId" : standorderId.Id
            });
            action29.setCallback( this, function(response2) {
                var state2 = response2.getState();                
                if (state2 === "SUCCESS"){
                    alert('Record deleted Successfully.');
                    //$A.get('e.force:refreshView').fire();
                    
                }
            });
            $A.enqueueAction(action29);
        }            
    },
    editSODetails : function(component, evt, helper) { 
        
        //  alert('editSODetails->>'+JSON.stringify(component.get("v.sigmaList")));
        //component.set("v.iseditPackage",true);
        var salesorderId=component.get("v.OrderList").Id;
        
        if(salesorderId!=undefined )
        {
            
            var salesOrderevent = component.getEvent("salesOrderevent");
            salesOrderevent.setParams({
                "soId" : salesorderId
            });
            salesOrderevent.fire();
        }
        else
        {
            //alert('came in');
            var salesOrderevent = component.getEvent("salesOrderevent");
            salesOrderevent.setParams({
                "salesorderId" : ""
            } );
            salesOrderevent.fire();
        }
    }
})