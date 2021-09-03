({
    SelectedID  : function(component, event, helper){
          console.log('ILPLI::::'+JSON.stringify(component.get("v.ILPLI.sigmaerpdev2__Product__r.Name")));
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");  
        var SelId = event.getParam("sObjectId");
        var fromId = component.get('v.FromId');
        var ghhh = component.get("v.ILPLI.sigmaerpdev2__InventoryLocation__c");
       //component.set("v.ILPLI.sigmaerpdev2__ILid__c",SelId);
        //component.set("v.ILPLI.sigmaerpdev2__InventoryLocation__c",SelId);
    //   alert('indexNum>>'+component.get('v.ILPLI.sigmaerpdev2__InventoryLocation__c'));
          //   alert('sigmaerpdev2__ILid__c>>'+component.get('v.ILPLI.sigmaerpdev2__ILid__c'));
        if(context === 'To Location')
        {
            component.find("bucket1").set("v.errors", [{message:' '}]);
            component.set("v.ILPLI.sigmaerpdev2__InventoryLocation__c",SelId);
            component.set("v.ILPLI.sigmaerpdev2__ILid__c",SelId);
            var g = component.get("v.ILPLI");
            if(fromId == SelId){
               // component.find("bucket").set("v.errors", [{message:"From Location & To Location Should be different."}]);
                return;
            }
            
            component.find("bucket").set("v.errors", null);
            var selQuantity = component.get("v.ILPLI.sigmaerpdev2__bucket_field__c");
            
            if(selQuantity == null || selQuantity < 1){
                component.find("bucket").set("v.errors", [{message:"Select Valid Quantity."}]);
                return;
            }
            
            
        }
        if(context === 'From Location')
        {
            component.set("v.FromLocId",SelId);
        }
        if(context === 'ilpName')
        {
            component.set("v.ilpId",SelId);  
        }
        
        var successIcon = component.find('successIcon');
        $A.util.removeClass(successIcon, 'slds-hide');

        var stockMovementHighlight = component.getEvent("CarryStockEvent");            
            stockMovementHighlight.setParams({
                ToLocation: objectId
            }).fire();
    },
    validateQuantity : function(component, event, helper) {
        var availQuantity = component.get("v.ILPLI.sigmaerpdev2__Available_Quantity__c");
        var selQuantity = component.get("v.ILPLI.sigmaerpdev2__bucket_field__c"); 
        var lookup = component.get("v.ILPLI.sigmaerpdev2__ILid__c");
        
        var fromId = component.get('v.FromId');
       // alert(availQuantity+'fromId>>'+JSON.stringify(selQuantity));
        if(JSON.stringify(selQuantity)!='""' && JSON.stringify(selQuantity)!='0')
        {
              //component.set("v.isBinShow",false);
            component.set("v.isLocationShow",true); 
            component.set("v.ILPLI.sigmaerpdev2__Bin__c","");
            component.set("v.ILPLI.sigmaerpdev2__ILid__c","");
              component.find("bucket1").set("v.value", "");
        }
        else
        {
         
            component.set("v.ILPLI.sigmaerpdev2__Bin__c","");
            component.set("v.ILPLI.sigmaerpdev2__ILid__c","");
            component.set("v.ToBinId",'');
            component.set("v.recID",'');
            component.set("v.searchString",'');
            
               component.set("v.isLocationShow",false); 
            component.set("v.isBinShow",false);
            
           // component.find("bucket1").set("v.value", "");
           // component.find("bucket").set("v.value", "");
            
        }
        var ToID = component.get("v.ILPLI.sigmaerpdev2__ILid__c");
     //   alert('ToID>>'+ToID);
        if(selQuantity > availQuantity){
            component.find("bucket").set("v.errors", [{message:"Pick Qty should be less than or equal to Available Qty."}]);
            return;
        }else if(selQuantity < 0 || (selQuantity % 1) != 0){            
            var successIcon = component.find('successIcon');
       		 $A.util.addClass(successIcon, 'slds-hide');
            component.find("bucket").set("v.errors", [{message:"Please Enter Valid Quantity."}]);
            return;
        }else if(selQuantity !=undefined && selQuantity !=0 && lookup == undefined){
            component.find("bucket1").set("v.errors", [{message:'Select "To Location"'}]);
            return;
        }else if(lookup != undefined && selQuantity == 0 ){
            var successIcon = component.find('successIcon');
       		 $A.util.addClass(successIcon, 'slds-hide');
            component.find("bucket").set("v.errors", [{message:"Please Enter Valid Quantity.."}]);
            return;
        }else if(fromId == ToID){
            //component.find("bucket").set("v.errors", [{message:"From Location & To Location should not be same.."}]);
            return;
        }else{
            component.find("bucket").set("v.errors", null);
        }
    },
    
    clearsearchString : function (component, event, helper){
        var clearEv = component.getEvent("clearLookupIdEvent");
        var strng= event.getParam("str");
        component.set("v.ILPLI.sigmaerpdev2__ILid__c",''); 
    },
    ToBinChange : function (component, event, helper){
        var ToBinId = component.get('v.ToBinId');
        var FromBinId = component.get('v.FromBinId');
       // alert('ILPLI::::'+JSON.stringify(component.get("v.ILPLI")));
	//	alert('FromBin::::'+FromBinId);
     /* if(ToBinId == FromBinId)
            component.find("FromBin").set("v.errors", [{message:"From Bin & To Bin should not be same.."}]);
        component.set("v.ILPLI.sigmaerpdev2__Bin__c",ToBinId);*/
        
        //for(var i=0;i<FromBinId.length;i++)
       // {
            //for(var j=0;j<ToBinId.length;j++)
          ////  {
                //if(ToBinId[j]== FromBinId[i])
                if(ToBinId=== FromBinId)
                    component.find("FromBin").set("v.errors", [{message:"From Bin & To Bin should not be same.."}]);
                    console.log('FromBin::::'+FromBinId);
                    console.log('ToBinId::::'+ToBinId);
        if(ToBinId)
                component.set("v.ILPLI.sigmaerpdev2__Bin__c",ToBinId);
        else
            component.set("v.ILPLI.sigmaerpdev2__Bin__c","");
           // }
        //}
    },
      locChange: function(component, event, helper) {
        var recID= component.get("v.recID");
     //  alert('recID locChange>>>'+JSON.stringify(recID));
         if(JSON.stringify(recID)==='""')
         {
             // component.set("v.binId",'');
             // component.set("v.FormLocId",'');
               component.set("v.ILPLI.sigmaerpdev2__Bin__c",'');
             component.set("v.isBinShow",false);
               component.set("v.ToBinId",'');
            //component.set("v.isError",false);
       // component.set("v.errorMsg",null);
         }
         else{
                component.set("v.ILPLI.sigmaerpdev2__Bin__c",'');
              component.set("v.ToBinId",'');
             
             component.set("v.isBinShow",true);
             
             //added on 04-06-2020 changed lookupsobject to cutom lookup
             component.find("bucket1").set("v.errors", [{message:' '}]);
            component.set("v.ILPLI.sigmaerpdev2__InventoryLocation__c",recID);
            component.set("v.ILPLI.sigmaerpdev2__ILid__c",recID);
             
             
            component.find("bucket").set("v.errors", null);
            var selQuantity = component.get("v.ILPLI.sigmaerpdev2__bucket_field__c");
            
            if(selQuantity == null || selQuantity < 1){
                component.find("bucket").set("v.errors", [{message:"Select Valid Quantity."}]);
                return;
            }
                     var successIcon = component.find('successIcon');
        $A.util.removeClass(successIcon, 'slds-hide');

        var stockMovementHighlight = component.getEvent("CarryStockEvent");            
            stockMovementHighlight.setParams({
                ToLocation: recID
            }).fire();
             
             
             //component.set("v.FormLocId",recID);
            //  component.set("v.binId",'');
         }
       // if(binId!=null && JSON.stringify(binId)!="" )
         //   helper.fetchILPdata(component, event, helper);
    }
})