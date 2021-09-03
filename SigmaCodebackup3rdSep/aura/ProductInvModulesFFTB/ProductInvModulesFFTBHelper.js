({
    helperMethod : function(component) {
    	var action = component.get("c.fetchJSONHelpMenu");
        action.setCallback(this, function(response) {           
            var state = response.getState();            
            if (state === "SUCCESS") {
                var jsonData = JSON.stringify(response.getReturnValue().listObjects);
				//alert(JSON.stringify(response.getReturnValue().CommunityUser));
               	component.set('v.jsonString',jsonData[0]);
				if(response.getReturnValue().CommunityUser)
				{
					component.set('v.CommunityURL',response.getReturnValue().COmmURL);
                    component.set('v.IsCommunityUser',response.getReturnValue().CommunityUser);
				}
				else
				{
					component.set('v.CommunityURL','');
                    component.set('v.IsCommunityUser',response.getReturnValue().CommunityUser);
				}
				
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }
})