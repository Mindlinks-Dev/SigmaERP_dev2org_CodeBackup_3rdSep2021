({
    doInit : function(component, event, helper) {
       /* if($A.get("$Browser.formFactor") == "PHONE")
            component.set('v.mobileScreenFlag',true);
        var spinner=component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        var myPageRef = component.get("v.pageReference");
        if(myPageRef.state.tdID)
            component.set('v.tdID',myPageRef.state.tdID);*/
       
		//helper.fetchTdData(component, event, helper);
	},
    SelectedID:function(component,event,helper)
    {
        var  context = event.getParam("instanceId");
        var  objectId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        var  sInPro=component.get("v.StockInProductPopup");

        
        if(context =='POrder')
        {
           var POevent = component.getEvent("POevent");
                POevent.setParams({
                    "data" : {"index":component.get('v.indexNum'),"transID":objectId,"transName":objectLabel},
                    "flag" : "fetchStockLines"
                });
                POevent.fire();             
        }
        else if(context=='MyAccount3')
        {
            sInPro.sigmaerpdev2__Putaway_location__c=objectId;
            sInPro.Loc_Name = objectLabel;
            
        }else if(context=='Lot')
        {
            sInPro.sigmaerpdev2__Lot__c = objectId;
            sInPro.Lot_Name = objectLabel;
        }
        
        
    }, 
     removeSRP : function(component, event, helper) 
    {
        var POevent = component.getEvent("POevent");
       // alert('ind>>'+component.get('v.indexNum'));
        POevent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "removeSRPro"
        });
        POevent.fire();
    },
   afterProductScaned: function(component, event, helper) {
        
    if(!component.get('v.scannedProductBarCodeValue') || component.get('v.scannedProductBarCodeValue').length <5){
	  //  alert('1Hi');
		return;
	}
	var prodBarCodeValue=component.get('v.scannedProductBarCodeValue');
	window.setTimeout(
		$A.getCallback(function() {
			var prodBarCodeValueInner=component.get('v.scannedProductBarCodeValue');
		    var prodFound = false;
			var allProdPicked = false;
			var allPickedProdName = '';
			if(prodBarCodeValueInner.length==prodBarCodeValue.length)
			{
                //code changed by rashmi on 23-10-2019 to handle product barcode scanning for same po and update qty in selected index
			 
				var tli=component.get('v.StockRecievingProdList');
			 	// alert('StockRecievingProdList>>'+JSON.stringify(component.get('v.StockRecievingProdList')));
				
				for(var i=0;i<tli.length;i++)
				{
					
                    //	alert('Product_Bar_Code>>>'+tli[i].Product_Bar_Code);
                    //	alert('prodBarCodeValue>>>'+prodBarCodeValue);
                    //	alert('remainqty>>>'+tli[i].remainqty);
                    //	alert('sigmaerpdev2__Quantity_Received__c>>>'+tli[i].SRLineItemRec.sigmaerpdev2__Quantity_Received__c);
					if(tli[i].Product_Bar_Code==prodBarCodeValue && tli[i].remainqty!=tli[i].SRLineItemRec.sigmaerpdev2__Quantity_Received__c)
					{
					  //  alert('hi inside if2');
                      //  alert('hi inside if2');
						tli[i].SRLineItemRec.sigmaerpdev2__Quantity_Received__c=tli[i].SRLineItemRec.sigmaerpdev2__Quantity_Received__c? parseInt(tli[i].SRLineItemRec.sigmaerpdev2__Quantity_Received__c)+1:1;
						component.set("v.scannedProductName",tli[i].productName);
						prodFound=true;
						break;
					}  
				}
			/*	if(prodFound)
				{
					break; 
				}*/
				component.set('v.StockRecievingProdList',tli);
				
				if(prodFound)
				{
				  //  alert('hi if');
					component.set('v.scannedProductBarCodeValue','');
					component.set("v.productFoundFlag",true);
				}
				else
				{
				   // alert('hi else');
					component.set("v.scannedProductName",'Not Found');
					component.set("v.productFoundFlag",true);
				}

			}
		}), 1000
	);
 },
     barCodeClear: function(component, event, helper) {
        if(!component.get('v.scannedProductBarCodeValue')){
           // alert('hi event');
            //$A.util.addClass(component.find('productNameDispaly'), 'slds-hide');
        }
     },
    
    handleLookupValueselected: function(component, event, helper) 
    {
        //alert('handleLookupValueselected>>.');
        if(event.getParam("objectAPIName")==='sigmaerpdev2__Purchase_Order__c'){
          //   alert('fired>>.');
            var POevent = component.getEvent("POevent");
            
                POevent.setParams({
                    "data" : {"index":component.get('v.indexNum'),"transID":component.get('v.transactionID'),"transName":component.get('v.transactionName')},
                    "flag" : "fetchStockLines"
                });
                POevent.fire();
            //}
        }
       
        
    }, 

     handleTransIdValueChange: function(component, event, helper) 
    {
        //alert('transactionID'+component.get('v.transactionID'));
        if(!component.get('v.transactionID')){
            component.set('v.StockRecievingProdList',[]);
           //alert('StockRecievingProdList--->'+ component.get('v.StockRecievingProdList'));
        }
    }
  
})