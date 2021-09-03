({
   selectVendorModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
    onClickCheckBox : function(component, event, helper) {
         var cmpEvent = component.getEvent("MultiplePOEvt");
       // var IsSelected = component.get("v.Innerwrapper.IsSelected");  "IsSelected" : IsSelected
        cmpEvent.setParams({
            "rowIndex" : component.get('v.itemIndex') ,
            "flag" : "SelectedAccount",
            "RecordID" : component.get('v.MultiplePO.Account.Id'),
            "IsSelected" : component.get('v.MultiplePO.isSelected')
         });
        
        cmpEvent.fire();
        
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
   closeVendorModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.isModalOpen", false);
   },
})