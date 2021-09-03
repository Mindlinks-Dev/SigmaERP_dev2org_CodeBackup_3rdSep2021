({
    SelectedID : function(cmp, event) 
    {
      
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");
        
        if(context == 'ReceivingLocation')
        {  
            
            cmp.set("v.StockRcvProduct.sigmaerpdev2__Putaway_location__c",objectId);
            
        }
        if(context == 'lotpro')
        { 
           
           cmp.set("v.StockRcvProduct.sigmaerpdev2__Lot__c",objectId); 
            
        }
       // alert('objectId '+objectId); 
    },
    handleLookupValueselected: function(component, event, helper) 
    {
       // alert('handleLookupValueselected>>.');
        if(event.getParam("objectAPIName")==='sigmaerpdev2__Lot__c'){
             //alert('lotRecord>>.'+component.get('v.lotRecord') + 'lotname' +component.get('v.productid'));
            var POevent = component.getEvent("POevent");
            
                POevent.setParams({
                    "data" : {"index":component.get('v.indexNum'),"lotID":component.get('v.lotRecord'),"lotName":component.get('v.productid')},
                     "flag" : "fetchStockLines"
                });
                POevent.fire();
            //}
        }
    }, 

     handleTransIdValueChange: function(component, event, helper) 
    {
      //  alert('transactionID'+component.get('v.lotRecord'));
        if(!component.get('v.lotRecord')){
            component.set('v.StockRcvProduct.sigmaerpdev2__Lot__c',null);
           //alert('StockRecievingProdList--->'+ component.get('v.StockRecievingProdList'));
        }
    },
    showSerialNumModal : function(component, event, helper) {
        //alert('qty remainqty->'+component.get('v.remainqty'));
       // alert('qty received->'+component.get('v.StockRcvProduct.sigmaerpdev2__Quantity_Received__c') );
        if(component.get('v.StockRcvProduct.sigmaerpdev2__Quantity_Received__c')<=0 || component.get('v.StockRcvProduct.sigmaerpdev2__Quantity_Received__c')>component.get('v.remainqty'))
       {
			alert('Receiving Quantity should be greater than 0 and Less than Remainig Quantity.');
            return;
       }
        var POevent = component.getEvent("POevent");
        POevent.setParams({
            "data" : {"qty":component.get('v.StockRcvProduct.sigmaerpdev2__Quantity_Received__c'),"parentIndex":component.get('v.parentIndx'),"index":component.get('v.indx')},
            "flag" : "openModal"
        });
        POevent.fire();
    },
    getproductimagedata :function (component, event, helper) {
        
       // alert('view product');
         var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
       
        SigmaComponentEvent.setParams({
            "data": {
                "ProductID": component.get('v.productid')
            },
            "flag": "Viewproductimage"
        });
        SigmaComponentEvent.fire();
    }
})