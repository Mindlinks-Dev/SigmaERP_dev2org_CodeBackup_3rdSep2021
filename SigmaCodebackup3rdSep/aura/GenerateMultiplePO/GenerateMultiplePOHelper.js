({
    createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.MultiplePOWrapList");
        console.log('RowItemList>>'+JSON.stringify(RowItemList));
       // alert('RowItemList>>'+JSON.stringify(component.get("v.MultiplePOWrapList")));
        for(var i=0; i<RowItemList.length; i++)
        {
            var reqpro = RowItemList[i].POP.sigmaerpdev2__Product__c;
            console.log('reqpro>>'+JSON.stringify(reqpro));
            console.log('reqpro.length>>'+reqpro);
            if(reqpro == undefined || reqpro == null || reqpro == '')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Please select the product name on row '+ (i + 1) + ' to add a new row ',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
        }
        RowItemList.push({
            'vendorName':'',
            'vendorId':'',
            'status':'Submitted',
            'POSubmitted':'true',
            'POP': {
            'sobjectType': 'sigmaerpdev2__Purchase_Order_Product__c',
            'sigmaerpdev2__Product__c': '',
            'sigmaerpdev2__Buying_Price__c': '0.00',
            'sigmaerpdev2__Total_Buying_Price__c':'0.00',
            'sigmaerpdev2__Expected_Delivery_Date__c':'',
            'sigmaerpdev2__Quantity__c': '0',
            'sigmaerpdev2__Discount__c':'0.00'
            }
            
        });
        // set the updated list to attribute (contactList) again    
        
        component.set("v.MultiplePOWrapList", RowItemList);
        console.log('inside MultiplePOWrapList>>>>>>>>'+JSON.stringify(component.get("v.MultiplePOWrapList")));
   		//fetch PO to Contact checkbox from db
        var CheckPOtoContact = component.get("c.getApprDetails");
        CheckPOtoContact.setCallback(this, function(a) {
         //  alert('response>>'+a.getReturnValue().sigmaerpdev2__PO_to_Contact__c);
            component.set("v.IsPotocontactchecked",a.getReturnValue().sigmaerpdev2__PO_to_Contact__c);
        });
        $A.enqueueAction(CheckPOtoContact);
    },
    // helper function for check if first Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
        var allPOPRows = component.get("v.MultiplePOWrapList");
        var todaysDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var expectedDate = component.get("v.ExpectedDate");
        
        
        
        var isChecked = component.get("v.IsPotocontactchecked");
        if( expectedDate<todaysDate){
                   // alert('hi');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": "PO expected date should not be past date."
                    });
                    toastEvent.fire();
                    return;
                }
        for (var indexVar = 0; indexVar < allPOPRows.length; indexVar++) {
			for(var indexVarj = indexVar+1; indexVarj < allPOPRows.length; indexVarj++)
			{
                 //alert('Expected_Delivery_Date__c'+allPOPRows[indexVar].POP.sigmaerpdev2__Expected_Delivery_Date__c);
                 //alert('Expected_Delivery_Date__c'+allPOPRows[indexVarj].POP.sigmaerpdev2__Expected_Delivery_Date__c);
                if(isChecked)
                { 
                    if((allPOPRows[indexVar].POP.sigmaerpdev2__Product__c == allPOPRows[indexVarj].POP.sigmaerpdev2__Product__c)&& (allPOPRows[indexVar].vendorId == allPOPRows[indexVarj].vendorId) && (allPOPRows[indexVar].vendorLocation == allPOPRows[indexVarj].vendorLocation) &&(allPOPRows[indexVar].POP.sigmaerpdev2__Expected_Delivery_Date__c == allPOPRows[indexVarj].POP.sigmaerpdev2__Expected_Delivery_Date__c) )
                    {
                        isValid = false;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message:'Duplicate details can\'t be created on row number ' + (indexVar + 1) + ' and ' + (indexVarj + 1),
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        return;
                    }
                }
                else
                {
                    if((allPOPRows[indexVar].POP.sigmaerpdev2__Product__c == allPOPRows[indexVarj].POP.sigmaerpdev2__Product__c)&& (allPOPRows[indexVar].vendorId == allPOPRows[indexVarj].vendorId))
                    {
                        isValid = false;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message:'Duplicate details can\'t be created on row number ' + (indexVar + 1) + ' and ' + (indexVarj + 1),
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        return;
                    }
                }
                   
			}
            if (allPOPRows[indexVar].POP.sigmaerpdev2__Product__c == '' || allPOPRows[indexVar].POP.sigmaerpdev2__Product__c == undefined || allPOPRows[indexVar].POP.sigmaerpdev2__Product__c == null) {
                isValid = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Product name can\'t be blank on row number ' + (indexVar + 1),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
           //     alert('Product Name Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
            if (allPOPRows[indexVar].vendorId == '' || allPOPRows[indexVar].vendorId == undefined || allPOPRows[indexVar].vendorId == null) {
                isValid = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Vendor details can\'t be blank for product '+'"'+allPOPRows[indexVar].POP.sigmaerpdev2__Product__r.Name +'"'+' on row number ' + (indexVar + 1) ,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
          }
          if (allPOPRows[indexVar].vendorLocation == '' || allPOPRows[indexVar].vendorLocation == undefined || allPOPRows[indexVar].vendorLocation == null) {
                isValid = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Location is not configured for the selected vendor for product '+'"'+allPOPRows[indexVar].POP.sigmaerpdev2__Product__r.Name +'"'+' on row number ' + (indexVar + 1),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
          }
          if(allPOPRows[indexVar].POP.sigmaerpdev2__Quantity__c == 0 || allPOPRows[indexVar].POP.sigmaerpdev2__Quantity__c < 0)
          {
              var toastEvent = $A.get("e.force:showToast");
              toastEvent.setParams({
                  title : 'Error',
                  message:'Order quantity should not be "0" or "Negative" value for product '+'"'+allPOPRows[indexVar].POP.sigmaerpdev2__Product__r.Name +'"'+' on row number ' + (indexVar + 1),
                  duration:' 5000',
                  key: 'info_alt',
                  type: 'error',
                  mode: 'pester'
              });
              toastEvent.fire();
              return;
          }
          if(allPOPRows[indexVar].POP.sigmaerpdev2__Expected_Delivery_Date__c == undefined || allPOPRows[indexVar].POP.sigmaerpdev2__Expected_Delivery_Date__c == null || allPOPRows[indexVar].POP.sigmaerpdev2__Expected_Delivery_Date__c == '')
          {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Expected delivery date can\'t be blank for product '+'"'+allPOPRows[indexVar].POP.sigmaerpdev2__Product__r.Name +'"'+' on row number ' + (indexVar + 1),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
          }
            if(allPOPRows[indexVar].POP.sigmaerpdev2__Expected_Delivery_Date__c > expectedDate  ){ //allPOPRows[indexVar].POP.sigmaerpdev2__Expected_Delivery_Date__c != expectedDate ||          {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Expected delivery date should not be greater than po expected date '+'"'+allPOPRows[indexVar].POP.sigmaerpdev2__Product__r.Name +'"'+' on row number ' + (indexVar + 1),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
          }
          if(allPOPRows[indexVar].POP.sigmaerpdev2__Expected_Delivery_Date__c < todaysDate)
          {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Expected dilivery date  should not be past date for product '+'"'+allPOPRows[indexVar].POP.sigmaerpdev2__Product__r.Name +'"'+' on row number ' + (indexVar + 1),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
          }
        }
        return isValid;
    },
})