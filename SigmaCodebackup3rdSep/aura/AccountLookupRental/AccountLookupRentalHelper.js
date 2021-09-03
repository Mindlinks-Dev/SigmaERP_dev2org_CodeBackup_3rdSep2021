({
    loadSavedOrders : function(cmp,event,isOrderID)
    {
        cmp.set("v.orderSFId", isOrderID);       	
        var action = cmp.get('c.fetchSavedOrders');
        action.setParams
        ({
            "orderSFId" : isOrderID
        });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (cmp.isValid() && state === "SUCCESS")
                               {
                                   var savedOrderDetails = response.getReturnValue();
                                   if(savedOrderDetails.sigmaerpdev__Orders_Status__c ==='Order Confirmed'){
                                       cmp.set("v.flagForProceedPayment",true);
                                       cmp.set('v.flagForSaveOrderButton',true);
                                   }
                                   cmp.set("v.recordName", savedOrderDetails.sigmaerpdev__AccountId__r.Name);                    
                                   cmp.set("v.recordId", savedOrderDetails.sigmaerpdev__AccountId__c);   
                                   cmp.set("v.storeName", savedOrderDetails.sigmaerpdev__StoreName__c);                       
                               }    
                           });         
        $A.enqueueAction(action);       
        action = cmp.get('c.fetchOrderLines');
        action.setParams
        ({
            "orderSFId" : isOrderID
        });                        
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();          
                               var allProductsAmount = '';            
                               if (cmp.isValid() && state === "SUCCESS")
                               {
                                   var savedOrderLineDetails = response.getReturnValue();
                                  // alert('savedOrderLineDetails::'+savedOrderLineDetails);
                                   for(var i=0;i<savedOrderLineDetails.length;i++)
                                   {                      
                                       var pdId = savedOrderLineDetails[i].sigmaerpdev__Product__r.Id;
                                       var pdName = savedOrderLineDetails[i].sigmaerpdev__Product_Name__c;
                                       var pdAmount = parseFloat(savedOrderLineDetails[i].sigmaerpdev__Total_Amount__c).toFixed(2);
                                       var pdQuantity = savedOrderLineDetails[i].sigmaerpdev__Quantity__c;
                                       var pdPrice = parseFloat(savedOrderLineDetails[i].sigmaerpdev__Total_Price__c).toFixed(2);
                                       var temppdPrice = parseFloat(savedOrderLineDetails[i].sigmaerpdev__Total_Price__c).toFixed(2);
                                       var prodTotalAmount = parseFloat(pdPrice/pdQuantity).toFixed(2);
                                       var singleProdTotalAmount = (prodTotalAmount*pdQuantity).toFixed(2);
                                       var productObj = {
                                           Id : pdId,
                                           Name  : pdName,
                                           productAmount : prodTotalAmount,
                                           quantity  : pdQuantity,                       
                                           totalAmount : singleProdTotalAmount
                                       };              
                                       var products = cmp.get("v.prod");                    
                                       if(products.length !==0 )
                                       {
                                           allProductsAmount = (allProductsAmount + (savedOrderLineDetails[i].sigmaerpdev__Total_Price__c)).toFixed(2);
                                           products.push(productObj);
                                           cmp.set("v.prod", products);
                                       }
                                       else
                                       {
                                           allProductsAmount = '';
                                           allProductsAmount = parseFloat(savedOrderLineDetails[i].sigmaerpdev__Total_Price__c);
                                           cmp.set("v.prod", productObj); 	
                                       }
                                       allProductsAmount = allProductsAmount;
                                       cmp.set('v.productsTotalAmount', allProductsAmount);                   
                                   }
                               }          
                           });       
        cmp.set('v.showOrderLines',true);         
        $A.enqueueAction(action);        	
    },
    
    fetchCurrency : function(cmp,event)
    {   	
        var action = cmp.get('c.getCurrency');       
        action.setCallback(this, function(response) {
            var state = response.getState();         
            if (cmp.isValid() && state === "SUCCESS")
            {              
                var matches = response.getReturnValue();
                if (matches.length === 0)
                {
                    cmp.set('v.currencySymbol', null);
                    return;
                }                
                // Store the results
                cmp.set('v.currencySymbol', matches.sigmaerpdev__Currency__c);              
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {             
                var errors = response.getError();              
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        // this.displayToast('Error', errors[0].message);
                    }
                }
                else
                {
                    // this.displayToast('Error', 'Unknown error.');
                }
            }
        });       
        $A.enqueueAction(action);
    },
    
    ProductObj :function(Id,Name,productAmount,quantity,Discount,totalAmount,date)
    {
        this.Id = Id;	
        this.Name = Name;
        this.productAmount = productAmount;
        this.quantity = quantity ;
        this.Discount = Discount ;
        this.totalAmount = totalAmount ;
        this.date = date ;
    },
    
    fetchProduct : function(cmp, event) 
    {     
        var productId = cmp.get('v.productId');     
        var action = cmp.get('c.fetchProduct');         
        action.setParams({
            "prodId" : productId
        });                         
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();          
            if (cmp.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var products = response.getReturnValue();
                //alert(JSON.stringify(products));
                // If we have no products, return nothing
                if (products.length === 0)
                {
                    cmp.set('v.products', null);
                    return;
                }                
                // Store the results               
                //added by sandhya, for fetching MaxDiscount             
                cmp.set('v.MaxDicount', products.sigmaerpdev__Max_Discount__c);               
                //products.sigmaerpdev__Product_Price__c = products.sigmaerpdev__Product_Price__c.toFixed(2);               
                cmp.set('v.prodObject', products);              
                var main = cmp.find("mainBlocktoggle");
                $A.util.addClass(main, 'toggle');              
                var toggleText = cmp.find("toggleProduct");
                $A.util.addClass(toggleText, 'toggle');              
                var productInfo = cmp.find("showProductToggle");
                $A.util.removeClass(productInfo, 'toggle');             
            }
        });        
        // Enqueue the action                  
        $A.enqueueAction(action);        
    }, 
    fetchInventory :function(cmp, event)
    {
        var productId = cmp.get('v.productId');      
        var action = cmp.get('c.fetchInventory');  
        action.setParams
        ({
            "prodId" : productId
        }); 
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (cmp.isValid() && state === "SUCCESS")
                               {
                                   var inventory = response.getReturnValue();              
                                   cmp.set('v.AvailableInventory', inventory.sigmaerpdev__Available_Qty__c);  
                               }
                           });                        
        $A.enqueueAction(action);        
    }, 
    
    saveOrder : function(cmp, event) 
    {
        var productList = cmp.get("v.prod");
        var accLookupId = cmp.get("v.recordId");
        //alert(accLookupId);
        var custID = cmp.get("v.customerID");       
        var StoreName = cmp.get("v.storeName");
        var billingPerson = cmp.get("v.CreatedBy");  
        var billingPersonID = cmp.get('v.CreatedbyID');
        var paymenttype = cmp.find("paymenttype");
        var paymenttypevalue =  paymenttype.get("v.value");
        var allProductsAmount = cmp.get("v.productsTotalAmount");
        var ProductDiscount = cmp.get("v.productsDiscount");
        var orderdeldate = cmp.get("v.delivarydate");
        var jsonString = [];
        for(var i = 0 ; i < productList.length; i++)
        {
            var jsonString1  =  JSON.stringify(Object.create(null, { Name: { value: productList[i].Name , enumerable: true },
                                                                    Id:{ value: productList[i].Id, enumerable: true },
                                                                    productAmount: { value: productList[i].productAmount, enumerable: true },
                                                                    amountperinterval: { value: productList[i].amountperinterval, enumerable: true },
                                                                    quantity: { value: productList[i].quantity, enumerable: true },
                                                                    Discount: { value: productList[i].Discount, enumerable: true },
                                                                    totalAmount: { value: productList[i].totalAmount, enumerable: true },
                                                                    deliverydate: { value: productList[i].deliverydate, enumerable: true },
                                                                    startdate: { value: productList[i].startdate, enumerable: true },
                                                                    duedate: { value: productList[i].duedate, enumerable: true },
                                                                    returneddate: { value: productList[i].returndate, enumerable: true },
                                                                    rentalstatus: { value: productList[i].rentalstatus, enumerable: true },
                                                                    billinginterval: { value: productList[i].billinginterval, enumerable: true },
                                                                   }) );
        jsonString.push(jsonString1);
        }
        var orderID = cmp.get("v.orderSFId");       
        if(custID==='' || custID===null){          
            custID = accLookupId;             
        }       
        cmp.set("v.subid" , undefined);
        var subid = cmp.get("v.subid");
        cmp.set("v.paymenttype" , paymenttypevalue);
        var action = cmp.get('c.orderSave');
        action.setParams({
            "productList" : jsonString,
            "OrderIDD" : orderID,          
            "accId": custID,
            "subid": subid,
            "storeName": StoreName,
            "allPdtsAmount" :allProductsAmount,            
            "billingPerson": billingPerson,
            "orderdelivarydate": orderdeldate,
            "paymenttype":paymenttypevalue,
        });                         
        // Define the callback
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();          
                               if (cmp.isValid() && state === "SUCCESS")
                               {
                                   var responseOrderId = response.getReturnValue();
                                   
                                   var successAlert = cmp.find("successAlert");
                                   $A.util.removeClass(successAlert,'slds-hide');
                                   cmp.set('v.flagForSaveOrderButton',true);
                                   if (responseOrderId.length === 0)
                                   {   
                                    	return;
                                   } 
               				 		cmp.set('v.orderSFId',responseOrderId); 
                                   //window.location.href = "/" + responseOrderId;
                               }
                               else{              
                                   var successAlert = cmp.find("successAlert");
                                   $A.util.removeClass(successAlert,'slds-hide');
                                   var successAlertTheme = cmp.find("successAlertTheme");
                                   $A.util.removeClass(successAlertTheme,'slds-theme--success');
                                   $A.util.addClass(successAlertTheme,'slds-theme--error');
                                   var iconsuccess=cmp.find("iconsuccess");
                                   $A.util.addClass(iconsuccess,'slds-hide');
                                   var iconwarning=cmp.find("iconwarning");
                                   $A.util.removeClass(iconwarning,'slds-hide');
                                   var recordCreatedHeader = cmp.find("recordCreatedHeader");
                                   $A.util.addClass(recordCreatedHeader,'slds-hide');
                                   var recordNotCreatedHeader = cmp.find("recordNotCreatedHeader");
                                   $A.util.removeClass(recordNotCreatedHeader,'slds-hide');
                                   var recordCreatedOK = cmp.find("recordCreatedOK");
                                   $A.util.addClass(recordCreatedOK,'slds-hide');
                                   var recordCreatedCancel = cmp.find("recordCreatedCancel");
                                   $A.util.removeClass(recordCreatedCancel,'slds-hide');
                               }
                           });       
        // Enqueue the action                  
        $A.enqueueAction(action);
    },
    
    PrepareProductList : function(cmp, event) 
    {
        var productObj = event.getParam("productInfo");
        var productQuantity = event.getParam("productQuantity");
        var productAmount = event.getParam("productAmount");
        var deliverydate = event.getParam("deliverydate");
        var productDiscount = event.getParam("ProductDiscount");
        var startdate = event.getParam("startdate");
        var duedate = event.getParam("duedate");
        var returndate = event.getParam("returndate");
        var rentalstatus = event.getParam("rentalstatus");
        var billinginterval = event.getParam("billinginterval");
        var amountperinterval = event.getParam("amountperinterval");
        var customerName = cmp.get("v.storeName");
        
        productAmount = parseFloat(productAmount).toFixed(2);
        productObj.sigmaerpdev__Product_Price__c = parseFloat(productObj.sigmaerpdev__Product_Price__c).toFixed(2); 
        var ProductObj = {
            Id : productObj.Id,
            Name : productObj.Name,		
            productAmount : productAmount,
            quantity : productQuantity,	
            Discount  : productDiscount,
            totalAmount : productAmount,
            //date : deliverydate,
            startdate : startdate,
            duedate : duedate,
            returndate : returndate,
            rentalstatus : rentalstatus,
            billinginterval : billinginterval,
            amountperinterval : amountperinterval,
            deliverydate : deliverydate
        };
        var productsAmount = cmp.get("v.productsTotalAmount");
        var allProductsAmount = parseFloat(productsAmount);
        productAmount = parseFloat(productAmount);		 
        var ProdDiscount = cmp.get("v.productsDiscount");
        var allProductsDiscount = ProdDiscount;     
        var products = cmp.get("v.prod");
        if(products.length !==0 )
        {            
            allProductsAmount = allProductsAmount + productAmount;
            //allProductsDiscount = allProductsDiscount + Discount;           
            products.push(ProductObj);
            cmp.set("v.prod", products);
        }
        else
        {            
            allProductsAmount = parseFloat(productAmount);
            //allProductsDiscount = Discount;
            cmp.set("v.prod", ProductObj); 	
        } 
        allProductsAmount = parseFloat(allProductsAmount).toFixed(2);       
        cmp.set('v.productsTotalAmount', allProductsAmount);
        cmp.set('v.productsDiscount', allProductsDiscount);		              
        var productInfo = cmp.find("showProductToggle");
        $A.util.addClass(productInfo, 'toggle');     
        var toggleText = cmp.find("toggleProduct");
        $A.util.addClass(toggleText, 'toggle');       
        var main = cmp.find("mainBlocktoggle");
        $A.util.removeClass(main, 'toggle');        
        var tableList = cmp.find("tableListToogle");
        $A.util.removeClass(tableList, 'toggle');      
        cmp.set('v.showOrderLines',true);          
        cmp.set('v.showOrderLines',true);        
    },   
    
    removeOrderLineItem : function(component, index) {
        var orderList = component.get("v.prod");
        var amount = orderList[index].totalAmount;       
        var updatedTotal = component.get("v.productsTotalAmount");
        updatedTotal = (updatedTotal - amount);
        updatedTotal = parseFloat(updatedTotal).toFixed(2);
        component.set("v.productsTotalAmount", updatedTotal);        
        orderList.splice(index, 1);
        component.set("v.prod", orderList);
    }
})