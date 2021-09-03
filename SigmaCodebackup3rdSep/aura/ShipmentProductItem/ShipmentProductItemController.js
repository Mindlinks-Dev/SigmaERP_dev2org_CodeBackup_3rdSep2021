({
    editFlow: function(component, event, helper) {
        var shList = event.getParam("shipment");
        component.set("v.rowIndexVar",event.getParam("rowIndex"));
        component.set("v.ShipmentProducts",shList);
        component.set("v.recordName1",shList.Pkg__Name);
        component.set("v.Custname",shList.Cust__Name);
        component.set("v.ShipmentProducts.sigmaerpdev2__Shipment_Delivery_Date__c",shList.sigmaerpdev2__Shipment_Delivery_Date__c);
        
    },
    doInit : function(component, event, helper) {
        //alert('cuctomerId>>'+component.get('v.cuctomerId'));
        var action = component.get("c.getStockInProductStatus");
        var StockInProductList = component.get("v.ShipmentProducts");
        component.set("v.ShipmentProducts.sigmaerpdev2__Status__c",'');
        action.setCallback(this, function(a) {
            
            component.set("v.status", a.getReturnValue());
            component.set("v.ShipmentProducts",component.get("v.ShipmentProducts"));
            
            var selectedPKID=component.get("v.ShipmentProducts").sigmaerpdev2__Package_ID__c;
            component.set("v.selectedPackageId",selectedPKID);
            
        });
        $A.enqueueAction(action); 
        
    },
    SelectedID:function(component,event,helper)
    {
        var cuctomerId1= component.get('v.cuctomerId1');
            // alert('cuctomerId1>>'+JSON.stringify(component.get('v.cuctomerId1')));
        var  context = event.getParam("instanceId");
        var  objectId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        var  shipPro=component.get("v.ShipmentProducts");
        if(context === 'MyPackage')
        {
            shipPro.sigmaerpdev2__Package_ID__c= objectId; 
            shipPro.Pkg__Name=objectLabel;
            var  packageId=objectId;
            var action = component.get("c.getPackageCustomerName");
            action.setParams
            ({ 
                "packageId": packageId,
            });0
            action.setCallback(this, function(a) {
                var response= a.getReturnValue();
                component.set("v.Custname",response.sigmaerpdev2__Customer__r.Name);
                if(JSON.stringify(component.get('v.cuctomerId1'))==='null')
                 component.set("v.cuctomerId1",response.sigmaerpdev2__Customer__c);
                
                
                 console.log('cuctomerId>> after..'+JSON.stringify(component.get('v.cuctomerId')));
                component.set("v.selectedPackageId",response.Id);            
                shipPro.sigmaerpdev2__Customer_Name__c=response.sigmaerpdev2__Customer__c;
                shipPro.Cust__Name=response.sigmaerpdev2__Customer__r.Name;
            });
            $A.enqueueAction(action); 
            
        }
        
    },
    saveStatus : function(component,event,helper)
    {
        
        component.set("v.ShipmentProducts.sigmaerpdev2__Status__c",component.find("status").get("v.value")); 
    },
    ViewPackage: function(component, event, helper) {               
        var packageId = component.get("v.selectedPackageId");                      
        
        if(packageId !== '') 
        { 
            window.open("/"+packageId);
        }
        else
        {
            var msg = "Please select a package.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
    },
    
    submit : function(component, event, helper)
    {
        var Popupval = component.get("v.ShipmentProducts");
        alert(JSON.stringify(Popupval));
        component.set("v.ShipmentProduct",Popupval);
        
        var StkPrdList =  component.get("v.ShipmentProduct");
		var pkvalue  = component.get('v.recordName1');
        
        if(Popupval.Pkg__Name =='' || Popupval.Pkg__Name==undefined || Popupval.Pkg__Name==null) 
        {
            
            var msg = "Please enter Package Number.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        if(pkvalue =='' || pkvalue==undefined || pkvalue==null) 
        {
            
            var msg = "Please enter Package Number.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            component.set("v.Custname","");
            return;
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }

        if(Popupval.sigmaerpdev2__Status__c =="--Select--" || Popupval.sigmaerpdev2__Status__c==undefined ) 
        {
            
            var msg = "Please select Status.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        

        var shipdate= component.get("v.ShipmentProducts.sigmaerpdev2__Shipment_Delivery_Date__c");
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var date = new Date(component.get("v.today"));
        
        var someDate = new Date(component.get("v.ShipmentProducts.sigmaerpdev2__Shipment_Delivery_Date__c"));
        component.set('v.Orderdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
        
        var orderdate = new Date(component.get("v.Orderdate"));
        if(shipdate == '')
        {
            var msg = "Enter Shipment Delivery Date";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        if(orderdate < date)
        {
            var msg = "shipment Delivary Date Should be greater than Today.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        var compEvent = component.getEvent("carryShipmentInList");
        compEvent.setParams({"shList" : StkPrdList,"isEdit" : true,"rowIndex" : component.get("v.rowIndexVar")});
        compEvent.fire();
       //// alert('cuctomerId1>>'+component.get('v.cuctomerId1'));
      //  alert('cuctomerId>>'+component.get('v.cuctomerId'));
         if(JSON.stringify(component.get('v.cuctomerId'))==='null')
                 component.set("v.cuctomerId",component.get('v.cuctomerId1'));
       // alert('cuctomerId>>'+component.get('v.cuctomerId'));

        component.set("v.isOpenchild", false);
        component.set("v.isOpenTablechild", true);

    },
    
    closeModel: function(component, event, helper) 
    {
        component.set("v.isOpenchild", false);
        
    },
    handleComponentEvent : function(cmp, event) {
        alert("");
        var status = event.getParam("status");
        cmp.get("v.ShipmentProducts.sigmaerpdev2__Status__c",status);

        // set the handler attributes based on event data
       // cmp.set("v.messageFromEvent", message);
      
    }
    
})