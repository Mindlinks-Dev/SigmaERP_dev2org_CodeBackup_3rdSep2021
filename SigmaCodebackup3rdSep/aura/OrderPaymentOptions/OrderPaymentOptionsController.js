({
    doInit : function(cmp, event, helper) {
       
        cmp.set("v.Spinner", true);
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set("v.Spinner", false);
            }), 3000
        );
        cmp.set('v.paymentOptions',true);
        var orderdata = cmp.get('v.selectedOrderList');
        var orderid =[];
        for(var i=0;i<orderdata.length;i++)
            {
                orderid.push(orderdata[i].Id)
            }
        cmp.set('v.selectedOrderList',orderid);
        cmp.set('v.OrderIds',orderid);
        
       // alert(cmp.get('v.selectedOrderList'));
        
        //alert('paymentoption:::'+JSON.stringify(cmp.get('v.amountTobeCharged')));
    },
    
    
     handleTaxValues : function(cmp,event,helper)
    {
        cmp.set('v.paymentOptions',true);
        cmp.set('v.cashPayment', false);
        cmp.set('v.chequePayment', false);
        cmp.set('v.cardInfo', false);
    },
    cashpaymentpage : function(component, event, helper) {
        
        component.set('v.paymentOptions',false);
        component.set('v.cashPayment',true);
        component.set('v.chequePayment',false);
        component.set('v.cardInfo',false);
        
    },
    
    chequepaymentpage : function(component, event, helper) {
        
        component.set('v.paymentOptions',false);
        component.set('v.cashPayment',false);
        component.set('v.chequePayment',true);
        component.set('v.cardInfo',false);
    },
    
    keyentrypage : function(component, event, helper) {
        component.set('v.paymentOptions',false);         
        component.set('v.cashPayment',false);         
        component.set('v.chequePayment',false); 
        component.set('v.cardInfo',true);     
    },
    
    gotoTaxPage : function(component, event, helper){
        //alert('ji');
        window.history.back();    
        //var reloadTaxEvent = component.getEvent("reloadTaxValues");                   
        //reloadTaxEvent.fire();
       // var TempOrderID = component.get('v.orderSFId');
       // window.location.href = "/" + TempOrderID; 
    },
     showTransSuccessPage: function(component, event, helper){   
        component.set('v.transSuccess',true);
        component.set('v.cashPayment',false);
        component.set('v.chequePayment',false);
        component.set('v.cardInfo',false);
    }  
    
        
})