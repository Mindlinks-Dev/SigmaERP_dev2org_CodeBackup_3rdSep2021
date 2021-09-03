({
    doInit : function(component, event, helper) {
       // helper.getAccontRecord(component); 
    },
    removeProd : function(component, event, helper) 
    {
        var POevent = component.getEvent("POevent");
        alert('ind>>'+component.get('v.indexNum'));
        POevent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "removePro"
        });
        POevent.fire();
    },
    addRow: function(component, event, helper) {
        helper.addAccountRecord(component, event);
    },
    handleSelectedAccount :function (component, event, helper)
    {
        var flag = event.getParam('flag');
        var rowIndex = event.getParam('rowIndex');
        var RecordID = event.getParam('RecordID');
        var IsSelected = event.getParam('IsSelected');
        component.set("v.IsSelected",IsSelected);
        
        var AccountList = component.get("v.MultiplePO.Account");
        console.log('AccountList>>'+JSON.stringify(AccountList));
        component.set("v.AccountName",AccountList[rowIndex].Account.Name);
        component.set("v.AccountId",AccountList[rowIndex].Account.Id );
        console.log('AccountName>>'+componnet.get("v.AccountName"));
        console.log('AccountId>>'+componnet.get("v.AccountId"));
        for(var j = 0 ; j<AccountList.length ; j++)
        {
            if(AccountList[j].isSelected ==true && j!=rowIndex)
            {
                AccountList[j].isSelected = false;
            }
            
        }
        component.set("v.MultiplePO.Account",AccountList);
    },
    
    removeRow: function(component, event, helper) {
        //Get the account list
        var accountList = component.get("v.accountList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        accountList.splice(index, 1);
        component.set("v.accountList", accountList);
    },
    
    save: function(component, event, helper) {
        if (helper.validateAccountList(component, event)) {
            helper.saveAccountList(component, event);
        }
    },
    selectVendorModel:function(component, event, helper) {
        // Set isModalOpen attribute to true
         component.set("v.isModalOpen", true);
       
        
        var action = component.get("c.getAccountRecord");
        
        action.setParams({
            "productID": component.get("v.TempPurchaseOrderProducts.sigmaerpdev2__Product__c")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = JSON.stringify(response.getReturnValue());
           // alert('result--->>'+result);
            
            if (component.isValid() && state === "SUCCESS")
                component.set("v.MultiplePOWrapper", response.getReturnValue());   
            alert('inside select vendor'+JSON.stringify(component.get("v.MultiplePOWrapper.vpdata")));
            
        });
        $A.enqueueAction(action);
       // helper.getAccontRecord(component); 
        
        
    },
    closeVendorModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    onClickCheckBox : function(component, event, helper) {
        
        var checkval=  event.getSource().get('v.checked');
        alert(event.getSource().get('v.checked'));
        var vendorName=component.get("v.accLst[0].Name");
        alert(component.get("v.accLst[0].Name"));
        if(checkval==true) {
            component.set("v.accountList[0].vendorName",vendorName);
            alert('vendorName>>>'+component.get("v.accountList[0].vendorName"));
        }
        else{
            component.set("v.accountList[0].vendorName","");
        }
    },
    submitDetails : function(component, event, helper) 
    {
        
        var vendorList = component.get("v.accLst");
        alert('vendorList'+JSON.stringify(vendorList));
        var vendProdList = component.get("v.accountList");
        alert('vendProdList'+JSON.stringify(vendProdList));
        var selectedtLists = [];
        for(var i=0;i<vendorList.length;i++)
        {
            //  alert('vendorList'+JSON.stringify(vendorList[i].Name));
            if(vendorList[i].isSelected == true){
                alert('hi'+i);
                var vendorName=vendorList[i].Name;
                selectedtLists.push(vendorList[i].isSelected);
                
                alert('vendorName>>>>>>>>'+vendorName);
                //for(var i=0;i<vendProdList.length;i++)
                //{
                component.set("v.acc[0].vendorName",vendorName);
                alert('vendorName>>>'+component.get("v.acc[0].vendorName"));
                // }
            }
            else{
                component.set("v.acc[0].vendorName","");
            }
        }
        component.set("v.isModalOpen", false);
    }
})