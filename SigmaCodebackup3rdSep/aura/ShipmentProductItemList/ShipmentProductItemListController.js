({
     doInit : function(component, event, helper) {
       
    },
    addProducts : function(component,event,helper)
    {
       
        var rowIndex =event.getSource().get("v.name");
        component.set("v.isOpen", true);
        var Popupval = component.get("v.ShipmentProduct");
        var appEvent  = $A.get("e.c:CarryShipmentEvent");
        appEvent.setParams({"shipment" : Popupval[rowIndex],
                            "rowIndex": rowIndex 
                           });
        appEvent.fire();
        
       
       
    },

	handleRemoveProductItemClick : function(component, event, helper) {
       var self = this;  // safe reference
		var TestDelete1 = component.find('ModalDelete');
        $A.util.removeClass(TestDelete1, 'slds-hide');
        var index = event.target.dataset.index;
        component.set("v.index",index);
    },
     cancelModalDelete : function(component, event, helper) {
        var cancelModalDelete = component.find('ModalDelete');
        $A.util.addClass(cancelModalDelete, 'slds-hide');
    },
     confirmModalDelete : function(component, event, helper) 
    {
       var abc=  component.get("v.index");
        helper.removeProductItem(component, abc);
        var confirmModalDelete = component.find('ModalDelete');
        $A.util.addClass(confirmModalDelete, 'slds-hide');
    }
})