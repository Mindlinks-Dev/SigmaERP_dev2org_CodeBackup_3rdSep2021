({
	getPropList : function(component, event, helper,page) {
        page = page || 1;
        var action = component.get("c.FetchProposal");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('state>>>>>>'+state);
            if (state === "SUCCESS") {
                var propres = response.getReturnValue();
                component.set('v.total', propres.total);
                component.set('v.page', propres.page);
                component.set('v.pages', Math.ceil(propres.total/propres.pageSize));
                component.set("v.PropList",propres);
               // alert('PropList>>>>>'+JSON.stringify(component.get("v.PropList")));
            }
        });
        $A.enqueueAction(action);
    },
})