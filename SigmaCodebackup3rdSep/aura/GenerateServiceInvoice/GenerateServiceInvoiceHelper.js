({
    generatePDF : function(component,event,helper) {
        var action = component.get("c.generateInvoicePDF");
        //var id = JSON.stringify(component.get('v.recordId'));
        action.setParams({ currentRecordRowIdString : component.get('v.recordId') });
        action.setCallback(this,function(response){
            var state = response.getState();
            //alert('state==='+state);
            if(state == "SUCCESS") {
               
                //var spinner = component.find('spinner');
                /*var evt = spinner.get("e.toggle");
                if(!$A.util.hasClass(spinner, 'hideEl')){
                    evt.setParams({ isVisible : false });
                }		
                else {
                    evt.setParams({ isVisible : true });
                }
                evt.fire();*/
                component.set("v.showSuccess", true);
            }
            else if (state === "ERROR") {
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },
    
    updateWorkOrderStatus : function(component,event,helper){
    var action = component.get("c.updateStatus");
        //var id = JSON.stringify(component.get('v.recordId'));
         action.setParams({ currentRecordRowId : component.get('v.recordId') });
        action.setCallback(this,function(response){
             var state = response.getState();
            if(state == "SUCCESS") {
                var workOrderData = response.getReturnValue();
                component.set('v.isWorkOrderEmpty',workOrderData.isWorkOrderEmpty);
            }
            else if (state === "ERROR") {
                alert('error');
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();

    }
})