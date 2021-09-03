({
    doInit: function (component, event, helper)
    {
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
        
           component.set("v.LightView",true);
        } 
      
        else {
        
           component.set("v.LightView",false);
        }
    },
	openRecords : function(component, event, helper){
        
       /* var temp = component.get("v.sigmaList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
        */
        var PropList =  component.get("v.PropList.Id");
       
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
           
             sforce.one.navigateToSObject(PropList, 'detail');
            } 

            else {
                 
                 window.location.href = "/"+PropList;
            }
    },
    dropdown : function (component, event, helper)
    { 
        var dropdownContent = component.find('dropdownContent');
        $A.util.toggleClass(dropdownContent, 'slds-is-open');
    }, 
    Navigate: function(component, event , helper)
    {
       var proId= component.get("v.PropList.Id");
        var rec  = component.get("v.PropList");
        var usagetype = rec.sigmaerpdev2__Usage_Type__c;
        if(usagetype == 'Service'){
            
      // window.location = '/apex/ProposalPage?Id='+proId;
        component.set("v.proposalid",proId); 
         component.set("v.maincomp",false); 
         component.set("v.iseditproposal",true); 
        }else{
           
           // window.location = '/apex/ProposalforProduct?Id='+proId; 
           
             component.set("v.proposalid",proId); 
         component.set("v.maincomp",false); 
         component.set("v.PropProdFlag",true); 
        }
        
      /*  var action = component.get("c.fetchProposalList");
        action.setCallback(this,function(a){
            if(a.getReturnValue != null){
               var result = a.getReturnValue;
                alert(result.Usage_Type__c);
               
            }
        });
        $A.enqueueAction(action); */ 
    },
    handleDeleteprop : function(component, event, helper){
        var propId = component.get("v.PropList");
        var result = confirm("Are you sure to delete this Record?");
        if (result) {            
            var action = component.get("c.deleteproposal"); 
            action.setParams({
                "propId" : propId.Id
            });
            action.setCallback( this, function(response2) {
                var state2 = response2.getState();                
                if (state2 === "SUCCESS"){
                    alert('Record deleted Successfully.');
                    window.location.reload();
                    // $A.get('e.force:refreshView').fire();
                    
                }
            });
            $A.enqueueAction(action);
        }            

    }
})