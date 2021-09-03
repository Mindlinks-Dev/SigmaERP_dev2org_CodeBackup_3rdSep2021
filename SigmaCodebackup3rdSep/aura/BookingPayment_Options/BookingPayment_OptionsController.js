({
    doInit : function(cmp, event, helper) {
  
        cmp.set("v.Spinner", true);
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set("v.Spinner", false);
            }), 3000
        );
        cmp.set('v.paymentOptions',true);
        
        //alert('Inside payment helper option MainWrapperObject:::'+JSON.stringify(cmp.get('v.BookingWrap')));
        //alert('customrID:::'+cmp.get('v.BookingWrap.CustomerId'));

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
    },
    
    
/*<fieldset class="slds-form--compound">
<div class="form-element__group">
<div class="slds-form-element__row">
<div class="slds-size--1-of-2" style="text-align:center;background:white;">
<img src="{!$Resource.sigmaerpdev2__Cash}" height="100" width="100" onclick = "{!c.cashpaymentpage}"/><br/>
<!--<div class="payment-img Cash" onclick = "{!c.cashpaymentpage}"></div>-->

<p class="slds-form-element__label">Cash</p>
</div>

<div class="slds-size--1-of-2" style="text-align:center;background:white;">
<img src="{!$Resource.Cheque}"  height="100" width="100"  onclick = "{!c.chequepaymentpage}" /><br/><br/><br/>
<!--<div class="payment-img Cheque" onclick = "{!c.chequepaymentpage}"></div>-->
<p class="slds-form-element__label">Cheque</p>
</div>
</div>
</div>
</fieldset>*/
    
    
})