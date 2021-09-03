({
	init: function (component, event, helper) {
        var spinner = component.find("mySpinner");
		$A.util.toggleClass(spinner, "slds-hide");
		helper.fetchRecipes(component, event, helper);
	},
	createRecipe: function (component, event, helper) {
		helper.createRecipeH(component, event, helper);
	},
	updateRecipesList: function (component, event, helper) {
		helper.updateRecipesListH(component, event, helper);
	},
	handleEditFlow: function (component, event, helper) {
		helper.handleEditFlowH(component, event, helper);
	},
	loadMoreData: function (cmp, event, helper) {
		//Display a spinner to signal that data is being loaded
		//event.getSource().set("v.isLoading", true);
		//Display "Loading" when more data is being loaded
		cmp.set('v.loadMoreStatus', 'Loading');
		helper.fetchData(cmp, event, helper)
			.then($A.getCallback(function (data) {
				var currentData = cmp.get('v.recipedataList');
				//Appends new data to the end of the table
				var newData = currentData.concat(data);
				cmp.set('v.recipedataList',newData);
				if (cmp.get('v.recipedataList').length >= cmp.get('v.totalNumberOfRows')) {
					cmp.set('v.loadMoreStatus', '');
				}else{
					cmp.set('v.loadMoreStatus', 'Load More');
				}
				//event.getSource().set("v.isLoading", false);
			}));
	}
})