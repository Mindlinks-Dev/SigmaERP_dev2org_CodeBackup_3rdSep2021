({
	handleMenuSelectH : function(component, event, helper,flag) {
        var data = component.get("v.recipeItems");
        var RecipeManagementComponentEvent = component.getEvent("RecipeManagementComponentEvent");
        RecipeManagementComponentEvent.setParams({"data" : data,"flag":flag });
        RecipeManagementComponentEvent.fire();
	}
})