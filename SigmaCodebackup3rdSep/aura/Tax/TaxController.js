({
    doInitTax : function(cmp, event, helper) {       
        var spinner = cmp.find('spinner');
        $A.util.addClass(spinner, "slds-show"); 
        //alert('In Tax cmp'+cmp.get("v.recordId"));
        
        helper.fetchTax(cmp); 
        
    },
    
    showPaymentOptions : function(component, event, helper) {  
        component.set('v.payment_Options_Page',true);
        
        component.set('v.mainblock',false);
    },
    
    
    
    
    backToCreateOrders : function(component, event, helper){
        var reloadCreateOrdersPage = component.getEvent("showCreateOrders");                   
        reloadCreateOrdersPage.fire();        
    },
    
    reloadTaxValues:function(component, event, helper){
        helper.fetchTax(component); 
        component.set('v.mainblock',true);
        component.set('v.payment_Options_Page',false);        
    },
    
    
    
    gotoOrderDetailsPage : function(component, event, helper)
    {
        var TempOrderID = component.get('v.orderSFId');
        var payment = component.get('v.paymenttype');
        if(payment === "Prepaid"){
            alert("Please make payment");
        }
        else if((typeof sforce != 'undefined') && sforce && (!!sforce.one)){
            //window.location.href = "/" + TempOrderID; 
            window.location.href = "/one/one.app#/sObject/" + TempOrderID;
        }
            else{
                window.location.href = "/" + TempOrderID; 
            }
        
    }
})