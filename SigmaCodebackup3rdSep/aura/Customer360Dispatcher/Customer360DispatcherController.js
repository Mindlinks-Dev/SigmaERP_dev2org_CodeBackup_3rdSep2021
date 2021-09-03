({
    getData : function(component, event, helper) {
        debugger;
        var map_action = component.find('modal_map');
        if(!($A.util.hasClass(map_action,"slds_hide"))){
            $A.util.addClass(map_action,"slds_hide");
        }
        helper.getDataHelper(component,event);
    },
    closeWindow : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    navigateWO : function(component, event, helper) {
        //Navigate the link to the corersponding record ID.
        var navEvt = $A.get("e.force:navigateToSObject");
        
        navEvt.setParams({
            "recordId": component.get("v.recordId")
        });
        navEvt.fire();
    },
    navigatePreviousWO : function(component, event, helper) {
        //Navigate the link to the corersponding record ID.
        var navEvt = $A.get("e.force:navigateToSObject");
        // alert(component.get("v.caserecordID"));
        navEvt.setParams({
            "recordId": component.get("v.workOrderDetails.lastVisitWorkOrderId")
        });
        navEvt.fire();
    },
    map_popup : function(component, event, helper) {
        debugger;
        //var map_action = component.find('modal_map');
        //$A.util.removeClass(map_action,"slds_hide");
        //$A.util.addClass(map_action,"slds_show");
        component.set('v.modalpopup',true);
        
    },
    modal_map_close : function(component, event, helper) {
        //var map_action = component.find('modal_map');
        
        //$A.util.removeClass(map_action,"slds_show");
        //$A.util.addClass(map_action,"slds_hide");
        component.set('v.modalpopup',false);
        
    },
    onClickToDial: function (cmp, event, helper) {
        var clickToDialService = cmp.find("clickToDialService");
        clickToDialService.enable();
        // clickToDialService is for internal use only.
        // Use sforce.opencti.onClickToDial() in your org.
        // https://developer.salesforce.com/docs/atlas.en-us.api_cti.meta/api_cti/sforce_api_cti_onclicktodial_lex.htm
        //clickToDialService = cmp.find("clickToDialService");
        clickToDialService.addDialListener(function(payload){
        	console.log("This alert simulates the onClickToDial method for Open CTI in Lightning Experience. The phone number is dialed sending the following payload: " + JSON.stringify(payload));
        });
    }
})