({
    loadJquery : function(component, event, helper) {
         alert('loadJquery before run ');
     $("document").ready(function(){
            alert('loadJquery before run ');
       });
 },
    
    doInit: function(cmp, event, helper) 
    {
        cmp.set("v.steps", [
           
            { label: "Basic Information", value: "step-1" },
            { label: "Address Details", value: "step-2" },
            { label: "Terms and Condition", value: "step-3" },
            { label: "Payment", value: "step-4" }
            //{ label: "Address Section", value: "step-3" }
            
        ]);
            cmp.set("v.currentStep", "step-1");
          
            
            cmp.set("v.showAddressSection", false);
            cmp.set("v.showBasicInfoSection", true);
            cmp.set("v.showAggrementSection", false); 
            
            
            var urlString = window.location.href;
            var CommunityBaseURL = urlString.substring(0, urlString.indexOf("/s/"));
            //alert('CommunityBaseURL>>'+CommunityBaseURL);
            cmp.set(
            "v.LogoutURL",
            CommunityBaseURL +
            "/s/"
    );
         //cmp.set("v.LogoutURL",CommunityBaseURL +"/secur/logout.jsp?retUrl=" +CommunityBaseURL +"/s/login");   
       //alert('LogoutURL>>'+cmp.get("v.LogoutURL"));     
            
            
  },
            
  goToBasicInfo: function(component, event, helper) {
    //alert('checkbox>>'+component.get('v.isSelected'));
    if (component.get("v.isSelected")) {
      component.set("v.showAggrementSection", false);
      component.set("v.showAddressSection", false);
      component.set("v.showBasicInfoSection", true);
      component.set("v.currentStep", "step-2");
    } else {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Accept terms and conditions."
      });
      toastEvent.fire();
      return;
    }
  },  
            
  backToAggrementSection: function(component, event, helper) {
    component.set("v.showAddressSection", false);
    component.set("v.showAggrementSection", true);
    component.set("v.showBasicInfoSection", false);
  },          
  goToTermsSection: function(component, event, helper) {
    
     var MainWrapperObject = component.get("v.MainWrapperObject");  
     console.log('MainWrapperObject: ' + JSON.stringify(MainWrapperObject));
     if (MainWrapperObject.Address == "") 
     {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Enter your Address."
         });
         toastEvent.fire();
         return;
      }         
            
     if (MainWrapperObject.ContactPerson == "") 
     {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Enter Contact Person Name."
         });
         toastEvent.fire();
         return;
      } 
     
     
    
      if (MainWrapperObject.PostCode == "") 
     {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Enter your PostCode."
         });
         toastEvent.fire();
         return;
      }  
      if (MainWrapperObject.City == "") 
     {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Enter your City."
         });
         toastEvent.fire();
         return;
      }    
      
    component.set("v.currentStep", "step-3");   
    component.set("v.showAddressSection", false);
    component.set("v.showAggrementSection", true);
    component.set("v.showBasicInfoSection", false);
      
  },  
    
            
  DateValidate : function(component, event, helper){
            //alert('Inside DateValidate');
    var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
              //alert('today!'+today);
    var dateValue = component.get("v.MainWrapperObject.ExpiryDate");
             //alert('dateValue!'+dateValue);
    console.log(today);

    if(today  >= dateValue){
        //alert('You can not enter lesser than or equals to todays date!');
        dateValue = null;
        component.set("v.MainWrapperObject.ExpiryDate", dateValue);
        var dateFlag = true;
        if (dateFlag) 
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title: "Error",
            type: "error",
            message: "You can not enter a lesser than or equals to todays date."
            });
            toastEvent.fire();
            return;
         }   
    }
},         

   goToAddressSection: function(cmp, event, helper) 
  {
      var MainWrapperObject = cmp.get("v.MainWrapperObject");
      var EmailFlag = helper.validateEmail(JSON.stringify(cmp.get("v.MainWrapperObject.EmailId")));
      if (!EmailFlag) 
            {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title: "Error",
            type: "error",
            message: "Enter valid email address."
            });
            toastEvent.fire();
            return;
            }     
            
            if(MainWrapperObject.ContactNumber == "") 
            {
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your Contact Number."
                });
                toastEvent.fire();
                return;
            } 
            
            if (MainWrapperObject.FirstName == "") 
            {
           		var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your First Name."
                });
                toastEvent.fire();
                return;
            }    
            
            if (MainWrapperObject.LastName == "") 
            {
           		var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your Last Name."
                });
                toastEvent.fire();
                return;
            } 
            if (MainWrapperObject.BreweryName == "") 
            {
           		var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter Brewery Name."
                });
                toastEvent.fire();
                return;
            } 
       cmp.set("v.showAddressSection", true);
       cmp.set("v.showBasicInfoSection", false);
       cmp.set("v.currentStep", "step-2");   
  },        
  
 
  goToBasicInfoSection: function(component, event, helper) {
    component.set("v.currentStep", "step-1");    
    component.set("v.showAddressSection", false);
    component.set("v.showBasicInfoSection", true);
  },  
   backToAddressSection: function(component, event, helper) {
    component.set("v.currentStep", "step-2");   
    component.set("v.showAddressSection", true);
    component.set("v.showBasicInfoSection", false);
    component.set("v.showAggrementSection", false);        
  },  
            
  gotoPaymentPage: function(component, event, helper) {
 
    component.set("v.showAddressSection", false);
    component.set("v.showBasicInfoSection", false);
    component.set("v.showAggrementSection", false);  
    component.set("v.paymentNotification",false);  
    component.set("v.showPaymentSection",true);
    component.set("v.currentStep", "step-4");  
  },           
            
            
            
 SaveBreweryDetails: function(cmp, event, helper)
 {
     //alert('Inside SaveBreweryDetails>>'+JSON.stringify(cmp.get("v.MainWrapperObject"))); 
     var MainWrapperObject = cmp.get("v.MainWrapperObject");
      if (cmp.get("v.isSelected")) 
      {
      cmp.set("v.showAggrementSection", false);
      cmp.set("v.showAddressSection", false);
      cmp.set("v.showBasicInfoSection", true);

    } else 
    {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Accept terms and conditions."
      });
      toastEvent.fire();
      return;
    }
     
    
            
	 /*if(MainWrapperObject.CardNumber == "") 
     {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Enter your Card Number."
         });
         toastEvent.fire();
         return;
      }               
     if (MainWrapperObject.ExpiryDate == "" || MainWrapperObject.ExpiryDate== null) 
     {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Please select	a valid Expiry Date."
         });
         toastEvent.fire();
         return;
      }        
     if (MainWrapperObject.CVV == "") 
     {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        title: "Error",
        type: "error",
        message: "Enter your Card CVV Number."
         });
         toastEvent.fire();
         return;
      }  */     
            
            
            
            
     var spinner = cmp.find("mySpinner");
     $A.util.toggleClass(spinner, "slds-hide"); 
     //alert('Inside SaveBreweryDetails controller MainWrapperObject>>>'+JSON.stringify(MainWrapperObject)); 
     helper.SaveBreweryInfo(cmp, event, helper);
  }
            
})