({
        doInit : function(component, event, helper) {
            var action1 = component.get("c.SelectPackages");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            //   alert('Is standard order'+state);
            if (state === "SUCCESS") 
            {       
                    console.log('response isSigmaOrder>>>'+response.getReturnValue());
                component.set('v.isSigmaOrder',response.getReturnValue()); 
 		
            }
             
        });
        $A.enqueueAction(action1);  
       // alert('cuctomerId>>'+component.get('v.Id'));
        var action = component.get("c.getStockInProductStatus");
        var StockInProductList = component.get("v.ShipmentProduct");
        component.set("v.ShipmentProduct.sigmaerpdev2__Status__c",'');
        action.setCallback(this, function(a) {
            
            component.set("v.status", a.getReturnValue());
            //component.set("v.ShipmentProduct",component.get("v.ShipmentProducts"));
            
            var selectedPKID=component.get("v.ShipmentProduct").sigmaerpdev2__Package_ID__c;
            if(selectedPKID!=undefined)
            component.set("v.selectedPackageId",selectedPKID);
              if(component.get('v.Id')!=undefined && JSON.stringify(component.get('v.Id'))!='""')
            component.set("v.isOpenPackage",false);
            
            
            
        });
        $A.enqueueAction(action); 
        
    },
	 SelectedID:function(component,event,helper)
    {
        var cuctomerId1= component.get('v.cuctomerId1');
          //   alert('cuctomerId1>>'+JSON.stringify(component.get('v.cuctomerId1')));
        var  context = event.getParam("instanceId");
        var  objectId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        var  shipPro=component.get("v.ShipmentProduct");
       //  alert('cuctomerId1>>'+JSON.stringify(context));
        if(context === 'MyPackage'  )
        {
          //  alert('cuctomerId1>>'+JSON.stringify(objectId));
           // if(sigmaerpdev2__Package_ID__c!=undefined)
           // 
           console.log('JSON.stringify(objectId)>>>'+JSON.stringify(objectId)); 
          if( JSON.stringify(objectId)!='""')
          {
                var action5 = component.get("c.FindDuplicatePackage");
            //alert(packageId);
            action5.setParams
            ({ 
                "packageId": objectId,
            });
            action5.setCallback(this, function(b) {
               // alert(Custname);
                
                       
                var response= b.getReturnValue();
                console.log("response"+response);
                if(response==='Found' )
                {
                    
                   var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            //title : 'Alert',
                            message: 'Package is involved in shipment',
                            messageTemplate: 'Record {0} created! See it {1}!',
                            duration:' 5000',
                            //key: 'info_alt',
                            type: 'warning',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                       
                    return;
                }
                else
                {
                    shipPro.sigmaerpdev2__Package_ID__c= objectId; 
                    
                    
                    
                    //  if(objectLabel!=undefined)
                    // shipPro.Pkg__Name=objectLabel;
                    
                    var  packageId=objectId;
                    var action = component.get("c.getPackageCustomerName");
                    //alert(packageId);
                    action.setParams
                    ({ 
                        "packageId": packageId,
                    });
                    action.setCallback(this, function(a) {
                        // alert(Custname);
                        var response= a.getReturnValue();
                        component.set("v.Custname",response.sigmaerpdev2__Customer__r.Name);
                        if(JSON.stringify(component.get('v.cuctomerId1'))==='null')
                            component.set("v.cuctomerId1",response.sigmaerpdev2__Customer__c);
                        component.set("v.ShipmentProduct.sigmaerpdev2__Customer_Name__c",response.sigmaerpdev2__Customer__c);
                        component.set("v.ShipmentProduct.Cust__Name",response.sigmaerpdev2__Customer__r.Name);
                        component.set("v.ShipmentProduct.Pkg__Name",response.Name);
                        
                        console.log('cuctomerId>> after..'+JSON.stringify(component.get('v.cuctomerId')));
                        component.set("v.selectedPackageId",response.Id);            
                        // shipPro.sigmaerpdev2__Customer_Name__c=response.sigmaerpdev2__Customer__c;
                        // shipPro.Cust__Name=response.sigmaerpdev2__Customer__r.Name;
                        var StappComponentEvent = component.getEvent("StappComponentEvent");
                        StappComponentEvent.setParams({
                            "data": {
                                
                                "conName" : response.sigmaerpdev2__Customer__r.Name,
                                "customer": response.sigmaerpdev2__Customer__c,
                            },
                            "flag": "accountContact"
                        });
                        StappComponentEvent.fire();
                    });
                    $A.enqueueAction(action); 
                }
            });
            $A.enqueueAction(action5); 
              
          }
        
            
        }
        
    },
    
          packageChangeNew: function(component, event, helper) {
               var recID= component.get("v.packageId");
    ///   alert('recID locChange>>>'+JSON.stringify(recID));
         if(JSON.stringify(recID)==='""')
         {
                component.set("v.packageName",'');
             component.set("v.Custname","");
                if(JSON.stringify(component.get('v.cuctomerId1'))==='null')
                 component.set("v.cuctomerId1","");
                 component.set("v.ShipmentProduct.sigmaerpdev2__Customer_Name__c","");
                  component.set("v.ShipmentProduct.Cust__Name","");
                 component.set("v.ShipmentProduct.Pkg__Name","");
               component.set("v.packageName","");
             
             component.set("v.ShipmentProduct.Pkg__Name","");
              component.set("v.ShipmentProduct.sigmaerpdev2__Package_ID__c","");
                
                // console.log('cuctomerId>> after..'+JSON.stringify(component.get('v.cuctomerId')));
              //  component.set("v.selectedPackageId",response.Id);  
             
             
             
             // component.set("v.binId",'');
            //  component.set("v.FormLocId",'');
             
            //// component.set("v.isBinShow",false);
          //  component.set("v.isError",false);
        //component.set("v.errorMsg",null);
         }
         else{
             let objectId=recID;
             var  shipPro=component.get("v.ShipmentProduct");
         
    console.log('JSON.stringify(objectId)>>>'+JSON.stringify(objectId)); 
          if( JSON.stringify(objectId)!='""')
          {
                var action5 = component.get("c.FindDuplicatePackage");
            //alert(packageId);
            action5.setParams
            ({ 
                "packageId": objectId,
            });
            action5.setCallback(this, function(b) {
               // alert(Custname);
                
                       
                var response= b.getReturnValue();
                console.log("response>>"+JSON.stringify(response));
                
               if(JSON.stringify(response)!='{}' && response!==undefined && response!==null && response!==NaN && response!==null)
               {
                   let sp=response['Found'];
                   let packageName=sp[0].sigmaerpdev2__Package_ID__r.Name;
                   let ShipmentName=sp[0].sigmaerpdev2__Shipment__r.Name;
                   console.log('packageName'+packageName);
                     console.log('ShipmentName'+ShipmentName);
                   var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            //title : 'Alert',
                            message: 'Package '+packageName+' is involved in shipment '+ShipmentName,
                            messageTemplate: 'Record {0} created! See it {1}!',
                            duration:' 5000',
                            //key: 'info_alt',
                            type: 'warning',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                       component.set("v.packageId","");
                    return;
                   
               }
                else
                {
                    shipPro.sigmaerpdev2__Package_ID__c= objectId; 
                    
                    
                    
                    //  if(objectLabel!=undefined)
                    // shipPro.Pkg__Name=objectLabel;
                    
                    var  packageId=objectId;
                    var action = component.get("c.getPackageCustomerName");
                    //alert(packageId);
                    action.setParams
                    ({ 
                        "packageId": packageId,
                    });
                    action.setCallback(this, function(a) {
                        // alert(Custname);
                        var response= a.getReturnValue();
						console.log('response customer >>>'+JSON.stringify(response));
                        component.set("v.Custname",response.sigmaerpdev2__Customer__r.Name);
                        if(JSON.stringify(component.get('v.cuctomerId1'))==='null')
                            component.set("v.cuctomerId1",response.sigmaerpdev2__Customer__c);
                        component.set("v.ShipmentProduct.sigmaerpdev2__Customer_Name__c",response.sigmaerpdev2__Customer__c);
                        component.set("v.ShipmentProduct.Cust__Name",response.sigmaerpdev2__Customer__r.Name);
                        component.set("v.ShipmentProduct.Pkg__Name",response.Name);
						 console.log('isSigmaOrder>>>'+JSON.stringify(component.get('v.isSigmaOrder')));		
						 if(component.get('v.isSigmaOrder'))
						 component.set("v.ShipmentProduct.sigmaerpdev2__Contact_Person__c",response.sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__BillingPersonNew__c);
                       else
						   component.set("v.ShipmentProduct.sigmaerpdev2__Contact_Person__c",response.sigmaerpdev2__Order__r.sigmaerpdev2__BillingPersonNew__c);
						console.log('response ShipmentProduct >>>'+JSON.stringify(component.get('v.ShipmentProduct')));
                        console.log('cuctomerId>> after..'+JSON.stringify(component.get('v.cuctomerId')));
                        component.set("v.selectedPackageId",response.Id);            
                        // shipPro.sigmaerpdev2__Customer_Name__c=response.sigmaerpdev2__Customer__c;
                        // shipPro.Cust__Name=response.sigmaerpdev2__Customer__r.Name;
						let conPerson=component.get("v.ShipmentProduct.sigmaerpdev2__Contact_Person__c");
                        console.log('conPerson>>..'+JSON.stringify(conPerson));
                        
						var StappComponentEvent = component.getEvent("StappComponentEvent");
                        StappComponentEvent.setParams({
                            "data": {
                                
                                "conName" : response.sigmaerpdev2__Customer__r.Name,
                                "customer": response.sigmaerpdev2__Customer__c,
								"contactPerson": conPerson
                            },
                            "flag": "accountContact"
                        });
                        StappComponentEvent.fire();
                    });
                    $A.enqueueAction(action); 
                }
            });
            $A.enqueueAction(action5); 
              
          }
         }
       // if(binId!=null && JSON.stringify(binId)!="" )
         //   helpe
          },
        
     packageChange: function(component, event, helper) {
        var recID= component.get("v.recID");
    ///   alert('recID locChange>>>'+JSON.stringify(recID));
         if(JSON.stringify(recID)==='""')
         {
             component.set("v.Custname","");
                if(JSON.stringify(component.get('v.cuctomerId1'))==='null')
                 component.set("v.cuctomerId1","");
                 component.set("v.ShipmentProduct.sigmaerpdev2__Customer_Name__c","");
                  component.set("v.ShipmentProduct.Cust__Name","");
                 component.set("v.ShipmentProduct.Pkg__Name","");
             component.set("v.ShipmentProduct.Pkg__Name","");
              component.set("v.ShipmentProduct.sigmaerpdev2__Package_ID__c","");
                
                // console.log('cuctomerId>> after..'+JSON.stringify(component.get('v.cuctomerId')));
              //  component.set("v.selectedPackageId",response.Id);  
             
             
             
             // component.set("v.binId",'');
            //  component.set("v.FormLocId",'');
             
            //// component.set("v.isBinShow",false);
          //  component.set("v.isError",false);
        //component.set("v.errorMsg",null);
         }
         else{
            //// component.set("v.isBinShow",true);
             //component.set("v.FormLocId",recID);
            //  component.set("v.binId",'');
         }
       // if(binId!=null && JSON.stringify(binId)!="" )
         //   helper.fetchILPdata(component, event, helper);
    },
})