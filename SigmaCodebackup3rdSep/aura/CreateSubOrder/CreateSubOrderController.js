({
    myAction : function(component, event, helper) {
        var sid = component.get("v.recordId");
      	if(sid!=null && sid!=' ')
        {
           
        var action = component.get("c.subscriptionrecord");
        action.setParams
        ({ 
            "Ids": sid            
        });
        action.setCallback( this, function(a){            
            var state = a.getState();
            if (state === "SUCCESS")
            {
                var spinner=component.find('spinner');
        		$A.util.toggleClass(spinner, 'slds-hide');
                var sigmaOrder = a.getReturnValue(); 
               // alert(sigmaOrder.sigmaerpdev2__Usage_Type__c);
             if(sigmaOrder.sigmaerpdev2__Usage_Type__c!='Product')
                    {
                        var msg = "Can't create order for service Product.";
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;
                    }
                    else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    }
                    if(sigmaOrder.sigmaerpdev2__Account_Subscription__r.sigmaerpdev2__Status__c!='Active')
                    {
                        var msg = "Your Account Subscription is not Active.";
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;
                    }
                    else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    }
                 if(sigmaOrder.sigmaerpdev2__Order_Status__c=='Pending' || sigmaOrder.sigmaerpdev2__Order_Status__c=='Order Confirmed' || sigmaOrder.sigmaerpdev2__Order_Status__c=='Cancelled')
					{
						var msg = "Order is alredy created for this Interval.";
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;
					}
					 else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    }
                if(sigmaOrder.sigmaerpdev2__Usage_Type__c=='Product')
                {
                component.set("v.contactName",sigmaOrder.sigmaerpdev2__Customer__r.Name);
                component.set('v.customerID',sigmaOrder.sigmaerpdev2__Customer__c);
				component.set("v.custType",sigmaOrder.sigmaerpdev2__Customer__r.sigmaerpdev2__Customer_Type__c);
                component.set("v.Amount",sigmaOrder.sigmaerpdev2__next_Billing_Amount__c);
                component.set("v.quant",sigmaOrder.sigmaerpdev2__Quantity__c);
                component.set("v.productname",sigmaOrder.sigmaerpdev2__Product_Name__r.Name);
                component.set("v.productid",sigmaOrder.sigmaerpdev2__Product_Name__c);
                    
              
                var productid = component.get("v.productid");
                var productname = component.get("v.productname");
              
                var productQuantity = component.get("v.quant");
                var productAmount = component.get("v.Amount");
               
                var customerName = component.get("v.storeName");
                
                var ProductObj = {
                    Id : productid,
                    Name : productname,	
                    productAmount : productAmount,
                    quantity : productQuantity,	
                    totalAmount : productAmount
                };
                
                //alert("ProductObj"+ProductObj)
                component.set("v.productsTotalAmount",productAmount);
                var productsAmount = component.get("v.productsTotalAmount");
                var allProductsAmount = parseFloat(productsAmount);
                productAmount = parseFloat(productAmount);
                
                var products = component.get("v.prod");
                
                if(products.length !==0 )
                {            
                    allProductsAmount = allProductsAmount + productAmount;
                    products.push(ProductObj);
                    component.set("v.prod", products); 	

                }
                else
                {            
                   
                    allProductsAmount = parseFloat(productAmount);
                    component.set("v.prod", ProductObj); 
                 
                }
                allProductsAmount = parseFloat(allProductsAmount).toFixed(2); 
                component.set('v.productsTotalAmount', allProductsAmount); 

              }
             
            }
        });
		$A.enqueueAction(action);
       
        } 
    },
	  submit : function(component, event, helper) {
		var billingPerson=component.get("v.billingPerson");
		var custType=component.get("v.custType");
		var delivarydate=component.get("v.delivarydate");
        var productList = component.get("v.prod");
         
        component.set("v.recordId1" , undefined);
        var accLookupId = component.get("v.recordId1");
        //  alert('accLookupId'+accLookupId);
        var subid=component.get("v.recordId");
        var custID = component.get("v.customerID");
        var StoreName = component.get("v.storeName");
       	var allProductsAmount = component.get("v.productsTotalAmount");
        
        var jsonString = [];
        for(var i = 0 ; i < productList.length; i++)
        {
             var jsonString1  =  JSON.stringify(Object.create(null, { Name: { value: productList[i].Name , enumerable: true }, Id:{ value: productList[i].Id, enumerable: true },productAmount: { value: productList[i].productAmount, enumerable: true }, quantity: { value: productList[i].quantity, enumerable: true }, totalAmount: { value: productList[i].totalAmount, enumerable: true } }) );
            jsonString.push(jsonString1);
            
        }
        
        var orderID = component.get("v.recordId1");
        if(custID==='' || custID===null){
            custID = accLookupId; 
            
        }
          component.set("v.spinner", true);
          
         /*var spinner=component.find('spinner');
         $A.util.toggleClass(spinner, 'slds-hide');*/
        var action1 = component.get('c.orderSave');         
        action1.setParams({
            "productList" : jsonString,
            "OrderIDD" : orderID,
            "accId": custID,
            "storeName": StoreName,
            "subid": subid,
            "allPdtsAmount" :allProductsAmount,
            "billingPerson" : billingPerson,
            "custType" : custType,
            "orderdelivarydate": delivarydate
            
        });
        
        // Define the callback
        action1.setCallback(this, function(response) 
        {
            var state = response.getState();
            var responseOrderId = response.getReturnValue();
          //  alert('responseOrderId>>'+responseOrderId);
            if (component.isValid() && state === "SUCCESS" && responseOrderId!=null)
            {
                component.set("v.spinner", true);
                alert('Order Created Successfully.');
                window.location.href = "/" + response.getReturnValue();
                if (responseOrderId.length === 0)
                {
                    return;
                }
                
            }
            else{
                component.set("v.spinner", true);
                alert('Order can not be created with insufficient stock in product inventory.');
                history.back();
            }
      });
	 $A.enqueueAction(action1);
        
	},
     cancelButton : function(component, event, helper)
    {
    	history.back();
	}
    
})