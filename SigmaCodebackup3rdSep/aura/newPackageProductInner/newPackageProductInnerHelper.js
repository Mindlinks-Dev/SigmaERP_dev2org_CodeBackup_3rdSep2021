({
	showPopupHelper: function(component, componentId, className)
    {
        var modal = component.find(componentId); 
        $A.util.removeClass(modal, className+'hide'); 
        $A.util.addClass(modal, className+'open'); 
        
    },
    VBOMwindow: function(component, event, helper)
    {
        var invtID = component.get("v.InventoryID");        
       
        window.open("/apex/Update_VirtualBOM_PackLevel?id="+invtID, "MsgWindow", "scrollbars=yes,resizable=yes");
    },
})