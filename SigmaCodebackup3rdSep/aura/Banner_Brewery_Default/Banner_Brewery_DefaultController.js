({
    doInit : function(component, event, helper) {         
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(userId=='' || userId==null)
        {
            component.set("v.banner",true);            
        }
        else
        {
            component.set("v.banner",false);
        }
    }
})