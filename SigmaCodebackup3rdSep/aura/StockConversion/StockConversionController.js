({
    doInit : function(component, event, helper){
        var record = component.get('v.recordId');
        helper.onPageLoad(component, event, record);
    },
    
    selectTab : function(component, event, helper) 
    {
       /* var selfRefreshEvt = component.getEvent("selfRefreshEvtindtockconv");
        selfRefreshEvt.fire();*/
        
       /* var selfRefreshEvtforTabs = component.getEvent("selfRefreshEvtforTabs");
        selfRefreshEvtforTabs.setParams({
            "selfRefreshEvt" : "selfRefreshEvt"
        });
        selfRefreshEvtforTabs.fire();*/
       
        var proj='hiii';
        var ProjectPhasesEvent = $A.get("e.c:selfRefreshEvt"); 
        ProjectPhasesEvent.setParams({'selfRefreshEvttab': proj}); 
        //alert('event fired'+proj);
        ProjectPhasesEvent.fire();
        
        var tab = event.getSource().get('v.id');
        component.set("v.disTab",tab);
    }
    
})