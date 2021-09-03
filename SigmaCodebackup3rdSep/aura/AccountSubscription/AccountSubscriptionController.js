({
    doInit : function(component, event, helper)
    {
        // alert(component.get("v.recordId"));
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
                if (state === "SUCCESS") 
                {
                    component.set('v.AccSubscriptions', getsubdetails);
                    component.find("status").set("v.value", getsubdetails.sigmaerpdev2__Status__c);
                    component.set('v.AccSubscriptions.sigmaerpdev2__Status__c',  getsubdetails.sigmaerpdev2__Status__c);
                    if(getsubdetails.sigmaerpdev2__Status__c=='Active')
                    {
                        var msg = "You can not Edit Active Subscription.";
                        component.set("v.errorMsg", msg);
                        component.set("v.isblurtrue",true);
                        return;
                        
                    }
                    if(getsubdetails.sigmaerpdev2__Status__c=='InActive')
                    {
                        var msg = "You can not Edit InActive Subscription.";
                        component.set("v.errorMsg", msg);
                        component.set("v.isblurtrue",true);
                        return;
                        
                    }
                    //    component.set('v.recordName', getsubdetails.sigmaerpdev2__Subscription_Line_Item__r.Name);
                    //    component.set('v.AccSubscriptions.sigmaerpdev2__Subscription_Line_Item__c',getsubdetails.sigmaerpdev2__Subscription_Line_Item__c);
                    component.set('v.recordName1', getsubdetails.sigmaerpdev2__Account__r.Name);
                    component.set('v.AccSubscriptions.sigmaerpdev2__Account__c',getsubdetails.sigmaerpdev2__Account__c);
                    component.set('v.noofdays',getsubdetails.sigmaerpdev2__End_Date__c);
                    
                    component.find("frequency").set("v.value", getsubdetails.sigmaerpdev2__Billing_Frequency__c);
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
        else if(instanceId === "MyPAccount1")
        {
            
            // component.set('v.recordName',instanceId);
            //  component.set('v.recordName2',instanceId);
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
                                        component.set("v.AccSubscriptions.sigmaerpdev2__Subscription_Tier__c",getsubdetails.sigmaerpdev2__Subscription__r.sigmaerpdev2__Subscription_Tier__c);
                                    }
                                });
            
            $A.enqueueAction(action2);
            
        }
    },
    saveStatus : function(cmp,event,helper)
    {
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Status__c",cmp.find("status").get("v.value")); 
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
        
        var charges=cmp.get("v.totalcharges");
        
        var basecharges=(charges/duration)*frequency;
        cmp.set("v.AccSubscriptions.sigmaerpdev2__Unit_Price__c",basecharges);
        
    },
    savesubscription : function(component, event, helper)
    {
        var Accsubscription=component.get("v.AccSubscriptions");
        component.set('v.enddate',Accsubscription.sigmaerpdev2__Start_Date__c);
        var someDate = new Date(component.get("v.enddate"));
        var enddate = new Date(someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate());      
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
        var interval=component.get("v.intervals");
        var frequency=component.get("v.frequency");
        var inter= interval/frequency;
        component.set("v.AccSubscriptions.sigmaerpdev2__Total_Intervel__c",inter);
        var recid = component.get("v.recordId");
        
        
        if(recid=='')
        {
            recid=null;
        }
        var today = new Date();
        var date = new Date(today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate());
        var startdate = new Date(component.get("v.AccSubscriptions.sigmaerpdev2__Start_Date__c"));
        
        var subenddate=component.get("v.noofdays");
        //validation starts
        /*  if(Accsubscription.Account_Subscription__c =="" || Accsubscription.Account_Subscription__c==undefined ) 
        {
            var msg = "Please Select Subscription.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }*/
        if(Accsubscription.sigmaerpdev2__Subscription_Line_Item__c =="" || Accsubscription.sigmaerpdev2__Subscription_Line_Item__c==undefined ) 
        {
            var msg = "Please Select Subscription Line Item.";
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
            
            var msg = "Select Billing Frequency. ";
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
            
            var msg = "Select Subscription Start Date. ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        if(enddate < date) 
        {
            
            var msg = "Start Date Should  be Greater than or Equal to todays Date . ";
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
        
        if(Accsubscription.sigmaerpdev2__Start_Date__c!= Accsubscription.sigmaerpdev2__Subscribe_Date__c)
        {
            var msg = "Subscribe Date Should be Equal to Start Date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return; 
        }
        else{
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
        
        //validation ends
        var spinner=component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        var action33 = component.get("c.saveAccsub");
        action33.setParams
        ({ 
            "Accsub": Accsubscription,
            "interval":inter,
            "frequency":frequency,
            "recid":recid,
            "subenddate":subenddate
            
        });
        action33.setCallback( this, function(a) 
                             {
                                 var state = a.getState();
                                 
                                 if (state === "SUCCESS") 
                                 {                                     
                                     
                                     var spinner=component.find('spinner');
                                     $A.util.toggleClass(spinner, 'slds-hide');
                                     
                                     var subrecid= a.getReturnValue().Id;
                                     alert('Account Subscription Record Created Successfully.');
                                     //alert('subrecid>>'+subrecid);
                                     if( (typeof sforce != 'undefined') && (sforce != null) ) {
                                         //alert('lightnign2');	
                                         
                                         sforce.one.navigateToSObject(subrecid,'detail');
                                     } 
                                     // Desktop Navigation
                                     else {
                                         //alert('classic');	
                                         window.location.href = "/"+subrecid;
                                     }
                                     
                                     // var sigmalist =  component.get("v.sigmaList.Id");
                                     //alert('Account Subscription Record Created Successfully.');
                                     
                                     /* if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) 
                                     {                                         
                                         window.location.href = "/one/one.app#/sObject/" + a.getReturnValue().Id;
                                     }
                                     else{            
                                         window.location.href = "/" + a.getReturnValue().Id;
                                     }*/
                                     
                                     
                                     
                                 }
                                 else
                                 {
                                     alert("Account Subscription Record Creation failed.");
                                 }
                                 
                             });
        
        $A.enqueueAction(action33);
        
    },
    cancelButton:function(cmp, event){
        window.history.back();
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