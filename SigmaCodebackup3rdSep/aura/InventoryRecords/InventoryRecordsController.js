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
        
        var temp = component.get("v.soList");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": temp.Id
        });
        editRecordEvent.fire();       
        
    },
    
    openRecords : function(component, event, helper){
        
       /* var temp = component.get("v.soList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
        */
         var Orderlist =  component.get("v.soList.Id");
       
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
            //alert('if');
            sforce.one.navigateToSObject(Orderlist, 'detail');
        } 
        // Desktop Navigation
        else {
            // alert('else');
            window.location.href = "/"+Orderlist;
        }
    }
    
})