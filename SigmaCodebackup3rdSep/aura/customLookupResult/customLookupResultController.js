({
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRecord");
       
       // alert(JSON.stringify(getSelectRecord));
        // call the event   
        var compEvent = component.getEvent("oSelectedRecordEvent");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({"recordByEvent" : getSelectRecord }); 
        compEvent.setParams({"objectAPIName" : component.get("v.objectAPIName") });
        compEvent.setParams({"context" : component.get("v.context") });
        // fire the event  
        compEvent.fire();
        
    },
})