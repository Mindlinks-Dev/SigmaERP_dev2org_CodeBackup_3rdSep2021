({
    doInit : function(component, event, helper) {         
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(userId=='' || userId==null)
        {
            component.set("v.banner",true);            
        }
        else
        {
            component.set("v.banner",false);
        }
    },
    clickRequestForDemo : function(component, helper, event){
        component.set("v.requestForDemoContent",true);
    },
    submitForDemo : function(component, helper, event){
        var allValid = component.find('fieldId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            alert('Thanks for requesting a demo, Our representative will contact you!');
        } else {
            //alert('Please fill all the required field.');
        }
    },
    Cancel : function(component, event, helper){
        component.set("v.requestForDemoContent",false);
    }
})