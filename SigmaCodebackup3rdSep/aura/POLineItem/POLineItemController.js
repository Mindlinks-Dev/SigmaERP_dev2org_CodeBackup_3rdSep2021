({
    editFlow : function(component, event, helper) {
        var siList = event.getParam("po");
        //console.log(JSON.stringify(siList));
        //alert(JSON.stringify(siList));
        component.set("v.rowIndexVar",event.getParam("rowIndex"));
        component.set("v.PurchaseOrderProducts",siList);
        if(component.get("v.isSigmaOrder")==false)
        {
            component.set("v.recordName2",siList.Product_name); 
        }
        else
        {
            component.set("v.recordName2",siList.Product_name);
        }        
        component.set("v.Productid",siList.sigmaerpdev2__Product__c);
        component.set("v.PurchaseOrderProducts.sigmaerpdev2__Discount__c",siList.sigmaerpdev2__Discount__c);       
        component.set("v.PurchaseOrderProducts.sigmaerpdev2__Buying_Price__c",siList.sigmaerpdev2__Buying_Price__c);
        component.set("v.PurchaseOrderProducts.sigmaerpdev2__Expected_Delivery_Date__c",siList.sigmaerpdev2__Expected_Delivery_Date__c);
        component.set("v.PurchaseOrderProducts.sigmaerpdev2__Quantity__c",siList.sigmaerpdev2__Quantity__c);
        
    },
    doInit : function(component, event, helper) 
    {
        var action3 = component.get("c.getPOProductStatus");
        action3.setCallback(this, function(a3)
                            {
                                component.set("v.PurchaseOrderProducts.sigmaerpdev2__Product__c",component.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__c")); 
                                component.find("Product").set("v.searchString",component.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__r.Name"));
                                component.set("v.status", a3.getReturnValue());
                                component.find("statuss").set("v.value", component.get("v.PurchaseOrderProducts.sigmaerpdev2__Status__c")); 
                                component.set("v.PurchaseOrderProducts.sigmaerpdev2__Status__c",component.find("statuss").get("v.value"));
                                component.set("v.PurchaseOrderProducts",component.get("v.PurchaseOrderProducts"));
                            });        
        $A.enqueueAction(action3);
    },
    validateBuyingPrice : function(cmp,event,helper)
    {
        cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Status__c",cmp.find("statuss").get("v.value")); 
        
        var buyingPrice = cmp.find("BuyingPrice").get("v.value");
        var temp = cmp.get("v.PurchaseOrderProducts");
        temp.sigmaerpdev2__Buying_Price__c = buyingPrice;
        cmp.set("v.PurchaseOrderProducts",temp);
        
        
        var tempObjectForPurchaseOrderProducts = cmp.get("v.PurchaseOrderProducts");
        tempObjectForPurchaseOrderProducts.sigmaerpdev2__Status__c = cmp.find("statuss").get("v.value");
              
        if(buyingPrice < 0)
        {
            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Buying_Price__c",'');    
        }
        else
        {
            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Buying_Price__c",cmp.find("BuyingPrice").get("v.value"));
            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Expected_Delivery_Date__c",cmp.find("ExpectedDeliveryDate").get("v.value"));
        }
        
        
    },
    
    // This function call when the end User Select any record from the result list.   
    handleLookupValueselected : function(component, event, helper) {
        //alert('hi2');
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        var Productid = component.get("v.Productid");
        var objectLabel = event.getParam("objectLabel");
        var  poPro=component.get("v.PurchaseOrderProducts");
        var VendorId = event.getParam("VendersObjectId");
        // console.log('Productid>>'+Productid);
        //	console.log('poPro>>'+poPro);
        
        
        component.set("v.PurchaseOrderProducts.sigmaerpdev2__Product__c",Productid); 
        poPro.Product_name=component.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__r.Name");
        
        component.set("v.PurchaseOrderProducts.sigmaerpdev2__Vender_Products__c",VendorId);
        
        // helper.helperMethod(component, event, helper);
    },
    SelectedID : function(cmp, event) 
    {
        //alert('hi1');
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        var  poPro=cmp.get("v.PurchaseOrderProducts");
        var VendorId = event.getParam("VendersObjectId");
        if(context === 'MyVendorProduct')
        {
            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Product__c",objectId); 
            poPro.Product_name=objectLabel;
            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Vender_Products__c",VendorId);
            
        }
        
        
    },
    
    validateQuantity : function (cmp,event)
    {
        var qty = cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Quantity__c");
        var  produid=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__c");
        console.log('produid>>>'+JSON.stringify(cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__c")));
        if(produid != undefined && produid!='')
        { 
            
            if(qty !== null)
            {
                // qty = qty.toFixed();
                if(qty < 1)
                {
                    var msg = "Quantity should be greater than 0 or Positive ";
                    cmp.set("v.errorMsg", msg);
                    cmp.set("v.isError",true);
                    return;
                    
                }else if((qty % 1) != 0){
                    var msg = "Decimal Values are not allowed,Please Enter a valid Quantity";
                    cmp.set("v.errorMsg", msg);
                    cmp.set("v.isError",true);
                    return;
                    
                }
                    else
                    {
                        cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Quantity__c",qty);    
                    }   
            }
            
            var  productid=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__c"); 
            var VendorID = cmp.get("v.Vendorid");
            
            if(productid != undefined && qty !=null)
            {
                var action = cmp.get("c.getbuyingprice");
                action.setParams
                ({ 
                    "productid": productid,
                    "VendorID" : VendorID
                    
                    
                });
                action.setCallback(this, function(a) {
                    var response= a.getReturnValue();
                    console.log(JSON.stringify(response.sigmaerpdev2__Product_Name__r.Name));
                    if(response != null){
                        var quantity=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Quantity__c");
                        var  prodid=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__c");
                        var  discount=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Discount__c");
                        if(discount == null){
                            var totalqty=quantity*response.sigmaerpdev2__Buying_Price__c;
                            cmp.set("v.PurchaseOrderProducts.Product_name",response.sigmaerpdev2__Product_Name__r.Name);
                            console.log(JSON.stringify(cmp.get('v.PurchaseOrderProducts.Product_name')));
                            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Buying_Price__c",totalqty);
                            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__VendorPrice__c",response.sigmaerpdev2__Buying_Price__c);
                        }
                        else{
                            var totalqty=(response.sigmaerpdev2__Buying_Price__c-(response.sigmaerpdev2__Buying_Price__c*(discount/100)))*quantity;
                            var totalqty1=quantity*response.sigmaerpdev2__Buying_Price__c;
                            cmp.set("v.PurchaseOrderProducts.Product_name",response.sigmaerpdev2__Product_Name__r.Name);
                            console.log(JSON.stringify(cmp.get('v.PurchaseOrderProducts.Product_name')));
                            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Buying_Price__c",totalqty);
                            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Total_Buying_Price__c",totalqty1);
                            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__VendorPrice__c",response.sigmaerpdev2__Buying_Price__c);
                        }
                    }
                    
                    
                });
                $A.enqueueAction(action); 
            }
        }
        else 
        {
            
            cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Quantity__c",'');
            
            var msg = "please enter the product, to caluculate the Buying price. ";
            cmp.set("v.errorMsg", msg);
            cmp.set("v.isError",true);
            return;
            
        }
        
    },
    discount:function(cmp,event,helper)
    {
        //alert('call');
        var qty = cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Quantity__c");
        //var  produid=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__c");
        
        var  productid=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__c"); 
        var VendorID = cmp.get("v.Vendorid");
        
        if(productid != undefined && qty !=null)
        {
            var action = cmp.get("c.getbuyingprice");
            action.setParams
            ({ 
                "productid": productid,
                "VendorID" : VendorID
                
                
            });
            action.setCallback(this, function(a) {
                var response= a.getReturnValue();
                
                if(response != null){
                    var quantity=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Quantity__c");
                    var  prodid=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__c");
                    var  discount=cmp.get("v.PurchaseOrderProducts.sigmaerpdev2__Discount__c");
                    if(quantity != null && discount >0 && discount!=null){
                        var totalqty= (response.sigmaerpdev2__Buying_Price__c-(response.sigmaerpdev2__Buying_Price__c*(discount/100)))*quantity;
                        var totalqty1=quantity*response.sigmaerpdev2__Buying_Price__c;
                        cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Buying_Price__c",totalqty);
                        cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Total_Buying_Price__c",totalqty1);
                        cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__VendorPrice__c",response.sigmaerpdev2__Buying_Price__c);
                        
                    }
                    else{
                        var totalqty=quantity*response.sigmaerpdev2__Buying_Price__c;
                        cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Buying_Price__c",totalqty);
                        cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                        cmp.set("v.PurchaseOrderProducts.sigmaerpdev2__VendorPrice__c",response.sigmaerpdev2__Buying_Price__c);
                    }
                }
                
                
            });
            $A.enqueueAction(action); 
        }
        
    },
    submit : function(component, event, helper) {
        var Popupval = component.get("v.PurchaseOrderProducts");
        //var namep = component.get("v.productName");
        //alert(JSON.stringify(component.get("v.PurchaseOrderProducts.sigmaerpdev2__Product__r.Name")));
        component.set("v.PurchaseOrderProduct",Popupval);
        var StkPrdList =  component.get("v.PurchaseOrderProduct");
        if(Popupval.sigmaerpdev2__Product__c =="" || Popupval.sigmaerpdev2__Product__c==undefined)
        {
            var msg = "Please select a product";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(Popupval.sigmaerpdev2__Quantity__c =="" || Popupval.sigmaerpdev2__Quantity__c==undefined ) 
        {
            var msg = "Please Enter a Valid quantity";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } 
        if(Popupval.sigmaerpdev2__Quantity__c<1) 
        {
            var msg = "Quantity should be greater than 0 or Positive";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        //added by sandhya, validation for restricting decimals
        if((Popupval.sigmaerpdev2__Quantity__c % 1) != 0){
            var msg = "Please give valid Quantity";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        // ends here
        if(Popupval.sigmaerpdev2__Expected_Delivery_Date__c == '' ) 
        {
            var msg = "Please select Expected Delivery Date";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(Popupval.sigmaerpdev2__Discount__c <0) 
        {
            var msg = "Please give valid Discount";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        if(Popupval.sigmaerpdev2__Discount__c > 100) 
        {
            var msg = "Discount should not greater than 100";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        var compEvent = component.getEvent("carrypoList");
        compEvent.setParams({"poList" : StkPrdList,"isEdit":true,"rowIndex":component.get("v.rowIndexVar")});
        compEvent.fire();
        
        component.set("v.isOpenchild", false);
        component.set("v.isOpenTablechild", true)
        //helper.helperMethod(component, event, helper);
        
        
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpenchild", false);       
    },
    handlePOIdValueChange:function(component, event, helper) {
        var newValue = event.getParam("value");
        var action = component.get("c.getbuyingprice");        
        action.setParams
        ({ 
            "productid": newValue,
            "VendorID" : component.get("v.Vendorid")               
        });
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + JSON.stringify(response.sigmaerpdev2__Product_Name__r.Name));
                var response = response.getReturnValue();
                component.set("v.PurchaseOrderProducts.Product_name",response.sigmaerpdev2__Product_Name__r.Name);
                //component.set("v.PurchaseOrderProducts.Product_name",response.sigmaerpdev2__Product_Name__r.Name);
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            
        });
        $A.enqueueAction(action); 
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
               
        
    }
    
})