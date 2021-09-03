({
    doInit : function(component, event, helper){
        var action = component.get('c.getPickList');  
        action.setParams({
            objName : component.get('v.objName'),
            fldName : component.get('v.fldName')
        });
        action.setCallback(this,function(result){
            var resultValue = result.getReturnValue();
            component.set('v.ratingList',resultValue);
        })
    },
    handleSubmit1 : function(component, event, helper) {
        var validitem = true;
        var Name = component.find("Name").get("v.value");
        if ($A.util.isEmpty(Name)){
            validitem = false;
        }
        var Phone_Number = component.find("Phone_Number").get("v.value");
        if ($A.util.isEmpty(Phone_Number)){
            validitem = false;
        }
        var Email_Address = component.find("Email_Address").get("v.value");
        if ($A.util.isEmpty(Email_Address)){
            validitem = false;
        }
        var Company_Name = component.find("Company_Name").get("v.value");
        if ($A.util.isEmpty(Company_Name)){
            validitem = false;
        }
        var Job_Title = component.find("Job_Title").get("v.value");
        if ($A.util.isEmpty(Job_Title)){
            validitem = false;
        }
        var Is_Salesforce = component.find("Is_Salesforce").get("v.value");
        //alert('Is_Salesforce'+Is_Salesforce);
        if ($A.util.isEmpty(Is_Salesforce)){
            validitem = false;
        }
        
        //alert('userData'+userData);
        if(validitem){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Thank you for entering details.",
                "type": "success",
                "message": "Soon our representative will contact you.",
                "mode": "sticky"
            });            
            toastEvent.fire();
            setTimeout(function(){
                helper.handleSubmit(component, event, helper); 
            }, 4000);
            
        }
    },
    handleSubmit : function(component, event, helper){
        var validUserData = component.find('UserData').reduce(function (validSoFar, inputCmp){
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validUserData){    
            helper.handleSubmit(component, event, helper); 
        }
        
    },
    handleCancel : function(component, event, helper) {
        component.set("v.UserDetails_ShoppingCart",false);
    }
    /*savepick : function(component, event, helper) {
         alert('savepicklist');
         var pick = component.get("! v.options");
         alert('savepicklist2222');
         alert('options'+pick);
         if(pick==true)
         {
        component.set("v.createAcc.sigmaerpdev2__IsSalesforce__c",Yes);
         }
         else
         {
            component.set("v.createAcc.sigmaerpdev2__IsSalesforce__c",No); 
         }
    }*/
})