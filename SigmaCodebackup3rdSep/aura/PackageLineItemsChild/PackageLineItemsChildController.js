({
    fetchProductImageData:function (component, event, helper)
    {
        var PP=component.get('v.packageLinItems');
        console.log("PP"+JSON.stringify(PP));
        if(JSON.stringify(PP)!='""')
        {
            
        }
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
                    SigmaComponentEvent.setParams({
                        "data" : {"prodId":component.get('v.packageLinItems.sigmaerpdev2__Product__c'),"PPData":component.get('v.packageLinItems')},
                        "flag" : "viewProductImage"
                    });
                    SigmaComponentEvent.fire();
    },
    AfterselectInput:
    function(component, event, helper) {
         var checkBoxValue=component.find('Quantity').get('v.packageLinItems.sigmaerpdev2__Quantity__c');
        //alert('Quantity'+checkBoxValue);
         var value2=component.get("v.orderedQuantity");
        //alert('orderedQuantity'+orderedQuantity);
        if(checkBoxValue!=value2)
        {
            alert('please enter proper input');
        }
        
    },
    
	selectMalually: function(component, event, helper) {
		var isConfirm=confirm('Are you sure you want select Stock Manually!');
		if(isConfirm)
			helper.getILPLIDataForManSelect(component, event, helper);
	},
	doInit: function(component, event, helper) {
        console.log('doInit packageLinItems>>>>>>>>>>>>>'+JSON.stringify(component.get('v.packageLinItems')));
      // alert("doInit in package line child");
       //  alert("doInit in package line child"+JSON.stringify(component.get("v.packageLinItems")));
       var headerStatus=component.get('v.headerStatus');
        // alert("headerStatus"+headerStatus);
		if(component.get("v.packageLinItems.sigmaerpdev2__Status__c")=='Ready')
			component.set("v.isDisable",true);
		//alert(JSON.stringify(component.get("v.configValues")));
        if(!component.get('v.packRecordId'))
        {
            component.set('v.packageLinItems.sigmaerpdev2__Status__c',component.get('v.headerStatus'));
        }
	},
    closeSelectManualModal:function(component, event, helper){
		component.set("v.openSelectMalual",false);
	},
     handleAutoSelectCheckBox:function(component, event, helper){
        var checkBoxValue=component.find('checkbox').get('v.value');
        var tempILPLIData=component.get("v.tempILPLIData");
        var tempQaunt=component.get("v.packageLinItems.sigmaerpdev2__Quantity__c");
        for(var i=0;i<tempILPLIData.length;i++){
            if(checkBoxValue){
                if(tempQaunt>=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c && tempQaunt!=0){
                    tempILPLIData[i].enteredQuant=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c;
                    tempQaunt-=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c;
                }
                else if(tempQaunt!=0){
                    tempILPLIData[i].enteredQuant=tempQaunt;
                    tempQaunt-=tempQaunt;
                }
            }
            else{
                tempILPLIData[i].enteredQuant=0;
            }
        }
        component.set("v.tempILPLIData",tempILPLIData);
    },
    selectedIPPLI:function(component, event, helper){
		//alert(JSON.stringify(component.get("v.ilpliData")));
		//alert(JSON.stringify(component.get("v.tempILPLIData")));
		var enteredQuant=0;
		var newILPLI=[];
		var ilpliData=component.get("v.tempILPLIData");
        var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
		for(var i=0;i<ilpliData.length;i++){
			//alert(ilpliData[i].enteredQuant);
			if(ilpliData[i].enteredQuant!=undefined){
				enteredQuant+=parseInt(ilpliData[i].enteredQuant);
				newILPLI.push(ilpliData[i]);
                if(ilpliIdAllocatedQuantMap[ilpliData[i].Id])
                    ilpliIdAllocatedQuantMap[ilpliData[i].Id]=(ilpliIdAllocatedQuantMap[ilpliData[i].Id]+parseInt(ilpliData[i].enteredQuant));
                else
                    ilpliIdAllocatedQuantMap[ilpliData[i].Id]=parseInt(ilpliData[i].enteredQuant);
			}
		}
		if(component.get("v.packageLinItems.sigmaerpdev2__Quantity__c")!=enteredQuant){
			//alert('Sum of selected ILPLI Quantities should be equal to Packaged Quantity');
			return;
		}
		component.set("v.ilpliData",newILPLI);
        component.set('v.ilpliIdAllocatedQuantMap',ilpliIdAllocatedQuantMap);
        component.set("v.StockSelectedAs","Manualy");
		component.set("v.openSelectMalual",false);
		component.set("v.isILPLISelectedManualy",true);
	},
    AutoPick: function(component, event, helper) {
		var isConfirm=confirm('Are you sure you want select Stock Automatically!');
		if(isConfirm){
            //alert(JSON.stringify(component.get('v.productIdAvailableQuantMap')));
            var productIdAvailableQuantMap=component.get('v.productIdAvailableQuantMap');
            var productIdRemainILPLIMap=component.get('v.productIdRemainILPLIMap');
            //alert(JSON.stringify(productIdRemainILPLIMap[component.get('v.packageLinItems.stapp__Product__c')]));
            var packageLinItems=component.get('v.packageLinItems');
            if(productIdAvailableQuantMap[packageLinItems.sigmaerpdev2__Product__c]!=undefined)
            {
                if(productIdAvailableQuantMap[packageLinItems.sigmaerpdev2__Product__c]>=packageLinItems.sigmaerpdev2__Quantity__c)
                {
                    productIdAvailableQuantMap[packageLinItems.sigmaerpdev2__Product__c]-=packageLinItems.sigmaerpdev2__Quantity__c;
                    //console.log(productIdRemainILPLIMap[packageLinItems.stapp__Product__c]);
                    var newILPLI=[];
                    var tempILPLIData=productIdRemainILPLIMap[packageLinItems.sigmaerpdev2__Product__c];
                    //console.log(tempILPLIData);
                    var outTempAvalQuant=component.get('v.packageLinItems.sigmaerpdev2__Quantity__c');
                    for (var i = 0; i < tempILPLIData.ilpliOrderByExpiryDate.length; i++){
                        var tempQuant=tempILPLIData.ilpliOrderByExpiryDate[i].sigmaerpdev2__AvailableAdjustedQty__c;
                        if(tempQuant>0)
                        {
                            if(tempQuant>=outTempAvalQuant)
                            {
                                var tempnewILPLI=new Object();
                                tempnewILPLI.Id=tempILPLIData.ilpliOrderByExpiryDate[i].Id;
                                tempnewILPLI.enteredQuant=outTempAvalQuant;
                                newILPLI.push(tempnewILPLI);
                                outTempAvalQuant-=outTempAvalQuant;
                                tempILPLIData.ilpliOrderByExpiryDate[i].sigmaerpdev2__AvailableAdjustedQty__c-=outTempAvalQuant;
                                break;
                            }
                            else{
                                var tempnewILPLI=new Object();
                                tempnewILPLI.Id=tempILPLIData.ilpliOrderByExpiryDate[i].Id;
                                tempnewILPLI.enteredQuant=tempQuant;
                                newILPLI.push(tempnewILPLI);
                                outTempAvalQuant-=tempQuant;
                                tempILPLIData.ilpliOrderByExpiryDate[i].sigmaerpdev2__AvailableAdjustedQty__c-=outTempAvalQuant;
                            }
                        }
                    }
                    if(outTempAvalQuant>0)
                    {
                        for (var i = 0; i < tempILPLIData.ilpliOrderByRecieveDate.length; i++) {
                            var tempQuant=tempILPLIData.ilpliOrderByRecieveDate[i].sigmaerpdev2__AvailableAdjustedQty__c;
                            if(tempQuant>0)
                            {
                                if(tempQuant>=outTempAvalQuant)
                                {
                                    var tempnewILPLI=new Object();
                                    tempnewILPLI.Id=tempILPLIData.ilpliOrderByRecieveDate[i].Id;
                                    tempnewILPLI.enteredQuant=outTempAvalQuant;
                                    newILPLI.push(tempnewILPLI);
                                    outTempAvalQuant-=outTempAvalQuant;
                                    tempILPLIData.ilpliOrderByRecieveDate[i].sigmaerpdev2__AvailableAdjustedQty__c-=outTempAvalQuant;
                                    break;
                                }
                                else{
                                    var tempnewILPLI=new Object();
                                    tempnewILPLI.Id=tempILPLIData.ilpliOrderByRecieveDate[i].Id;
                                    tempnewILPLI.enteredQuant=tempQuant;
                                    newILPLI.push(tempnewILPLI);
                                    outTempAvalQuant-=tempQuant;
                                    tempILPLIData.ilpliOrderByRecieveDate[i].sigmaerpdev2__AvailableAdjustedQty__c-=tempQuant;
                                }
                            }
                        }
                    }
                    //console.log(tempILPLIData);
                    //console.log(newILPLI);
                    component.set("v.ilpliData",newILPLI);
                    productIdRemainILPLIMap[packageLinItems.sigmaerpdev2__Product__c]=tempILPLIData;
                    component.set("v.productIdAvailableQuantMap",productIdAvailableQuantMap);
                    component.set("v.productIdRemainILPLIMap",productIdRemainILPLIMap);
                    component.set("v.isILPLISelectedAutomatiaclly", true);
                    component.set("v.StockSelectedAs","Autopick");
                }
                else
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "error",
                        "type": "error",
                        "message": "No Stock Available!"
                    });
                    resultsToast.fire();
                }
            }
            else
				helper.getILPLIDataForAutopick(component, event, helper);
		}
	},
})