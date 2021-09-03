({
	 addProducts : function(component,event,helper)
    {
     //   alert('edit flow');
        var Popupval = component.get("v.purchaseOrder");
        //alert(JSON.stringify(Popupval));
        var approved = component.get("v.approve");
        var ReqApprove = component.get("v.Reqapprove");
    
       
        if(approved){
            component.set("v.isOpen", false);
            alert("Once Approval is Accepted,Cannot edit");
            return;
        }else if(ReqApprove){
            component.set("v.isOpen", false);
            alert("Once Order is Requested For Approval,Cannot edit");
            return;
        }else{
          //  alert('edit flow rowindex');
            component.set("v.isOpen", true);
            var rowIndex =event.getSource().get("v.name");
           
            var appEvent  = $A.get("e.c:CarryPOEvent");
            appEvent.setParams({"po" : Popupval[rowIndex],
                                "rowIndex": rowIndex 
                               });
            appEvent.fire();
            
        }
    },
    handleRemoveProductItemClick : function(component, event, helper) {
          
        var self = this;  // safe reference
		 var index = event.target.dataset.index;
        helper.removeProductItem(component, index);
    },
    
    /* getproductimagedata :function (component, event, helper) {
        
          var Popupval = component.get("v.purchaseOrder");
          //alert(JSON.stringify(component.get("v.purchaseOrder")));
          var rowIndex =event.target.dataset.index;
          var appEvent  = $A.get("e.c:CarryPOEvent");
            appEvent.setParams({"po" : Popupval[rowIndex],
                                "rowIndex": rowIndex,
                               });
          
            appEvent.fire();
     
    
    }*/
    getproductimagedata :function (component, event, helper) {
        
       // alert('view product');
         var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
       var Popupval = component.get("v.purchaseOrder");
        var productid = event.getSource().get("v.value");
        SigmaComponentEvent.setParams({
            "data": {
                "ProductID": productid
            },
            "flag": "Viewproductimage"
        });
        SigmaComponentEvent.fire();
    }
    
})