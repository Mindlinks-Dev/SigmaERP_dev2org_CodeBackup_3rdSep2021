({
    helperMethod : function() {
        
    },
    removeProductItem : function(component, index) {
        var ShipmentProductsList = component.get("v.ShipmentProducts");
        var action = component.get("c.deleteShipmentProd");
        action.setParams({
            "ShipmentProducts":JSON.stringify(ShipmentProductsList),
            "idx":index
        });
        
        ShipmentProductsList.splice(index, 1);
        component.set("v.ShipmentProducts", ShipmentProductsList);
        $A.enqueueAction(action);
        
    },
    
    createnewShipment: function(component, newShipment) {
        this.upsertShipment(component, newShipment, function(a) {
            newShipment = component.get("v.Shipment");
            newShipment.push(a.getReturnValue());
            component.set("v.Shipment", newShipment);
        });  
    },
    
    upsertShipment : function(component, newShipment, callback) {
               
        
        var action = component.get("c.saveShipment");
       
        action.setParams
        ({ 
            "ShipmentObj": newShipment,
            "shipmentProduts" : JSON.stringify(component.get("v.ShipmentProducts"))//$A.util.json.encode(component.get("v.packageProducts"))
        });
        action.setCallback( this, function(a) {
            var state = a.getState();
            //alert('state'+state);
            if (state === "SUCCESS") 
            {
                component.set("v.curRecordID",a.getReturnValue().Id);
                console.log('a>>>>>'+JSON.stringify(a.getReturnValue()));
                if(a.getReturnValue() != null)
                {
                    let Name=a.getReturnValue().Name;
                    console.log("name:::"+JSON.stringify(Name));
                    if(name!=undefined )
                    if ((typeof sforce != 'undefined') && sforce && (!!sforce.one))
                    {
                        
                        var successAlert = component.find("successAlert");
                        $A.util.removeClass(successAlert,'slds-hide');
                         $A.get('e.force:refreshView').fire();//added on-01-05-2020
                        
                    }else
                    {                        
                        //window.location.href = "/" + a.getReturnValue().Id;
                        //commented above line and added below line on 7-2-2020 to show in SalesOrderModules UI page after update button is pressed                                           
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Success!",
                            "message": Name+"  Shipment record created successfully!"
                        });
                        toastEvent.fire();                                            
                        var evt = $A.get("e.force:navigateToComponent");
                        evt.setParams({
                            componentDef : "c:SalesOrderModules",
                            componentAttributes: {
                                from : 'Shipment'
                            }
                        });
                        evt.fire();
                        //ends here 
                          $A.get('e.force:refreshView').fire();//added on-01-05-2020
                    }    
                } else
                {
                    var successAlert = component.find("successAlert");
                    $A.util.removeClass(successAlert,'slds-hide');
                    var successAlertTheme = component.find("successAlertTheme");
                    $A.util.removeClass(successAlertTheme,'slds-theme--success');
                    $A.util.addClass(successAlertTheme,'slds-theme--error');
                    var iconsuccess=component.find("iconsuccess");
                    $A.util.addClass(iconsuccess,'slds-hide');
                    var iconwarning=component.find("iconwarning");
                    $A.util.removeClass(iconwarning,'slds-hide');
                    var recordCreatedHeader = component.find("recordCreatedHeader");
                    $A.util.addClass(recordCreatedHeader,'slds-hide');
                    var recordNotCreatedHeader = component.find("recordNotCreatedHeader");
                    $A.util.removeClass(recordNotCreatedHeader,'slds-hide');
                    var recordCreatedOK = component.find("recordCreatedOK");
                    $A.util.addClass(recordCreatedOK,'slds-hide');
                    var recordCreatedCancel = component.find("recordCreatedCancel");
                    $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                     $A.get('e.force:refreshView').fire();//added on-01-05-2020
                }   
            }
            else
            {
                var successAlert = component.find("successAlert");
                $A.util.removeClass(successAlert,'slds-hide');
                var successAlertTheme = component.find("successAlertTheme");
                $A.util.removeClass(successAlertTheme,'slds-theme--success');
                $A.util.addClass(successAlertTheme,'slds-theme--error');
                var iconsuccess=component.find("iconsuccess");
                $A.util.addClass(iconsuccess,'slds-hide');
                var iconwarning=component.find("iconwarning");
                $A.util.removeClass(iconwarning,'slds-hide');
                var recordCreatedHeader = component.find("recordCreatedHeader");
                $A.util.addClass(recordCreatedHeader,'slds-hide');
                var recordNotCreatedHeader = component.find("recordNotCreatedHeader");
                $A.util.removeClass(recordNotCreatedHeader,'slds-hide');
                var recordCreatedOK = component.find("recordCreatedOK");
                $A.util.addClass(recordCreatedOK,'slds-hide');
                var recordCreatedCancel = component.find("recordCreatedCancel");
                $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                 $A.get('e.force:refreshView').fire();//added on-01-05-2020
            }
        });
        document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action);
         // $A.get('e.force:refreshView').fire();//added on-01-05-2020
    }
})