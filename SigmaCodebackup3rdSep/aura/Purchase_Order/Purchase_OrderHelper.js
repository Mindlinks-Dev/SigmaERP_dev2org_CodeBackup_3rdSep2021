({
    helpergetcompanyrelatedtaxtreatment:function (component, event, helper) {
       // alert('in helper')
        var compid=component.get("v.Pur_Order.sigmaerpdev2__Company__c");
        var taxtreatmentid=component.get("v.Pur_Order.sigmaerpdev2__Tax_Treatment__c");
        var action = component.get("c.fetchcompanyrelatedtaxtreatment");
        var taxtreatmentname=component.get('v.Pur_Order.TaxTreatmentName');
        action.setParams({
            "compid": compid,
            "taxtreatmentid":taxtreatmentid
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                 // alert('returnData'+JSON.stringify(returnData))
                    	var arr=[];
                  		for (var i = 0; i < returnData.length; i++) {
                           arr.push(returnData[i].Id);
                        }
                    for (var i = 0; i < arr.length; i++) {
                        if (arr[i] !== taxtreatmentid) {
                          //alert('inside if')
                           component.set("v.Pur_Order.sigmaerpdev2__Tax_Treatment__c",'');
                             component.set("v.Pur_Order.TaxTreatmentName",'');
                           
                        }
                        else{
                           
                          // alert('inside else')
                            component.set("v.Pur_Order.sigmaerpdev2__Tax_Treatment__c",taxtreatmentid);
                            component.set("v.Pur_Order.TaxTreatmentName",taxtreatmentname);
                           return; 
                        }
                        
                    }
                        
                        }
            }
                });
        $A.enqueueAction(action);
    },
     helperGetTaxData:function (component, event, helper) {
        var accid=component.get("v.Pur_Order.sigmaerpdev2__Product_Supplier__c");
       // alert('inside helper'+accid)
        var action = component.get("c.fetchTaxtreatmentData");
        // alert('inside action')
        action.setParams({
            "accId": accid,
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
           // alert('state'+state)
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                   // alert('130>>>'+JSON.stringify(returnData));
                     if(returnData.acc.sigmaerpdev2__Vendor_Tax_Treatment__c)
                            {
                                component.set("v.Pur_Order.sigmaerpdev2__Tax_Treatment__c",returnData.acc.sigmaerpdev2__Vendor_Tax_Treatment__c	);
                                component.set("v.Pur_Order.TaxTreatmentName",returnData.acc.sigmaerpdev2__Vendor_Tax_Treatment__r.Name);
                            }
                            else
                            {
                                component.set("v.Pur_Order.sigmaerpdev2__Tax_Treatment__c",'');
                                component.set("v.Pur_Order.TaxTreatmentName",'');
                            }
                    
                  
                }
            }
                });
        $A.enqueueAction(action);
    },    
     removeAccData: function (component, event, helper) {
        component.set("v.Pur_Order.sigmaerpdev2__Contact__c",'');
        component.set("v.Pur_Order.ContactName",'');
       
        component.set("v.Pur_Order.sigmaerpdev2__Tax_Treatment__c",'');
        component.set("v.Pur_Order.TaxTreatmentName",'');
        
    },
    
     removeComData: function (component, event, helper) {
        // alert('helper')
                   component.set("v.Pur_Order.sigmaerpdev2__Street__c",'');
                    component.set("v.Pur_Order.sigmaerpdev2__City__c",'');
                    component.set("v.Pur_Order.sigmaerpdev2__State_Province__c",'');
                    component.set("v.Pur_Order.sigmaerpdev2__Zip_Postal_Code__c",'');
                    component.set("v.Pur_Order.sigmaerpdev2__Country__c",'');
                      
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_Street__c",'');
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_City__c",'');
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_State_Province__c",'');
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_Zip_Postal_Code__c",'');
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_Country__c",''); 
       
        
    },
	 helperGetAccountData:function (component, event, helper,accid) {
       // alert('hiii>>');
        var action = component.get("c.fetchAccountData");
        action.setParams({
            "accId": accid
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                //  alert('returnData>>>>'+JSON.stringify(returnData)) 
                    if(returnData){
                         if(returnData.Contacts.length==1){ 
                        component.set("v.Pur_Order.sigmaerpdev2__Contact__c",returnData.Contacts[0].Id);
                        component.set("v.Pur_Order.ContactName",returnData.Contacts[0].Name);
                        } 
            
                    }
                }
                
            }
            else{
                //component.set("v.accRelatedData",'');
            }
        });
        $A.enqueueAction(action);
    }, 
      getTaxDetailsHelper: function (component, event, helper) {
          //alert('inside getTaxDetailsHelper')
        //alert(JSON.stringify(component.get("v.orderLinesData")));
        var action = component.get("c.fetchTaxData");
        action.setParams({
            "headerData": JSON.stringify(component.get("v.Pur_Order")),
            "LinesData": JSON.stringify(component.get("v.orderLinesData")),
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            //alert('37>>>'+state);
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null) {
                    var returnData=a.getReturnValue();
                    
                    //alert(JSON.stringify(JSON.parse(returnData)));
                    var taxDataList=JSON.parse(returnData);
                    var popList=component.get("v.orderLinesData");
                    var totalGross=0;
                    var totalNet=0;
                    var totalTax=0;
                    for(var i=0; i< popList.length; i++)
                    {
                        for(var j=0;j<taxDataList.length;j++)
                        {
                            //alert(i+'-'+j+'-'+taxDataList[j].indx);
                            if(i==taxDataList[j].indx)
                            {
                                taxDataList[j].taxAmount=taxDataList[j].taxAmount.toFixed(2);
                                taxDataList[j].totAmount=taxDataList[j].totAmount.toFixed(2);
                                taxDataList[j].netAmount=taxDataList[j].netAmount.toFixed(2);
                                popList[i].pop.sigmaerpdev2__Tax_Amount__c=taxDataList[j].taxAmount;
                                popList[i].pop.sigmaerpdev2__Total_Amount__c=taxDataList[j].totAmount;
                                totalGross+=parseFloat(taxDataList[j].totAmount);
                                totalNet+=parseFloat(taxDataList[j].netAmount);
                                totalTax+=parseFloat(taxDataList[j].taxAmount);
                                var totalTaxRate=0;
                                for(var k=0;k<taxDataList[j].TaxDataList.length;k++)
                                {
                                    totalTaxRate+=taxDataList[j].TaxDataList[k].taxRate;
                                }
                                popList[i].pop.sigmaerpdev2__Tax_Rate__c=totalTaxRate;
                            }
                        }
                    }
                    component.set("v.orderLinesData",popList);
                    component.set("v.totalGross",totalGross.toFixed(2));
                    component.set("v.totalNet",totalNet.toFixed(2));
                    component.set("v.totalTax",totalTax.toFixed(2));
                    component.set('v.taxDataList',taxDataList);
                }
                
            }
            else{
                console.log(JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
    },
      helpergetConfigurationValues:function (component, event, helper,accid) {
         
         var action = component.get("c.fetchConfigurationValues");
        
        action.setParams({
            "CompanyName": component.get('v.Pur_Order.CompanyName')
           
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState();
           
            if (state === "SUCCESS") {
                if (a.getReturnValue() != null)
                {
                    var returnData=a.getReturnValue();
                   
                    component.set('v.configData',returnData);
                    
                    component.set('v.Pur_Order.sigmaerpdev2__Company__c',returnData.company.Id);
                    component.set('v.Pur_Order.CompanyName',returnData.company.Name);
                   
                    var recId = component.get("v.recordId");
                   if(recId == null && recId == undefined){
                   
                    component.set("v.Pur_Order.sigmaerpdev2__Street__c",returnData.company.sigmaerpdev2__Street__c);
                    component.set("v.Pur_Order.sigmaerpdev2__City__c",returnData.company.sigmaerpdev2__City__c);
                    component.set("v.Pur_Order.sigmaerpdev2__State_Province__c",returnData.company.sigmaerpdev2__State_Province__c);
                    component.set("v.Pur_Order.sigmaerpdev2__Zip_Postal_Code__c",returnData.company.sigmaerpdev2__Zip_Postal_Code__c);
                    component.set("v.Pur_Order.sigmaerpdev2__Country__c",returnData.company.sigmaerpdev2__Country__c);
                      
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_Street__c",returnData.company.sigmaerpdev2__Shipping_Street__c);
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_City__c",returnData.company.sigmaerpdev2__Shipping_City__c);
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_State_Province__c",returnData.company.sigmaerpdev2__Shipping_State_Province__c);
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_Zip_Postal_Code__c",returnData.company.sigmaerpdev2__Shipping_Zip_Postal_Code__c);
                    component.set("v.Pur_Order.sigmaerpdev2__Shipping_Country__c",returnData.company.sigmaerpdev2__Shipping_Country__c); 
                    
                    //alert(JSON.stringify(component.get('v.Pur_Order')));
                   }
                }
                
            }
            else{
                //alert(JSON.stringify(a.getError()));
                component.set('v.configData',null);
            }
        });
        $A.enqueueAction(action);
    },
})