({
    doInit: function(cmp,event,helper) {
        helper.getShipment(cmp,event,helper);
    },
    
    onPicklistChange : function(component,event,helper) {
        var selected = component.find("levels").get("v.value");
        component.set("v.selectedCourier",selected);
        var values=component.get("v.myMap");
        if(selected!="--None--"){
            for(var key in values){
                if(key==selected)
                    component.set("v.courierSlug",values[key]);
            } 
        }
        else
            component.set("v.courierSlug",null);
    },
    
    pushShipment : function(cmp,event,helper) {
       
        if(cmp.get("v.shipment.sigmaerpdev__Tracking_ID__c")=='' || cmp.get("v.shipment.sigmaerpdev__Tracking_ID__c") == undefined || cmp.get("v.shipment.sigmaerpdev__Tracking_ID__c")== null){
            $A.get("e.force:showToast").setParams({"title":"Error!","type":"error","message":"Please enter Tracking Number."}).fire();
        }
        else{
            if(cmp.get("v.shipment.sigmaerpdev__Status__c")=='Shipped' ){
                var action = cmp.get("c.pushtoAfterShip");
                action.setParams({
                    ShipmentID:cmp.get("v.recordId")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var returneddata = response.getReturnValue();
                        if(returneddata.status==false){
                            $A.get("e.force:showToast").setParams({"title":"Error!","type":"error","message":returneddata.errorMessage}).fire();
                        }
                        else if(returneddata.status==true){
                            $A.get("e.force:showToast").setParams({"title":"Success!","type":"Success","message":returneddata.errorMessage}).fire();
                            $A.get('e.force:refreshView').fire();
                            helper.getShipment(cmp);
                        }
                    }
                    else if (state === "INCOMPLETE") {
                    }
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    cmp.set("v.message",errors[0].message);
                                    //cmp.set('v.showmsg',true);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                });
                $A.enqueueAction(action);
            }
            else
                $A.get("e.force:showToast").setParams({"title":"Error!","type":"error","message":"Shipment status should be Shipped to Push to Aftership"}).fire();
        }
    },
    getStatus : function(cmp,event,helper) {
        var action = cmp.get("c.trackCourier");
        action.setParams({shipId:cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returneddata = response.getReturnValue();
                if(returneddata.status==false){
                    $A.get("e.force:showToast").setParams({"title":"Error!","type":"error","message":returneddata.errorMessage}).fire();
                }
                else if(returneddata.status==true){
                    $A.get("e.force:showToast").setParams({"title":"Shipment recent status!","type":"info","message":returneddata.errorMessage}).fire();
                    cmp.set("v.hasStatus",true);
                    $A.get('e.force:refreshView').fire();
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
            }
        });
        $A.enqueueAction(action);
    }
})