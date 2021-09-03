({
    doInit : function(component, event,helper) 
    {
       // alert('view cart111');
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, "slds-hide");
        helper.toGetcustomerData(component, event,helper);  
    },
    deleteProduct: function(component, event, helper,index) 
    {
        var index=event.getSource().get("v.name");
        helper.toDeleteProductCart(component, event,helper,index);  
    },
    UpdateCart : function(component, event,helper) 
    {
        helper.UpdateCart(component, event,helper);
    },
    CalculateBoxQty : function(component, event,helper) 
    {
        component.set("v.PlaceorderBtn",true);
    },
    addCart: function(component, event, helper) { 
        helper.toSaveCart(component, event,helper);     
    },
    ClearItems: function(component, event, helper) { 
        // alert('button should hide');
        component.set("v.HideButtons",false);
        helper.ClearCart(component, event,helper);     
    },
    placeOrders: function(component, event, helper) {
        component.set("v.UserDetails_ShoppingCart",true);
        //helper.CalBoxQty(component, event,helper);
        //Added by Seema
        /*var custid =component.get("v.DisplayCartDetail");
        alert('custid'+component.get("v.DisplayCartDetail"));
            helper.checkingAddAndCloneData(component,event,helper,custid); 
            */
    },
    BacktoCatalog : function(component, event,helper) {
        component.set("v.parentcmp",true);
        component.set("v.Shipcmp",false);
        $A.get('e.force:refreshView').fire();
    }
})