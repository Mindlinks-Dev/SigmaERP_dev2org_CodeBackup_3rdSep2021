({
	closeInfo : function(component, event, helper){		        
        component.set("v.showIcons", false);
    },
    showInfo :  function(component, event, helper){        
        component.set("v.showIcons", true);
    },
    showBpPayments : function(component, event, helper){
        component.set("v.showModules", true);        
        component.set("v.showBPPayments", true);
		component.set("v.showBPConfigs", false);  
        component.set("v.showBPs", false);
    },
    showBPConfiguration : function(component, event, helper){
        component.set("v.showModules", true);        
        component.set("v.showBPPayments", false);
		component.set("v.showBPConfigs", true);
        component.set("v.showBPs", false); 
    },
    showBP : function(component, event, helper){
        component.set("v.showModules", true);        
        component.set("v.showBPPayments", false);
        component.set("v.showBPConfigs", false);
		component.set("v.showBPs", true);     
    },
})