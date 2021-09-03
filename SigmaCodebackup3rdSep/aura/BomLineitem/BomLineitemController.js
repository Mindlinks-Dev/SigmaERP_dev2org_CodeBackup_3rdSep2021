({
    
    //code added by rashmi on 22-11-2019
    itemsChange: function(component, event, helper)
    {
        
        var sersec = component.find('serialinput');
        var wrapper = component.get('v.wrapper');
        var convqty = component.get('v.convqty');
        var lineqty = component.get('v.lineItem.indpro.sigmaerpdev2__Quantity__c'); 
       // var DispupdatQty = component.get('v.lineItem.updqtydisplay');
        var protype = component.get('v.lineItem.indpro.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c');
        var autostock = component.get('v.autostock');
        var eachserial = component.get('v.lineItem.eachserialNo');
        //alert('set serial no>>'+reqserqty);
        //alert(eachserial);
        //alert('set serial no'+eachserial.length);
        
        
        
        /*     var productTypeData = component.getEvent("productTypeData"); 
        productTypeData.setParams({ 
            "prodType" : protype
        })
        productTypeData.fire(); */
        // alert('after event fire');
        
        /*for(var i=0;i<wrapper.IndPros.length;i++)
            {
               wrapper.IndPros[i].pickQty =wrapper.IndPros[i].pickQty * lineqty;
             //  alert('wrapper.eachLineItemILPLIWrapper[i].pickQty -->>>'+wrapper.eachLineItemILPLIWrapper[i].pickQty );
            }
          component.set("v.wrapper",wrapper);*/
        // alert('pickqty>>z'+pickqty);
        // alert('sigmaerpdev2__Net_Quantity__c>>'+JSON.stringify(component.get('v.wrapper.record.sigmaerpdev2__Net_Quantity__c')));
        
        if(convqty <=  component.get('v.wrapper.record.sigmaerpdev2__Net_Quantity__c'))
        {
            var reqserqty=lineqty*convqty;
            
            component.set("v.lineItem.updqtydisplay",reqserqty);
            if( reqserqty > 0 && protype == 'SERIALIZED'){
                //show
                //  alert('hi');
                $A.util.removeClass(sersec,"slds-hide");
                $A.util.addClass(sersec, "slds-show"); 
            }else{
                //hide
                $A.util.removeClass(sersec,"slds-show");
                $A.util.addClass(sersec, "slds-hide"); 
            }
            //  var serial=component.get("v.serial");
            //  alert('Serial Data>>>'+JSON.stringify(serial));
            /*  if (!Array.isArray(serial)) {
            serial = [serial];
        }*/
            
            if(typeof eachserial === "undefined")
            {
                var WrapperArray = [];
                if(protype == 'SERIALIZED')
                {
                    
                    for(var i= 0; i< reqserqty; i++ )
                    {
                        WrapperArray.push({
                            'sigmaerpdev2__Serial_Number__c': null
                        });   
                        
                    }
                }
                
                component.set("v.lineItem.eachserialNo", WrapperArray); 
                //  alert(JSON.stringify(component.get("v.lineItem.eachserialNo")));
            }
            else if( eachserial.length!=reqserqty )
            {
                var WrapperArray = [];
                if(protype == 'SERIALIZED')
                {
                    
                    for(var i= 0; i< reqserqty; i++ )
                    {
                        WrapperArray.push({
                            'sigmaerpdev2__Serial_Number__c': null
                        });   
                        
                    }
                }
                
                component.set("v.lineItem.eachserialNo", WrapperArray); 
               // alert(JSON.stringify(component.get("v.lineItem.eachserialNo")));
            }
            
            
        }
        
    },
    
    SelectedID  : function(component, event, helper)
    {
        
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");  
        var SelId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        if(context == 'Lot')
        {
            component.set("v.lineItem.lot",SelId); 
        }
        
    },
	 showSerialNumber : function(component, event, helper){        
        	    
        
        	component.set("v.showManSerNumEntryFlg", false);
        	component.set("v.showAutoSerNumEntryFlg", false);
        	component.set("v.enableSaveForUplAndMan", false);
        	helper.openModalHelper(component, event, helper);    
        
    },
	
   
   closeModal : function(component, event, helper){
        component.set("v.showManSerNumEntryFlg", false);
        component.set("v.showAutoSerNumEntryFlg", false);
        component.set("v.showModal", false);
        alert('showModal close>>>'+ component.get("v.showModal"));
    },
	
	clearNumbers : function(component, event, helper){
        var index = event.target.dataset.index;
		var length = component.get("v.pro.sigmaerpdev2__Net_Quantity__c");                    
        var serialList = [];        
		serialList =  component.get("v.serials");        
        for(var i=0;i<length;i++){
            if(i == index)
                serialList[i].SerialNo = '';                      	                      
        }
       	component.set('v.serials',serialList); 
    },
	
   showAutoSerialize : function(component, event, helper){        
        component.set("v.showAutoSerNumEntryFlg", true);
        component.set("v.showManSerNumEntryFlg", false);
        component.set("v.enableSaveForUplAndMan", false);         
    },
	 showManualEntry : function(component, event, helper){
        component.set("v.showManSerNumEntryFlg", true);
        component.set("v.enableSaveForUplAndMan", true); 
        component.set("v.showAutoSerNumEntryFlg", false);
    },
	autoSerialize : function(component, event, helper){      
        var wrapper = component.get('v.wrapper');
        var convqty = component.get('v.convqty');
        var lineqty = component.get('v.lineItem.indpro.sigmaerpdev2__Quantity__c'); 
        var selectedProdName = component.get("v.autoSerialName");
		var eachserial = component.get('v.lineItem.eachserialNo');  
        //alert('eachserial>>>'+JSON.stringify(eachserial));
        if(selectedProdName == undefined || selectedProdName == ''){
          //   alert('if');
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Error",
                    "title": "Error!",
                    "message": "Enter Serial number format."
                });
                toastEvent.fire();
                return;
        }else{
            //alert('else');
            var pName;
            if(selectedProdName.length >= 3)
                pName = component.get("v.autoSerialName").substring(0,3);
            else
                pName = component.get("v.autoSerialName").substring(0, selectedProdName.length);
            //var serialList = component.get("v.serials");        
           	//alert('serialList>>'+serialList);
           	 var reqserqty=lineqty*convqty;
           // alert('reqserqty>>'+reqserqty);
            component.set("v.lineItem.updqtydisplay",reqserqty);
            var timezone = $A.get("$Locale.timezone");        
            var d = new Date().toLocaleString("en-US", {timeZone: timezone})
            var finArr = []
            for(var i=0;i<reqserqty;i++)
            {
              // if(!serialList[i].sigmaerpdev2__Serial_Number__c)
                     finArr.push({
                            'sigmaerpdev2__Serial_Number__c': pName+'-'+d[12]+d[13]+d[15]+d[16]+d[18]+d[19]+'-SER-'+d[6]+d[7]+d[8]+d[9]+d[0]+d[1]+'-'+i
                        }); 
                    //serialList[i].sigmaerpdev2__Serial_Number__c = pName+'-'+d[12]+d[13]+d[15]+d[16]+d[18]+d[19]+'-SER-'+d[6]+d[7]+d[8]+d[9]+d[0]+d[1]+'-'+i;           
            //alert('finArr>>'+finArr);
            }               
            //alert('finArr111==='+JSON.stringify(finArr));
           
            var finalres = reqserqty;
            for(var i=0;i<finalres.length;i++){
			//alert('inside finalres>>>'+finalres[i].sigmaerpdev2__Serial_Number__c);
                
                finArr.push(finalres[i].sigmaerpdev2__Serial_Number__c);
               
            }
            // alert('finArr22==='+JSON.stringify(finArr));
           // component.set("v.SMData.serialNumberLst", finArr); 
             component.set("v.lineItem.eachserialNo",finArr); 
            
           // alert('eachserialNo after set==='+JSON.stringify(component.get("v.lineItem.eachserialNo")));
            //component.set("v.SMData.serialNumberLst", serialList);
            
        } 
        component.set("v.showModal",false);
    },
	addSerialNumber : function(component, event, helper){         
        var wrapper = component.get('v.wrapper');
        var convqty = component.get('v.convqty');
        var lineqty = component.get('v.lineItem.indpro.sigmaerpdev2__Quantity__c'); 
        var selectedProdName = component.get("v.autoSerialName");
		var eachserial = component.get('v.lineItem.eachserialNo');        		
            //manual entry flow
			var reqserqty=lineqty*convqty;
		//	alert('reqserqty>>'+reqserqty);
			component.set("v.lineItem.updqtydisplay",reqserqty);
        
            //var srlNo = component.get('v.fileInput');
            var myArray = [];
            for(var i = 0; i < reqserqty; i++){
                myArray.push(JSON.stringify(reqserqty[i].SerialNo));
					//alert('myArray>>'+myArray);           
		   }
		   //alert('myArray111==='+JSON.stringify(myArray));
			var final = reqserqty;
        	//alert('final>>>'+final[i].SerialNo.trim());
            for(var i=0;i<final.length;i++){
                if(final[i].SerialNo.trim() == ''){ 
                    alert('fail>>>'+final[i].SerialNo.trim());
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": "Serial Number is empty @ row : "+(i+1)
                    });
                    toastEvent.fire();
                    return;
                }else
                {
                    // alert('success>>>'+final[i].SerialNo.trim());
                     component.set("v.showModal",false);
                }
            }
            var flag = false;
            for(var i = 0; i < myArray.length; i++){
                for(var j = 0; j < myArray.length; j++){
                    if(i != j){                    
                        if (myArray[i] == myArray[j]){
                            flag = true;                        
                        }
                    }
                }
            }
            if(flag){            
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Error",
                    "title": "Error!",
                    "message": "Duplicate serial number found."
                });
                toastEvent.fire();
                return;
            }
            
            var finArr1 = [];
            var finalres1 = reqserqty;
            for(var i=0;i<finalres1.length;i++){                
                finArr.push(finalres1[i].SerialNo);
            }
           component.set("v.lineItem.eachserialNo",finArr);  
           component.set("v.showModal",false);         
    }
   
    
})