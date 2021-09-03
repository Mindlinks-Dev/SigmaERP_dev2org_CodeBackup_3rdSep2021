({
    OrderDeleteRecord : function(component, event, helper) {  
       // alert('delete');
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
                    window.location.reload()
                   // $A.get('e.force:refreshView').fire();
                    
                }
            });
            $A.enqueueAction(action29);
        }            
    },
    editSODetails : function(component, event, helper) { 
        //alert('edit');
        
        //  alert('editSODetails->>'+JSON.stringify(component.get("v.sigmaList")));
        //component.set("v.iseditPackage",true);
        var salesorderId=component.get("v.OrderList").Id;
        //alert('salesorderId'+salesorderId);
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