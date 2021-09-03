({
    onfocus : function(component,event,helper){
       // alert(component.get("v.SearchKeyWord"));
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = component.get("v.SearchKeyWord")? component.get("v.SearchKeyWord"):'';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
        // get the search Input keyword  
        
        var getInputkeyWord = component.get("v.SearchKeyWord");
       // alert('21>>>'+getInputkeyWord)
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
     var pillTarget = component.find("lookup-pill");
		  var lookUpTarget = component.find("lookupField"); 
		 
		  $A.util.addClass(pillTarget, 'slds-hide');
		  $A.util.removeClass(pillTarget, 'slds-show');
		 
		  $A.util.addClass(lookUpTarget, 'slds-show');
		  $A.util.removeClass(lookUpTarget, 'slds-hide');
         
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );
         component.set("v.recordID",'' );
         component.set("v.recordName", '');
     },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
      // alert('caught in parent'+selectedAccountGetFromEvent);
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
         //alert('caught in parent'+JSON.stringify(selectedAccountGetFromEvent.Name));
       
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);
         
       
      // alert('selected-->'+JSON.stringify(selectedAccountGetFromEvent.Name));
      //  alert('69---'+JSON.stringify(component.get("v.selectedRecord")));
        console.log('selected-->'+JSON.stringify(selectedAccountGetFromEvent))
        component.set('v.recordID',selectedAccountGetFromEvent.Id);
          component.set('v.recordName',selectedAccountGetFromEvent.Name);
        let isSigmaOrder=component.get("v.isSigmaOrder");
        console.log('isSigmaOrder'+isSigmaOrder);
        if(component.get("v.isSigmaOrder")==true)
        {
           // alert(component.get('v.objectAPIName'));
            let apiName=component.get('v.objectAPIName'); console.log('apiName'+apiName);
            if(apiName==='sigmaerpdev2__Inventory_Location__c')component.set('v.recordName',selectedAccountGetFromEvent.sigmaerpdev2__Location__r.Name);
             else if(apiName==='Account')component.set('v.recordName',selectedAccountGetFromEvent.Name);
          else if(apiName==='sigmaerpdev2__Vendor_Product__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
                 else if(apiName==='Product2')component.set('v.recordName',selectedAccountGetFromEvent.Name);
                else if(apiName==='sigmaerpdev2__Tax_Code__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
               else if(apiName==='Contact')component.set('v.recordName',selectedAccountGetFromEvent.Name);
                else if(apiName==='sigmaerpdev2__Tax_Treatment__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
                else if(apiName==='sigmaerpdev2__Company__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
            //else if(apiName==='Account')component.set('v.recordName',selectedAccountGetFromEvent.Name);
            else if(apiName==='sigmaerpdev2__Package__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
            else component.set('v.recordName',selectedAccountGetFromEvent.Name);
           //alert('90>>>>'+component.get("v.recordName"))
        }else{
            
            let apiName=component.get('v.objectAPIName'); console.log('apiName'+apiName);
            
             if(apiName==='sigmaerpdev2__Inventory_Location__c')component.set('v.recordName',selectedAccountGetFromEvent.sigmaerpdev2__Location__r.Name);    
            else if(apiName==='Account')component.set('v.recordName',selectedAccountGetFromEvent.Name);
           else if(apiName==='Product2')component.set('v.recordName',selectedAccountGetFromEvent.Name);
                else if(apiName==='sigmaerpdev2__Tax_Code__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
               else if(apiName==='Contact')component.set('v.recordName',selectedAccountGetFromEvent.Name);
                else if(apiName==='sigmaerpdev2__Tax_Treatment__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
                else if(apiName==='sigmaerpdev2__Company__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
                else if(apiName==='sigmaerpdev2__Package__c')component.set('v.recordName',selectedAccountGetFromEvent.Name);
            
                 else component.set('v.recordName',selectedAccountGetFromEvent.OrderNumber);
        }
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
    //To Create Contact Starts  
    createContact : function(component, event, helper) {
        var StappComponentEvent = component.getEvent("SigmaComponentEvent");
        StappComponentEvent.setParams({
            "data": {
                "createContactFlag":true
            },
            "flag": "CreateContact"
        });
        StappComponentEvent.fire();
    }
    //To Create Contact Ends  
})