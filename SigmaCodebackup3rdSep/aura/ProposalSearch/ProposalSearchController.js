({
	myAction : function(component, event, helper) {
		
	},
    toggle: function(component, event, helper) {
        var items = component.get("v.POList"); 
        var chevronright = component.find('chevronright');
        var chevrondown = component.find('chevrondown');
        
        $A.util.toggleClass(chevronright, 'slds-hide');
        $A.util.toggleClass(chevrondown, 'slds-hide');
        var getAttributeValue = component.get("v.checkThis");
        if(getAttributeValue==true){
            component.set("v.checkThis", false);
            component.set('v.expanded',false);
        }
        else{
            component.set("v.checkThis", true);
            component.set('v.expanded',true);
        }
       
    },
    toggle1: function(component, event, helper) {
        var items = component.get("v.POList"); 
        var chevronright = component.find('chevronright1');
        var chevrondown = component.find('chevrondown1');
        
        $A.util.toggleClass(chevronright, 'slds-hide');
        $A.util.toggleClass(chevrondown, 'slds-hide');
        var getAttributeValue = component.get("v.checkThis1");
        if(getAttributeValue==true){
            component.set("v.checkThis1", false);
            component.set('v.expanded1',false);
        }
        else{
            component.set("v.checkThis1", true);
            component.set('v.expanded1',true);
        }
       
    },
    FetchProp : function(component, event, helper,page) {        
        var spinner = component.find("mySpinner");
    	$A.util.toggleClass(spinner, "slds-hide");
        page = page || 1;
        
        var propdet = component.get("v.propdetails");
        component.set("v.proposalObjectList",propdet);
        if(propdet.sigmaerpdev2__End_Date__c != '' && propdet.sigmaerpdev2__End_Date__c != null){
        	if(propdet.sigmaerpdev2__Start_Date__c > propdet.sigmaerpdev2__End_Date__c){           
                component.set("v.errorText",'Start Date must be lesser than End Date.');
                component.set("v.isErrorflag",true);          
                //component.set("v.expanded1",false);
            }else{
                component.set("v.isErrorflag",false);
            }    
        }else{
            component.set("v.errorText",'');
            component.set("v.isErrorflag",false);
        }
        
        //alert('propdet>>>>>>>>>>>'+JSON.stringify(propdet));
        
        var action = component.get("c.FetchProposal");
        action.setParams({ pageNumber : page,
                          propdetail : JSON.stringify(component.get("v.proposalObjectList")) 
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('state>>>>>>'+state);
            if (state === "SUCCESS") {
                var spinner = component.find("mySpinner");
    			$A.util.toggleClass(spinner, "slds-hide");
                var propres = response.getReturnValue();
                component.set('v.total', propres.total);
                component.set('v.page', propres.page);                
                component.set('v.pages', Math.ceil(propres.total/propres.pageSize));
                //component.set('v.EditFlag', propres.ProdEditFlag);
                //component.set('v.RecordId', propres.RecordId);
                component.set("v.PropList",propres);
                component.set("v.expanded1", true);                
                //alert('PropList>>>>>'+JSON.stringify(component.get("v.PropList")));
            }else if (state === "ERROR") {
                var spinner = component.find("mySpinner");
    			$A.util.toggleClass(spinner, "slds-hide");
                var errors = response.getError();
                alert('Error occured while fetching Proposals : '+errors);
            }
        });
        $A.enqueueAction(action);
    },
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getPropList(component, event, helper,page);
    },
    
    cancel: function (component, event, helper) {
        window.location.reload();        
    }
})