({
	    validateQuantity : function(component, event, helper) {
        var availQuantity = component.get("v.IlpliItem.sigmaerpdev2__Available_Quantity__c");
        var selQuantity = component.get("v.IlpliItem.sigmaerpdev2__bucket_field__c");
        var ProType = component.get("v.ProType");
        var AdjustType = component.get("v.AdjustType");
        
        if(selQuantity > availQuantity && AdjustType != 'Increase Stock'){
            component.find("bucket").set("v.errors", [{message:"Pick Quantity should be less than or equal to available quantity."}]);
           component.set("v.istrue",false);
           
            return;
        } else if( selQuantity < 0) {
            component.find("bucket").set("v.errors", [{message:"Pick quantity should be non-negative"}]);
            component.set("v.istrue",true);
            return;
        } else {
            component.find("bucket").set("v.errors", null);
             component.set("v.istrue",true);
            
        }
    }})