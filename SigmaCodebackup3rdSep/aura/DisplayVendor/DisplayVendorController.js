({
    loadData: function(component, event, helper) 
    {
        
        var action = component.get('c.loadvendorProductDetails');
        action.setParams({ 
            "ProductId" : component.get("v.SelectedProductId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.wrapperList', response.getReturnValue());
                console.log(JSON.stringify(response.getReturnValue().size));
            }
        });
        $A.enqueueAction(action);
    },
    /*  onCheck: function(component, event, helper) {

        var getAllCheckboxes = component.find("checkbox");
        for (var i = 0; i < getAllCheckboxes.length; i++) {
            if (getAllCheckboxes[i].get("v.value") == true) {
                alert(getAllCheckboxes[i].get("v.text"));
                console.log(getAllCheckboxes[i].get("v.text"));
            }
        }
    },*/
    onRadio: function(component, event) {
        var selected = event.getSource().get("v.text");
        var selected1 = event.getSource().get("v.labelClass");
        // var selected2 = event.getSource().get("v.name");
        // console.log('selected2>>>'+selected2);
        var cbs = document.getElementsByClassName("slds-radio");
        for (var i = 0; i < cbs.length; i++) {
            cbs[i].checked = false;
        }
        component.set("v.checkThis", true);
        component.set("v.selectedRecordId", selected);
        component.set("v.VendorLocationName", selected1);
        //alert('component.get("v.VendorLocationName")'+component.get("v.VendorLocationName"));
        
        var action = component.get('c.fetchVendorInfo');
        action.setParams({ 
            "vendorId" : component.get("v.selectedRecordId"),
            "venLocName" : component.get("v.VendorLocationName"),
            "productId" : component.get("v.SelectedProductId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('response.getReturnValue()>>'+response.getReturnValue());
            if (state === "SUCCESS") 
            {
                var vpdata=response.getReturnValue();
                console.log('vpdata'+JSON.stringify(vpdata));
                
                component.set("v.VendorName", vpdata.sigmaerpdev2__Account_Name__r.Name);
                component.set("v.BuyingPrice", vpdata.sigmaerpdev2__Buying_Price__c);
                component.set("v.CurrentStock",vpdata.sigmaerpdev2__Current_Stock__c);
                component.set("v.VendorLocationId",vpdata.sigmaerpdev2__Vendor_Location__c);
                if(vpdata.sigmaerpdev2__Vendor_Contact__c == ''  || vpdata.sigmaerpdev2__Vendor_Contact__c == null || vpdata.sigmaerpdev2__Vendor_Contact__c == 'undefined')
                {
                    component.set("v.vendorEmail",'');
                }
                else
                {
                    if(vpdata.sigmaerpdev2__Vendor_Contact__r.Email == ''  || vpdata.sigmaerpdev2__Vendor_Contact__r.Email == null || vpdata.sigmaerpdev2__Vendor_Contact__r.Email == 'undefined')
                    {
                        component.set("v.vendorEmail",'');  
                    }
                    else
                    {
                        component.set("v.vendorEmail",vpdata.sigmaerpdev2__Vendor_Contact__r.Email); 
                       // alert('valid email'+component.get("v.vendorEmail")); 
                    }
                    
                }
                
                var compEvent = component.getEvent("SendDataEvt");
                compEvent.setParams({
                    "VendorId" : component.get("v.selectedRecordId"),
                    "VendorName": component.get("v.VendorName"),
                    "VendorLocation":component.get("v.VendorLocationName"),
                    "BuyingPrice":component.get("v.BuyingPrice"),
                    "VendorEmail":component.get("v.vendorEmail"),
                    "VendorLocationID":component.get("v.VendorLocationId")
                });
                compEvent.fire();
            }
        });
        $A.enqueueAction(action);
        console.log('hello-->>'+component.get("v.selectedRecordId"));
    }
    
})