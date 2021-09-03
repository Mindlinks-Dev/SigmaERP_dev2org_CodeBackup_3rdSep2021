({
    
    doInit: function (component, event, helper) {
      // alert('sigmaorder'+JSON.stringify(component.get("v.sigmaOrderLines")));
      // alert('totalpay'+component.get('v.sigmaOrder.sigmaerpdev2__Total_Payable_Amount__c')); 
       // alert('recordid'+component.get("v.recordId"));
       if(!component.get("v.sigmaOrderLines.sigmaerpdev2__Delivary_Date__c")){
            component.set("v.sigmaOrderLines.sigmaerpdev2__Delivary_Date__c", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
           
        }
        if(!component.get("v.sigmaOrderLines.sigmaerpdev2__Order_Status__c")){
            component.set("v.sigmaOrderLines.sigmaerpdev2__Order_Status__c", component.get("v.sigmaOrder.sigmaerpdev2__Orders_Status__c"));
        }
        //code added by rashmi
         if(component.get('v.sigmaOrderLines.sigmaerpdev2__Product__c')){
                helper.getProductDataEdit(component, event, helper, component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c"));
            }
       // alert('checkbo::'+component.get('v.isbackorder')); 
    },
    handleAccountIdUpdate : function(cmp, event, helper) {
        var productID = event.getParam("sObjectId");
        //alert('productID'+productID);
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        if(instanceId === "MyProduct")
            
        {
            cmp.set('v.sigmaOrderLines.sigmaerpdev2__Product__c', productID);
            
            if(cmp.get('v.sigmaOrderLines.sigmaerpdev2__Product__c')){
              // alert('callinghelper');
                helper.getProductDataEdit(cmp, event, helper, cmp.get("v.sigmaOrderLines.sigmaerpdev2__Product__c"));
            }
        }
    },
    selectMalually: function (component, event, helper) {
        
        if(component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c")==undefined || component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c")==='')
        {
            alert('Product Not Selected');
            return;
        }
        if(component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")==undefined || component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")==='' || component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")<1)
        {
            alert('Enter a Valid Quantity');
            return;
        } 
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},//"AttributeType":component.get("v.productPrices")[0].stapp__Attribute_Type__c},
            "flag" : "manualSelectILPLI"
        });
        SigmaComponentEvent.fire();
       
    },
    autoPickInventory: function (component, event, helper) {
        
        if(component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c")==undefined || component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c")==='')
        {
            alert('Product Not Selected');
            return;
        }
        if(component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")==undefined || component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")==='' || component.get("v.orderLines.sigmaerpdev2__Net_Quantity__c")<1)
        {
            alert('Enter a Valid Quantity');
            return;
        } 
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "autoPickILPLI"
        });
        SigmaComponentEvent.fire();
        
    },
    
    Warrantydetails: function (component, event, helper) {
        
        if(component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c")==undefined || component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c")==='')
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
        if( component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c") % 1 != 0)
        {
            alert('Decimal values are not allowed,Enter a valid quantity');
            component.set("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c",component.get("v.sigmaOrderLines.sigmaerpdev2__Quantity__c"))
        } 
       else
        {
           component.set("v.sigmaOrderLines.sigmaerpdev2__Quantity__c", parseInt(component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")));
        
      		//  alert('Total'+component.get("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c"));
       		 if (component.get("v.sigmaOrderLines.sigmaerpdev2__Quantity__c") > component.get("v.availableQuantity") && component.get("v.StockItem") ) 
       		 {
           		 helper.handleBackOrder(component, event, helper);
       		 }
      		  else
        	{
                //alert(component.get("v.sigmaOrderLines.sigmaerpdev2__Discounts__c"));
				if(component.get("v.sigmaOrderLines.sigmaerpdev2__Discounts__c") == undefined)
				{
					component.set("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c", ((component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")) * (component.get("v.sigmaOrderLines.sigmaerpdev2__Total_Amount__c"))));
                
				}
				else
				{
					var totalprice=((component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")) * (component.get("v.sigmaOrderLines.sigmaerpdev2__Total_Amount__c")));   
				    component.set("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c",(totalprice-(totalprice*(component.get("v.sigmaOrderLines.sigmaerpdev2__Discounts__c")/100))));
     
				}
            	
			} 
        }
    },
    updateTotalPrice:function (component, event, helper){
      /*  if(!component.get("v.sigmaOrderLines.sigmaerpdev2__Discounts__c"))
        {
            component.set("v.sigmaOrderLines.sigmaerpdev2__Discounts__c",0);
        } */
        if(component.get("v.sigmaOrderLines.sigmaerpdev2__Discounts__c")<0)
        {
            alert('Discount must be greater than zero');
            component.set('v.sigmaOrderLines.sigmaerpdev2__Discounts__c',null);
            
        }
         if(component.get("v.sigmaOrderLines.sigmaerpdev2__Discounts__c") >component.get("v.maxdiscount")){
            alert('Discount Should not greater than or Equal to MaxDiscount of Product,MaxDiscount:'+component.get("v.maxdiscount"));
              component.set('v.sigmaOrderLines.sigmaerpdev2__Discounts__c',null);
         //   cmp.set('v.productAmount',total1);
           // return;
        }
        else
        {
        // component.set("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c",parseInt((component.get("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c"))-((component.get("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c"))*(component.get("v.sigmaOrderLines.sigmaerpdev2__Discounts__c")/100))));
        var totalprice=((component.get("v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c")) * (component.get("v.sigmaOrderLines.sigmaerpdev2__Total_Amount__c")));   
        component.set("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c",(totalprice-(totalprice*(component.get("v.sigmaOrderLines.sigmaerpdev2__Discounts__c")/100))));
      //  alert('final Amount'+component.get("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c"));
        }
    },
    removeOrderLines: function (component, event, helper) {
        if (confirm('Are you sure you want to delete the line item?')) {
    // Save it!
      var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data": {
                "index": component.get('v.indexNum')
            },
            "flag": "removeOrderLine"
        });
        SigmaComponentEvent.fire();
		} else {
           return;
		}
       
    },
    handleProductIdValueChange: function (component, event, helper) {
       console.log('Chalukya');
        var ol=component.get('v.sigmaOrderLines');
        //alert('ol>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+ol);
        if(ol){
            // alert('innn');
            if(!component.get('v.productName')){
               // alert('remove');
                // component.set('v.sigmaOrderLines.sigmaerpdev2__Product__c','')
                component.set('v.sigmaOrderLines.sigmaerpdev2__Net_Quantity__c',0);
                component.set('v.sigmaOrderLines.sigmaerpdev2__Quantity__c',0);
                component.set('v.availableQuantity',0);
                component.set('v.sigmaOrderLines.sigmaerpdev2__Total_Amount__c',0);
                component.set('v.sigmaOrderLines.sigmaerpdev2__Discounts__c',0);
                component.set('v.sigmaOrderLines.sigmaerpdev2__Total_Price__c',0);
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
        
        if ((component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c"))) {
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
     /*   var prodId = component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c")
        
        var action = component.get("c.getproductimage");
        action.setParams({
            "prodId": prodId,
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState();
               alert('state::'+state);
            if (state == "SUCCESS") {
                 var productimage=JSON.stringify(a.getReturnValue());
                component.set('v.ProductView',true);
                component.set('v.productimageexist',true);
                component.set('v.ProductImageData',productimage);
                alert('imagedata'+JSON.stringify(component.get('v.ProductImageData')));
               }
            
         });
          $A.enqueueAction(action);*/
    }
    
    
})