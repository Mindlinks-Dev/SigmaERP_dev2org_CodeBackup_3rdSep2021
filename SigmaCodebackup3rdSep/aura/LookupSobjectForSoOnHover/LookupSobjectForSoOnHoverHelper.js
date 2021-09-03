/**
 * (c) Tony Scott. This code is provided as is and without warranty of any kind.
 *
 * This work by Tony Scott is licensed under a Creative Commons Attribution 3.0 Unported License.
 * http://creativecommons.org/licenses/by/3.0/deed.en_US
 */
({
    /**
     * Perform the SObject search via an Apex Controller
     */
    doSearch : function(cmp,event) {
        var searchString = cmp.get('v.searchString');  
        var inputElement = cmp.find('lookup');
        var lookupList = cmp.find('lookuplist');
		var stappOrder = cmp.get("v.stappOrder");
        var sObjectAPIName = cmp.get('v.sObjectAPIName');
        var sObjectId = event.getParam("sObjectId");
       
      
        if(sObjectAPIName =='Account'  || sObjectAPIName =='Order' || sObjectAPIName =='Contact' || sObjectAPIName =='Product2' || sObjectAPIName =='stapplink__Inventory_Location__c' || sObjectAPIName =='stapplink__Inventory_Location_Product__c')
        {
            var toggleText = cmp.find("slds");
            $A.util.addClass(toggleText, 'toggle');
            
            var WsearchString = cmp.get('v.SRString');
           
            inputElement.set('v.errors', null);        
           if (typeof searchString === 'undefined' || searchString.length < 2)
            {
                
                $A.util.addClass(lookupList, 'slds-hide');
                $A.util.removeClass(lookupList, 'slds-show');
                
                return;
            }

        	 $A.util.removeClass(lookupList, 'slds-hide');
             $A.util.addClass(lookupList, 'slds-show');

       		 
             var action = cmp.get('c.lookup');

            action.setAbortable();

             // Set the parameters
            action.setParams({"searchString" : searchString, 
                              "sObjectAPIName" : sObjectAPIName,
                              "WsearchString" : WsearchString});
            // Define the callback
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                // Callback succeeded
                if (cmp.isValid() && state === "SUCCESS")
                {
                    // Get the search matches
                    var matches = response.getReturnValue();
                    //alert(matches);
                    if (matches.length == 0)
                    {
                        cmp.set('v.matches', null);
                        return;
                    }
                    
                   
                    cmp.set('v.matches', matches);
                }
                else if (state === "ERROR") // Handle any error by reporting it
                {
                    var errors = response.getError();
                   
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            //this.displayToast('Error', errors[0].message);
                        }
                    }
                    else
                    {
                        //this.displayToast('Error', 'Unknown error.');
                    }
                }
            });
             
            // Enqueue the action                  
            $A.enqueueAction(action);
            
            
        }else
        {
         
         var customer = cmp.find("forCustomer");
        $A.util.addClass(customer, 'toggle');
        var toggleText = cmp.find("slds");
        $A.util.removeClass(toggleText, 'toggle'); 
            
            // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);        
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 2)
        {
            
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }

        // Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');
        $A.util.addClass(lookupList, 'slds-show');

       
        var WsearchString = cmp.get('v.SRString');
       
        var action = cmp.get('c.lookup');

        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();

        // Set the parameters
        action.setParams({ "searchString" : searchString, 
                           "sObjectAPIName" : sObjectAPIName,
                           "WsearchString" :WsearchString});
                          
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
			
            if (cmp.isValid() && state === "SUCCESS")
            {
                var matches = response.getReturnValue();

                if (matches.length == 0)
                {
                    cmp.set('v.matches', null);
                    return;
                }
                
               cmp.set('v.matches', matches);
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                       // this.displayToast('Error', errors[0].message);
                    }
                }
                else
                {
                    //this.displayToast('Error', 'Unknown error.');
                }
            }
        });
         
        // Enqueue the action                  
        $A.enqueueAction(action);
        
      }
        
       
                
    },

    /**
     * Handle the Selection of an Item
     */
    handleSelection : function(cmp, event) {
        var objectId = this.resolveId(event.currentTarget.id);
        var objectLabel = event.currentTarget.innerText;
       
        console.log('objectId=' + objectId);
        console.log('objectLabel=' + objectLabel);
       
        var updateEvent = cmp.getEvent("updateLookupIdEvent");
        
       
        var instanceId = cmp.get('v.instanceId');
       
        
        updateEvent.setParams({
             "sObjectId" : objectId, "instanceId" : instanceId,"sObjectIdNew" :objectId,
             "VendersObjectId":objectId,"objectLabel":objectLabel
            });
        
            // Fire the event
            updateEvent.fire(); 
        
     
        // Update the Searchstring with the Label
        cmp.set("v.searchString", objectLabel);

        // Hide the Lookup List
        var lookupList = cmp.find("lookuplist");
        $A.util.addClass(lookupList, 'slds-hide');
		$A.util.removeClass(lookupList, 'slds-show');
        
        // Hide the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.addClass(inputElement, 'slds-hide');

        // Show the Lookup pill 
        var lookupPill = cmp.find("lookup-pill");
        $A.util.removeClass(lookupPill, 'slds-hide');

        // Lookup Div has selection
        var inputElement = cmp.find('lookup-div');
        $A.util.addClass(inputElement, 'slds-has-selection');

    },

    /**
     * Clear the Selection
     */
    clearSelection : function(cmp) {
        var clearEvent = cmp.getEvent("clearLookupIdEvent");
       
       
        var instanceId = cmp.get('v.instanceId');
      
        clearEvent.setParams({
            "instanceId" : instanceId
        });
        
        // Fire the event
        clearEvent.fire();

        // Clear the Searchstring
        cmp.set("v.searchString", '');

        // Hide the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        $A.util.addClass(lookupPill, 'slds-hide');
        

        // Show the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.removeClass(inputElement, 'slds-hide');

        // Lookup Div has no selection
        var inputElement = cmp.find('lookup-div');
        $A.util.removeClass(inputElement, 'slds-has-selection');
    },

    /**
     * Resolve the Object Id from the Element Id by splitting the id at the _
     */
    resolveId : function(elmId)
    {
        var i = elmId.lastIndexOf('_');
        return elmId.substr(i+1);
    },

    /**
     * Display a message
     */
    displayToast : function (title, message) 
    {
        var toast = $A.get("e.force:showToast");

        // For lightning1 show the toast
        if (toast)
        {
            //fire the toast event in Salesforce1
            toast.setParams({
                "title": title,
                "message": message
            });

            toast.fire();
        }
        else // otherwise throw an alert
        {
            alert(title + ': ' + message);
        }
    }
})