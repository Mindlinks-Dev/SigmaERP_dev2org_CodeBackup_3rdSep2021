({
	getILPLIDataForManSelect: function (component, event, helper) {
        //alert(JSON.stringify(component.get("v.packageLinItems")));
        var action = component.get("c.fetchILPLIDataForManualSelection");
        //alert(component.get("v.compId"));
        action.setParams({
            "prodID": component.get("v.packageLinItems.sigmaerpdev2__Product__c"),
            "locId": component.get("v.locId"),
            "compId": component.get("v.compId")
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                //alert(JSON.stringify(a.getReturnValue().length));
                //alert(JSON.stringify(a.getReturnValue()));
                if (a.getReturnValue().length > 0) {
                    var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
                    var tempILPLIData=[];
                    for(var i=0;i<a.getReturnValue().length;i++)
                    {
                        //alert(a.getReturnValue()[i].Id);
                        if(ilpliIdAllocatedQuantMap[a.getReturnValue()[i].Id])
                        {
                            a.getReturnValue()[i].sigmaerpdev2__AvailableAdjustedQty__c-=ilpliIdAllocatedQuantMap[a.getReturnValue()[i].Id];
                            if(a.getReturnValue()[i].sigmaerpdev2__AvailableAdjustedQty__c>0)
                                tempILPLIData.push(a.getReturnValue()[i]);
                        }
                        else
                        {
                            tempILPLIData.push(a.getReturnValue()[i]);
                        }
                    }
                    component.set("v.tempILPLIData", tempILPLIData);
                    component.set("v.openSelectMalual", true);
                } else {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "error",
                        "type": "error",
                        "message": "No Stock Available!"
                    });
                    resultsToast.fire();
                }
            } else {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "error",
                    "message": "Error while getting ILPLI data for this Product."
                });
                resultsToast.fire();
            }
        });
        $A.enqueueAction(action);
    },
     getILPLIDataForAutopick: function (component, event, helper) {
        var action = component.get("c.fetchILPLIDataForAutoPick");
        //alert(component.get("v.compId"));
        action.setParams({
            "prodID": component.get("v.packageLinItems.sigmaerpdev2__Product__c"),
            "locId": component.get("v.locId"),
            "compId": component.get("v.compId"),
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            //alert(state);
            if (state === "SUCCESS") {
                //alert(JSON.stringify(a.getReturnValue().ilpliOrderByExpiryDate));
                //alert(a.getReturnValue().ilpliOrderByExpiryDate.length);
                //alert(JSON.stringify(a.getReturnValue().ilpliOrderByRecieveDate));
                //alert(a.getReturnValue().ilpliOrderByRecieveDate.length);
                var tempILPLIData = a.getReturnValue();
                //console.log(tempILPLIData);
                var requirderQuant = component.get("v.packageLinItems.sigmaerpdev2__Quantity__c");
                var availStock = 0;
                for (var i = 0; i < tempILPLIData.ilpliOrderByExpiryDate.length; i++) {
                    availStock += tempILPLIData.ilpliOrderByExpiryDate[i].sigmaerpdev2__AvailableAdjustedQty__c;
                }
                for (var i = 0; i < tempILPLIData.ilpliOrderByRecieveDate.length; i++) {
                    availStock += tempILPLIData.ilpliOrderByRecieveDate[i].sigmaerpdev2__AvailableAdjustedQty__c;
                }
                if (availStock < requirderQuant) {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "error",
                        "type": "error",
                        "message": "No Stock Available!"
                    });
                    resultsToast.fire();
                }
                else {
                    var newILPLI=[];
                    var outTempAvalQuant=component.get('v.packageLinItems.sigmaerpdev2__Quantity__c');
                    for (var i = 0; i < tempILPLIData.ilpliOrderByExpiryDate.length; i++){
                        var tempQuant=tempILPLIData.ilpliOrderByExpiryDate[i].sigmaerpdev2__AvailableAdjustedQty__c;
                        if(tempQuant>=outTempAvalQuant)
                        {
                            var tempnewILPLI=new Object();
                            tempnewILPLI.Id=tempILPLIData.ilpliOrderByExpiryDate[i].Id;
                            tempnewILPLI.enteredQuant=outTempAvalQuant;
                            newILPLI.push(tempnewILPLI);
                            tempILPLIData.ilpliOrderByExpiryDate[i].sigmaerpdev2__AvailableAdjustedQty__c-=outTempAvalQuant;
                            outTempAvalQuant-=outTempAvalQuant;
                            break;
                        }
                        else{
                            var tempnewILPLI=new Object();
                            tempnewILPLI.Id=tempILPLIData.ilpliOrderByExpiryDate[i].Id;
                            tempnewILPLI.enteredQuant=tempQuant;
                            newILPLI.push(tempnewILPLI);
                            outTempAvalQuant-=tempQuant;
                            tempILPLIData.ilpliOrderByExpiryDate[i].sigmaerpdev2__AvailableAdjustedQty__c-=tempQuant;
                        }
                    }
                    if(outTempAvalQuant>0)
                    {
                        for (var i = 0; i < tempILPLIData.ilpliOrderByRecieveDate.length; i++) {
                            var tempQuant=tempILPLIData.ilpliOrderByRecieveDate[i].sigmaerpdev2__Available_Quantity__c;
                            if(tempQuant>=outTempAvalQuant)
                            {
                                var tempnewILPLI=new Object();
                                tempnewILPLI.Id=tempILPLIData.ilpliOrderByRecieveDate[i].Id;
                                tempnewILPLI.enteredQuant=outTempAvalQuant;
                                newILPLI.push(tempnewILPLI);
                                tempILPLIData.ilpliOrderByRecieveDate[i].sigmaerpdev2__AvailableAdjustedQty__c-=outTempAvalQuant;
                                outTempAvalQuant-=outTempAvalQuant;
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
                    component.set("v.ilpliData",newILPLI);
                    //console.log(newILPLI);
                    component.set("v.isILPLISelectedAutomatiaclly", true);
                    component.set("v.StockSelectedAs","Autopick");
                    //console.log(tempILPLIData);
                    var productIdAvailableQuantMap=component.get('v.productIdAvailableQuantMap');
                    var productIdRemainILPLIMap=component.get('v.productIdRemainILPLIMap');
                    //alert(JSON.stringify(productIdAvailableQuantMap));
                    if(productIdAvailableQuantMap[component.get('v.packageLinItems.sigmaerpdev2__Product__c')]==undefined)
                    {
                        productIdAvailableQuantMap[component.get('v.packageLinItems.sigmaerpdev2__Product__c')]=availStock-requirderQuant;
                        productIdRemainILPLIMap[component.get('v.packageLinItems.sigmaerpdev2__Product__c')]=tempILPLIData;
                    }
                    component.set('v.productIdAvailableQuantMap',productIdAvailableQuantMap);
                    component.set('v.productIdRemainILPLIMap',productIdRemainILPLIMap);
                    //alert('last '+JSON.stringify(component.get('v.productIdAvailableQuantMap')));
                    /*var StappComponentEvent = component.getEvent("StappComponentEvent");
                    StappComponentEvent.setParams({
                        "data" : {"prodId":component.get('v.packageLinItems.stapp__Product__c'),"availQuant":availStock-requirderQuant,"tempILPLIData":tempILPLIData},
                        "flag" : "autoPickFlag"
                    });
                    StappComponentEvent.fire();*/
                }
            }
            else {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "error",
                    "message": "Error while getting ILPLI data for this Product."
                });
                resultsToast.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
})