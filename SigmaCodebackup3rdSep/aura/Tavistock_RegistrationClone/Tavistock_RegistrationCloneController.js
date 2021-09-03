({
	
     onGroup1: function(cmp, evt) {
		 //var selected = evt.getSource().get("v.label");
         //alert('selected1:'+selected);
         
         var selected = evt.getParam("value");
         cmp.set("v.BookingWrapper.custWrap.ageof18years", selected); 
	 },
    onGroup2: function(cmp, evt) {
		 var selected = evt.getParam("value");
		 cmp.set("v.BookingWrapper.custWrap.registeredwithmedical", selected); 
	 },
    
    save : function(component, event, helper) {
        var BookingWrapper = component.get("v.BookingWrapper");
        //alert('BookingWrapper>>'+JSON.stringify(BookingWrapper));
        //alert('BookingWrapper.custWrap.FirstName>>'+BookingWrapper.custWrap.FirstName);
        if(BookingWrapper.custWrap.FirstName==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your firstname."
            });
            toastEvent.fire();
            return;
        }
         if(BookingWrapper.custWrap.LastName==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your LastName."
            });
            toastEvent.fire();
            return;
        }
        
         if(BookingWrapper.custWrap.DateofBirth==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "select your Date of Birth."
            });
            toastEvent.fire();
            return;
        }
        
         if(BookingWrapper.custWrap.EmailId==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "enter your EmailId."
            });
            toastEvent.fire();
            return;
        }
          if(BookingWrapper.custWrap.MobilePhoneNumber==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "enter your Mobile Phone Number."
            });
            toastEvent.fire();
            return;
        }
         if(BookingWrapper.custWrap.Address==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "enter your Address."
            });
            toastEvent.fire();
            return;
        }
        
        
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
        helper.saveCustomerInfo(component, event, helper);
		
	},
    
    
})