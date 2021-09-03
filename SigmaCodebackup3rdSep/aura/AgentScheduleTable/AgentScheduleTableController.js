({
	doInit : function(component, event, helper) {
        var today = new Date();
        component.set('v.fromDate',  today.getFullYear()+ "-" + (today.getMonth() + 1) + "-" + ((today.getDate() < 10 ? '0' : '') + today.getDate()));
		helper.doInitHelper(component,event);
	},
    getOutputDate : function(component, event, helper) {
        //debugger;
        var enteredDate = component.find("datefield").get("v.value");
        component.set('v.fromDate',enteredDate);
        helper.doInitHelper(component,event);
        
        var today = new Date();
        today = today.getFullYear()+ "-" + (today.getMonth() + 1) + "-" +today.getDate();
        var from = new Date(today);
        var to = new Date(enteredDate);
        
        
        if(from == to){
            //component.set('v.hideChevronLeft',true); 
        }
        else if(to < from){
            component.set('v.isPast',true);
            //component.set('v.hideChevronLeft',true); 
        }
        else{
            component.set('v.hideChevronLeft',false);
            component.set('v.isPast',false);
        }
        helper.getWOADetails(component,event); 
    },
    closeWindow: function(component, event, helper) {
        debugger;
        var value = component.find('picklistvalue').get('v.value');
        if(value != ""){
           component.set('v.picklistValue',value);
           helper.getWOADetails(component,event);
        }
        else{
            component.set('v.message',"Please Choose a Territory");
            component.set('v.isOpen',true);
        }
    },
    
    handleClickLeft: function(component, event, helper) {
        debugger;
        var enteredDate = component.find("datefield").get("v.value");
        var picklistval = component.find("picklistvalue").get("v.value");
        
        //Subtracting date by one day.
        var dt = new Date(enteredDate);
        dt.setDate(dt.getDate() - 1);
        dt = dt.getFullYear()+ "-" + (dt.getMonth() + 1) + "-" +dt.getDate();
        
        component.set('v.picklistValue',picklistval);
        component.set('v.fromDate',dt);
        
        var today = new Date();
        today = today.getFullYear()+ "-" + (today.getMonth() + 1) + "-" +today.getDate();
        var from = new Date(today);
        var to = new Date(dt);
        
        if(from == to){
            //component.set('v.hideChevronLeft',true); 
        }
        else if (to < from){
            component.set('v.isPast',true);
            //component.set('v.hideChevronLeft',true); 
        }
        else{
            component.set('v.hideChevronLeft',false);
            component.set('v.isPast',false);
        }
        helper.getWOADetails(component,event);
    },
    handleClickRight: function(component, event, helper) {
        debugger;
        var enteredDate = component.find("datefield").get("v.value");
        var picklistval = component.find("picklistvalue").get("v.value");
        
        //Adding date by one day.
        var dt = new Date(enteredDate);
        dt.setDate(dt.getDate() + 1);
        dt = dt.getFullYear()+ "-" + (dt.getMonth() + 1) + "-" +dt.getDate();
        
        component.set('v.picklistValue',picklistval);
        component.set('v.fromDate',dt);
        
        //Comparing Today's Date and 
        var today = new Date();
        today = today.getFullYear()+ "-" + (today.getMonth() + 1) + "-" +today.getDate();
        var from = new Date(today);
        var to = new Date(dt);
        
        if(from == to){
            //component.set('v.hideChevronLeft',true); 
        }
        else if (to < from){
            component.set('v.isPast',true);
            //component.set('v.hideChevronLeft',true); 
        }
        else{
            component.set('v.hideChevronLeft',false);
            component.set('v.isPast',false);
        }
		
        helper.getWOADetails(component,event);
    },
})