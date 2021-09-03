({
    Search : function(component, event, helper) {
        component.set("v.displayedSection","section1");
       // alert(component.get("v.displayedSection"));
        var recordIdFromUi = component.get("v.recordId");
        event.getSource().get("v.name") 
        
        
        helper.fetchProductInventory(component,event,helper);
        
    },
    
    createNewRecord : function(component, event, helper) {
        var childname = event.getSource().get("v.name"); 
        if(childname=="Product Inventory"){
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "sigmaerpdev2__Inventory__c"
            });
            createRecordEvent.fire();
        }
        if(childname=="Inventory Location Product"){
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "sigmaerpdev2__Inventory_Location_Product__c"
            });
            createRecordEvent.fire();
        }
        if(childname=="Inventory Location Product List"){
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "sigmaerpdev2__Inventory_Location_Product_Line_Item__c"
            });
            createRecordEvent.fire();        }
    },
    accordionProductInventory : function(component, event, helper) {
        var chevronrightProductInventory = component.find('chevronrightProductInventory');
        $A.util.toggleClass(chevronrightProductInventory, 'slds-hide');
        
        var chevrondownProductInventory = component.find('chevrondownProductInventory');
        $A.util.toggleClass(chevrondownProductInventory, 'slds-hide');
        
        var ProductInventoryBody = component.find('ProductInventoryBody');
        $A.util.toggleClass(ProductInventoryBody, 'slds-hide');
        
        
        
    },
    accordionInventoryLocation  : function(component, event, helper) {
        var chevronright = component.find('chevronright');
        $A.util.toggleClass(chevronright, 'slds-hide');
        
        var chevrondown = component.find('chevrondown');
        $A.util.toggleClass(chevrondown, 'slds-hide');
        
        var inventroylocation = component.find('inventroylocation');
        $A.util.toggleClass(inventroylocation, 'slds-hide');
        
        
        
    },
    accordionInventoryLocationproduct  : function(component, event, helper) {
        var chevronproduct = component.find('chevronproduct');
        $A.util.toggleClass(chevronproduct, 'slds-hide');
        
        var chevronproductline = component.find('chevronproductline');
        $A.util.toggleClass(chevronproductline, 'slds-hide');
        
        var inventroylocationproduct = component.find('inventroylocationproduct');
        $A.util.toggleClass(inventroylocationproduct, 'slds-hide');
        
        
        
    },  callComponent : function(component, event, helper){
        window.location.reload();
        
        /* var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:InventoryClassComponent",
                        
                    });
                    evt.fire(); 
                     */
    },
    
    clearSel : function(component, event, helper){
        var prdName = component.get("v.productName");
       // alert('prdName'+prdName);
        var locname = component.get("v.LocationName");
        // alert('locname'+locname);
        if(prdName == '' || prdName == undefined){
            component.set("v.displayedSection","");
        }
        if(locname == '' || locname == undefined){
            component.set("v.displayedSection","");
        }

        
    }
})