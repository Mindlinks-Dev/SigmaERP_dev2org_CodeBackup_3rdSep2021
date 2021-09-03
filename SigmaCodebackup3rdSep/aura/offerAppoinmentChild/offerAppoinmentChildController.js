({
	doInit : function(component, event, helper)
    {
        alert('hellochild');
        var offerData=component.get("v.offerData");
        var start=offerData.startDate.split('T');
        var DateBSF = $A.localizationService.formatDate(start[0], "DD-MM-YYYY");
        var end=offerData.endDate.split('T');
        component.set("v.start",DateBSF);
        component.set("v.End",end[0]);
    }
})