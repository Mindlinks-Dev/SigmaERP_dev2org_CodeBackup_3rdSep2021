({
    doInit : function(component, event, helper)
    {
        var recid = component.get("v.recordId");
        
        var action1 = component.get("c.getsubscriptionStatus");
        action1.setCallback(this, function(res){ 
            component.set("v.status", res.getReturnValue());
            
        });
        $A.enqueueAction(action1);
        
        var actionTier = component.get("c.getsubscriptionTier");
        actionTier.setCallback(this, function(res1){
            component.set("v.subTier", res1.getReturnValue());
            
        });
        $A.enqueueAction(actionTier);
        
        var action3 = component.get("c.getBillingfrequency");
        action3.setCallback(this, function(res) {
            component.set("v.Billingfrequency", res.getReturnValue());
        });
        $A.enqueueAction(action3);
        
        var action4 = component.get("c.getsubscriptionduration");
        action4.setCallback(this, function(res) {
            component.set("v.duration", res.getReturnValue());
        });
        $A.enqueueAction(action4);
        
        var action2 = component.get("c.getAccsub");
        action2.setParams
        ({ 
            "recid": recid
        });
        action2.setCallback(this, function(res) {
            var state = res.getState();
            var getsubdetails = res.getReturnValue();
            if (state === "SUCCESS") 
            {
                // alert('getsubdetails>>'+JSON.stringify(res.getReturnValue()));
                if(getsubdetails.sigmaerpdev2__Product_Name__c !=undefined)
                {
                    var msg = "You can't Upgrade Order selected Usage Type as Product/Service base subscription.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isblurtrue",true);
                    return;
                    
                }
                if(getsubdetails.sigmaerpdev2__Status__c !='Active')
                {
                    var msg = "Subscription should be Active Status.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isblurtrue",true);
                    return;
                    
                }
                if(getsubdetails.sigmaerpdev2__Subscription_Line_Item__r.sigmaerpdev2__Usage_Type__c=='Product')
                {
                    var msg = "You can't Upgrade Order selected  Usage Type as Product/Service  base subscription.";
                    component.set("v.errorMsg", msg);
                    component.set("v.isblurtrue",true);
                    return;  
                }
                component.set('v.recordName', getsubdetails.sigmaerpdev2__Subscription_Line_Item__r.Name);
                component.set('v.AccSubscriptions.sigmaerpdev2__Subscription_Line_Item__c',getsubdetails.sigmaerpdev2__Subscription_Line_Item__c);
                component.set('v.recordName1', getsubdetails.sigmaerpdev2__Account__r.Name);
                component.set('v.AccSubscriptions.sigmaerpdev2__Account__c',getsubdetails.sigmaerpdev2__Account__c);
                if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='1 Month')
                {
                    var duration=1;
                }
                else if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='3 Month')
                {
                    var duration=3;
                }
                    else if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='6 Month')
                    {
                        var duration=6;
                    }
                        else if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='12 Month')
                        {
                            var duration=12;
                        }
                component.set("v.interval",duration);
                component.set("v.totalcharges",getsubdetails.sigmaerpdev2__Amount__c);
                var today = new Date();    
                var someDate = new Date(getsubdetails.sigmaerpdev2__End_Date__c);
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var yyyy = today.getFullYear();
                
                component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
                component.set('v.enddate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
                var enddate = component.get("v.enddate");
                var date = component.get("v.today");
                
                
                // Additional code by chandu for upgrade
                var Accsubscription = component.get("v.AccSubscriptions.sigmaerpdev2__Subscription_Line_Item__c");
                var action3= component.get("c.getsubscriptionDetails");
                action3.setParams
                ({ 
                    "subname": Accsubscription
                    
                });
                action3.setCallback( this, function(res) 
                                    {
                                        var state = res.getState();
                                        var getsub = res.getReturnValue();
                                        if (state === "SUCCESS") 
                                        {
                                            component.find("subTier").set("v.value", getsub.sigmaerpdev2__Subscription__r.sigmaerpdev2__Subscription_Tier__c);
                                            if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='1 Month')
                                            {
                                                var duration=1;
                                            }
                                            else if(getsub.sigmaerpdev2__Subscription_Duration__c=='3 Months')
                                            {
                                                var duration=3;
                                            }
                                                else if(getsub.sigmaerpdev2__Subscription_Duration__c=='6 Months')
                                                {
                                                    var duration=6;
                                                }
                                                    else if(getsub.sigmaerpdev2__Subscription_Duration__c=='12 Months')
                                                    {
                                                        var duration=12;
                                                    }
                                            
                                            component.set("v.charges",getsub.sigmaerpdev2__Total_charges__c);
                                            component.set("v.intervals",duration);
                                            
                                            
                                            
                                        }
                                    });
                $A.enqueueAction(action3);
            }
            
        });
        $A.enqueueAction(action2);
        
    },
    
    handleAccountIdUpdate : function(component, event, helper)
    {
        var accountId = event.getParam("sObjectId");
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        var  objectLabel = event.getParam("objectLabel");
        if (instanceId === "Supplier,Vendor")
        {
            component.set('v.recordId', accountId);
            component.set('v.recordName1',instanceId);
            component.set('v.AccSubscriptions.sigmaerpdev2__Account__c',accountId);
            
        }
        else if(instanceId === "MyPAccount")
        {
            component.set('v.recordId', accountId);
            component.set('v.recordName',instanceId);
            component.set('v.AccSubscriptions.sigmaerpdev2__SubscriptionDetail__c',accountId);
            var Accsubscription = component.get("v.AccSubscriptions.sigmaerpdev2__SubscriptionDetail__c");
            var action2= component.get("c.getsubscriptionDetails");
            action2.setParams
            ({ 
                "subname": Accsubscription
                
            });
            action2.setCallback( this, function(a) 
                                {
                                    var state = a.getState();
                                    
                                    var getsubdetails = a.getReturnValue();
                                    if (state === "SUCCESS") 
                                    {
                                        if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='1 Month')
                                        {
                                            var duration=1;
                                        }
                                        else if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='3 Months')
                                        {
                                            var duration=3;
                                        }
                                            else if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='6 Months')
                                            {
                                                var duration=6;
                                            }
                                                else if(getsubdetails.sigmaerpdev2__Subscription_Duration__c=='12 Months')
                                                {
                                                    var duration=12;
                                                }
                                        
                                        component.set("v.charges",getsubdetails.sigmaerpdev2__Total_charges__c);
                                        component.set("v.intervals",duration);
                                        
                                    }
                                });
            $A.enqueueAction(action2);
            
        }
    },
    saveStatus : function(cmp,event,helper)
    {
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Status__c",cmp.find("status").get("v.value")); 
    },
    saveTier : function(cmp,event,helper)
    {
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Subscription_Tier__c",cmp.find("subTier").get("v.value"));
    },
    
    savesubscription : function(component, event, helper)
    {
        
        var interval=component.get("v.intervals");
        var recid=component.get("v.recordId");
        var frequency=component.get("v.frequency");
        
        var inter= interval/frequency;
        component.set("v.AccSubscriptions.sigmaerpdev2__Total_Intervel__c",inter);
        
        var Accsubscription=component.get("v.AccSubscriptions");
        component.set("v.AccSubscription",Accsubscription);
        var ListAccsubscription=component.get("v.AccSubscription");
        //      alert('caled upgrade'+ JSON.stringify(Accsubscription));
        //  alert('caled upgrade'+ JSON.stringify(component.get("v.AccSubscription")));
        // return;
        var startdate = new Date(component.get("v.AccSubscriptions.sigmaerpdev2__Start_Date__c"));
        
        
        var today = new Date();        
        component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var date = new Date(component.get("v.today"));
        
        // var someDate = new Date(component.get("v.enddate"));
        component.set('v.enddate', startdate.getFullYear()+ "-" +(startdate.getMonth() + 1)+ "-" + startdate.getDate() );
        var enddate = new Date(component.get("v.enddate"));  
        var subscribedate = new Date(component.get("v.AccSubscriptions.sigmaerpdev2__Subscribe_Date__c"));
        component.set('v.subscribedate', subscribedate.getFullYear()+ "-" +(subscribedate.getMonth() + 1)+ "-" + subscribedate.getDate() );
        var subdate = new Date(component.get("v.subscribedate")); 
        var subenddate=component.get("v.noofdays");
        
        if(Accsubscription.sigmaerpdev2__Subscription_Line_Item__c =="" || Accsubscription.sigmaerpdev2__Subscription_Line_Item__c==undefined ) 
        {
            var msg = "Please Select Subscription.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(Accsubscription.sigmaerpdev2__Account__c =="" || Accsubscription.sigmaerpdev2__Account__c==undefined ) 
        {
            
            var msg = "Please Select Customer Account.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(Accsubscription.sigmaerpdev2__Billing_Frequency__c ==""|| Accsubscription.sigmaerpdev2__Billing_Frequency__c === '--Select--') 
        {
            
            var msg = "Select Subscription Frequency. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(frequency>interval) 
        {
            
            var msg = "Select Correct Billing Frequency. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        if(Accsubscription.sigmaerpdev2__Status__c ==""|| Accsubscription.sigmaerpdev2__Status__c === '--Select--') 
        {
            
            var msg = "Select Subscription Status. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(Accsubscription.sigmaerpdev2__Start_Date__c =="") 
        {
            
            var msg = "Select Subscribe Start Date. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(Accsubscription.sigmaerpdev2__Discount__c<0)
        {
            var msg = "Enter Valid Discount.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return; 
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } 
        
        if(enddate < date) 
        {
            
            var msg = "Start Date Should   be Greater than or Equal to todays Date . ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } 
        if(Accsubscription.sigmaerpdev2__Subscribe_Date__c =="") 
        {
            
            var msg = "Select Subscribe Date. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(Accsubscription.sigmaerpdev2__Subscribe_Date__c!=Accsubscription.sigmaerpdev2__Start_Date__c)
        {
            var msg = "Subscription Date Should be Equal to  Start Date. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return; 
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } 
        
        var action = component.get("c.updateAccount");
        action.setParams
        ({ 
            "Accsub": ListAccsubscription,
            "interval":inter,
            "frequency":frequency,
            "recid":recid,
            "subenddate":subenddate
        });
        action.setCallback( this, function(a) 
                           {
                               var state = a.getState();
                               if (state === "SUCCESS") 
                               { 
                                   var recordid =a.getReturnValue()[0].Id;
                                  /* if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) 
                                   {               
                                       
                                       //  window.location.href = "/one/one.app#/sObject/" + a.getReturnValue().Id;
                                       sforce.one.navigateToSObject(recordid);
                                   }
                                   else{          
                                       
                                       // window.location.href = "/" + a.getReturnValue().Id;
                                       sforce.one.navigateToSObject(recordid);
                                   }  */
                                       var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({ "recordId":recordid,
                                                  "slideDevName": "related" 
                                                 }); 
                                navEvt.fire();
                                   //window.location.href = "/" + a.getReturnValue().Id; 
                               }
                               
                           });
        document.getElementById("Accspinner").style.display = "block";	
        $A.enqueueAction(action);
        
    },
    cancelButton:function(cmp, event){
        //window.location.reload();
         $A.get("e.force:closeQuickAction").fire();
        
    },
    saveduration : function(cmp,event,helper)
    {
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Subscription_Duration__c",cmp.find("duration").get("v.value")); 
        var durations=cmp.get("v.AccSubscriptions.sigmaerpdev2__Subscription_Duration__c");
        var interval=cmp.get("v.interval");
        var charges=cmp.get("v.totalcharges");
        //alert('charges'+charges);
        
        if(durations=='1 Month')
        {
            var duration=1;
        }
        else if(durations=='3 Month')
        {
            var duration=3;
        }
            else if(durations=='6 Month')
            {
                var duration=6;
            }
                else if(durations=='12 Month')
                {
                    var duration=12;
                }
        
        var basecharges=(charges/interval)*duration;
        cmp.set("v.intervals",duration);
        cmp.set("v.durationcharges",basecharges);
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Start_Date__c",'');
        cmp.set("v.noofdays",'');
        
        
    },
    savefrequency : function(cmp,event,helper)
    {
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Billing_Frequency__c",cmp.find("frequency").get("v.value")); 
        var getfrequency=cmp.get("v.AccSubscriptions.sigmaerpdev2__Billing_Frequency__c");
        if(getfrequency=='Monthly')
        {
            cmp.set("v.frequency",1); 
        }else if(getfrequency=='Quarterly')
        {
            cmp.set("v.frequency",3); 
        }else if(getfrequency=='BY yearly')
        {
            cmp.set("v.frequency",6); 
        }
            else if(getfrequency=='Yearly')
            {
                cmp.set("v.frequency",12); 
            }
        var frequency=cmp.get("v.frequency");
        var duration=cmp.get("v.intervals");
        var charges=cmp.get("v.durationcharges");
        var basecharges=(charges/duration)*frequency;
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Unit_Price__c",basecharges);
        
    },
    getenddate:function(cmp, event){
        
        var interval=cmp.get("v.intervals");
        var startdate=cmp.get("v.AccSubscriptions.sigmaerpdev2__Start_Date__c");
        var noofdays=interval*30;
        var date = new Date(startdate);
        date.setDate(date.getDate() + noofdays-1); 
        cmp.set("v.noofdays", date.getFullYear()+ "-" +(date.getMonth() + 1)+ "-" + date.getDate());
        
    }
    
})