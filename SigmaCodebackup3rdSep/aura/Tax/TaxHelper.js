({
    fetchTax : function(cmp,event){
        
        var action = cmp.get('c.getTax');
        var customerSFId = cmp.get('v.recordId');
        
        action.setParams({
            "customerSFID" : customerSFId 
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            
            if (cmp.isValid() && state === 'SUCCESS')
            {
                
                var matches = response.getReturnValue();
                
                //alert(matches[0].sigmaerpdev__Status__c);
                if (matches.length === 0)
                {
                    cmp.set('v.FederalTax', null);
                    cmp.set('v.StateTax', null);
                    cmp.set('v.TaxType', null);
                    cmp.set('v.TaxOnBillAmount', null);
                    return;
                }
                
                var FederalStatus = matches[0].sigmaerpdev__Status__c;
                var StateStatus = matches[1].sigmaerpdev__Status__c;
                
                var FederalTax;
                if(FederalStatus === 'Active'){            
                    FederalTax= matches[0].sigmaerpdev__Tax_Amount__c;
                }
                else{
                    FederalTax = 0;
                }
                var federalTaxType = matches[0].sigmaerpdev__Type__c;
                
                if(StateStatus === 'Active'){ 
                    var StateTax = matches[1].sigmaerpdev__Tax_Amount__c;
                }
                else{
                    StateTax = 0;
                }
                var StateTaxType = matches[1].sigmaerpdev__Type__c;
                
                
                var BillAmount = cmp.get("v.TotalProductAmount");
                var TaxOnBillAmount = '';
                var TotalBillAmount = '';
                var NetTotalBillAmount = '';
                
                if(FederalStatus === 'Active'){                               
                    if(federalTaxType === 'Percentage'){
                        TaxOnBillAmount = (BillAmount * FederalTax)/100;
                    }else{
                        TaxOnBillAmount = BillAmount + FederalTax;
                    }
                }
                else{
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'FederalTax Status',
                        mode: 'sticky',
                        message: 'FederalTax Status is "Inactive" Please make it as Active for applying ,or no FederalTax  For This country',
                        type : 'warning'
                    });
                    toastEvent.fire();*/
                    alert('FederalTax Status is "Inactive" Please make it as Active for applying ,or no FederalTax  For This country');
                   
                }
                
                if(StateStatus === 'Active'){
                    if(StateTaxType === 'Percentage'){
                        TaxOnBillAmount = (TaxOnBillAmount + (BillAmount * StateTax)/100);
                    }else{
                        TaxOnBillAmount = (TaxOnBillAmount + (BillAmount + StateTax));
                    }
                }
                else{
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'StateTax Status',
                        mode: 'sticky',
                        message: 'StateTax Status is "Inactive", Please make it as Active for applying Tax ,or no StateTax  For This State',
                        type : 'warning'
                    });
                    toastEvent.fire();*/
                    alert('StateTax Status is "Inactive", Please make it as Active for applying Tax ,or no StateTax  For This State');
                }
                
                TaxOnBillAmount = parseFloat(TaxOnBillAmount).toFixed(2);
                cmp.set('v.FederalTax', FederalTax);
                cmp.set('v.StateTax', StateTax);
                //cmp.set('v.ProdTax', ProdTax);
                cmp.set('v.flatTaxType',federalTaxType);
                cmp.set('v.stateTaxType',StateTaxType);
                //cmp.set('v.prodTaxType',ProdTaxType);
                if(TaxOnBillAmount >=0){
                    cmp.set('v.TaxOnBillAmount', TaxOnBillAmount);
                }
                else{
                    cmp.set('v.TaxOnBillAmount', 0);
                }
                
                cmp.find("federalTaxId").set("v.value",FederalTax);
                cmp.find("stateTaxId").set("v.value",StateTax);
                //cmp.find("prodTaxId").set("v.value",ProdTax);
                var spinners = cmp.find('spinner');
                $A.util.removeClass(spinners, 'slds-show');
                
                NetTotalBillAmount = parseFloat(BillAmount) + parseFloat(TaxOnBillAmount);
                
                NetTotalBillAmount = parseFloat(NetTotalBillAmount).toFixed(2);
                if(NetTotalBillAmount >=0){
                    cmp.set('v.totalBillAmountValue',NetTotalBillAmount);
                }
                else{
                    cmp.set('v.totalBillAmountValue',BillAmount);
                }
               
            }
            else if (state === 'ERROR') // Handle any error by reporting it
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        alert('Error'+errors[0].message);
                        
                    }
                }
                else
                {
                    alert('Error Unknown Error:');
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        cmp.set('v.mainblock',true);
    }
})