({
    doInit: function (component, event, helper) {
    	// alert('defaultValues'+JSON.stringify(component.get("v.defualtInventorystatus")));
		// alert('defaultValues.........'+JSON.stringify(component.get("v.defaultValues")));
        // alert('date'+JSON.stringify(component.get("v.StandardOrderLines")));
        if(!component.get("v.StandardOrderLines.sigmaerpdev2__Delivery_Date__c")){
            component.set("v.StandardOrderLines.sigmaerpdev2__Delivery_Date__c", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
        }
        if(!component.get("v.StandardOrderLines.sigmaerpdev2__Order_Status__c")){
            component.set("v.StandardOrderLines.sigmaerpdev2__Order_Status__c", component.get("v.standOrder.sigmaerpdev2__Orders_Status__c"));
        }
        if(component.get('v.StandardOrderLines.Product2Id')){
                helper.getProductDataEdit(component, event, helper, component.get("v.StandardOrderLines.Product2Id"));
            }
        
    },
    
    handleAccountIdUpdate : function(cmp, event, helper) {
     //   alert('Event2 handled in OL');
        var productID = event.getParam("sObjectId");
      //  alert('productID'+productID);
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        if(instanceId === "MyProduct")
            
        {
          //  alert(productID);
            cmp.set('v.StandardOrderLines.Product2Id', productID);
            
            if(cmp.get('v.StandardOrderLines.Product2Id')){
                helper.getProductDataEdit(cmp, event, helper, cmp.get("v.StandardOrderLines.Product2Id"));
            }
        }
    },
   
    selectMalually: function (component, event, helper) {
    //    alert('Inside Manual picking'+component.get("v.StandardOrderLines.Product2Id"));
        if(component.get("v.StandardOrderLines.Product2Id")==undefined || component.get("v.StandardOrderLines.Product2Id")==='')
        {
            alert('Product Not Selected');
            return;
        }
        if(component.get("v.StandardOrderLines.Quantity")==undefined || component.get("v.StandardOrderLines.Quantity")==='' || component.get("v.orderLines.Quantity")<1)
        {
            alert('Enter a Valid Quantity');
            return;
        } 
       // alert('Event1111');
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},//"AttributeType":component.get("v.productPrices")[0].stapp__Attribute_Type__c},
            "flag" : "manualSelectILPLI"
        });
        SigmaComponentEvent.fire();
    },
    
    autoPickInventory: function (component, event, helper) {
	//	alert('Inside auto picking'+component.get("v.StandardOrderLines.Product2Id"));	       
        if(component.get("v.StandardOrderLines.Product2Id")==undefined || component.get("v.StandardOrderLines.Product2Id")==='')
        {
            alert('Product Not Selected');
            return;
        }
        if(component.get("v.StandardOrderLines.Quantity")==undefined || component.get("v.StandardOrderLines.Quantity")==='' || component.get("v.StandardOrderLines.Quantity")<1)
        {
            alert('Enter a Valid Quantity');
            return;
        } 
       // alert('Event1111');
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "autoPickILPLI"
        });
        SigmaComponentEvent.fire();
    },
     Warrantydetails: function (component, event, helper) {
        
        if(component.get("v.StandardOrderLines.Product2Id")==undefined || component.get("v.StandardOrderLines.Product2Id")==='')
        {
            alert('Product Not Selected');
            return;
        }
        
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "productwarranty"
        });
        SigmaComponentEvent.fire();
        
    },
	
    updateOrderQuantity: function (component, event, helper) {
        
        if(component.get("v.StandardOrderLines.Quantity") % 1 != 0)
        {
            alert('Decimal values are not allowed,Enter a valid quantity');
            component.set("v.StandardOrderLines.Quantity",component.get("v.StandardOrderLines.sigmaerpdev2__Net_Quantity__c"))
       
        }
        else
        {
            component.set("v.StandardOrderLines.sigmaerpdev2__Net_Quantity__c", parseInt(component.get("v.StandardOrderLines.Quantity")));
        	if (component.get("v.StandardOrderLines.sigmaerpdev2__Net_Quantity__c") > component.get("v.availableQuantity") && component.get("v.StockItem")) 
        	{
           	 	helper.handleBackOrder(component, event, helper);
        	}
       	 else
        	{
                //alert(component.get("v.StandardOrderLines.sigmaerpdev2__Discounts__c"));
                if(component.get("v.StandardOrderLines.sigmaerpdev2__Discount__c") == undefined)
                {
             		component.set("v.StandardOrderLines.sigmaerpdev2__TotalPrice__c", ((component.get("v.StandardOrderLines.Quantity")) * (component.get("v.StandardOrderLines.sigmaerpdev2__Unit_Price__c"))));
        	    }
                else
                {
                     var totalprice=((component.get("v.StandardOrderLines.Quantity")) * (component.get("v.StandardOrderLines.sigmaerpdev2__Unit_Price__c")));   
          			 component.set("v.StandardOrderLines.sigmaerpdev2__TotalPrice__c",(totalprice-(totalprice*(component.get("v.StandardOrderLines.sigmaerpdev2__Discount__c")/100))));
         		 }
			}
        }
        
        
    },
   
    updateTotalPrice:function (component, event, helper){
		
       // alert('Inside Update total price');
     /*   if(!component.get("v.StandardOrderLines.sigmaerpdev2__Discount__c"))
        {
            component.set("v.StandardOrderLines.sigmaerpdev2__Discount__c",0);
        }*/
		 if(component.get("v.StandardOrderLines.sigmaerpdev2__Discount__c")<0)
        {
            alert('Discount must be greater than zero');
            component.set('v.StandardOrderLines.sigmaerpdev2__Discount__c',null);
            
        }
         if(component.get("v.StandardOrderLines.sigmaerpdev2__Discount__c") >component.get("v.maxdiscount")){
            alert('Discount Should not greater than MaxDiscount of Product,MaxDiscount:'+component.get("v.maxdiscount"));
              component.set('v.StandardOrderLines.sigmaerpdev2__Discount__c',null);
         //   cmp.set('v.productAmount',total1);
           // return;
        }
        else
        {
        // component.set("v.StandardOrderLines.sigmaerpdev2__TotalPrice__c",parseInt((component.get("v.StandardOrderLines.TotalPrice"))-((component.get("v.StandardOrderLines.TotalPrice"))*(component.get("v.StandardOrderLines.sigmaerpdev2__Discount__c")/100))));
        var totalprice=((component.get("v.StandardOrderLines.Quantity")) * (component.get("v.StandardOrderLines.sigmaerpdev2__Unit_Price__c")));   
          //  alert('totalprice>>'+totalprice);
            component.set("v.StandardOrderLines.sigmaerpdev2__TotalPrice__c",(totalprice-(totalprice*(component.get("v.StandardOrderLines.sigmaerpdev2__Discount__c")/100))));
          //  alert('final Amount'+component.get("v.StandardOrderLines.sigmaerpdev2__TotalPrice__c"));
        }
    },
	
    removeOrderLines: function (component, event, helper) {
		//  alert('Inside remove OL');
		if (confirm('Are you sure you want to delete the line item?'))
        {
            var StandComponentEvent = component.getEvent("SigmaComponentEvent");
        	StandComponentEvent.setParams({
            "data": {
                "index": component.get('v.indexNum')
            },
            "flag": "removeOrderLine"
        });
        StandComponentEvent.fire();
        }
        else {
           return;
		}
        
    },
   
    handleProductIdValueChange: function (component, event, helper) {
         
      //  alert('Inside hnadler');
        var ol=component.get('v.StandardOrderLines');
        if(ol){
        //     alert('innn');
            if(!component.get('v.productName')){
         //       alert('remove');
                // component.set('v.StandardOrderLines.Product2Id','')
                component.set('v.StandardOrderLines.sigmaerpdev2__Net_Quantity__c',0);
                component.set('v.StandardOrderLines.Quantity',0);
                component.set('v.availableQuantity',0);
                component.set('v.StandardOrderLines.sigmaerpdev2__Unit_Price__c',0);
                component.set('v.StandardOrderLines.sigmaerpdev2__Discount__c',0);
                component.set('v.StandardOrderLines.sigmaerpdev2__TotalPrice__c',0);
				component.set('v.allocatedAs','');
                //allocatedAs
                
                var idListStr=component.get('v.idListStr');
                if(idListStr)
                    idListStr = idListStr.replace(event.getParam("oldValue"), "");
                component.set('v.idListStr',idListStr)
            }
        }
        //else{
        //}
    },
     splitOrderLines: function (component, event, helper) {
        
        if ((component.get("v.StandardOrderLines.Product2Id"))) {
            var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
            SigmaComponentEvent.setParams({
                "data": {
                    "index": component.get('v.indexNum'),
                    "availQty":component.get('v.availableQuantity')
                },
                "flag": "splitOrderLine"
            });
            SigmaComponentEvent.fire();
        } else {
            alert('Product is missing');
        }
    },
     getproductimagedata :function (component, event, helper) {
        
       // alert('view product');
         var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data": {
                "index": component.get('v.indexNum')
            },
            "flag": "Viewproductimage"
        });
        SigmaComponentEvent.fire();
     }
    
})