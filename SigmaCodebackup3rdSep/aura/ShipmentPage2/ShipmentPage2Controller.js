({  doInit : function(component, event, helper,page) { 
   // alert("doInit"+page);
       // var spinner = component.find("mySpinner");
      //  $A.util.toggleClass(spinner, "slds-hide");
        helper.getShipmentList(component, event, helper,page);
        
        
    },
  
    selectShipment : function(component, event, helper) 
    {
        component.set("v.isshipmentFlag",true);
        component.set("v.Listflag",false);
    },
    handleShipment : function(cmp, event) {
        // alert('event.getParam("shipmentId")');
        var shipId = event.getParam("shipmentId");
       // alert('event.getParam("shipmentId")'+shipId);
        if(shipId!=undefined && shipId!=null && JSON.stringify(shipId)!='""')
        { 
            cmp.set("v.shipId",shipId);
            cmp.set("v.isshipmentFlagWithId",true);
            cmp.set("v.isshipmentFlag",false);
            cmp.set("v.Listflag",false);
         }
    },
  pageChange: function(component, event, helper) {
       // alert('pageChange');
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getShipmentList(component, event, helper,page);
    },


})