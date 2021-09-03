({
    doInit: function(component, event, helper) {
        
        var action = component.get("c.getRentalStatus");
        var inputrentalstatus = component.find("InputRentalStatus");
        var opts=[];
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputrentalstatus.set("v.options", opts);
        });
        $A.enqueueAction(action); 
        
        var action = component.get("c.getBillingInterval");
        var inputbillinginterval = component.find("InputBillingInterval");
        var opts2=[];
        action.setCallback(this, function(a2) {
            opts2.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a2.getReturnValue().length;i++){
                opts2.push({"class": "optionClass", label: a2.getReturnValue()[i], value: a2.getReturnValue()[i]});
            }
            inputbillinginterval.set("v.options", opts2);
        });
        $A.enqueueAction(action);
    },
    
    calTotal : function(cmp, event, helper){
        var productQantity = cmp.get('v.productQuantity');
        var amountperinterval = cmp.get('v.prductObj.sigmaerpdev__Billing_Charge__c');
        var startdate = cmp.get('v.startdate');
        var duedate = cmp.get('v.duedate');
        var returndate = cmp.get('v.returndate');
        var deliverdate = cmp.get('v.deliverydate');
        var billinginterval = cmp.find("InputBillingInterval");
        var billingintervalvalue =  billinginterval.get("v.value");
        var discount = cmp.get('v.discountamount');
        var prodbillinginterval = cmp.get('v.prductObj.sigmaerpdev__Billing_Interval__c');
        var productAvailableInventory = cmp.get('v.AvailableInventory');
        var discvalue;
        var todayDate = new Date();
        var Month = todayDate.getMonth() + 1;
        var Day = todayDate.getDate();
        var Year = todayDate.getFullYear();
        var now  = Year + "-" + Month + "-" + Day;
        
        if(prodbillinginterval == '--None--' || prodbillinginterval == '' || prodbillinginterval == undefined || prodbillinginterval == null){
            /*var showToast = $A.get("e.force:showToast"); 
            showToast.setParams({ 
                'type' : 'warning',
                'title' : 'Product billing interval is not defined',
            	'message' : 'Billing amount cannot be calculated',
            }); 
            showToast.fire();*/
            alert('Product billing interval is not defined');
        }
        if(productQantity > productAvailableInventory)
        {
            alert('Selected quantity is not available, Max availabe is :'+productAvailableInventory);
            cmp.set('v.productQuantity',null);
        }
        if(productQantity <0 || (productQantity % 1) != 0)
        {
             alert('Please Give Valid Quantity');
            //alert('Quantity cannot be Negative');
            cmp.set('v.productQuantity',null);
        }
      /* if((productQantity % 1) != 0)
        {
            alert('Please Give Valid Quantity');
            cmp.set('v.productQuantity',null);
        } */
       
        if(billingintervalvalue != '' || billingintervalvalue != undefined || billingintervalvalue != null){
            if(prodbillinginterval == 'Day' && billingintervalvalue == 'Hour'){
                /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Billing Interval cannot be less than a day',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Billing Interval cannot be less than a day');
                billinginterval.set("v.value", '');
                return;
            }
                if(prodbillinginterval == 'Week' && (billingintervalvalue == 'Hour' || billingintervalvalue == 'Day')){
                    /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Billing Interval cannot be less than a week',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Billing Interval cannot be less than a week');
                billinginterval.set("v.value", '');
                return;
            }
                if(prodbillinginterval == 'Month' && (billingintervalvalue == 'Hour' || billingintervalvalue == 'Day' || billingintervalvalue == 'Week')){
                    /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Billing Interval cannot be less than a Month',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Billing Interval cannot be less than a Month');
                billinginterval.set("v.value", '');
                return;
            }
                if(prodbillinginterval == 'Quarterly' && (billingintervalvalue == 'Hour' || billingintervalvalue == 'Day' || billingintervalvalue == 'Week' || billingintervalvalue == 'Month')){
                    /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Billing Interval cannot be less than a Quarter',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Billing Interval cannot be less than a Quarter');
                billinginterval.set("v.value", '');
                return;
            }
                if(prodbillinginterval == 'Annual' && (billingintervalvalue == 'Hour' || billingintervalvalue == 'Day' || billingintervalvalue == 'Week' || billingintervalvalue == 'Month' || billingintervalvalue == 'Quarterly')){
                    /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Billing Interval cannot be less than a Annual',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Billing Interval cannot be less than a Annual');
                billinginterval.set("v.value", '');
                return;
            }
            }
        
        if(discount != '' && discount != undefined && discount != null){
            discvalue = discount;
        }
        else{
            discvalue = 0;
        }
        
     /*   if(discount < 0){
            alert('Discount Should not negative value');
            cmp.set('v.discountamount',null);
              cmp.set('v.rentalnetamount',null);
          
        }*/
        
        
        if(startdate != '' && startdate != undefined && startdate != null){
            if( new Date(startdate) < new Date(now)){
                /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Past dates cannot be choosen',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Past dates cannot be choosen');
                cmp.set('v.startdate','');
                return;
            }
        }
        
        if(duedate != '' && duedate != undefined && duedate != null){
            if(new Date(duedate)<= new Date(startdate)){
                /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Due date should be greater than Start date',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Due date should be greater than Start date');
                cmp.set('v.duedate','');
                return;
            }
        }
        
        if(returndate != '' && returndate != undefined && returndate != null){
            if( new Date(returndate) <= new Date(startdate)){
                /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Return date cannot be less than start date',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Return date cannot be less than start date');
                cmp.set('v.returndate', '');
            }
            else if(new Date(returndate) <= new Date(duedate)){
                /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Return date cannot be less than Due date',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Return date cannot be less than Due date');
                cmp.set('v.returndate', '');
            }
        }
        
        if(deliverdate != '' && deliverdate != undefined && deliverdate != null){
            if(new Date(deliverdate)< new Date(startdate)){
                /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'message' : 'Delivery date should be greater than Start date',
                    'type' : 'info'
                }); 
                showToast.fire();*/
                alert('Delivery date should be greater than Start date');
                cmp.set('v.deliverdate','');
                return;
            }
        }        
        var total;
		var actualtotal;
        if(startdate != '' && startdate != undefined && startdate != null && duedate != '' && duedate != undefined && duedate != null && returndate != '' && returndate != undefined && returndate != null && productQantity != '' && productQantity != undefined && productQantity != null)
        {
            if(prodbillinginterval == 'Hour'){
                var one_day=1000*60*60*24;
                var days = Math.ceil(((Date.parse(returndate)-Date.parse(startdate))/(one_day)));
                 actualtotal = (days * amountperinterval * productQantity * 24);
				if(discvalue != null && discvalue != '' && discvalue != undefined){
                var discountamount = (actualtotal/100)*discvalue;
                 total = actualtotal-discountamount;
				 cmp.set('v.rentalnetamount', total);
				}
				else{
                cmp.set('v.rentalnetamount', actualtotal);
				}
            }
            
            if(prodbillinginterval == 'Day'){
                var one_day=1000*60*60*24;
                var days = Math.ceil(((Date.parse(returndate)-Date.parse(startdate))/(one_day)));
                actualtotal = (days * amountperinterval * productQantity);
				if(discvalue != null && discvalue != '' && discvalue != undefined){
                var discountamount = (actualtotal/100)*discvalue;
                total = actualtotal-discountamount;
				 cmp.set('v.rentalnetamount', total);
				}else{
                cmp.set('v.rentalnetamount', actualtotal);
				}
            }
            var total;
            if(prodbillinginterval == 'Week'){
                var one_day=1000*60*60*24;
                var days = Math.ceil(((Date.parse(returndate)-Date.parse(startdate))/(one_day)));
                 actualtotal = ((days/7) * amountperinterval * productQantity);
				 if(discvalue != null && discvalue != '' && discvalue != undefined){
                 var discountamount = (actualtotal/100)*discvalue;
                 total = actualtotal-discountamount;
				 cmp.set('v.rentalnetamount', actualtotal);
				 }
				 else{
                cmp.set('v.rentalnetamount', total);
				 }
            }
            if(prodbillinginterval == 'Month'){
                var one_day=1000*60*60*24;
                var days = Math.ceil(((Date.parse(returndate)-Date.parse(startdate))/(one_day)));
                 actualtotal = ((days/30) * amountperinterval * productQantity);
				 if(discvalue != null && discvalue != '' && discvalue != undefined){
                var discountamount = (actualtotal/100)*discvalue;
                 total = actualtotal-discountamount;
				  cmp.set('v.rentalnetamount', total);
				 }else{
                 cmp.set('v.rentalnetamount', actualtotal);
				 }
            }
            if(prodbillinginterval == 'Quarterly'){
                var one_day=1000*60*60*24;
                var days = Math.ceil(((Date.parse(returndate)-Date.parse(startdate))/(one_day)));
                 actualtotal = ((days/91.2501) * amountperinterval * productQantity);
				 if(discvalue != null && discvalue != '' && discvalue != undefined){
                var discountamount = (actualtotal/100)*discvalue;
                total = actualtotal-discountamount;
				 cmp.set('v.rentalnetamount', total);
				 }else{
                cmp.set('v.rentalnetamount', actualtotal);
				 }
            }
            if(prodbillinginterval == 'Annual'){
                var one_day=1000*60*60*24;
                var days = Math.ceil(((Date.parse(returndate)-Date.parse(startdate))/(one_day)));
               actualtotal = ((days/365) * amountperinterval * productQantity);
			   if(discvalue != null && discvalue != '' && discvalue != undefined){
                var discountamount = (actualtotal/100)*discvalue;
                total = actualtotal-discountamount;
				cmp.set('v.rentalnetamount', total);
			   }else{
                cmp.set('v.rentalnetamount', actualtotal);
			   }
            }
        }
        
        if( discount < 0){
            alert('Discount Should not be Negative');
            cmp.set('v.discountamount',null);
              cmp.set('v.rentalnetamount',actualtotal);
          
        }
		if( discount > 100){
            alert('Discount Should be in 0 and 100');
            cmp.set('v.discountamount',null);
              cmp.set('v.rentalnetamount',actualtotal);
          
        }
		
    },
    
    addToCart : function(cmp, event, helper)
    {	
        var productQantity = cmp.get('v.productQuantity');
        var delivarydate= cmp.get('v.deliverydate');
        var amountperinterval = cmp.get('v.prductObj.sigmaerpdev__Billing_Charge__c');
        var rentalstatus = cmp.find("InputRentalStatus");
        var rentalstatusvalue =  rentalstatus.get("v.value");
        //var billinginterval = cmp.find("InputBillingInterval");
        //var billingintervalvalue =  billinginterval.get("v.value");
        var startdate = cmp.get('v.startdate');
        var duedate = cmp.get('v.duedate');
        var returndate = cmp.get('v.returndate');
        
        if(productQantity == NaN || productQantity == undefined || productQantity == null || productQantity == ''){
            alert('Please Enter Qunatity');
            return null;
        }
        
        if(productQantity == undefined || startdate == undefined || duedate == undefined || returndate == undefined){
            /*var showToast = $A.get("e.force:showToast"); 
                showToast.setParams({ 
                    'title' : 'Error!', 
                    'message' : 'Please Enter all the required fields',
                    'type' : 'warning'
                }); 
                showToast.fire();*/
            alert('Please Enter all the required fields');
        }
        else{
            helper.setproductList(cmp, event,helper);
        }
    },
    
    cancelProduct : function(cmp, event, helper)
    {                 
        var showProductPage = cmp.getEvent("backToProductList");                   
        showProductPage.fire();
        var rentalstatus = cmp.find("InputRentalStatus");
        var billinginterval = cmp.find("InputBillingInterval");
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