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
        // Get the search string, input element and the selection container
        var searchString = cmp.get('v.searchString'); 
        //alert(searchString);
        var inputElement = cmp.find('lookup');
        var lookupList = cmp.find('lookuplist');

        var sObjectAPIName = cmp.get('v.sObjectAPIName');
      //alert('sObjectAPIName:'+sObjectAPIName);
        var sObjectId = event.getParam("sObjectId");

        if(sObjectAPIName ==='Account'  || sObjectAPIName ==='sigmaerpdev2__Sigma_Order__c' || sObjectAPIName ==='Order'  || sObjectAPIName ==='Contact' || sObjectAPIName ==='Product2' || sObjectAPIName ==='Product2Rental' || sObjectAPIName ==='sigmaerpdev2__Inventory_Location__c' || sObjectAPIName ==='sigmaerpdev2__Inventory_Location_Product__c'|| sObjectAPIName==='Order' || sObjectAPIName ==='sigmaerpdev2__Lot__c'||sObjectAPIName==='sigmaerpdev2__Inventory__c' || sObjectAPIName=== 'sigmaerpdev2__SubscriptionDetail__c' || sObjectAPIName==='sigmaerpdev2__Subscription_Line_Item__c' || sObjectAPIName==='sigmaerpdev2__Currency__c'||sObjectAPIName=== 'sigmaerpdev2__Sublevel_location__c' || sObjectAPIName==='sigmaerpdev2__Project_Resource__c' ||sObjectAPIName==='sigmaerpdev2__Resource__c'||sObjectAPIName ==='sigmaerpdev2__Tax_Treatment__c'  ||sObjectAPIName ==='sigmaerpdev2__Tax_Code__c'||sObjectAPIName ==='sigmaerpdev2__Company__c'    )
        {
            //alert('sObjectAPIName'+sObjectAPIName)
            var toggleText = cmp.find("slds");
            $A.util.addClass(toggleText, 'toggle');
           
            var WsearchString = cmp.get('v.SRString');
            inputElement.set('v.errors', null);        
            if (typeof searchString === 'undefined' || searchString.length < 2)
            {
                // Hide the lookuplist
                $A.util.addClass(lookupList, 'slds-hide');
                $A.util.removeClass(lookupList, 'slds-show');
                return;
            }
        	// Show the lookuplist
       		 $A.util.removeClass(lookupList, 'slds-hide');
             $A.util.addClass(lookupList, 'slds-show');

       		 // Get the API Name
       		 // var sObjectAPIName = cmp.get('v.sObjectAPIName');

       		 // Create an Apex action
             var action = cmp.get('c.lookup');

             // Mark the action as abortable, this is to prevent multiple events from the keyup executing
             action.setAbortable();
			
          // alert('search string'+searchString);
           //alert('sObjectAPIName'+sObjectAPIName);
            //alert('WsearchString'+WsearchString);
             // Set the parameters
            action.setParams({"searchString" : searchString, 
                              "sObjectAPIName" : sObjectAPIName,
                              "WsearchString" : WsearchString});
            //alert('before call action function');             
            // Define the callback
            action.setCallback(this, function(response) {
                var state = response.getState();
              // alert('state>>'+state);
                // Callback succeeded
                if (cmp.isValid() && state === "SUCCESS")
                {
                    // Get the search matches
                    var matches = response.getReturnValue();
                  	 //alert('matches>>'+JSON.stringify(matches));
                    // If we have no matches, return nothing
                    if (matches.length === 0)
                    {
                        cmp.set('v.matches', null);
                        return;
                    }
                    
                    // Store the results
                    cmp.set('v.matches', matches);
                    //alert(JSON.stringify(cmp.get('v.matches')));
                }
                else if (state === "ERROR") // Handle any error by reporting it
                {
                    var errors = response.getError();
                    //alert('Error Is:: '+errors);
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
           //alert('Char');
          // 
         //alert(' INSIDE else OF LOOKUPSOBJECT SOBJECT APINAME CHECK CONDITION **'+sObjectAPIName);
         var customer = cmp.find("forCustomer");
        $A.util.addClass(customer, 'toggle');
        var toggleText1 = cmp.find("slds");
        $A.util.removeClass(toggleText1, 'toggle'); 
            
            // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);        
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 2)
        {
            // Hide the lookuplist
          
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }

        // Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');
        $A.util.addClass(lookupList, 'slds-show');

        // Get the API Name
      
        var WsearchString1 = cmp.get('v.SRString');
      	var WsearchString2 = cmp.get('v.SRString1'); 		// code added on FFP mearge
        // Create an Apex action
        action = cmp.get('c.lookup');
		var action = cmp.get('c.lookup');//Previous declaration
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();

        // Set the parameters
        action.setParams({ "searchString" : searchString, 
                           "sObjectAPIName" : sObjectAPIName,
                           "WsearchString" :WsearchString1,
                         "WsearchString1":WsearchString2});
                          
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
			//alert(response.getState());
            // Callback succeeded
            if (cmp.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var matches = response.getReturnValue();

                // If we have no matches, return nothing
                if (matches.length === 0)
                {
                    cmp.set('v.matches', null);
                    return;
                }
                
                // Store the results
                cmp.set('v.matches', matches);
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
               // alert('Error Is:: '+errors);
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
        
      }//Close of Else
        
       
                
    },

    /**
     * Handle the Selection of an Item
     */
    handleSelection : function(cmp, event) {
        // Resolve the Object Id from the events Element Id (this will be the <a> tag)
        var objectId = this.resolveId(event.currentTarget.id);
		
        // The Object label is the inner text)
        var objectLabel = event.currentTarget.innerText;
        
		//var newlst =cmp.get("v.acclst");
      
        // Log the Object Id and Label to the console
        console.log('objectId=' + objectId);
        console.log('objectLabel=' + objectLabel);
       // alert('objectId::'+objectId); 
       // alert('objectLabel : '+objectLabel);
        // Create the UpdateLookupId event
        var updateEvent = cmp.getEvent("updateLookupIdEvent");
        
        // Get the Instance Id of the Component
        var instanceId = cmp.get('v.instanceId');
    console.log('instanceId=' + instanceId);
        // alert('instanceId : '+instanceId);
         updateEvent.setParams({
             "sObjectId" : objectId, "instanceId" : instanceId,"sObjectIdNew" :objectId,
                "VendersObjectId":objectId,"objectLabel":objectLabel
            });
       
            // Fire the event
            updateEvent.fire(); 
        
      
        // Update the Searchstring with the Label
        
        cmp.set("v.recID",objectId);//set productId to recID - added for Proposal Product
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
        var inputElement1 = cmp.find('lookup-div');
        $A.util.addClass(inputElement1, 'slds-has-selection');

    },

    /**
     * Clear the Selection
     */
    clearSelection : function(cmp) {
        // Create the ClearLookupId event
        var clearEvent = cmp.getEvent("clearLookupIdEvent");

        // Get the Instance Id of the Component
        var instanceId = cmp.get('v.instanceId');
      //  alert(instanceId);
        //alert(cmp.get("v.recID"));

        // Populate the event with the Instance Id
        clearEvent.setParams({
            "instanceId" : instanceId
        });
        
        // Fire the event
        clearEvent.fire();
       // alert('v.searchString'+cmp.get('v.searchString'));

        // Clear the Searchstring
        cmp.set("v.searchString", '');
        cmp.set("v.recID",'');

        // Hide the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        $A.util.addClass(lookupPill, 'slds-hide');
        

        // Show the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.removeClass(inputElement, 'slds-hide');

        // Lookup Div has no selection
        var inputElement1 = cmp.find('lookup-div');
        $A.util.removeClass(inputElement1, 'slds-has-selection');
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