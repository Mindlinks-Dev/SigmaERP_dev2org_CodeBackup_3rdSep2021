({
    
    doInit: function(component, event, helper) {
        // call the fetchPickListVal(component, field_API_Name, aura_attribute_name_for_store_options) -
        // method for get picklist values dynamic   
        // alert('fetchproducts');
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, "slds-hide");
        var today = $A.localizationService.formatDate(new Date(), "DD-MM-YYYY");
        component.set('v.today', today);
        //helper.toGetLocationData(component, event,helper);
        helper.toGetcustomerData(component, event,helper);
        
        
    },
    
    inlineEditProductName : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId").focus();
        }, 100);
    },
    
    inlineEditLocation : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.LocationEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("Location").set("v.options" , component.get("v.locationPicklistOpts"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("Location").focus();
        }, 100);
    },
    
    onCurrentStockChange : function(component,event,helper){ 
        // if edit field value changed and field not equal to blank,
        // then show save and cancel button by set attribute to true
        //if(event.getSource().get("v.value").trim() != '' && event.getSource().get("v.value") != undefined ){ 
        component.set("v.showSaveCancelBtn",true);
        /* }*/
    },
    
    ondateChange : function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },    
    
    CurrentStockcloseBox : function (component, event, helper) {
        // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.nameEditMode", false); 
        // check if change/update Name field is blank, then add error class to column -
        // by setting the 'showErrorClass' att. as True , else remove error class by setting it False   
        if(event.getSource().get("v.value").trim() == '' && event.getSource().get("v.value") != undefined ){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }, 
    
    closeLocationBox : function (component, event, helper) {
        // on focus out, close the input section by setting the 'ratingEditMode' att. as false
        component.set("v.locationEditMode", false); 
    },
    SelectedID : function(cmp, event) 
    {
        // alert('inside came');
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");
        
        if(context == 'MyVendor')
        {  
            
            cmp.set("v.singleRec.sigmaerpdev2__Vendor__c",objectId);
            
        }else if(context =='MyAccount2')
        { 
            
            cmp.set("v.singleRec.sigmaerpdev2__Location__c",objectId); 
            
        }
            else if(context =='MyContact')
            {
                cmp.set("v.singleRec.sigmaerpdev2__Delivery_Person__c",objectId); 
            }
        
    },
    ChangeLocationId: function(component, event, helper) {
        var locationId =component.get('v.locationId');
        var locationName =component.get('v.locationName');
        //alert(locationId);
        //alert(locationName);
        if(locationId){
            component.set('v.singleRec.sigmaerpdev2__Location__c',locationId);
            component.set('v.singleRec.sigmaerpdev2__Location__r.Name',locationName);
            //$A.util.addClass(component.find('productNameDispaly'), 'slds-hide');
            component.set("v.showSaveCancelBtn",true);
        }
        else{
            component.set('v.singleRec.sigmaerpdev2__Location__c','');
            component.set('v.singleRec.sigmaerpdev2__Location__r.Name','');
            
        }
    },
    getproductimagedata: function(component, event, helper) {
        component.set("v.viewProductImageModal",true);
          var action = component.get("c.getContents");
       // var picId = component.get("v.pictureList");
        var picId = '0692x0000078jezAAA';
         alert('picId>>>'+picId)
         var sObjectName = component.get("v.sObjectName");
        alert('sObjectName>>>'+sObjectName)
       
        action.setParams({
             imgId :picId,
             ObjectName : sObjectName
         })  
       action.setCallback(this, function(response) {
           var state = response.getState();
           alert('state>>>'+state)
           if(component.isValid() && state === 'SUCCESS') {
                 component.set("v.contents", response.getReturnValue().Id);
               alert('response>>>'+JSON.stringify(response.getReturnValue()))
           }
       });
        $A.enqueueAction(action);
    
        /*var a = event.currentTarget.name;
        alert('Selected :'+a);*/
        /*var getproductimagedata = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');*/
        
    },
    viewProductImageModal: function(component, event, helper) {
        component.set("v.viewProductImageModal",false);
    }
    
    
})