({
    setproductList : function(cmp, product, helper)
    {
        product = cmp.get('v.prductObj');        
		var pdVal = 'gotProduct';
        var productQty = cmp.get('v.productQuantity');
        var discount = cmp.get('v.discountamount');
        var productAmount = cmp.get('v.rentalnetamount');
		var deliverydate = cmp.get('v.deliverydate');
		var amountperinterval = cmp.get('v.prductObj.sigmaerpdev__Billing_Charge__c');
        var rentalstatus = cmp.find("InputRentalStatus");
        var rentalstatusvalue =  rentalstatus.get("v.value");
        var billinginterval = cmp.find("InputBillingInterval");
        var billingintervalvalue =  billinginterval.get("v.value");
        var startdate = cmp.get('v.startdate');
        var duedate = cmp.get('v.duedate');
        var returndate = cmp.get('v.returndate');
		
		var productEvent = cmp.getEvent("productObjEvent");
		productEvent.setParams({
            "productInfo" : product,
			"productVal" : pdVal,
            "productQuantity" : productQty ,
			"ProductDiscount":discount,
			"productAmount" : productAmount ,
			"deliverydate" : deliverydate,
			"startdate" : startdate,
			"duedate" : duedate,
			"returndate" : returndate,
			"rentalstatus" : rentalstatusvalue,
			"billinginterval" : billingintervalvalue,
            "amountperinterval" : amountperinterval
        });
        // Fire the event
        productEvent.fire();
        cmp.set('v.productQuantity','');//used to clear previously entered  Values 
        cmp.set('v.rentalnetamount',''); 
        cmp.set('v.discountamount','');
        cmp.set('v.startdate',''); 
        cmp.set('v.duedate',''); 
        cmp.set('v.returndate',''); 
        cmp.set('v.Discount','');
        cmp.set('v.deliverydate','');
        rentalstatus.set("v.value", '');
        billinginterval.set("v.value", '');
    }
})