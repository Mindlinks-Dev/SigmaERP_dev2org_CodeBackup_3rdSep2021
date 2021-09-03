({
    createObjectData: function(component, event) {
        // get the Vplist from component and add(push) New Object to List  
        var RowItemList = component.get("v.Vplist");
        RowItemList.push({
            'sobjectType': 'Vendor_Product__c',
            'Product__r.Name': '',
            'Vendor_Code__c': '',
            'Currenct_Stock__c': '',
            'Price__c':''
        });
        // set the updated list to attribute (Vplist) again    
        component.set("v.Vplist", RowItemList);
    },
   // helper function for check if first Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
        var allContactRows = component.get("v.Vplist");
        for (var indexVar = 0; indexVar < allContactRows.length; indexVar++) {
            if (allContactRows[indexVar].Currenct_Stock__c == '') {
                isValid = false;
                alert('Current stock Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }
        return isValid;
    }
})