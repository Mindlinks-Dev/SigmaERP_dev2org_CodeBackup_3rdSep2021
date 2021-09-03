({
	doInit : function(cmp, event, helper) {
       

    },
    
    addToCart : function(cmp, event, helper)
    {
        var productQuantityId = cmp.find("productQuantityId");
        var productQtyfromAnother = productQuantityId.get("v.value");
        var productQantity = parseInt(productQtyfromAnother,10);
  	    if(isNaN(productQantity)){
            productQuantityId.set("v.errors", [{message:"Please Select atleast one quantity to Proceed"}]);
            return null;
        }
        else{
            productQuantityId.set("v.errors",null);
        }
       helper.setproductList(cmp, event,helper); 
    },
    cancelProduct : function(cmp, event, helper)
    {                 
        var showProductPage = cmp.getEvent("backToProductList");                   
        showProductPage.fire();        
    },
    calculatePrice : function(cmp, event, helper)
    {
         var product = cmp.get('v.prductObj');
       
        var productqty = cmp.get('v.productQuantity');
      
    },
         
    computeTotal : function(cmp, event, helper)
    {
    	var product = cmp.get('v.prductObj');
        
    	var productAvailableInventory = cmp.get('v.AvailableInventory');
		
        var productQuantityId = cmp.find("productQuantityId");
        var productQtyfromAnother = productQuantityId.get("v.value");
         
        var productQantity = parseInt(productQtyfromAnother,10);
       
        
        if(productAvailableInventory >= productQantity)
        {            
        	if(productQantity > 0)
        	{
        		var Total = product.sigmaerpdev__Product_Price__c * productQantity;
        		
        		cmp.set('v.productAmount',Total.toFixed(2));
        	}
        	else 
        	{
        		cmp.set('v.productAmount',0);  
                
        	}
        }
        else
        {
            alert('Selected quantity is not available, Max availabe is :'+productAvailableInventory);
            cmp.set('v.productQuantity',null);
        	cmp.set('v.productAmount',null);
        }
        
        
        
        
	}    
})