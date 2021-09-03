({
	myAction : function(component, event, helper) {
      
		
	},
    addProducts : function(component, event, helper) {
		 var rowIndex =event.getSource().get("v.name");
       	var wrapperListInsertLineItems= component.get("v.quotelinelist");
         component.set("v.isOpen", true);
        var appEvent  = $A.get("e.c:carryorderpopup");
        appEvent.setParams({"popup" : wrapperListInsertLineItems[rowIndex],
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
     confirmModalDelete : function(component, event, helper) 
    {
        
       var abc=  component.get("v.index");
       var wraplist=component.get("v.quotelinelist"); 
       wraplist.splice(abc, 1);
       component.set("v.quotelinelist",wraplist);
       var confirmModalDelete = component.find('ModalDelete');
       $A.util.addClass(confirmModalDelete, 'slds-hide');
    },
     cancelModalDelete : function(component, event, helper) {
       
        var cancelModalDelete = component.find('ModalDelete');
        $A.util.addClass(cancelModalDelete, 'slds-hide');
    }
   
})