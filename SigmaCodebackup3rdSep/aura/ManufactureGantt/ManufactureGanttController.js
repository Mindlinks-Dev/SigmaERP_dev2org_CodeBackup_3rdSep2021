({
    doInit : function(component, event, helper) {
         alert('MRID-->'+JSON.stringify(component.get('v.ManufacRunObj')));
	  var msg = '';
        var mRid = component.get('v.ManufacRunObj');        
        if(mRid.Id == '')
        	msg = 'Save the Manufacturing Run details before allocating the resources.';  
        
        if (mRid.Id == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "Warning!",                
                "message": msg
            });
            toastEvent.fire();
            return;
        }                      
		window.open('/apex/sigmaerpdev__MR_GanttChart?Id='+mRid.Id, "_self"); 
    },
	RedirectGantt : function(component, event, helper) {
         	
	}
})