({
    doInit: function(component, event, helper) {
		//alert('doinit')        
        helper.WorkOrderDetails(component,event);
        //component.set("v.showLoadingSpinner",true); 
        
    },
    SaveAssignAgent : function(component, event, helper){
        //helper.SaveAssignAgentDetails(component,event);
        component.set("v.AssignAgentSuccessMsg",true); 
    },
    CancelAssignAgent : function (component, event, helper){
         var dismissActionPanel = $A.get("e.force:closeQuickAction");
         dismissActionPanel.fire();
    },
    confirmedSaveAgent  : function (component, event, helper){
        //alert('doinit2')
        helper.SaveAssignAgentDetails(component,event);
        
       
    },
    handleComponentEvent  : function (component, event, helper){
        var message = event.getParam("slotDetails");
        //alert(">>"+message);
        
        component.set("v.slotWODetails",message);
    },
    closeMessage: function(component, event, helper) {
        component.set("v.AssignAgentSuccessMsg", false);
        
    },
    
    closeUserMessage: function(component, event, helper) {
        component.set("v.showMessage", false);        
    },
    
    TechnicianSearch: function(component, event, helper) {
        component.set("v.isSpinnertoLoad",true);
        component.set("v.enableProductDetailSection",false);
        var searchTextId =component.find("searchTechnician");
        var searchText=searchTextId.getElement().value;
       
        if(searchText.length>=3){
            //helper.getSearchTechnician(component,event);
            helper.InitialListOfTechnicians(component,event, searchText);
        }else if(searchText == null ||  searchText==''){
            helper.InitialListOfTechnicians(component,event, '');
        }
        else{
            alert("Please enter atleast 3 characters.");
           
        }  
        
    }
})