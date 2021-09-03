({
    showPopupHelper: function(component, componentId, className)
    {
        
        var modal = component.find(componentId); 
        $A.util.removeClass(modal, className+'hide'); 
        $A.util.addClass(modal, className+'open'); 
    },
    VBOMwindow: function(component, event, helper)
    {
        var invtID = component.get("v.InventoryID");
       
       	var url;
        var action = component.get("c.getDebutUrl");
        action.setCallback( this, function(response) {
            url= action.getReturnValue();
          
            var ret = url.replace('.my.salesforce.com','');
        	
            window.open(ret+"--stapplink.eu11.visual.force.com/apex/Update_VirtualBOM_PackLevel?id="+invtID, "MsgWindow", "scrollbars=yes,resizable=yes");
        });
        $A.enqueueAction(action);
      
    },
	
	
	fetchTransLineItems: function(component,event, transId) {		        
		var transLineId = transId;
       
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "slds-hide");
        var action = component.get("c.fetchLineItems");        
        action.setParams({			
			"transIdObj": component.get("v.transId"),
            "transLineItemId": transLineId                  
        	});            
        action.setCallback(this, function(response) {            
            var state = response.getState();
			 component.set("v.transLineListNew",response.getReturnValue());            
			var spinner = component.find('spinner');
        	$A.util.addClass(spinner, "slds-hide");            
                });
        $A.enqueueAction(action);
	},	
    
    //added on 15/11/2017
    hidePopupHelper: function(component, componentId, className){       
        var modal = component.find(componentId);         
        $A.util.addClass(modal, className+'hide'); 
        $A.util.removeClass(modal, className+'open');        
    }
   
})