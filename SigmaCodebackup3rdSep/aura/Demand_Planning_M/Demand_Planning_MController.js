({
    doInit : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        if($A.get("$Browser.formFactor") == "PHONE")
        component.set('v.mobileScreenFlag',true);
        
	},
     print : function(component, event, helper) {
        window.print();
    },
	FetchCustInfo : function(component, event, helper) {
        window.scrollTo(0, 0);
        var fromDate = component.get("v.selFromDate");
        var toDate = component.get("v.selToDate");
        var pageNumber = component.get("v.PageNumber");         
        var pageSize = component.get("v.recToDisplay");         
        
        //validation starts from here
        var fromDate = component.get("v.selFromDate");
        var toDate = component.get("v.selToDate");                     
		var ProductId = component.get("v.recordId");      
        
        if(ProductId == '' || ProductId == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": "Select value for the Product field."
            });
            toastEvent.fire();
            return;
        }
        
        if(fromDate == '' || fromDate == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": "Enter value for From Date."
            });
            toastEvent.fire();
            return;
        }

		if(toDate == '' || toDate == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": "Enter value for To Date."
            });
            toastEvent.fire();
            return;
        }                
        
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");                
       
	    helper.fetchCustInfoH(component, pageNumber, pageSize);
               
	},
    lookupChanged : function(component, event, helper){        
        //component.set("v.PageNumber", 1); 
         var ProductId=component.get("v.recordId");
        if(ProductId)
        {
          var action = component.get("c.fetchCatogeryInfo");
             action.setParams({
            "prodId" :ProductId
           
                  });
        
         action.setCallback(this, function(response){
			var state = response.getState();   
            if( response.getReturnValue().sigmaerpdev2__Product_Type__c)
            {
               component.set("v.categoryid", response.getReturnValue().sigmaerpdev2__Product_Type__c);
            
            }
                 else
            {
                component.set("v.categoryid",'NONE');
            }
        
                   
        });
        $A.enqueueAction(action);  
        }
        else
        {
           component.set("v.categoryid",'') 
          // component.set("v.totalbackorderqty",0);
        }
         
	
    },  
        
  
    clear : function(component, event, helper){ 
       	component.set("v.recordId",'');
        component.set("v.recordName",'');
        component.set("v.search",'');
        component.set("v.finalList",'');
        component.set("v.categoryid",'');
        component.set("v.selFromDate",'');
        component.set("v.selToDate",'');
        component.set("v.status",'');
        component.set("v.totalbackorderqty",0);
        component.set("v.expanded",false);  
   
        // $A.get('e.force:refreshView').fire();
        return;
      
    },
     handleNext: function(component, event, helper) {
        window.scrollTo(0, 0); 
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");  
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.recToDisplay");
        pageNumber++;
        helper.fetchCustInfoH(component, pageNumber, pageSize);
    },
     
    handlePrev: function(component, event, helper) {
        window.scrollTo(0, 0); 
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");  
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.recToDisplay");
        pageNumber--;
        helper.fetchCustInfoH(component, pageNumber, pageSize);
    }, 
     pdfdownload : function(component, event, helper){
        var prodid =  component.get("v.recordId");
         var fromDate = component.get("v.selFromDate");
         var toDate = component.get("v.selToDate");
          var status =component.get("v.status");
         var recordName = component.get("v.recordName");
        //alert('recordName>>>>'+recordName);
        var url = '/apex/sigmaerpdev2__demandplanningpdf?productid='+prodid+'&fromdate='+fromDate+'&toDate='+toDate+'&status='+status+'&prodname='+recordName;
        window.open(url);
    },
})