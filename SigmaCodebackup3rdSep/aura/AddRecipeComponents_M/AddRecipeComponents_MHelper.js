({
	 updateData : function(component, event, helper) {
        var params = event.getParams();
        var RecipeManagementEvent = $A.get("e.c:RecipeManagementEvent");
        if(params.response.apiName == "sigmaerpdev2__Recipe__c")
        {
            RecipeManagementEvent.setParams({"flag":"updaterecipelist" });
            RecipeManagementEvent.fire();
        }else
        {
            RecipeManagementEvent.setParams({"flag":"refreshchild" });
            RecipeManagementEvent.fire();
        }
        
    }
})