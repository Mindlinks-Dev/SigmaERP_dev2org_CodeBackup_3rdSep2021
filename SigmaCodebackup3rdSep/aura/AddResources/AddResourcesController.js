({
    getDetails : function(component)
    {	
        var resourceid = component.get('v.resourceObject.sigmaerpdev2__Resource__c');
//         alert('doinit>>'+resourceid);
        if(component.get("v.Edit")==undefined)
            component.set("v.Edit",false);
        //console.log('resourceID1-->'+JSON.stringify(component.get("v.resourceID")));
        if(component.get("v.resourceID")!=null && component.get("v.resourceID")!=undefined && component.get("v.resourceID")!='')
        {
           
            var action = component.get("c.getResourceInfo");
            action.setParams({ resourceID : component.get("v.resourceID")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.addResObject.addResource",response.getReturnValue());
                    component.set("v.addResObject.oldID",response.getReturnValue().sigmaerpdev2__Resource__c);
                }
                else if (state === "INCOMPLETE") {
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
        if(component.get("v.Edit")==true )
        {
             //alert('edit');
            component.set("v.resourceObject.Id",component.get("v.Editingdata.allocresId"));
            //   component.set("v.resourceObject.RecordTypeId",component.get("v.Editingdata.recType"));
            component.set("v.resourceObject.sigmaerpdev2__Resource__c",component.get("v.Editingdata.ResourceId"));
            component.set("v.resourceObject.sigmaerpdev2__Resource__r.Name",component.get("v.Editingdata.ResourceName"));
            component.set("v.resourceObject.sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c",component.get("v.Editingdata.ResourceRoles"));
            //  component.set("v.resourceObject.sigmaerpdev2__Start_Date__c",component.get("v.Editingdata.StartDate"));
            //  component.set("v.resourceObject.sigmaerpdev2__End_Date__c",component.get("v.Editingdata.EndDate"));
            component.set("v.resourceObject.sigmaerpdev2__Manufacturing_Run__c",component.get("v.Editingdata.ManufacturingRun"));
      }
      // alert('hi'+component.get("v.Editingdata.allocresId"));
    /*    if(!resourceid)
         {
             alert('null');
             component.set('v.resourceObject.sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c','');  
         }*/
    },
    
    
    saveResource: function (component, event, helper){
        component.set("v.spinner",true);
       // alert('hi caled by save method');
        var ManuID= component.get("v.MRResID"); 
        
        var resourceData =component.get("v.resourceObject");
       // alert('hi caled by resourceData'+JSON.stringify(component.get("v.resourceObject")));
        //var  startdate = new Date(resourceData.sigmaerpdev2__Start_Date__c);
        //resourceData.sigmaerpdev2__Start_Date__c = startdate ;
        //var  enddate = new Date(resourceData.sigmaerpdev2__End_Date__c);
        //resourceData.sigmaerpdev2__End_Date__c = enddate ;
        var testingdata = JSON.stringify(resourceData);
       // alert('hi caled by resourceData'+testingdata);
        var ResourceAction = component.get("c.fetchMRResource");
        ResourceAction.setParams({					
            "manfRunId": ManuID
        });
        ResourceAction.setCallback(this, function (response) {
            var state = response.getState();	
            
            if(state == 'SUCCESS'){
                // alert('hi caled by state'+state);
                component.set("v.resourceList",response.getReturnValue());
                //alert('response.getReturnValue>>'+JSON.stringify(response.getReturnValue())); 
                
                var sizeOfResourcesAdded = component.get("v.resourceList").length;
                var selNewResID = component.get("v.resourceList"); 
                if(sizeOfResourcesAdded>0)
                {
                    for(var i=0;i<=sizeOfResourcesAdded-1;i++)
                    {
                        if(selNewResID[i].sigmaerpdev2__Resource__c == resourceData.sigmaerpdev2__Resource__c)
                        {
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"error",
                                "title": "Error!",
                                "message": " Selected Resource already has been added to the Resource Planning."
                            });
                            toastEvent.fire(); 
                            component.set("v.isAlradyExist",true);
                            return;
                        }
                    }
                }
                
                if(!component.get("v.isAlradyExist")){
                    
                    var action = component.get("c.saveResourceObject");
                    action.setParams({ resource : testingdata,
                                      ManuID:ManuID });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        // var result = response.getReturnValue();
                        if (state == "SUCCESS") {
                            component.set("v.spinner",false);
                            alert('Resource Added to the Manufacturing Run Process!!');
                            
                            var callEve = $A.get("e.c:AddResourceHandler");
                            /*  callEve.setParams({
                            "objectdata": response.getReturnValue(),"flag": "AddresourceList"
                        	});*/
                            // newresourceList.push(resourceObject);
                            callEve.fire();
                            component.find("popupmodal1").notifyClose();
                            
                        }
                        else if (state === "INCOMPLETE") {
                        }
                            else if (state == "ERROR") {
                                var errors = response.getError();
                                if (errors) {
                                    if (errors[0] && errors[0].message) {
                                        console.log("Error message: " + 
                                                    errors[0].message);
                                    }
                                } else {
                                    console.log("Unknown error");	
                                }
                            }
                    });
                    $A.enqueueAction(action);
                }
            }
            
        });
        $A.enqueueAction(ResourceAction); 
        
        if(resourceData.sigmaerpdev2__Resource__c=='' || resourceData.sigmaerpdev2__Resource__c==null || resourceData.sigmaerpdev2__Resource__c==undefined  )
        {
            /* component.set("v.message",'Please add the Resource to Manufacturing Run');
            component.set("v.showMessage",true);
            return;*/
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Warning!",
                "message": "Please Enter Resource Name."
            });
            toastEvent.fire();
            return;
        }
        /*
        var startDate = component.get("v.resourceObject.sigmaerpdev2__Start_Date__c");
        var endDate = component.get("v.resourceObject.sigmaerpdev2__End_Date__c");
        if(endDate < startDate){            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "End date must be greater than Start date."
            });
            toastEvent.fire(); 
            component.set("v.resourceObject.sigmaerpdev2__End_Date__c", '');              
            return;
        }
        // alert('came');
        */
        
        
        
    },
    
    SelectedID:function(component, event, helper){
       
        var resourceid = component.get('v.resourceObject.sigmaerpdev2__Resource__c');

        var action = component.get("c.fetchResourceData");
        action.setParams({
            "resourceid": resourceid
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state=== 'SUCCESS')
            {
                var resource = response.getReturnValue();
                if(resourceid)
                {
					component.set('v.resourceObject.sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c',resource.sigmaerpdev2__Roles__c);     
                }
                
            }
         });
        $A.enqueueAction(action); 
       
    },
    closeSelectPopupModal:function(component, event, helper){
        component.set("v.popupmodal1",false);//changed false to true by Sarah
        component.find("popupmodal1").notifyClose();
    },   
    
})