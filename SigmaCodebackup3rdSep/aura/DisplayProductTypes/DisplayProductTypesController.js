({
    doInit : function(component, event, helper) 
    {
      
        var spinner = component.find('spinner');
        //$A.util.toggleClass(spinner, "slds-hide");
        
        helper.toGetRetailerData(component, event, helper);
    },
    ProductTypecmp :function(component, event, helper) 
    {
        component.set("v.onselectProductType",event.currentTarget.name);
        var RList = component.get("v.RoList");
        for(var i=0;i<RList.length;i++){
            if(RList[i].Name==event.currentTarget.name){
                component.set("v.onselectRetailercode",RList[i].Id);
            }
        }
        helper.loadCatalogOrder(component, event, helper);
    },
})