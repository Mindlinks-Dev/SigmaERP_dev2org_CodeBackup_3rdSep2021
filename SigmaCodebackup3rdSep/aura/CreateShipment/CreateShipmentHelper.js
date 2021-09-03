({
    doInit : function(component, event, helper) {
       
        var pkgid = component.get("v.recordId");
        // alert('pkgid>>'+pkgid);
        component.set("v.status",'Shipped');
        component.set("v.Shipment.sigmaerpdev__Status__c",'Shipped'); 
        component.set("v.ShipmentProducts.sigmaerpdev__Status__c",'Shipped');
        
        var shipPro=component.get("v.ShipmentProducts");
        shipPro.sigmaerpdev__Package_ID__c= pkgid; 
        var action = component.get("c.getPackageCustomerName");
        action.setParams
        ({ 
            "packageId": pkgid,
        });
        action.setCallback(this, function(a) {
            var response= a.getReturnValue();
             //alert('response>>'+JSON.stringify(response));
            if(JSON.stringify(response)=='null')
            {
                var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": 'order was refunded.'
            });
            toastEvent.fire();	 
            //return;
               //  component.set("v.isError",true);
               // alert('inside if');
               // var msg = "order was refunded";
               // component.set("v.errorMsg", msg);
               
                var backdrop1 = component.find('backdrop1');
                $A.util.removeClass(backdrop1, "slds-hide");
                
                return;
            }
            component.set("v.pkgstatus",response.sigmaerpdev__Status__c);
            var pkstatus=component.get("v.pkgstatus");
            if(pkstatus=='In Shipment')
            {
                var msg = "Package is Already Shipped";
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                var backdrop1 = component.find('backdrop1');
                $A.util.removeClass(backdrop1, "slds-hide");
                
                return;
            }
            else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
            if(pkstatus=='In Progress')
            {
                
                var msg = "Package is Not Ready for Shipment.";
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                
                var backdrop1 = component.find('backdrop1');
                $A.util.removeClass(backdrop1, "slds-hide");
                return;
            }
            else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
            component.set("v.pkname",response.Name);
            component.set("v.custname",response.sigmaerpdev__Customer__r.Name);
            
            shipPro.sigmaerpdev__Customer_Name__c=response.sigmaerpdev__Customer__c;
            
            //new code to handel canceled package to restrict in shipment by chandana 
            component.set("v.pkgcancelstatus",response.sigmaerpdev__Canceled_Package__c);
            var pkcancelstatus=component.get("v.pkgcancelstatus");
            //alert('canceled package ::'+pkcancelstatus);
            if(pkcancelstatus== true)
            {
                var msg = "Package is canceled, Cannot proceed for Shipment.";
                component.set("v.errorMsg", msg);
                component.set("v.isError",true);
                 var backdrop1 = component.find('backdrop1');
                $A.util.removeClass(backdrop1, "slds-hide");
                
                return;
            }
            else{
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
        });
        $A.enqueueAction(action); 
        
        var action3 = component.get("c.getCouriers");
         action3.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 if (response.getReturnValue() != null) {
                     var couriers=[];
                     var result= response.getReturnValue();
                     component.set("v.myMap",result);
                     for(var key in result){
                         var data=key;
                         couriers.push(data);
                     }
                     component.set("v.courierlist",couriers);
                 }
             }
         });
         $A.enqueueAction(action3);
        
    },
    
    onPicklistChange : function(component,event,helper) {
        var selected = component.find("levels").get("v.value");
        component.set("v.Shipment.sigmaerpdev__Selected_Courier__c",selected);
        component.set("v.selectedCourier",selected);
        var values=component.get("v.myMap");
        if(selected!="--None--"){
            for(var key in values){
                if(key==selected)
                    component.set("v.courierSlug",values[key]);
            } 
        }
        else
            component.set("v.courierSlug",null);
    },
    
    createShipment :function(component,event,helper)
    {
          var deleverPerson = component.get("v.dpName"); 
        //salert('deleverPerson'+deleverPerson);
        // alert('deleverPerson1'+deleverPerson1);
         if(deleverPerson === undefined)
        {                      
            alert('Please enter delivery Person name.');
            //logisticName.set("v.errors", [{message:"Please enter logistics name."}]);   	                	 
            return ; 
        }
        else
        {
            component.set("v.Shipment.sigmaerpdev__Delivery_Person1__c",deleverPerson)
            
        }
        //alert('inside create ship');
        var newShipmentProducts = component.get("v.ShipmentProducts"); 
        
        //alert('newShipmentProducts::'+JSON.stringify(component.get("v.ShipmentProducts")));
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var todaydate = new Date( component.get('v.today'));
        var someDate = new Date(newShipmentProducts.sigmaerpdev__Shipment_Delivery_Date__c);
        
        
        var logName = component.get("v.selectedCourier")       
        if(logName === '' || logName === null || logName == '--None--' || logName == undefined)
        {                      
            alert('Please enter logistics name.');
            return null; 
        }
        
        if(newShipmentProducts.length < 1)
        {
            alert('Please add packages for shipment.');
            return null;
        }
        /*
        if(newShipmentProducts.sigmaerpdev__Shipment_Delivery_Date__c=='') 
        {
            
            var msg11 = "Please Select Shipment Delivery Date .";
            component.set("v.errorMsg", msg11);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        component.set('v.Orderdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
        var orderdate = new Date(component.get("v.Orderdate"));
        if(orderdate < todaydate)
        {
            var msg = "Shipment Delivery Date Should be greater than or Equal to Today Date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }*/
        var newShipment=component.get('v.Shipment');
        document.getElementById("Accspinner").style.display = "block";
        helper.createnewShipment(component, newShipment); 
    },
    
    SelectedID : function(component, event) {
        
        
        // Create the UpdateLookupId event
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        if(context ==='MyPAccount')
        {
            component.set("v.SAccount",objectId);
            
        }else if(context ==='MyPContact')
        {
            
            component.set("v.SContact",objectId);  
        }
        
    },
    
    cancelButton:function(cmp, event){
        $A.get("e.force:closeQuickAction").fire(); 
        //window.self.close();
       // window.history.back();
    },
    recordCreatedOK: function(component, event, helper) 
    {
        var recid = component.get("v.curRecordID");
        window.location.href = "/" + recid;     
    },
    recordCreatedCancel: function(component, event, helper) 
    {
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');    
        window.location.reload();
    }
})