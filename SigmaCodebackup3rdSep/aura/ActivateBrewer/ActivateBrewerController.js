({
    doInit : function(component, event, helper) 
    {
        //alert('Inside doInit of ActivateCustomer>>>>');
        //alert('CloseCurrentWindow Inside doInit of ActivateCustomer>>>>'+component.get("v.CloseCurrentWindow"));
        var ErrorDiv = component.find('messagePanel');
        $A.util.toggleClass(ErrorDiv, "slds-hide");
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        //alert('recordId>>>>'+component.get('v.recordId'));
        helper.getCustomerRegistryDetails(component,event, helper);
        
    },
    closeModal : function(component, event, helper) 
    {
        //alert('Inside closeModal');
        //alert('Close Flag>>'+component.get("v.CloseCurrentWindow"));
        if(component.get("v.CloseCurrentWindow"))
        {
            window.close();
        }
        else
        {
            $A.get("e.force:closeQuickAction").fire();
        }
        //
        location.reload();
        
    }
})