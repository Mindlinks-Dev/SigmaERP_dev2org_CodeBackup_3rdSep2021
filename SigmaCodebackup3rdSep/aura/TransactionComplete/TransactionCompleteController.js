({
    sendEmailMethod : function(component, event, helper) 
    {
        
        document.getElementById("Accspinner").style.display = "block";
        helper.sendEmailHelper(component);
    },
    /*showMainPage: function(component, event, helper){                
        var ordIdNo = component.get('v.orderSFId');
       
        if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
            alert('Redirecting to Lightning Record Page');
             sforce.one.navigateToSObject(ordIdNo, 'detail');
           // window.location.href = "/one/one.app#/sObject/" + ordIdNo;
        }
        else{
             alert('Redirecting to Classic Record Page');
            // Redirecting to Classic Record Page
            window.location.href = "/" + ordIdNo;
        }    
        
    }*/
    showMainPage: function(component, event, helper){                
        var ordIdNo = component.get('v.orderSFId');
		//alert('ordIdNo???'+ordIdNo);
       var device = $A.get("$Browser.formFactor");  
      // alert(device);
        if(device==='PHONE'){
           // alert('ordIdNo2???'+ordIdNo);
            //sforce.one.navigateToSObject(ordIdNo, 'detail');
          // window.location.href = "/one/one.app#/sObject/" + ordIdNo; 
        history.back();
        }
        else{
           // alert('else');
            window.location.href = "/" + ordIdNo;
        }
    }
     
    
    
})