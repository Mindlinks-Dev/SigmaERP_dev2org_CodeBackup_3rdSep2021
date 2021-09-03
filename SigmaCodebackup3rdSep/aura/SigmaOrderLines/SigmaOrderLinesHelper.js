({
	getProductDataEdit: function (component, event, helper, prodId) {
        var customer = component.get("v.sigmaOrder.sigmaerpdev2__AccountId__c");
        var action = component.get("c.getProdRelData");
        action.setParams({
            "prodId": prodId,
            "customerId":customer
        });
	action.setCallback(this, function (a) {
            var state = a.getState();
              // alert('state::'+state);
            if (state == "SUCCESS") {
                if(a.getReturnValue()!=null)
                {
                    
                    var product=a.getReturnValue();	
                     if(product.sigmaerpdev2__Product_Inventory__r != undefined) 
                     component.set("v.availableQuantity",product.sigmaerpdev2__Product_Inventory__r[0].sigmaerpdev2__Available_Qty__c);
                     component.set("v.maxdiscount",product.sigmaerpdev2__Max_Discount__c);
                     component.set("v.StockItem",product.sigmaerpdev2__Stock_Item__c);
					
                    if(product.sigmaerpdev2__Product_Prices__r != undefined) 
                    {
                       component.set('v.sigmaOrderLines.sigmaerpdev2__Discounts__c',product.sigmaerpdev2__Product_Prices__r[0].sigmaerpdev2__Discout__c); 
                    }
                    if(product.PricebookEntries!=undefined)
                    {
                        component.set("v.sigmaOrderLines.sigmaerpdev2__Total_Amount__c",product.PricebookEntries[0].UnitPrice);
                  
                         // alert('si'+product.PricebookEntries[0].size());
                    }
					/*if(product.sigmaerpdev2__Warranty_Applicable__c)
					{
						component.set("v.sigmaOrderLines.sigmaerpdev2__Product_Warranty_Start_Date__c",component.get("v.sigmaOrderLines.sigmaerpdev2__Delivary_Date__c"));
						component.set("v.sigmaOrderLines.sigmaerpdev2__Product_Duration__c",product.sigmaerpdev2__Warranty_Duration__c);
						component.set("v.sigmaOrderLines.sigmaerpdev2__Product_Interval__c",product.sigmaerpdev2__Warranty_Interval__c);
						var days;
						var totaldays;
						if(component.get("v.sigmaOrderLines.sigmaerpdev2__Product_Interval__c") =='Day')
						{
							days = 1;
							totaldays = component.get("v.sigmaOrderLines.sigmaerpdev2__Product_Duration__c") * days;    
						}
						 
						else if(component.get("v.sigmaOrderLines.sigmaerpdev2__Product_Interval__c") == 'Month')
						{
						days = 30;
						totaldays = component.get("v.sigmaOrderLines.sigmaerpdev2__Product_Duration__c") * days;
						}
						else if(component.get("v.sigmaOrderLines.sigmaerpdev2__Product_Interval__c") == 'Year')
						{
						days = 365;
						totaldays = component.get("v.sigmaOrderLines.sigmaerpdev2__Product_Duration__c") * days;
						}
						var enddate = new Date(component.get("v.sigmaOrderLines.sigmaerpdev2__Product_Warranty_Start_Date__c"));
						enddate.setDate(enddate.getDate() + totaldays);
						component.set("v.sigmaOrderLines.sigmaerpdev2__Product_Warranty_End_Date__c" ,enddate.getFullYear()+ "-" +(enddate.getMonth()+1)+ "-" + enddate.getDate());
						
					}*/
                    //alert(JSON.stringify(component.get("v.sigmaOrderLines")));
                    
                }
            }
         });
          $A.enqueueAction(action);
    },
    handleBackOrder: function(component, event, helper,source)
    {
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum'),"avail":component.get("v.availableQuantity"),"source":source},
            "flag" : "backOrderLines"
        });
        SigmaComponentEvent.fire();
    }
})