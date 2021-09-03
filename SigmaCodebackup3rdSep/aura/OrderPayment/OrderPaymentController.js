({
	doInit : function(component, event, helper) {
        //code added to restict Payement (custom button) access for specific users
        var action = component.get("c.fetchOrder");
        action.setParams({ 
            "AccId" : component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state==="SUCCESS") {
                var orderdata = response.getReturnValue();
             
                component.set('v.SigmaOrder',orderdata.OrderTypeusage.sigmaerpdev2__Sigma_order__c);
                component.set('v.StndOrder',orderdata.OrderTypeusage.sigmaerpdev2__Standard_object__c);
                if(component.get('v.SigmaOrder') == true)
                {
                    component.set('v.OrderList',orderdata.SigmaOrder);
                }
                else if(component.get('v.StndOrder') == true)
                {
                     component.set('v.OrderList',orderdata.StandardOrder);
                }
                
            }
        });
        $A.enqueueAction(action); 
    },
    close : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
    selectAllInvoice : function(component, event, helper){
        var OrderList=component.get("v.OrderList");
        if(component.get("v.selectAllFlag")){        
            for(var i=0;i<OrderList.length;i++){            
                OrderList[i].selected=true;
            }
        }
        else{        
            for(var i=0;i<OrderList.length;i++){            
                OrderList[i].selected=false;
            }            
        }
        component.set("v.OrderList",OrderList);
    },
    payorderamount : function(component, event, helper){ 
       
        var OrderList = component.get("v.OrderList");
        var selected=[];
        for(var i=0;i<OrderList.length;i++){
            if(OrderList[i].selected == true){
                selected.push(OrderList[i]);
            }
        }
        if(selected.length > 0){
            component.set("v.selectedOrderList",selected);
            
            var evt = $A.get("e.force:navigateToComponent");
           
            evt.setParams({
                componentDef: "c:OrderPaymentCalling",
                componentAttributes :{
                    "selectedOrderList": component.get("v.selectedOrderList"),
                    "SigmaOrder":component.get("v.SigmaOrder"),
                    "StndOrder" : component.get("v.StndOrder"),
                    "Accid": component.get("v.recordId")
                   
                }
            });       
            evt.fire(); 
        }
        else{
            alert('Select atleast one order to make Payment.');
            return;
        }       
    }
})