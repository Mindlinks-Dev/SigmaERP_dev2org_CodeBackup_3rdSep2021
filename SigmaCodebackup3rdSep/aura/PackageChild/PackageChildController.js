({
      doInit: function (component, event, helper)
    {
        //alert(component.get("v.LightView"));
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
        var package2 = component.get("v.packageList");
         //alert('package2.Id>>'+package2.Id);
        // var result=true;
        var result = confirm("Are you sure you want to delete this record ?");
        if (result) {            
            var action = component.get("c.deletePackageRecordById"); 
            action.setParams({
                "packageId" : package2.Id
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
       // window.open('/lightning/r/sigmaerpdev2__Sigma_Order__c/'+sigmalist+'/view');
        /* var temp = component.get("v.sigmaList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
        */
      
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
          
            sforce.one.navigateToSObject(packageList, 'detail');
        } 
        // Desktop Navigation
        else {
          
            window.location.href = "/"+packageList;
        }
    }, 
    editPackageDetails : function(component, evt, helper) { 
       // console.log('editPackageDetails'+JSON.stringify(component.get("v.packageList")));
        //alert('editPackageDetails'+JSON.stringify(component.get("v.packageList")));
         //component.set("v.iseditPackage",true);
        var packId=component.get("v.packageList").Id;
        if(packId!=undefined && packId!=null && JSON.stringify(packId)!='""')
        {
            var packageIdEvent = component.getEvent("packageIdEvent");
            packageIdEvent.setParams({
                "packageId" : packId
            });
            packageIdEvent.fire();
        }
        else
        {
             var packageIdEvent = component.getEvent("packageIdEvent");
            packageIdEvent.setParams({
                "packageId" : ""
            } );
            packageIdEvent.fire();
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

})