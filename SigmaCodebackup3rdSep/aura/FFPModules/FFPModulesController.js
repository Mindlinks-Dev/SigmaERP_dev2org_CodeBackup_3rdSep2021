({
    doInit : function(component, event, helper) {
        var action = component.get("c.getProfileName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.profName", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    redirToWorkOrder: function(cmp, event, helper) { 
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Work_Order__c"
        });
        homeEvent.fire();*/
        
        var url = '/lightning/o/sigmaerpdev2__Work_Order__c/list'; 
        window.open(url,'_blank'); 
    },
    
    redirToWorkOrderTechn : function(cmp, event, helper) { 
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Work_Order__c"
        });
        homeEvent.fire();
    },
    
    redirToWorkType : function(cmp, event, helper) {
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Work_Type__c"
        });
        homeEvent.fire();*/
       
        var url = '/lightning/o/sigmaerpdev2__Work_Type__c/list?filterName=Recent'; 
        window.open(url,'_blank');        
        
    },
    redirToWorkBinding : function(cmp, event, helper) {
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Work_T__c"
        });
        homeEvent.fire();*/
                
        var url = '/lightning/o/sigmaerpdev2__Work_T__c/list?filterName=Recent'; 
        window.open(url,'_blank');       
        
    },
    redirToServQ : function(cmp, event, helper) { 
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Service_Quote__c"
        });
        homeEvent.fire();*/
        
        var url = '/lightning/o/sigmaerpdev2__Service_Quote__c/list?filterName=Recent'; 
        window.open(url,'_blank');        
        
    },
    redirToServRes : function(cmp, event, helper) {
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Service_Resource__c"
        });
        homeEvent.fire();*/
        var url = '/lightning/o/sigmaerpdev2__Service_Resource__c/list?filterName=Recent'; 
        window.open(url,'_blank');   
    },
    redirToServContracts : function(cmp, event, helper) { 
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Service_Contract__c"
        });
        homeEvent.fire();*/
        var url = '/lightning/o/sigmaerpdev2__Service_Contract__c/list?filterName=Recent'; 
        window.open(url,'_blank');       
    },
    
    redirToProdReqAdmin : function(cmp, event, helper){
    	/*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Product_Request__c"
        });
        homeEvent.fire(); */
        
        var url = '/lightning/n/sigmaerpdev2__PRMain'; 
        window.open(url, '_blank');       
    },
    
    redirToProdReqTechn : function(cmp, event, helper) {  
       /* var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Product_Request__c"
        });
        homeEvent.fire();*/
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:PRMain"
        });
        evt.fire();
        
        
        /* var url = '/lightning/o/sigmaerpdev2__Product_Request__c/list?filterName=Recent'; 
        window.open(url,'_blank'); */       
    },
    redirToProdTrf : function(cmp, event, helper) {  
       /* var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Product_transfer__c"
        });
        homeEvent.fire();*/
        var url = '/lightning/o/sigmaerpdev2__Product_transfer__c/list?filterName=Recent'; 
        window.open(url,'_blank');        
    },
    redirToBusical : function(cmp, event, helper) {
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev2__Business_Calendar__c"
        });
        homeEvent.fire();*/
                
        var url = '/lightning/o/sigmaerpdev2__Business_Calendar__c/list?filterName=Recent'; 
        window.open(url,'_blank');
       
    },
    redirToRoute : function(cmp, event, helper) { 
        /* var homeEvent = $A.get("e.force:navigateToObjectHome"); 
        homeEvent.setParams({ "scope": "myNamespace__myObject__c" }); 
        homeEvent.fire();*/
       var urlEvent = $A.get( "e.force:navigateToURL" );    
        var url = 'https://sigma-mvp-dev2-dev-ed.lightning.force.com/lightning/n/sigmaerpdev2__RouteMap';
        urlEvent.setParams({ "url":  url});
        urlEvent.fire( );
        
        /*var url = '/lightning/n/sigmaerpdev2__RouteMap'; 
        window.open(url,'_blank'); */      
    },    
    redirToFSC : function(cmp, event, helper) {  
        var urlEvent = $A.get( "e.force:navigateToURL" );
        var url = 'https://sigma-mvp-dev2-dev-ed.lightning.force.com/lightning/n/sigmaerpdev2__Field_Stock_Check';
        urlEvent.setParams({ "url":  url});
        urlEvent.fire( );
        
        /*var url = '/lightning/n/sigmaerpdev2__Field_Stock_Check'; 
        window.open(url,'_blank');*/      
    },   
    closeInfo : function(component, event, helper){		        
        component.set("v.showWorkIcons", false);
    },
    showInfo :  function(component, event, helper){        
        component.set("v.showWorkIcons", true);
    },
    closeInfo2 : function(component, event, helper){		        
        component.set("v.showServiceIcons", false);
    },
    showInfo2 :  function(component, event, helper){        
        component.set("v.showServiceIcons", true);
    },
    closeInfo3 : function(component, event, helper){		        
        component.set("v.showProdIcons", false);
    },
    showInfo3 :  function(component, event, helper){        
        component.set("v.showProdIcons", true);
    },
    closeInfo4 : function(component, event, helper){		        
        component.set("v.showOtherIcons", false);
    },
    showInfo4 :  function(component, event, helper){        
        component.set("v.showOtherIcons", true);
    } 
})