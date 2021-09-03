({
    // function call on component Load
    doInit: function(component, event, helper) {
       var tempPOId = component.get("v.Id");
       if(tempPOId === 'undefined' || tempPOId === null || tempPOId === '' || tempPOId === undefined )
        {
          //  alert('tempPOId>>'+JSON.stringify(tempPOId));
            var popover3 = component.find("TempToDisplayStatus");
            $A.util.removeClass(popover3,'slds-hide');
            helper.loadPOStatus(component,event);
        }
        else
        {
           // alert('tempPOId>>'+JSON.stringify(tempPOId));
            var popover4 = component.find("TempToDisplayStatus");
            $A.util.removeClass(popover4,'slds-hide');
          //  helper.loadPurchaseOrderDetails(component,event,tempPurchaseOrderId);   
        }
    },
  	selectVendorModel:function(component, event, helper){
        var productid = component.get("v.POInstance.sigmaerpdev2__Product__c");
        console.log('productid'+productid);
        component.set("v.ProductId",productid);
        if(productid == '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Select Product!',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            component.set("v.isModalOpen", false);
            console.log(component.get("v.isModalOpen"));
        }
        else
        {
            component.set("v.isModalOpen", true);
            console.log(component.get("v.isModalOpen"));  
        }
        
    },
    handleComponentEvent : function(component, event, helper) {
        
        var valueFromChild = event.getParam("VendorId");
        var vendorNameFromChild = event.getParam("VendorName");
        var vendorLocationNameFromChild = event.getParam("VendorLocation");
        var buyingPrice =event.getParam("BuyingPrice");
        var vendoremail =event.getParam("VendorEmail");
        var vendorLocationId =event.getParam("VendorLocationID");
       // alert('vendorNameFromChild'+vendorNameFromChild);
        
        
        component.set("v.POInstance.sigmaerpdev2__Price__c", buyingPrice);
        
        component.set("v.SelectedVendorId", valueFromChild);
        console.log(component.get("v.SelectedVendorId")); 
        
        component.set("v.SelectedVendorName", vendorNameFromChild);
        console.log('vendorNameFromChild>>>'+component.get("v.SelectedVendorName"));
        
        component.set("v.SelectedVendorLocation", vendorLocationNameFromChild);
        console.log('SelectedVendorLocation>>>>'+component.get("v.SelectedVendorLocation"));
        
        component.set("v.SelectedBuyingPrice", buyingPrice);
        console.log(component.get("v.SelectedBuyingPrice"));
        
        component.set("v.vendorEmail", vendoremail);
        console.log(component.get("v.vendorEmail"));
        
        component.set("v.SelectedVendorLocationId", vendorLocationId);
        console.log('SelectedVendorLocationId>>>'+component.get("v.SelectedVendorLocationId"));
    },
    
     validateQuantity : function (component,event)
    {
        //alert('Qty>>'+component.get("v.POInstance.sigmaerpdev2__Quantity__c"));
        var qty = component.get("v.POInstance.sigmaerpdev2__Quantity__c");
        var  produid=component.get("v.POInstance.sigmaerpdev2__Product__c");
        console.log('produid>>>'+JSON.stringify(component.get("v.POInstance.sigmaerpdev2__Product__c")));
        if(produid != undefined && produid != '' || produid != null)
        { 
            
            if(qty == null || qty < 1 || (qty % 1) != 0 )
            {
                // qty = qty.toFixed();
              /*  if(qty < 1)
                {
                    alert('qty>'+qty);
                    var msg = "Quantity should be greater than 0 or Positive ";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    
                }else if((qty % 1) != 0){
                    var msg = "Decimal Values are not allowed,Please Enter a valid Quantity";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                    
                }
                    else
                    {
                        component.set("v.POInstance.sigmaerpdev2__Quantity__c",qty);    
                    }  */
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Please Enter a valid Quantity!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            else {
                component.set("v.POInstance.sigmaerpdev2__Quantity__c",qty);    
            } 
            var  productid=component.get("v.POInstance.sigmaerpdev2__Product__c"); 
            var vendorID = component.get("v.SelectedVendorId");
            console.log('vendorID>>'+vendorID);
            var locName = component.get("v.SelectedVendorLocation");
          // alert('locName>>'+locName);
            if(productid != undefined && qty !=null)
            {
                var quantity=component.get("v.POInstance.sigmaerpdev2__Quantity__c");
                var  discount=component.get("v.POInstance.sigmaerpdev2__Discount__c");
                var buyingPrice =component.get("v.SelectedBuyingPrice");
               // alert('quantity>>'+ quantity+ '  *    ' +'buyingPrice'+buyingPrice);
               // alert('totalqty>'+ quantity * buyingPrice);
                // alert('discount>'+ discount);
                if(discount == null || discount == ''){
                    
                    var totalqty=quantity*buyingPrice;
                    //alert(totalqty);
                   // console.log('totalqty>>'+totalqty);
                   // component.set("v.POInstance.Product_name",POInstance.sigmaerpdev2__Product_Name__r.Name);
                   // console.log(JSON.stringify(component.get('v.POInstance.Product_name')));
                    component.set("v.POInstance.sigmaerpdev2__Buying_Price__c",totalqty);
                   // component.set("v.POInstance.sigmaerpdev2__Price__c",buyingPrice);
                   // alert('Buying_Price>>'+JSON.stringify(component.get('v.POInstance.sigmaerpdev2__Buying_Price__c')));
                    component.set("v.POInstance.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                    component.set("v.POInstance.sigmaerpdev2__VendorPrice__c",buyingPrice);
                }
                else{
                  //  alert('quantity>>'+quantity);
                  //  alert('prodid>>'+prodid);
                  //  alert('discount>>'+discount);
                    var totalqty=(buyingPrice-(buyingPrice*(discount/100)))*quantity;
                   // alert('totalqty'+totalqty);
                    var totalqty1=quantity*buyingPrice;
                   // alert('totalqty1'+totalqty1);
                    // component.set("v.POInstance.Product_name",response.sigmaerpdev2__Product_Name__r.Name);
                   // console.log(JSON.stringify(component.get('v.POInstance.Product_name')));
                    component.set("v.POInstance.sigmaerpdev2__Buying_Price__c",totalqty);
                   // component.set("v.POInstance.sigmaerpdev2__Price__c",buyingPrice);
                    component.set("v.POInstance.sigmaerpdev2__Total_Buying_Price__c",totalqty1);
                    component.set("v.POInstance.sigmaerpdev2__VendorPrice__c",buyingPrice);
                }
				
            }
        }
        else 
        {
            
            component.set("v.POInstance.sigmaerpdev2__Quantity__c",'');
            
            var msg = "please enter the product, to caluculate the Buying price. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
            
        }
        
    },
     validateBuyingPrice : function(component,event,helper)
    {
        component.set("v.POInstance.sigmaerpdev2__Status__c","Open"); 
        console.log('POP status1'+component.get("v.POInstance.sigmaerpdev2__Status__c"));
        var buyingPrice = component.find("NetBuyingPrice").get("v.value");
        var temp = component.get("v.POInstance");
        temp.sigmaerpdev2__Buying_Price__c = buyingPrice;
        component.set("v.POInstance",temp);
         console.log('POP buying price'+component.get("v.POInstance.sigmaerpdev2__Buying_Price__c"));
        
        var tempPOP = component.get("v.POInstance");
        tempPOP.sigmaerpdev2__Status__c = "Open";
         console.log('POP status2'+tempPOP.sigmaerpdev2__Status__c);      
        if(buyingPrice < 0)
        {
            component.set("v.POInstance.sigmaerpdev2__Buying_Price__c",'');    
           // component.set("v.POInstance.sigmaerpdev2__Price__c",'');
        }
        else
        {
            component.set("v.POInstance.sigmaerpdev2__Buying_Price__c",component.find("NetBuyingPrice").get("v.value"));
            component.set("v.POInstance.sigmaerpdev2__Expected_Delivery_Date__c",component.find("ExpectedDeliveryDate").get("v.value"));
        //	component.set("v.POInstance.sigmaerpdev2__Price__c",component.find("BuyingPrice").get("v.value"));
        }
     },
    discount:function(component,event,helper)
    {
        
        var  productid=component.get("v.POInstance.sigmaerpdev2__Product__c"); 
        var quantity = component.get("v.POInstance.sigmaerpdev2__Quantity__c");
        console.log('productid'+ productid + ' qty'+  quantity);
        var  discount=component.get("v.POInstance.sigmaerpdev2__Discount__c");
        var buyingPrice =component.get("v.SelectedBuyingPrice");
                
        if(productid != undefined && quantity !=null)
        {
           // alert('quantity>>'+ quantity+ '  *    ' +'buyingPrice'+buyingPrice);
           // alert('totalqty>'+ quantity * buyingPrice);
           // alert('discount>'+ discount);
            if(discount == null || discount == ''){
                
                var totalqty=quantity*buyingPrice;
                //alert(totalqty);
                // console.log('totalqty>>'+totalqty);
                // component.set("v.POInstance.Product_name",POInstance.sigmaerpdev2__Product_Name__r.Name);
                // console.log(JSON.stringify(component.get('v.POInstance.Product_name')));
                component.set("v.POInstance.sigmaerpdev2__Buying_Price__c",totalqty);
               // alert('Buying_Price>>'+JSON.stringify(component.get('v.POInstance.sigmaerpdev2__Buying_Price__c')));
                component.set("v.POInstance.sigmaerpdev2__Total_Buying_Price__c",totalqty);
                component.set("v.POInstance.sigmaerpdev2__VendorPrice__c",buyingPrice);
              //  component.set("v.POInstance.sigmaerpdev2__Price__c",buyingPrice);
            }
            else{
                var totalqty=(buyingPrice-(buyingPrice*(discount/100)))*quantity;
               // alert('totalqty--------->'+totalqty);
                var totalqty1=quantity*buyingPrice;
               // alert('totalqty1---------->'+totalqty1);
                // component.set("v.POInstance.Product_name",response.sigmaerpdev2__Product_Name__r.Name);
                // console.log(JSON.stringify(component.get('v.POInstance.Product_name')));
                component.set("v.POInstance.sigmaerpdev2__Buying_Price__c",totalqty);
                component.set("v.POInstance.sigmaerpdev2__Total_Buying_Price__c",totalqty1);
                component.set("v.POInstance.sigmaerpdev2__VendorPrice__c",buyingPrice);
              //  component.set("v.POInstance.sigmaerpdev2__Price__c",buyingPrice);
            }
          
        }
        
    },
  
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        //alert('SelectedVendorName>>'+component.get("v.SelectedVendorName")); 
        //alert('SelectedVendorLocation>>'+component.get("v.SelectedVendorLocation")); 
        var vendorName =component.get("v.SelectedVendorName");
        if(vendorName == ''  || vendorName == null || vendorName == 'undefined')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please select vendor name!',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            component.set("v.isModalOpen", true);
        }
        else
        {
            component.set("v.isModalOpen", false); 
        }
        
    },
    closeVendorModel: function(component, event, helper) {
        
        component.set("v.isModalOpen", false);
    },
    removeRow : function(component, event, helper){
        // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    
})