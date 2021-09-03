({
	getProductDataEdit: function (component, event, helper, prodId) {
       // alert('in edit>');
       var customer = component.get("v.standOrder.AccountId");
       // alert('AccountId'+customer);
        var action = component.get("c.getProdRelData");
        action.setParams({
            "prodId": prodId,
            "customerId":customer,
        });
	action.setCallback(this, function (a) {
            var state = a.getState();
               //alert('state::'+state);
            if (state == "SUCCESS") {
                if(a.getReturnValue()!=null)
                {
                    //alert( "before::"+component.get("v.standOrder.sigmaerpdev2__ShippingPostalCode__c"));
                    var product=a.getReturnValue();	
                   // alert(JSON.stringify(product));
                     if(product.sigmaerpdev2__Product_Inventory__r != undefined) 
                    component.set("v.availableQuantity",product.sigmaerpdev2__Product_Inventory__r[0].sigmaerpdev2__Available_Qty__c);
                     //if(product.PricebookEntries[0].UnitPrice !== 'undefined')
                     if(product.PricebookEntries!=undefined)
                     {
                           component.set("v.StandardOrderLines.sigmaerpdev2__Unit_Price__c",product.PricebookEntries[0].UnitPrice);
                  
                         // alert('si'+product.PricebookEntries[0].size());
                     }
                   
                      component.set("v.maxdiscount",product.sigmaerpdev2__Max_Discount__c);
                    component.set("v.StockItem",product.sigmaerpdev2__Stock_Item__c);
                   // alert(product.sigmaerpdev2__Product_Prices__r);
					if(product.sigmaerpdev2__Product_Prices__r != undefined) 
                    {
                       component.set('v.StandardOrderLines.sigmaerpdev2__Discount__c',product.sigmaerpdev2__Product_Prices__r[0].sigmaerpdev2__Discout__c); 
                    }
					/*if(product.sigmaerpdev2__Warranty_Applicable__c)
					{
						component.set("v.StandardOrderLines.sigmaerpdev2__Product_Warranty_Start_Date__c",component.get("v.StandardOrderLines.sigmaerpdev2__Delivery_Date__c"));
						component.set("v.StandardOrderLines.sigmaerpdev2__Product_Duration__c",product.sigmaerpdev2__Warranty_Duration__c);
						component.set("v.StandardOrderLines.sigmaerpdev2__Product_Interval__c",product.sigmaerpdev2__Warranty_Interval__c);
						var days;
						var totaldays;
						if(component.get("v.StandardOrderLines.sigmaerpdev2__Product_Interval__c") =='Day')
						{
							days = 1;
							totaldays = component.get("v.StandardOrderLines.sigmaerpdev2__Product_Duration__c") * days;    
						}
						 
						else if(component.get("v.StandardOrderLines.sigmaerpdev2__Product_Interval__c") == 'Month')
						{
						days = 30;
						totaldays = component.get("v.StandardOrderLines.sigmaerpdev2__Product_Duration__c") * days;
						}
						else if(component.get("v.StandardOrderLines.sigmaerpdev2__Product_Interval__c") == 'Year')
						{
						days = 365;
						totaldays = component.get("v.StandardOrderLines.sigmaerpdev2__Product_Duration__c") * days;
						}
						var enddate = new Date(component.get("v.StandardOrderLines.sigmaerpdev2__Product_Warranty_Start_Date__c"));
						enddate.setDate(enddate.getDate() + totaldays);
						component.set("v.StandardOrderLines.sigmaerpdev2__Product_Warranty_End_Date__c" ,enddate.getFullYear()+ "-" +(enddate.getMonth()+1)+ "-" + enddate.getDate());
						
					}*/
					//alert(JSON.stringify(component.get("v.StandardOrderLines")));
                }
            }
         });
          $A.enqueueAction(action);
    },
    handleBackOrder: function(component, event, helper,source)
    {
      var StandComponentEvent = component.getEvent("SigmaComponentEvent");
        StandComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum'),"avail":component.get("v.availableQuantity"),"source":source},
            "flag" : "backOrderLines"
        });
        StandComponentEvent.fire();
    }
})