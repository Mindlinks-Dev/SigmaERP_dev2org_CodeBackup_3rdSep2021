({
	doInit : function(component, event, helper) {
		console.log('testing');
	},
    handleSelect : function(component, event, helper) {
         
         var selected = component.get("v.selectedTabId");
                // alert(selected);

          
          
        component.set("v.key",component.get("v.selectedTabId"));
       var key = component.get("v.key");
       // alert(key);
        
    // $A.get('e.force:refreshView').fire();
	},
   /* refreshFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        alert(workspaceAPI);
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
             alert(focusedTabId);
            workspaceAPI.refreshTab({
                      tabId: focusedTabId,
                      includeAllSubtabs: true
             });
        })
        .catch(function(error) {
            console.log(error);
        });
    }*/
    selectTab : function(component, event, helper) { 
        /* General utility */
        var key = component.get("v.key");
         var selected = component.get("v.selectedTabId");
        component.find("tabs").set("v.selectedTabId",key);
        //component.find("tabs").set("v.selectedTabId",selected);
    },
})