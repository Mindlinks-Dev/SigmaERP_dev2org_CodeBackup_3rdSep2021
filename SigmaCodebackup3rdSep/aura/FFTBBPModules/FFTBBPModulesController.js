({
	closeInfo : function(component, event, helper){		        
        component.set("v.showIcons", false);
    },
    showInfo :  function(component, event, helper){        
        component.set("v.showIcons", true);
    },
    showBPCustomers : function(component, event, helper){
        component.set("v.showModules", true);        
        component.set("v.showBPCustomers", true);
        component.set("v.showBPSales", false);
        component.set("v.showBPStock", false);
        component.set("v.showBPInv", false);
    },
    showBpSales : function(component, event, helper){
        component.set("v.showModules", true);        
        component.set("v.showBPCustomers", false);             
        component.set("v.showBPSales", true);
        component.set("v.showBPStock", false);
        component.set("v.showBPInv", false);
    },
    showBPProducts : function(component, event, helper){
        component.set("v.showModules", true); 
        component.set("v.showBPStock", true);         
        component.set("v.showBPCustomers", false);             
        component.set("v.showBPSales", false);
        component.set("v.showBPInv", false); 
    },
    
    showBPPrdInv : function(component, event, helper){
        component.set("v.showModules", true); 
        component.set("v.showBPStock", false);         
        component.set("v.showBPCustomers", false);             
        component.set("v.showBPSales", false);
        component.set("v.showBPInv", true); 
    },
})