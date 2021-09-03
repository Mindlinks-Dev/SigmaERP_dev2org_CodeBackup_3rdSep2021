({
	validateQuantity : function(component, event, helper) {
		var availQuantity = component.get("v.wrapList.ilpAvailQuantity");
        var selQuantity = component.get("v.wrapList.selQuantity");
        component.set("v.enteredQuantiy",selQuantity);
       // alert('selQuantity'+selQuantity);
        
        if(selQuantity != ''){
         	if(selQuantity <= 0){
            	alert('Quantity value must be greater than 0.');            
            	return; 
        	}   
        }       
      
        if(selQuantity > availQuantity){
            
            alert('Quantity value must be less than or equal to : '+availQuantity);
			component.set("v.wrapList.selQuantity",'');    
            return;
        }
        
        // validation on negative and spec-character by chandana 
       // alert('selQuantity::'+selQuantity);
       
      var iChars = "!`@#$%^&*()+=-[]\\\';,./{}|\":<>?~_"; 
	  var data= component.get("v.wrapList.selQuantity");
       // alert('data1111::'+JSON.stringify(component.get("v.wrapList.selQuantity")));
        //alert('data::'+data);
		for (var i = 0; i < data.length; i++)
                {   
					//alert('inside spec-char');
                    if (iChars.indexOf(data.charAt(i)) != -1)
                    {    
                    alert ("Your string has special characters. \nThese are not allowed.");
                    component.set("v.wrapList.selQuantity",0);
                    return false; 
                    } 
                }
	},
    
    handleApplicationEvent : function(cmp, event) {
        var selQuantity = cmp.get("v.wrapList.selQuantity");
        //alert('wrap::'+JSON.stringify(cmp.get("v.wrapList.selQuantity")));
        var qunt = event.getParam("quantity");
		//alert('qunt'+qunt);
                if(selQuantity !=undefined)
                {
                cmp.set("v.wrapList.selQuantity",qunt);
            	}
      
        //alert('final value::'+cmp.get("v.wrapList.selQuantity"));
    }
})