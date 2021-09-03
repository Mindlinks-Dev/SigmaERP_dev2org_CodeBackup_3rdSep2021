({
     netTotalAmountCalculator: function (component, event, helper) {
        // alert('hello')
        var pop=component.get('v.vpline.pop');
        //alert('pop>>>'+JSON.stringify(pop))
      //  var unitprice=pop.sigmaerpdev2__Unit_Price__c?pop.sigmaerpdev2__Unit_Price__c:0;
          var unitprice=pop.sigmaerpdev2__Buying_Price__c?pop.sigmaerpdev2__Buying_Price__c:0;
        var discount;
          discount=pop.sigmaerpdev2__Discount__c?unitprice*(pop.sigmaerpdev2__Discount__c/100):0;
        // discount=pop.sigmaerpdev2__Discount__c?pop.sigmaerpdev2__Discount__c:0;
        var quantity=pop.sigmaerpdev2__Quantity__c?pop.sigmaerpdev2__Quantity__c:0;
        var taxAmount=pop.sigmaerpdev2__Tax_Amount__c?parseInt(pop.sigmaerpdev2__Tax_Amount__c):0;
        var netAmount=(unitprice-discount)* quantity;
       // var netAmount=(unitprice* quantity)-discount;
        var totalAmount=netAmount+taxAmount;
          
        pop.sigmaerpdev2__Net_Amount__c=netAmount;
        pop.sigmaerpdev2__Total_Amount__c=totalAmount;
       // alert('21'+JSON.stringify(pop));
           //alert('231'+JSON.stringify(component.get('v.vpline.pop')));
        component.set('v.vpline.pop',pop);
       //alert('23'+JSON.stringify(component.get('v.vpline.pop')));
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "flag": "TaxFlag"
        });
        SigmaComponentEvent.fire();
    },
    
     
      remProddata: function (component, event, helper) {
        component.set("v.vpline.pop.sigmaerpdev2__Description__c",'');
        component.set("v.vpline.pop.sigmaerpdev2__Buying_Price__c",0);
        component.set("v.vpline.pop.sigmaerpdev2__Unit_Price__c",0);
        component.set("v.vpline.pop.sigmaerpdev2__Tax_Amount__c",0);
        component.set("v.vpline.pop.sigmaerpdev2__Net_Amount__c",0);
        component.set("v.vpline.pop.sigmaerpdev2__Total_Amount__c",0);
        component.set("v.vpline.pop.sigmaerpdev2__Discount__c",0);
          component.set("v.vpline.pop.sigmaerpdev2__Tax_Code__c",'');
    },
     getProductRelatedData: function (component, event, helper,triggeringPoint) {
        var action = component.get("c.getProdRelData");
        action.setParams({
            "prodId": component.get('v.vpline.pop.sigmaerpdev2__Product__c'),
            
            
            "taxTreatmentId":component.get('v.Pur_Order.sigmaerpdev2__Tax_Treatment__c'),
           
            "Customerid":component.get('v.Pur_Order.sigmaerpdev2__Product_Supplier__c')
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
           // alert('49>>>>'+state)
            if (state === "SUCCESS")
            {
                var prodDataWrap=a.getReturnValue();
                var returnedResp;
                
               
               
           
               
                    returnedResp=prodDataWrap.prodData;
                    if( triggeringPoint=='LookUpChange' )
                    {
                       // alert('here')
                      // component.set('v.vpline.pop.sigmaerpdev2__Buying_Price__c',returnedResp.sigmaerpdev2__Buying_Price__c);
                        if(returnedResp.sigmaerpdev2__Tax_Code__c)
                        {
                            
                            if(prodDataWrap.taxRateList && prodDataWrap.taxRateList.length>0)
                            {
                               
                                component.set('v.vpline.pop.sigmaerpdev2__Tax_Code__c',returnedResp.sigmaerpdev2__Tax_Code__c);
                                component.set('v.vpline.TaxCodeName',returnedResp.sigmaerpdev2__Tax_Code__r.Name);
                            }
                            else
                            {
                                alert('The Product defaulted Tax Code "'+returnedResp.sigmaerpdev2__Tax_Code__r.Name+'" dont have Tax Rate to "'+component.get('v.Pur_Order.TaxTreatmentName')+'" Tax Treatment.');
                                component.set('v.vpline.pop.sigmaerpdev2__Tax_Code__c','');
                                component.set('v.vpline.TaxCodeName','');
                            }
                        }
                        else
                        {
                            component.set('v.vpline.pop.sigmaerpdev2__Tax_Code__c','');
                            component.set('v.vpline.TaxCodeName','');
                        }
                    }
                    console.log('returnedResp>>'+JSON.stringify(returnedResp));
                
                 //alert('returnedResp>>'+JSON.stringify(returnedResp));
                
              
                
                this.netTotalAmountCalculator(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
    },
      getProductRelatedDatabp: function (component, event, helper,triggeringPoint) {
        var action = component.get("c.getVProdRelData");
        action.setParams({
            "prodId": component.get('v.vpline.pop.sigmaerpdev2__Product__c'),
            
            "vendorlocationid": component.get('v.Pur_Order.sigmaerpdev2__Vendor_Location__c'),
            "contactid": component.get('v.Pur_Order.sigmaerpdev2__Contact__c'),
            "taxTreatmentId":component.get('v.Pur_Order.sigmaerpdev2__Tax_Treatment__c'),
           
            "Customerid":component.get('v.Pur_Order.sigmaerpdev2__Product_Supplier__c')
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
           // alert('contactid>>>>'+component.get('v.Pur_Order.sigmaerpdev2__Contact__c'))
            //alert('vendorlocationid>>>>'+component.get('v.Pur_Order.sigmaerpdev2__Vendor_Location__c'))
        //  alert('49>>>>'+state)
            if (state === "SUCCESS")
            {
                var prodDataWrap=a.getReturnValue();
                var returnedResp;
                //flow for vendor product price check box enabled starts
               
               
                //normal price book flow starts
               
                    returnedResp=prodDataWrap.vprodData;
                // alert('returnedResp>>'+JSON.stringify(prodDataWrap));
                if(returnedResp){
                    if( triggeringPoint=='LookUpChange' )
                    {
                      // alert('here'+returnedResp.sigmaerpdev2__Buying_Price__c)
                        component.set('v.vpline.pop.sigmaerpdev2__Buying_Price__c',returnedResp.sigmaerpdev2__Buying_Price__c);
                      
                 //alert('returnedResp>>'+JSON.stringify(returnedResp));
                
              
                    }
                }
                 else{
                    alert('Buying Price is NOT configured')
                }
                this.netTotalAmountCalculator(component, event, helper);
               
            }
            
        });
        $A.enqueueAction(action);
    },
	})