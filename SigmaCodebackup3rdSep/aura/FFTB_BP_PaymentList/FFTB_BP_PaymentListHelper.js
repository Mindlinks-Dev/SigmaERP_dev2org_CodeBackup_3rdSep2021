({
	getDetailsH : function(component, event, helper) {
        var selBP = component.get("v.recordId");
        var froDate = component.get("v.fromDate");
        froDate = froDate +'T00:00:00.000Z';
        var toDate = component.get("v.endDate");
        toDate = toDate +'T23:59:59.000Z';
        
        var totAmt = 0;
        var netPay = 0;
        var disc = 0;
        var sigmaOrdIds = [];
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var action = component.get("c.getBPData");
        action.setParams({ 
            "bpId": selBP,
            "fromDate" : froDate,
            "endDate" : toDate
        });
        action.setCallback(this, function(response) {
            
            if(response.getState() == "SUCCESS"){
                var allValues = response.getReturnValue(); 
                component.set("v.showDetails", true);
                if(allValues.length > 0){
                	var commissionBp = response.getReturnValue()[0].sigmaerpdev2__Brewer_Account__r.sigmaerpdev2__Commision_Fees__c;               
                    component.set("v.bpComm",commissionBp);
                   
                    var comm = component.get("v.bpComm");
                    component.set("v.orderList", allValues);                
                    //component.set("v.showDetails", true);
                    
                    var listVal = component.get("v.orderList");
                    for(var i=0;i<listVal.length;i++){
                        totAmt = totAmt + listVal[i].sigmaerpdev2__TotalAmount__c;                        
                        sigmaOrdIds.push(listVal[i].Id);
                    }
                    component.set("v.sigmaOrdIdList",sigmaOrdIds);
                   
                    component.set("v.totalAmount",totAmt);
                    disc = (comm * totAmt) / 100;
                    component.set("v.deducCommAmt", disc);
                    netPay = totAmt - disc;
                    component.set("v.netPayable",netPay);	
                    component.set("v.amtPaid",netPay);
                }else{
                    component.set("v.orderList", allValues);     
                }
                
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);    
	},
    
    updatePaymentRecordH : function(component, event, helper){
        
        var selBP = component.get("v.recordId");
        var froDate = component.get("v.fromDate");
        var toDate = component.get("v.endDate");
        var totalSalesAmt = component.get("v.totalAmount");
        var deductCommAmt = component.get("v.deducCommAmt");
        var sigOrdsId = component.get("v.sigmaOrdIdList"); 
        var action = component.get("c.makeBPPayments");
        action.setParams({ 
            "bpId": selBP,
            "fromDate" : froDate,
            "endDate" : toDate,
            "totalSalesAmt" : totalSalesAmt,
            "deductCommAmt" : deductCommAmt,
            "sigOrdsId" : sigOrdsId
        });
        
        action.setCallback(this, function(response) {
            
            if(response.getState() == "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Brewery payment record updated successfully!"
                });
                toastEvent.fire();
                component.set("v.openModalPopUp", false);
                $A.get('e.force:refreshView').fire();
            }
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action); 
    }
	
})