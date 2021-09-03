({
    netTotalAmountCalculator: function (component, event, helper,totalprice) {
        // alert('hello')
       var Totalamt = component.get("v.sigmaOrderLines.sigmaerpdev2__Total_Price__c");
       var Taxamt = component.get("v.sigmaOrderLines.sigmaerpdev2__tax_amount__c");
       // alert('Totalamt>>>>>'+Totalamt)
        //alert('Taxamt>>>>>'+Taxamt)
        var Grossamt=+totalprice + +Taxamt;
      // alert('Grossamt>>>'+Grossamt)
        
        component.set('v.TotalGross',Grossamt);
    },
     getProductRelatedData: function (component, event, helper) {
       //alert('im in helper')
      //   var action = component.get("c.getProdRelDatatopopulatetaxcode");
      //alert(component.get('v.productName'));
      var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
       SigmaComponentEvent.setParams({
                "flag": "taxCalculation"
            });
        SigmaComponentEvent.fire();
       var action = component.get("c.getProdRelDatanew");
        
        action.setParams({
            "prodId": component.get('v.sigmaOrderLines.sigmaerpdev2__Product__c'),
            
            
            "taxTreatmentId":component.get('v.sigmaOrder.sigmaerpdev2__Tax_Treatment__c')
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
          // alert('49>>>>'+state)
            if (state === "SUCCESS")
            {
                // alert('here')
                var prodDataWrap=a.getReturnValue();
                 //alert('1'+JSON.stringify(prodDataWrap));
               
                 var returnedResp=prodDataWrap.prodData;
                 // var  returnedResp=a.getReturnValue().prodData;
                // alert('2'+JSON.stringify(returnedResp));
                   /* if( triggeringPoint=='LookUpChange' )
                    {*/
                        
                      
                        if(returnedResp.sigmaerpdev2__Tax_Code__c)
                        {
                            
                            if(prodDataWrap.taxRateList && prodDataWrap.taxRateList.length>0)
                            {
                               
                                component.set('v.sigmaOrderLines.sigmaerpdev2__Tax_Code__c',returnedResp.sigmaerpdev2__Tax_Code__c);
                               component.set('v.TaxCodeName',returnedResp.sigmaerpdev2__Tax_Code__r.Name);
                              // component.set('v.sigmaOrderLines.sigmaerpdev2__Tax_Code__r.Name',returnedResp.sigmaerpdev2__Tax_Code__r.Name);
                            }
                            
                            else
                            {
                                alert('The Product defaulted Tax Code "'+returnedResp.sigmaerpdev2__Tax_Code__r.Name+'" dont have Tax Rate to "'+component.get('v.sigmaOrder.TaxTreatmentName')+'" Tax Treatment.');
                                component.set('v.sigmaOrderLines.sigmaerpdev2__Tax_Code__c','');
                                component.set('v.TaxCodeName','');
                              // component.set('v.sigmaOrderLines.sigmaerpdev2__Tax_Code__r.Name','');
                            }
                        }
                        else
                        {
                            component.set('v.sigmaOrderLines.sigmaerpdev2__Tax_Code__c','');
                           component.set('v.TaxCodeName','');
                            // component.set('v.sigmaOrderLines.sigmaerpdev2__Tax_Code__r.Name','');
                        }
                   // }
                    console.log('returnedResp>>'+JSON.stringify(returnedResp));
                
                 //alert('returnedResp>>'+JSON.stringify(returnedResp));
                 
              
                
               // this.netTotalAmountCalculator(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
    },
    getProductRelatedData1: function (component, event, helper) {
       // alert('im in helper')
      //   var action = component.get("c.getProdRelDatatopopulatetaxcode");
      var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
       SigmaComponentEvent.setParams({
                "flag": "taxCalculation"
            });
        SigmaComponentEvent.fire();
       var action = component.get("c.getTaxCode");
        
        action.setParams({
            "prodId": component.get('v.sigmaOrderLines.sigmaerpdev2__Product__c'),
            
            
            "taxTreatmentId":component.get('v.sigmaOrder.sigmaerpdev2__Tax_Treatment__c'),
           
            "Customerid":component.get('v.sigmaOrder.sigmaerpdev2__AccountId__c')
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
           //alert('49>>>>'+state)
            if (state === "SUCCESS")
            {
                // alert('here')
                var prodDataWrap=a.getReturnValue();
                // alert('1'+JSON.stringify(prodDataWrap));
               
                 //var returnedResp=prodDataWrap.prodData;
                 // var  returnedResp=a.getReturnValue().prodData;
                // alert('2'+JSON.stringify(returnedResp));
                   /* if( triggeringPoint=='LookUpChange' )
                    {*/
                        
                                component.set('v.sigmaOrderLines.sigmaerpdev2__Tax_Code__c',prodDataWrap.sigmaerpdev2__Tax_Code__c);
                               component.set('v.TaxCodeName',returnedResp.sigmaerpdev2__Tax_Code__r.Name);
                               //component.set('v.sigmaOrderLines.sigmaerpdev2__Tax_Code__r.Name',returnedResp.sigmaerpdev2__Tax_Code__r.Name);
                            
                   // }
                    console.log('returnedResp>>'+JSON.stringify(returnedResp));
            }
            
        });
        $A.enqueueAction(action);
    },
    populatetaxcode:function (component, event, helper,triggeringPoint) {
       
        var prodId = component.get("v.sigmaOrderLines.sigmaerpdev2__Product__c");
        var customer = component.get("v.sigmaOrder.sigmaerpdev2__AccountId__c");
     // alert('inside helper'+prodId)
       // alert('inside helper'+customer)
        
         var action = component.get("c.gettaxcode");
        action.setParams({
            "prodId": prodId,
            "customerId":customer
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
              //alert('state::'+state);
            var returndata=a.getReturnValue();
            if (state == "SUCCESS") {
                if(a.getReturnValue()!=null)
                {
                 //alert('inside if'+JSON.stringify(returndata));
                    if(prodId != null || prodId != undefined || prodId !=' ') {
                       // alert('if')
                    component.set("v.sigmaOrderLines.sigmaerpdev2__Tax_Code__c",returndata.pro.sigmaerpdev2__Tax_Code__c);
                 component.set("v.TaxCodeName",returndata.pro.sigmaerpdev2__Tax_Code__r.Name);
                // component.set("v.sigmaOrderLines.sigmaerpdev2__Tax_Code__r.Name",returndata.pro.sigmaerpdev2__Tax_Code__r.Name);
                    }
                    else{
                        // alert('else')
                component.set("v.sigmaOrderLines.sigmaerpdev2__Tax_Code__c",' ');
                component.set("v.TaxCodeName",' ');
                // component.set("v.sigmaOrderLines.sigmaerpdev2__Tax_Code__r.Name",' ');
                    }
                    }
            }         
       
              });
          $A.enqueueAction(action);
        
    },
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
            
           // "data" : {"index":component.get('v.indexNum'),"avail":component.get("v.availableQuantity"),"source":source},
            "data" : {"index":component.get('v.indexNum'),"avail":component.get("v.sigmaOrderLines.sigmaerpdev2__Quantity__c"),"source":source},
            "flag" : "backOrderLines"
        });
        SigmaComponentEvent.fire();
    }
})