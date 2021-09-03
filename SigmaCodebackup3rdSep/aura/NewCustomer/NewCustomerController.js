({
	saveCustomer : function(component, event, helper) {
       var customerObj = component.get('v.cust');
       var fnameComp = component.find('firstName');
       var fName = fnameComp.get('v.value');        
       if(fName === '' || fName == null){
       		fnameComp.set("v.errors", [{message:"Enter first name."}]);
        	//return null;
        	return;
       }else{
         fnameComp.set("v.errors",null);   
       }
        
       var lnameComp = component.find('lastName');
       var lName = lnameComp.get('v.value');
       if(lName === '' || lName == null){
       		lnameComp.set("v.errors", [{message:"Enter last name."}]);
        	//return null;
        	return;
       }else{  
          lnameComp.set('v.errors',null);  
       }
        
       var countryComp = component.find('country');
       var country = countryComp.get('v.value');
       if(country === '' || country == null){
       		countryComp.set("v.errors", [{message:"Enter customer country."}]);
        	//return null;
        	return;
       }else{
           countryComp.set('v.errors',null); 
       }
        
       var stateComp = component.find('state');
       var state = stateComp.get('v.value');
       if(state === '' || state == null){
       		stateComp.set("v.errors", [{message:"Enter customer state."}]);
        	//return null;
        	return;
       }else{
           stateComp.set('v.errors',null); 
       } 
        
       var phoneComp = component.find('Phone');
       var phone = phoneComp.get('v.value');
       if(phone === '' || phone == null){
       		phoneComp.set("v.errors", [{message:"Enter phone number."}]);
        	//return null;
        	return;
       }else{
            phoneComp.set('v.errors',null);
       }
        
       var emailComp = component.find('Email');
       var email = emailComp.get('v.value');
       if(email === '' || email == null){
       		emailComp.set("v.errors", [{message:"Enter email id."}]);
        	//return null;
        	return;
       }else{
           var atpos = email.indexOf("@");
           var dotpos = email.lastIndexOf(".");
           if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length) {           		
           		emailComp.set("v.errors", [{message:"Enter a valid e-mail address."}]);
                //return false;
                return;
           }
       }
        
       var addressComp = component.find('address');
       var address = addressComp.get('v.value');
       if(address === '' || address == null){
       		addressComp.set("v.errors", [{message:"Enter customer address."}]);
        	//return null;
        	return;
       }else{
            addressComp.set('v.errors',null);
       }
        
       var spinner = component.find('spinner');
	   $A.util.addClass(spinner, "slds-show");     	
			  
       helper.customerHelperMethod(component);        
	},
    
    backToCreateOrders : function(component, event, helper){
        var reloadCreateOrdersPage = component.getEvent("customerRegEvent");                   
        reloadCreateOrdersPage.fire();
    }
})