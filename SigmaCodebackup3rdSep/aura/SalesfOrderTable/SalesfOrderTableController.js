({
    doinit : function(component, event, helper) 
    {
        var rowIndex = component.get("v.rowIndex");
        var SOrder = component.get("v.SOrder");
        console.log('SOrder in salesorder table>>'+JSON.stringify(component.get("v.SOrder.SO")));
    },
    OpenChat: function(component, event, helper) {
        component.set("v.isOpenChat", true);
    },
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenChat", false);
    },
    viewchangerequest: function(component, event, helper) {
        component.set("v.toViewReviseReq",true);
    },
    toggle: function(component, event, helper) {
        var chevronright = component.find('chevronright');
        var chevrondown = component.find('chevrondown');
        
        $A.util.toggleClass(chevronright, 'slds-hide');
        $A.util.toggleClass(chevrondown, 'slds-hide');
        var getAttributeValue = component.get("v.checkThis");
        if(getAttributeValue==true){
            component.set("v.checkThis", false);
            component.set('v.expanded',true);
        }
        else{
            component.set("v.checkThis", true);
            component.set('v.expanded',false);
        }
        
    },
    changerequest: function(component, event, helper)
    {
        var SOrder= component.get("v.SOrder");
        if(SOrder.SO.Status__c == 'Cancelled'|| SOrder.SO.Status__c == 'Partially Shipped' || SOrder.SO.Status__c == 'Fully Shipped')
        {
            //alert('order is already '+SOrder.SO.Status__c+' cannot Revise');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "warning",
                message: 'order is in \''+SOrder.SO.Status__c+'\' Status. Cannot Revise',
                type: "warning"
            });
            toastEvent.fire();
            component.set("v.showOrderChangeRequest",false);
        }
        else
        {
            component.set("v.showOrderChangeRequest",true);
        }
        
        //component.set("v.showOrderChangeRequest",true);
    },
    closeModal: function(component, event, helper)
    {
        component.set("v.isOpen",false);
        
    },
    closeModalSOLI: function(component, event, helper)
    {
        component.set('v.isOpenSOLI',false); 
    },
    
})