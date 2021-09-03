({
    doInit : function(component, event, helper)
    {
        var recid = component.get("v.recordId");
        // alert('recid>>>'+recid);
        if(recid!=null)
        {
            var action = component.get("c.getProjectData");
            action.setParams
            ({ 
                "recid": recid
            });
            action.setCallback(this, function(res) {
                var state = res.getState();
                // alert('state>>>>'+state);
                // alert('res.getReturnValue()>>>'+res.getReturnValue());
                var getprojdetails = res.getReturnValue();
                
                if (state === "SUCCESS") 
                {
                    //alert('state>>>>'+state);
                    component.set('v.ProjectData', getprojdetails);
                    // alert('afr data set'+JSON.stringify(component.get('v.ProjectData', getprojdetails)));
                    component.set('v.ProjectData.Name',getprojdetails.Name);
                    component.set('v.ProjectData.sigmaerpdev2__Start_Date__c',getprojdetails.sigmaerpdev2__Start_Date__c);
                    component.set('v.ProjectData.sigmaerpdev2__End_Date__c',getprojdetails.sigmaerpdev2__End_Date__c);
                    component.set('v.ProjectData.sigmaerpdev2__Template__c',getprojdetails.sigmaerpdev2__Template__c);
                }
                
            });
            $A.enqueueAction(action);
        }
        
    },
    doRefresh:function(component, event, helper)
    {
        var recid = component.get("v.recordId");
        // alert('recid>>>'+recid);
        if(recid!=null)
        {
            var action = component.get("c.getProjectData");
            action.setParams
            ({ 
                "recid": recid
            });
            action.setCallback(this, function(res) {
                var state = res.getState();
                // alert('state>>>>'+state);
                // alert('res.getReturnValue()>>>'+res.getReturnValue());
                var getprojdetails = res.getReturnValue();
                
                if (state === "SUCCESS") 
                {
                    //alert('state>>>>'+state);
                    component.set('v.ProjectData', getprojdetails);
                    // alert('afr data set'+JSON.stringify(component.get('v.ProjectData', getprojdetails)));
                    component.set('v.ProjectData.Name',getprojdetails.Name);
                    component.set('v.ProjectData.sigmaerpdev2__Start_Date__c',getprojdetails.sigmaerpdev2__Start_Date__c);
                    component.set('v.ProjectData.sigmaerpdev2__End_Date__c',getprojdetails.sigmaerpdev2__End_Date__c);
                    component.set('v.ProjectData.sigmaerpdev2__Template__c',getprojdetails.sigmaerpdev2__Template__c);
                }
                
            });
            $A.enqueueAction(action);
        }
    },
    cancelButton:function(cmp, event){
        // alert('go back');
        // window.location.reload();
        $A.get("e.force:closeQuickAction").fire();
    },
    RedirectGantt : function(component, event, helper)
    {
        var Gantturl = component.get("c.getGanttURL");
        Gantturl.setCallback(this, function(a) {
            //  alert('response>>'+a.getReturnValue().sigmaerpdev2__GanttURL__c);
            component.set("v.vfHost",a.getReturnValue().sigmaerpdev2__GanttURL__c);
        });
        
        $A.enqueueAction(Gantturl);
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:LoadGantt",
            componentAttributes: {
                recordId : component.get("v.recordId")
            }
        });
        evt.fire();
        
        /* var recid = component.get("v.recordId");
       // alert('loading gantt..');
        component.set("v.isopen",true);
        window.open('/apex/sigmaerpdev2__GanttChart?Id='+recid,"_self"); 
        */
    },
})