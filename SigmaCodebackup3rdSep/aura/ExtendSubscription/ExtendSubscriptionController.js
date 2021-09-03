({
    doInit : function(component, event, helper)
    {
        var recid = component.get("v.recordId");
       
        var action1 = component.get("c.getsubscriptionStatus");
        action1.setCallback(this, function(res) {
            component.set("v.status", res.getReturnValue());
        });
        $A.enqueueAction(action1);
        
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
        
        if(recid!=null)
        {
            var action2 = component.get("c.getAccsub");
            action2.setParams
            ({ 
                "recid": recid
            });
            action2.setCallback(this, function(res) {
                var state = res.getState();
                
                var getsubdetails = res.getReturnValue();
                //alert(state);
                if (state === "SUCCESS") 
                {
                    component.set('v.AccSubscriptions', getsubdetails);
                   // alert(getsubdetails.sigmaerpdev2__Status__c);
                    if(getsubdetails.sigmaerpdev2__Product_Name__c !=undefined)
                    {
                        var msg = "You can't Extend Order selected   Usage Type Product/Service base subscription.";
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
                       var msg = "You can't Extend Order selected  Usage Type as Product/Service  base subscription.";
                        component.set("v.errorMsg", msg);
                        component.set("v.isblurtrue",true);
                        return;  
                    }
                    component.set('v.recordName', getsubdetails.sigmaerpdev2__Subscription_Line_Item__r.Name);
                    component.set('v.AccSubscriptions.sigmaerpdev2__Subscription_Line_Item__c',getsubdetails.sigmaerpdev2__Subscription_Line_Item__c);
                    component.set('v.recordName1', getsubdetails.sigmaerpdev2__Account__r.Name);
                    component.set('v.AccSubscriptions.sigmaerpdev2__Account__c',getsubdetails.sigmaerpdev2__Account__c);
                    component.find("status").set("v.value", getsubdetails.sigmaerpdev2__Status__c);
                    component.find("frequency").set("v.value", getsubdetails.sigmaerpdev2__Billing_Frequency__c);
                    component.find("duration").set("v.value", getsubdetails.sigmaerpdev2__Subscription_Duration__c);
                    component.set('v.AccSubscriptions.sigmaerpdev2__Owned_Subscription_Duration__c',getsubdetails.sigmaerpdev2__Subscription_Duration__c);
                    var getsubdetails= component.get("v.AccSubscriptions");
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
                    component.set("v.intervals",duration);
                   
                    component.set("v.totalcharges",getsubdetails.sigmaerpdev2__Amount__c);
                    
                }
                
            });
            $A.enqueueAction(action2);
        }
        
    },
    
    handleAccountIdUpdate : function(component, event, helper)
    {
       
        var accountId = event.getParam("sObjectId");
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        var  objectLabel = event.getParam("objectLabel");
         if (instanceId === "Supplier,Vendor")
        {
            
            component.set('v.recordName1',instanceId);
            
            component.set('v.AccSubscriptions.sigmaerpdev2__Account__c',accountId);
            
        }
        else if(instanceId === "MyPAccount")
        {
            
            component.set('v.recordName',instanceId);
           
            component.set('v.AccSubscriptions.sigmaerpdev2__Subscription_Line_Item__c',accountId);
            var Accsubscription = component.get("v.AccSubscriptions.sigmaerpdev2__Subscription_Line_Item__c");
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
                                        
                                        component.set("v.totalcharges",getsubdetails.sigmaerpdev2__Total_charges__c);
                                        component.set("v.intervals",duration);
                                        component.set("v.AccSubscriptions.sigmaerpdev2__Subscription_Duration__c",getsubdetails.sigmaerpdev2__Subscription_Duration__c);
                                        
                                    }
                                });
           
            $A.enqueueAction(action2);
            
        }
    },
    saveStatus : function(cmp,event,helper)
    {
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Status__c",cmp.find("status").get("v.value")); 
    },
    saveduration : function(cmp,event,helper)
    {
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Subscription_Duration__c",cmp.find("duration").get("v.value")); 
        var durations=cmp.get("v.AccSubscriptions.sigmaerpdev2__Subscription_Duration__c");
        var Bllingfrequency=cmp.get("v.AccSubscriptions.sigmaerpdev2__Billing_Frequency__c");
        var interval=cmp.get("v.intervals");
       
        var charges=cmp.get("v.totalcharges");
       
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
        if(Bllingfrequency=='Monthly')
        {
            var frequency=1;
        }
        else if(Bllingfrequency=='Quarterly')
        {
            var frequency=3;
        }
            else if(Bllingfrequency=='BY yearly')
            {
                var frequency=6;
            }
                else if(Bllingfrequency=='Yearly')
                {
                    var frequency=12;
                }
        if(duration<frequency)
        {
            var msg = "Owned Subscription Duration is greater than billing frequency.";
            cmp.set("v.errorMsg", msg);
            cmp.set("v.isError",true);
            return;
        }
        else{
            cmp.set("v.isError",false);
            cmp.set("v.errorMsg", "");
        }
       
        var basecharges=(charges/interval)*duration;
        cmp.set("v.interval",duration);
        cmp.set("v.durationcharges",basecharges);
       
        var unitprice=(basecharges/duration)*frequency;
       
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Unit_Price__c",unitprice);
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Extend_Start_Date__c",'');
        cmp.set("v.noofdays",'');
    },
    savefrequency : function(cmp,event,helper)
    {
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Billing_Frequency__c",cmp.find("frequency").get("v.value"));
        var durations=cmp.get("v.AccSubscriptions.sigmaerpdev2__Subscription_Duration__c");
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
        
        var interval=cmp.get("v.interval");
       
        var charges=cmp.get("v.durationcharges");
        if(duration<frequency)
        {
            var msg = "Billing frequency Should be Less than Owned Subscription Duration.";
            cmp.set("v.errorMsg", msg);
            cmp.set("v.isError",true);
            return;
        }
        else{
            cmp.set("v.isError",false);
            cmp.set("v.errorMsg", "");
        }
        if(charges==null)
        {
            var totalcharges=cmp.get("v.totalcharges");
            var interval=cmp.get("v.intervals");
            var basecharges=(totalcharges/interval)*duration;
            var unitprice=(basecharges/duration)*frequency;
            cmp.set("v.AccSubscriptions.sigmaerpdev2__Unit_Price__c",unitprice);
            
        }
        else
        {
            
            var basecharges=(charges/interval)*frequency;
           
            cmp.set("v.AccSubscriptions.sigmaerpdev2__Unit_Price__c",basecharges);
            
        }
        
        
    },
    updatesubscription : function(component, event, helper)
    {
        var Accsubscription=component.get("v.AccSubscriptions");
        component.set('v.enddate',Accsubscription.sigmaerpdev2__Extend_Start_Date__c);
        var someDate = new Date(component.get("v.enddate"));
        component.set('v.enddate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
        var enddate = new Date(component.get("v.enddate"));      
        var subscribedate = new Date(component.get("v.AccSubscriptions.sigmaerpdev2__Subscribe_Date__c"));
        component.set('v.subscribedate', subscribedate.getFullYear()+ "-" +(subscribedate.getMonth() + 1)+ "-" + subscribedate.getDate() );
        var subdate = new Date(component.get("v.subscribedate"));  
        var getfrequency=component.get("v.AccSubscriptions.sigmaerpdev2__Billing_Frequency__c");
        if(getfrequency=='Monthly')
        {
            component.set("v.frequency",1); 
        }else if(getfrequency=='Quarterly')
        {
            component.set("v.frequency",3); 
        }else if(getfrequency=='BY yearly')
        {
            component.set("v.frequency",6); 
        }
            else if(getfrequency=='Yearly')
            {
                component.set("v.frequency",12); 
            }
        var interval;
        var intervals=component.get("v.interval");
        if(intervals==null)
        {
            interval=component.get("v.intervals");
        }
        else
        {
            interval=intervals;  
        }
      
        var frequency=component.get("v.frequency");
       
        var inter= interval/frequency;
       
        component.set("v.AccSubscriptions.sigmaerpdev2__Total_Intervel__c",inter);
        var recid = component.get("v.recordId");
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var date = new Date(component.get("v.today"));
        
        var startdate = new Date(component.get("v.AccSubscriptions.sigmaerpdev2__Extend_Start_Date__c"));
         var subenddate=component.get("v.noofdays");
      
        //validation starts
        
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
        if(Accsubscription.sigmaerpdev2__Extend_Start_Date__c =="" ||Accsubscription.sigmaerpdev2__Extend_Start_Date__c==undefined) 
        {
            
            var msg = "Select Extended Subscribe Start Date.";
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
     
    
        if(Accsubscription.sigmaerpdev2__Subscribe_Date__c =="") 
        {
            
            var msg = "Select Subscription Date. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(Accsubscription.sigmaerpdev2__Extend_Start_Date__c<=Accsubscription.sigmaerpdev2__End_Date__c) 
        {
            
            var msg = "Extended Start Date is Greater than Previous subscription End Date. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
     
         if(Accsubscription.sigmaerpdev2__Subscribe_Date__c!=Accsubscription.sigmaerpdev2__Extend_Start_Date__c)
        {
            var msg = "Subscribe Date Should be Equal to extended Start Date. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return; 
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } 
        
        //validation ends
        var action = component.get("c.saveAccsub");
        action.setParams
        ({ 
            "Accsub": Accsubscription,
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
                                   if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) 
                                     {                                         
                                         window.location.href = "/one/one.app#/sObject/" + a.getReturnValue().Id;
                                     }
                                     else{            
                                         window.location.href = "/" + a.getReturnValue().Id;
                                     }                                   
                                   //window.location.href = "/" + a.getReturnValue().Id;
                               }
                               
                           });
        document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action);
        
    },
    cancelButton:function(cmp, event){
       // window.location.reload();
       $A.get("e.force:closeQuickAction").fire();
    },
    extendsub : function(component, event, helper)
    {
        
        component.set("v.isopen",true);
       
    },
     getenddate:function(cmp, event){
       var interval;
        var intervals=cmp.get("v.interval");
     
        if(intervals==null)
        {
            interval=cmp.get("v.intervals");
        }
        else
        {
            interval=intervals;  
        }
        var startdate=cmp.get("v.AccSubscriptions.sigmaerpdev2__Extend_Start_Date__c");
        var noofdays=interval*30;
        var date = new Date(startdate);
        date.setDate(date.getDate() + noofdays-1); 
        cmp.set('v.noofdays', date.getFullYear()+ "-" +(date.getMonth() + 1)+ "-" + date.getDate() );
        
    }
    
})