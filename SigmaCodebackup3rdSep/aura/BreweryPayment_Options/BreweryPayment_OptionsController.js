({
    doInit : function(cmp, event, helper) {
       // alert('setssssssssssss>>>'+cmp.get('v.regid'));
        
        cmp.set("v.Spinner", true);
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set("v.Spinner", false);
            }), 3000
        );
        cmp.set('v.paymentOptions',true);
        
        //alert('MainWrapperObject:::'+JSON.stringify(cmp.get('v.MainWrapperObject')));
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
        // alert('hg111');
        component.set('v.paymentOptions',false);
        component.set('v.cashPayment',true);
        //alert('vdscsdv'+component.get('v.cashPayment'));
        component.set('v.chequePayment',false);
        component.set('v.cardInfo',false);
    },
    
    chequepaymentpage : function(component, event, helper) {
        
        component.set('v.paymentOptions',false);
        component.set('v.cashPayment',false);
        component.set('v.chequePayment',true);
       // alert('vdscsdv'+component.get('v.chequePayment'));
        component.set('v.cardInfo',false);
    },
    
    keyentrypage : function(component, event, helper) {
        component.set('v.paymentOptions',false);         
        component.set('v.cashPayment',false);         
        component.set('v.chequePayment',false); 
        component.set('v.cardInfo',true);     
    },
    
    gotoTaxPage : function(cmp, event, helper){
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
        cmp.set('v.showPaymentSection',false); 
        cmp.set('v.showAggrementSection',true); 
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 

        
    },    
    
    showTransSuccessPage: function(component, event, helper){   
        component.set('v.transSuccess',true);
        component.set('v.cashPayment',false);
        component.set('v.chequePayment',false);
        component.set('v.cardInfo',false);
    }     
})