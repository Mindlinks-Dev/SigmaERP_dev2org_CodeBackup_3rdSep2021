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
        
        var temp = component.get("v.stockList");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": temp.Id
        });
        editRecordEvent.fire();       
        
    },
    
    openRecords : function(component, event, helper){
        
        /* var temp = component.get("v.stockList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
        */
        //alert('recid-->'+component.get("v.stockList.Id"));
        var stockList =  component.get("v.stockList.Id");
       
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
          
            sforce.one.navigateToSObject(stockList, 'detail');
        } 
        // Desktop Navigation
        else {
          
            window.location.href = "/"+stockList;
        }
    },
     editso : function(component, event, helper) { 
             
        var stockId=component.get("v.stockList").Id;
        // alert('sr'+stockId);
        
         // alert('purchaseId__>>>'+purchaseId);
        if(stockId!=undefined)
             
       {
           // alert('in'); 
            var stockrecieveevent = component.getEvent("stockrecieveevent");
            stockrecieveevent.setParams({
                "stockId" : stockId
            });
            stockrecieveevent.fire();
           
        }
        else
        {
            // alert('innnn'); 
             var stockrecieveevent = component.getEvent("stockrecieveevent");
            stockrecieveevent.setParams({
                "stockId" : ""
            } );
            stockrecieveevent.fire();
           
        }
        },
    
    handleDeleteRecord : function(component, event, helper) { 
       //alert('trying to delete sr-->'+component.get("v.stockList"));
        var orderId = component.get("v.stockList");
       //alert("orderId-->>>"+JSON.stringify(component.get("v.stockList.Id")));
        var result = confirm("Are you sure you want to delete this record ?");
       // alert('result-->'+result);
        if (result) {            
            var action = component.get("c.deletestock"); 
            action.setParams({
                "StockId" : orderId.Id
            });
            action.setCallback( this, function(response2) {
                var state2 = response2.getState(); 
             // alert('state2'+state2);
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