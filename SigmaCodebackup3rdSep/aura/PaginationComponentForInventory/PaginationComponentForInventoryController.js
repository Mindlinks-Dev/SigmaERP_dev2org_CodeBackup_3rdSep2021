({
    //This function will handle 'Previous' button Action.
	 	previousPage : function(component, event, helper) {
		var myEvent = $A.get("e.c:PageChange");
        myEvent.setParams({ "direction": "previous",
                           "sertxt":component.get("v.txt")});
        myEvent.fire();
                },
    //This function will handle 'Next' button Action.
                nextPage : function(component, event, helper) {
       // alert('nextPage');
        var myEvent = $A.get("e.c:PageChange");
        myEvent.setParams({ "direction": "next",
                          "sertxt":component.get("v.txt")});
        myEvent.fire();
                }

})