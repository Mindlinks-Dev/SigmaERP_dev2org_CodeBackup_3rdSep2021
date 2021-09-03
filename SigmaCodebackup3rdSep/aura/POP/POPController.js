({
	 removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var AllRowsList = component.get("v.vplist");
        //alert(JSON.stringify(AllRowsList[index]));
        if(AllRowsList[index].pop.Id)
        {
            var deletedList=component.get('v.deletedList');
            deletedList.push(AllRowsList[index].pop);
            component.set('v.deletedList',deletedList);
        }
        //alert(JSON.stringify(deletedList));
        AllRowsList.splice(index, 1);
        component.set("v.vplist", AllRowsList);
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "flag": "TaxFlag"
        });
        SigmaComponentEvent.fire();
    }
})