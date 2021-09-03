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
     deletePackageRecord : function(component, event, helper) {        
        var ship = component.get("v.shipmentList");
         //alert('package2.Id>>'+package2.Id);
        // var result=true;
        var result = confirm("Are you sure you want to delete this record ?");
        if (result) {            
            var action = component.get("c.deleteShipmentRecordById"); 
            action.setParams({
                "shipmentId" : ship.Id
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
        
     },
     Navigate : function(component, event, helper) {
        
        var temp = component.get("v.packageList");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": temp.Id
        });
        editRecordEvent.fire();       
        
    },
    
    openRecords : function(component, event, helper){
     //   window.open('/lightning/r/sigmaerpdev2__Sigma_Order__c/'+sigmalist+'/view');
        /* var temp = component.get("v.sigmaList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
        */
        var packageList =  component.get("v.packageList.Id");
       
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
          
            sforce.one.navigateToSObject(packageList, 'detail');
        } 
        // Desktop Navigation
        else {
          
            window.location.href = "/"+packageList;
        }
    },
    editShipment: function (component, event, helper)
    {
        
        var packId=component.get("v.shipmentList").Id;
        //alert('editShipment'+packId);
         if(packId!=undefined && packId!=null && JSON.stringify(packId)!='""')
        {
            var shipmentIdEvent = component.getEvent("shipmentIdEvent");
            shipmentIdEvent.setParams({
                "shipmentId" : packId
            });
            shipmentIdEvent.fire();
        }
        else
        {
             var shipmentIdEvent = component.getEvent("shipmentIdEvent");
            shipmentIdEvent.setParams({
                "shipmentId" : ""
            } );
            shipmentIdEvent.fire();
        }
        
    /*    var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ShipmentProduct",
            componentAttributes: {
                Id : shipId,
            }
        });
        evt.fire(); */        
    },
    
})