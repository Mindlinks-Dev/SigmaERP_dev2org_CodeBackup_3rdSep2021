({
	handleActionsH : function(component, event, helper, soId, selectedMenuItemValue) {
        var currStatus = component.get("v.searchVal");
        var FFTBBPSalesEvnt = component.getEvent("FFTBBPSalesEvnt");
        FFTBBPSalesEvnt.setParams({"currStatus" : currStatus,"soId":soId, "selAct":selectedMenuItemValue});
        FFTBBPSalesEvnt.fire();
	}
})