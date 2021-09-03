({
	doInit : function(component, event, helper,page) {
        
		page = page || 1;        
       var action = component.get("c.fetchOrderList");
       action.setParams({ pageNumberOrder : page });
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
               var accs = response.getReturnValue(); 
               component.set('v.total', accs.totalOrder);
               component.set('v.page', accs.pageOrder);
               component.set('v.pages', Math.ceil(accs.totalOrder/accs.pageSizeOrder));
               component.set("v.OrderList",accs.OrderList);
           }
           else if (state === "INCOMPLETE") {
               // do something
           }
               else if (state === "ERROR") {
                   var errors = response.getError();
                   if (errors) {
                       if (errors[0] && errors[0].message) {
                           console.log("Error message: " + 
                                       errors[0].message);
                       }
                   } else {
                       console.log("Unknown error");
                   }
               }
       });
       
       $A.enqueueAction(action);
   
		
	},
  Order : function(component, event, helper){
       var action = component.get("c.OrderUsage");
        action.setCallback( this, function(a){
            
            if(a.getReturnValue() != null){
                
                var retval = a.getReturnValue();
               
                        component.set("v.isErrorflag",false);
                        component.set("v.sigmaFlag",true);
                        component.set("v.Listflag",false);
                       
                    
              
                
                
            }
            
        });
        $A.enqueueAction(action);
               },
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
		var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getOrderList(component, event, helper,page);
	},
    handlesoId : function(cmp, event) {
    // alert('event'+ event.getParam("soId") );
        var salesorderId = event.getParam("soId");
        //alert('salesorderId-->>>'+salesorderId);
        if(salesorderId!=undefined && salesorderId!=null && JSON.stringify(salesorderId)!='""')
        {
            cmp.set("v.soId",salesorderId);
            cmp.set("v.isErrorflag",false);
            cmp.set("v.sigmaFlag",true);
            cmp.set("v.Listflag",false);
            
         }
		
    }
})