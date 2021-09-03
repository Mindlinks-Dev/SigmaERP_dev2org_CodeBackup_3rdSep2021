({
	setproductList : function(cmp, product, helper)
    {
 	    product = cmp.get('v.prductObj');
        var productQty = cmp.get('v.productQuantity');
        var productAmount = cmp.get('v.productAmount');
  		
        var pdVal = 'gotProduct';
        
        var productEvent = cmp.getEvent("productObjEvent");  
		        
        productEvent.setParams({
            "productInfo" : product, "productVal" : pdVal,
            "productQuantity" : productQty , "productAmount" : productAmount
            
        });

        
        // Fire the event
        productEvent.fire();
        
        cmp.set('v.productQuantity','');//used to clear previously entered  Values 
        cmp.set('v.productAmount','');  
    
        
	}
})