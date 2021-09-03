({
      productTitle : function(component, event, helper) {		
        var sldsSection = component.find('sldsSection');
        $A.util.toggleClass(sldsSection, 'slds-is-open');
	},
    highlight : function(component, event, helper) {
        var buttonsldsSection = component.find('buttonsldsSection');
        $A.util.addClass(buttonsldsSection, 'highlight');
    }
    
})