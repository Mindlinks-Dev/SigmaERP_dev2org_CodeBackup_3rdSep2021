({
	getDetails : function(component, event, helper) {
        helper.getDetailsH(component, event, helper);
    },
    showActualPayments : function(component, event, helper) {
       component.set("v.openModalPopUp", true);
    },    
    closePopUp : function(component, event, helper) {
       component.set("v.openModalPopUp", false);
    },
    clearInfo : function(component, event, helper) {
       component.set("v.showDetails", false);
       component.set("v.recordId", "");
       component.set("v.recordName", "");        
       component.set("v.fromDate", "");
       component.set("v.endDate", "");
    },
    updatePaymentRecord : function(component, event, helper) {
       helper.updatePaymentRecordH(component, event, helper)
    },
})