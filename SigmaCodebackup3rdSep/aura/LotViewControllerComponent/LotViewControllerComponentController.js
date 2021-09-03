({
    Search : function(component, event, helper)
    {
        var txt1 = component.get('v.lotId');
       var txt2 = component.get('v.productId');
       
       
        
        if(txt1 == '' || txt1==undefined || txt1==null)
        {
            /* var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: "Please choose the Product",
                type : 'Error'
            });
            toastEvent.fire();
            return;*/
            var msg = "Please choose the Lot";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } 
        
        
        
        if (txt1 != ''){
            
            var action = component.get("c.getLotData");
            
            action.setParams({"productId": component.get('v.productId'), "lotId": component.get('v.lotId')});
            
        }
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert('state@@'+state);
            var responseData=response.getReturnValue()
            //alert('responseData@@'+JSON.stringify(responseData));
            
            if(state === "SUCCESS") {
                
                //alert(response.getReturnValue().length);
                if(response.getReturnValue().length > 0){
                    
                    component.set("v.ShowDetails", response.getReturnValue());
                    var popup = component.find('popup');
                    $A.util.removeClass(popup, 'slds-hide');
                    
                }
                else if(response.getReturnValue().length =='')
                {
                    //alert(response.getReturnValue().length);
                    /*  var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        
                        message: "Wrong Input!!",
                        type : 'error'
                        
                    });
                    toastEvent.fire();*/
                    var msg = "The selected lot don't have any Inventory Received";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    
                }
                
                    else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    } 
                
            } 
            else {
                /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    
                    message: "Enter Data is Wrong!!!",
                    type : 'error'
                    
                });
                toastEvent.fire();*/
                var msg = "Enter Data is Wrong!!!";
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                return;
                
                console.log('Problem getting account, response state:'  +state);
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    StockView : function(component, event, helper)
    {
        
        var action = component.get("c.getILP");
        action.setParams({"productId": component.get('v.productId'), "lotId": component.get('v.lotId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                
                if(response.getReturnValue().length > 0)
                {
                    
                    component.set("v.ShowIlp",response.getReturnValue());
                    
                    var popup1 = component.find('popup1');
                    $A.util.removeClass(popup1, 'slds-hide');
                    
                }
                
                else if(response.getReturnValue().length == '')
                {
                    /* var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: "No Record is Present!!",
                        type : 'error'
                        
                    });
                    toastEvent.fire(); */
                    var msg = "No Record is Present!!";
                    component.set("v.lotviewerrorMsg", msg);
                    component.set("v.lotviewError",true);
                    return;
                    
                }
                    else{
                        component.set("v.lotviewError",false);
                        component.set("v.lotviewerrorMsg", "");
                    } 
                
            } 
            else {
                console.log('Problem getting account, response state: '  +state);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    Delivery : function(component, event, helper)
    {
        var action = component.get("c.getShipment");
        
        action.setParams({"productId": component.get('v.productId'), "lotId": component.get('v.lotId')});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(JSON.stringify(response.getReturnValue()));
            if(state === "SUCCESS") {
                //alert(state);
                if(response.getReturnValue() !=null)
                {
                    //alert('response.getReturnValue()>>>'+JSON.stringify(response.getReturnValue()));
                    component.set("v.ShowDelivery",response.getReturnValue());
                    var popup2 = component.find('popup2');
                    $A.util.removeClass(popup2, 'slds-hide');
                    
                }
                else if(response.getReturnValue() == null)
                {
                    // alert('error')
                    /* var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: "No Quantity is Delivered.Please do verify!!!",
                        type : 'error'
                        
                    });
                    toastEvent.fire();*/
                    //alert('lotviewError>>'+JSON.stringify(component.get("v.lotviewError")));
                    var msg = "No Shipment record is created/Delivered for this product!!!";
                    component.set("v.lotviewerrorMsg", msg);
                    component.set("v.lotviewError",true);
                    return;
                    
                }
                    else{
                       // alert('lotviewerrorMsg>>'+JSON.stringify(component.get("v.lotviewerrorMsg")));
                        component.set("v.lotviewError",false);
                        component.set("v.lotviewerrorMsg", "");
                    } 
            } 
            else {
                console.log('Problem getting account, response state: '  +state);
            }
        });
        $A.enqueueAction(action);
        
    },
    closeMethod : function(component,event,helper) {
        var modal = component.find("popup");
        $A.util.addClass(modal, 'slds-hide');
        component.set("v.lotviewError",false);
        //alert('flag1>>'+v.isOpenchild);
        //component.set("v.isOpenchild", false);       
        
        // window.location.reload();
    },
    closeMethod2 : function(component) {
        var modal = component.find("popup1");
        $A.util.addClass(modal, 'slds-hide');
        
    },
    closeMethod3 : function(component) {
        var modal = component.find("popup2");
        $A.util.addClass(modal, 'slds-hide');
        
    },
    clearId:function(component,event,helper)
    {
        var  context = event.getParam("instanceId");
        var  objectId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        if(context =='MyProduct123')
        {
            // alert('alerty');
            component.set("v.productId","");
            //component.set("v.lotId","");
            //component.set("v.LotNumber","");
            
        }
        else if(context =='MyLot')
        {
            component.set("v.lotId","");
            
        }
        
    },
    SelectedID:function(component,event,helper)
    {
        var  context = event.getParam("instanceId");
        var  objectId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        if(context =='MyProduct123')
        {
            component.set("v.productId",objectId);
            
        }
        else if(context =='MyLot')
        {
            component.set("v.lotId",objectId);
            
        }
    }
    
})