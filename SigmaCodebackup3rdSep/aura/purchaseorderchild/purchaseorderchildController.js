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
        
        var temp = component.get("v.purchaselist");
       // alert('temp-->>'+temp);
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": temp.Id
        });
        editRecordEvent.fire();       
        
    },
    
     editpurchaseDetails : function(component, evt, helper) { 
             
        var purchaseId=component.get("v.purchaselist").Id;
        //alert('purchaseId---->'+purchaseId);
        
        if(purchaseId!=undefined)
       {
       
            var purchaseorderevent = component.getEvent("purchaseorderevent");
           //alert('purchaseorderevent---->'+purchaseorderevent);
            purchaseorderevent.setParams({
                "purchaseId" : purchaseId
            });
            purchaseorderevent.fire();
        }
        else
        {
            
             var purchaseorderevent = component.getEvent("purchaseorderevent");
            purchaseorderevent.setParams({
                "purchaseId" : ""
            } );
            purchaseorderevent.fire();
        }
        },
    
    
    
    
    
    openRecords : function(component, event, helper){
        
      
        
        var recid=component.get("v.purchaselist.Id");
      
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
         
            sforce.one.navigateToSObject(purchaselist, 'detail');
        } 
       
        else {
        
         
            sforce.one.navigateToSObject(component.get("v.recid"));   
        }
     
    }, 
   
    handleDeleteRecord : function(component, event, helper) {        
        
        var orderId = component.get("v.purchaselist");
      
        var result = confirm("Are you sure you want to delete this record ? ");
        if (result) {            
            var action = component.get("c.deletepurchaseorder"); 
            action.setParams({
                "purchaseOrderId" : orderId.Id
            });
            action.setCallback( this, function(response2) {
                var state2 = response2.getState();                
                if (state2 === "SUCCESS"){
                    //alert('Record deleted Successfully.');
                    //window.location.reload();
                    //commented above lines and added below line on 6-2-2020 to show PurchaseOrdeModules page after delete button is clicked
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Purchase Order record deleted successfully!"
                    });
                    toastEvent.fire();                    
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:PurachaseOrderModules",
                        componentAttributes: {
                            from : 'PO'
                        }
                    });
                    evt.fire();
                    //ends here     
                }
            });
            $A.enqueueAction(action);
        }            
    }
       
})