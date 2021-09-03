({
	fetchCustInfoH : function(component, pageNumber, pageSize) { 
        var fromDate = component.get("v.selFromDate");
        var toDate = component.get("v.selToDate");        
      //  var cType = component.get("v.custType");          
		var ProductId = component.get("v.recordId");
        
      //  var statType = component.get("v.statusType");
      //  var salesInvoiceFilter = component.get("v.salesInvoiceFilter");
        var status =component.get("v.status");
        //alert('ProductId==='+ProductId);
        var action = component.get("c.fetchCustomerInfo");        
        action.setParams({
            "prodId" :ProductId,
            "pageNumber":pageNumber,
            "pageSize":pageSize,
            "fromDate" :fromDate,
            "toDate" : toDate,
            "status" :status
            
        });
        action.setCallback(this, function(response){
			var state = response.getState();            
            
            if(state == "SUCCESS"){
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");   
                
                component.set("v.expanded", true);
                if(response.getReturnValue() != null){
                    window.scrollTo(0, 500); 
                   // alert('value'+response.getReturnValue());
                	component.set("v.finalList", response.getReturnValue());                	
                	component.set("v.rowLength", response.getReturnValue().stappOrderList.length);
                    
                    component.set("v.PageNumber", response.getReturnValue().pageNumber);
                    component.set("v.TotalRecords", response.getReturnValue().totalRecords);
                    component.set("v.RecordStart", response.getReturnValue().recordStart);
                    component.set("v.RecordEnd", response.getReturnValue().recordEnd);
                    component.set("v.TotalPages", Math.ceil(response.getReturnValue().totalRecords / pageSize));
                    component.set("v.totalbackorderqty", response.getReturnValue().totalqty);
                    component.set("v.availqty", response.getReturnValue().availqunt);
                }else{
                   component.set("v.finalList", "");                	
                   component.set("v.rowLength", 0); 
                }                                         
            }else if(state === "ERROR") {
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");   
				component.set("v.expanded", false);                
                var errors = response.getError();
                alert('Error occured while fetching Customer Informations : '+JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
	},
    
	CustInfoH : function(component, pageNumber, pageSize) { 
        var fromDate = component.get("v.selFromDate");
        var toDate = component.get("v.selToDate");        
      //  var cType = component.get("v.custType");          
		var ProductId = component.get("v.recordId");
        
      //  var statType = component.get("v.statusType");
      //  var salesInvoiceFilter = component.get("v.salesInvoiceFilter");
        var status =component.get("v.status");
        //alert('ProductId==='+ProductId);
        var action = component.get("c.customerInfo");        
        action.setParams({
            "prodId" :ProductId,
            "pageNumber":pageNumber,
            "pageSize":pageSize,
            "fromDate" :fromDate,
            "toDate" : toDate,
            "status" :status
            
        });
        action.setCallback(this, function(response){
			var state = response.getState();            
            
            if(state == "SUCCESS"){
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");   
                
                component.set("v.expanded", true);
                if(response.getReturnValue() != null){
                    window.scrollTo(0, 500); 
                   // alert('value'+response.getReturnValue());
                	component.set("v.finalList", response.getReturnValue());                	
                	component.set("v.rowLength", response.getReturnValue().stappOrderList1.length);
                    
                    component.set("v.PageNumber", response.getReturnValue().pageNumber);
                    component.set("v.TotalRecords", response.getReturnValue().totalRecords);
                    component.set("v.RecordStart", response.getReturnValue().recordStart);
                    component.set("v.RecordEnd", response.getReturnValue().recordEnd);
                    component.set("v.TotalPages", Math.ceil(response.getReturnValue().totalRecords / pageSize));
                    component.set("v.totalbackorderqty", response.getReturnValue().totalqty);
                    component.set("v.availqty", response.getReturnValue().availqunt);
                }else{
                   component.set("v.finalList", "");                	
                   component.set("v.rowLength", 0); 
                }                                         
            }else if(state === "ERROR") {
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");   
				component.set("v.expanded", false);                
                var errors = response.getError();
                alert('Error occured while fetching Customer Informations : '+JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
	}
})