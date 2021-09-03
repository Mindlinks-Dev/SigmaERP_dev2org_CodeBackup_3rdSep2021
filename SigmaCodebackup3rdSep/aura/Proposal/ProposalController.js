({
    doInit : function(component, event, helper) {
        var opts = [
            {value: "Proposal", label: "Proposal"},
            {value: "Proposal for Order", label: "Proposal for Order"}
         ];
         component.set("v.propTypes", opts);
        
        var recordIdFromUi = component.get("v.recordId");
        //alert('record id'+recordIdFromUi);
        var action = component.get("c.getProposalStatus");
        
        action.setCallback(this, function(a) 
                           {
                               component.set("v.status", a.getReturnValue());
                           });
        $A.enqueueAction(action);
        var action1 = component.get("c.getProducts");
        action1.setCallback(this, function(response) 
                            {
                                var state = response.getState();
                                if (state == 'SUCCESS')
                                {
                                    var prolist = response.getReturnValue();
                                    component.set('v.options',prolist);
                                }
                            });
        
        $A.enqueueAction(action1); 
        if(recordIdFromUi!=null)
        {
            //alert('record in if condition');
            var editaction = component.get("c.editrecord"); 
            editaction.setParams({
                "proposalid" : recordIdFromUi
            });
            editaction.setCallback(this, function(response) 
                                   {
                                       var state = response.getState();
                                       // alert('state>>>>>>>>>>>'+state);
                                       if (state == 'SUCCESS')
                                       {
                                           var editlist = response.getReturnValue();
                                          // alert('edit>>'+JSON.stringify(editlist));
                                           component.set('v.wrapperListInsertLineItems',editlist.wrapperListInsertLineItems);
                                           component.set('v.istrue',editlist.proposalobj.sigmaerpdev2__Is_Order_Created__c);
                                           var istue=component.get('v.istrue');
                                           
                                           
                                           //added if condition to restrict the edit flow when order status is signed
                                           if(editlist.proposalobj.sigmaerpdev2__Status__c=='Cancelled')
                                           {
                                               
                                               component.set('v.mainisError', true);
                                               component.set('v.mainerrorMsg', 'Cannot Edit the Proposal once its cancelled.');
                                               return;
                                           }  
                                           if(istue==true)
                                           {
                                               
                                               component.set('v.mainisError', true);
                                               component.set('v.mainerrorMsg', 'Cannot Edit the Proposal Once Order is Created.');
                                               return; 
                                               
                                           }
                                           else
                                           {
                                               
                                               component.set("v.mainisError",false);
                                               component.set("v.mainerrorMsg", "");   
                                              //  component.set("v.proposalstatus",editlist.proposalobj.sigmaerpdev2__Status__c);
                                              // alert('proposalstatus>>'+component.get(proposalstatus));
                                               component.set('v.Promap',editlist.wrapperList);
                                               // component.set('v.Promap',editlist.wrapperList);
                                               component.set('v.oldstatus',editlist.proposalobj.sigmaerpdev2__Status__c);
                                               
                                               component.set('v.proposalObject',editlist.proposalobj);
                                               // alert('proobject'+JSON.stringify(editlist.proposalobj));
                                               var proposalObject=component.get("v.proposalObject");
                                              // alert('proobject>>'+proposalObject);
                                               if(proposalObject.sigmaerpdev2__Client__c!=null)
                                               {
                                                   component.set('v.recordName',editlist.proposalobj.sigmaerpdev2__Client__r.Name);   
                                               }
                                               if(proposalObject.sigmaerpdev2__Billing_Contact__c!=null)
                                               {
                                                   component.set('v.CreatedBy',editlist.proposalobj.sigmaerpdev2__Billing_Contact__r.Name);
                                               }
                                               if(proposalObject.sigmaerpdev2__Agency__c!=null)
                                               {
                                                   component.set('v.Agency',editlist.proposalobj.sigmaerpdev2__Agency__r.Name);
                                               }
                                               if(proposalObject.sigmaerpdev2__Account_Executive_1_acc__c!=null)
                                               {
                                                   component.set('v.Salesexec1',editlist.proposalobj.sigmaerpdev2__Account_Executive_1_acc__r.Name);
                                               }
                                               if(proposalObject.sigmaerpdev2__Account_Executive_2_Acc__c!=null)
                                               {
                                                   component.set('v.Salesexec2',editlist.proposalobj.sigmaerpdev2__Account_Executive_2_Acc__r.Name);
                                               }
                                               if(proposalObject.sigmaerpdev2__Account_Executive_3_Acc__c!=null)
                                               {
                                                   component.set('v.Salesexec3',editlist.proposalobj.sigmaerpdev2__Account_Executive_3_Acc__r.Name);
                                               }
                                               if(proposalObject.sigmaerpdev2__Discount_Method__c=='Proposal')
                                               {
                                                   
                                                   //document.getElementById('radio-2').value=true;
                                                   document.getElementById('radio-4').checked=true;
                                                   var value=document.getElementById('radio-4').value;
                                                   component.set("v.disval", value);
                                                   component.set("v.prodis", true);
                                               }
                                               if(proposalObject.sigmaerpdev2__Discount_Method__c=='Product')
                                               {
                                                   
                                                   //document.getElementById('radio-2').value=true;
                                                   document.getElementById('radio-2').checked=true;
                                                   var value=document.getElementById('radio-2').value;
                                                   component.set("v.disval", value);
                                               }
                                               if(proposalObject.sigmaerpdev2__Discount_Method__c=='Location')
                                               {
                                                   
                                                   //document.getElementById('radio-2').value=true;
                                                   document.getElementById('radio-3').checked=true;
                                                   var value=document.getElementById('radio-3').value;
                                                   component.set("v.disval", value);
                                               }
                                               component.set("v.isOpenprodTable",true);
                                               
                                           }  
                                           
                                       }
                                   });
            
            $A.enqueueAction(editaction); 
        }
    },
	
	
   startdate : function(component, event, helper) {
	   
	   var dateee = component.get("v.DateIlp");
        var flag = component.get("v.flag");
        var status=component.get("v.proposalObject");
        
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var todaydate = new Date( component.get('v.today'));
        
        var someDate = new Date(dateee.sigmaerpdev2__Start_Date__c);
        component.set('v.strtdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
        
		var endDate=new Date(dateee.sigmaerpdev2__End_Date__c);
		 component.set('v.edate', endDate.getFullYear()+ "-" +(endDate.getMonth() + 1)+ "-" + endDate.getDate() );
		
		
        var strtdate = new Date(component.get("v.strtdate"));
		var edate = new Date(component.get("v.edate"));
		if(edate < todaydate)
		{
		alert('End date should be greater than present date');
            component.set('v.DateIlp.sigmaerpdev2__End_Date__c','');
          return;
                  
        }
        
        if(strtdate < todaydate)
        {
       
            alert('Start date should be Either be a Present/Future date');
            component.set('v.DateIlp.sigmaerpdev2__Start_Date__c','');
          return;
                  
        }
       
   },
	   
	   
	   


	
    handleorderList : function(component, event, helper) {
        
        var orderinfo = event.getParam("orderinfo");
        var editIndex = event.getParam("rowIndex");
        var Promap=event.getParam("Promap");
        
        var maplist=component.get("v.Promap");
        //  component.set("v.orderline",orderinfo);
        
        
        var wrapperListInsertLineItems = component.get("v.wrapperListInsertLineItems");
        
        if(editIndex!=undefined)
        {
            
            wrapperListInsertLineItems[editIndex]=orderinfo[0];
            maplist[editIndex]=Promap;
            component.set("v.wrapperListInsertLineItems",wrapperListInsertLineItems);
            component.set("v.Promap",maplist);
            
        }
        else
        {   if(wrapperListInsertLineItems == '' || wrapperListInsertLineItems == 'undefined')
        {
            
            component.set("v.wrapperListInsertLineItems",orderinfo[0]);
            component.set("v.Promap",Promap);
        }else
        {
            var flag=true;
            for(var i=0;i<wrapperListInsertLineItems.length;i++)
            {
                
                if(wrapperListInsertLineItems[i].LineItem.sigmaerpdev2__Product__c==orderinfo[0].LineItem.sigmaerpdev2__Product__c)
                {
                    
                    flag=false
                    wrapperListInsertLineItems[i]=orderinfo[0];
                    maplist[i]=Promap;
                }
            }
            if(flag==true)
            {
                wrapperListInsertLineItems.push(orderinfo[0]);
                maplist.push(Promap);  
            }
            
            component.set("v.wrapperListInsertLineItems",wrapperListInsertLineItems);
            component.set("v.Promap",maplist);
        }
         
        }
        //alert('wrapperListInsertLineItems:::'+JSON.stringify(component.get("v.wrapperListInsertLineItems")));
        
        
    },
    saveStatus : function(cmp,event,helper)
    {
        
        cmp.set("v.proposalObject.sigmaerpdev2__Status__c",cmp.find("status").get("v.value")); 
    },
    handleAccountIdUpdate : function(cmp, event, helper) {
        var accountId = event.getParam("sObjectId");
        var billingPersonName = cmp.get('v.CreatedBy');
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        if (instanceId === "Supplier,Vendor")
        {
            
            cmp.set('v.proposalObject.sigmaerpdev2__Client__c',accountId);
            
        }else if(instanceId === "MyContact")
        {
            cmp.set('v.proposalObject.sigmaerpdev2__Billing_Contact__c', accountId);
           // cmp.set('v.proposalObject.sigmaerpdev2__Billing_Person__c', billingPersonName);
            
            
        }
            else if(instanceId === "Agency")
            {
                cmp.set('v.proposalObject.sigmaerpdev2__Agency__c', accountId);
                
            }
               /* else if(instanceId === "SalesExec1")
                {
                    cmp.set('v.proposalObject.sigmaerpdev2__Account_Executive__c', accountId);
                    
                }
                    else if(instanceId === "SalesExec2")
                    {
                        cmp.set('v.proposalObject.sigmaerpdev2__Account_Executive1__c', accountId);
                        
                    }
                        else if(instanceId === "SalesExec3")
                        {
                            cmp.set('v.proposalObject.sigmaerpdev2__Account_Executive2__c', accountId);
                            
                        }*/
                else if(instanceId === "SalesExec1")
                {
                    cmp.set('v.proposalObject.sigmaerpdev2__Account_Executive_1_acc__c', accountId);
                    
                }
               else if(instanceId === "SalesExec2")
                 {
                     cmp.set('v.proposalObject.sigmaerpdev2__Account_Executive_2_Acc__c', accountId);
                        
                 }
                 else if(instanceId === "SalesExec3")
                  {
                      
                        cmp.set('v.proposalObject.sigmaerpdev2__Account_Executive_3_Acc__c', accountId);
                            
                  }
    },
    changeDiscount : function(component, event, helper) {
        var discountMethodContent = component.find('discountMethodContent');
        $A.util.toggleClass(discountMethodContent, 'slds-hide');
        
    },
    
    handleClick : function(component,event,helper)
    {
        var rate_value;
        // var wrapper=component.get("v.wrapper");
        var wrapperListInsertLineItems=component.get("v.wrapperListInsertLineItems");
        
        if(document.getElementById('radio-1').checked)
        {
            alert('Discount Method "None" is applied.');
            rate_value = document.getElementById('radio-1').value;
            for(var j=0;j<wrapperListInsertLineItems.length;j++)
            {
                if(wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c!= 0)
                {
                    
                    wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c=0;
                    
                }
                for(var i=0;i<wrapperListInsertLineItems[j].locqty.length;i++)
                {
                    if(wrapperListInsertLineItems[j].locqty[i].locdis!=0)
                    {
                        wrapperListInsertLineItems[j].locqty[i].locdis=0;
                    }
                }
            }
            
            var discountMethodContent = component.find('discountMethodContent');
            var proposalid = component.find('proposalid');
            $A.util.addClass(discountMethodContent, 'slds-hide');
            $A.util.addClass(proposalid, 'slds-hide');
            component.set("v.proposalObject.sigmaerpdev2__Field_Discount_Amount__c", 0);
            component.set("v.proposalObject.sigmaerpdev2__Discount_Method__c", 'None');
            component.set("v.prodis", false);
        }
        else if(document.getElementById('radio-2').checked)
        {
            alert('Discount Method "Product" is applied.');
            rate_value = document.getElementById('radio-2').value;
            for(var j=0;j<wrapperListInsertLineItems.length;j++)
            {
                
                for(var i=0;i<wrapperListInsertLineItems[j].locqty.length;i++)
                {
                    if(wrapperListInsertLineItems[j].locqty[i].locdis!=0)
                    {
                        wrapperListInsertLineItems[j].locqty[i].locdis=0;
                    }
                }
            }
            
            var discountMethodContent = component.find('discountMethodContent');
            var proposalid = component.find('proposalid');
            $A.util.addClass(discountMethodContent, 'slds-hide');
            $A.util.addClass(proposalid, 'slds-hide');
            component.set("v.proposalObject.sigmaerpdev2__Field_Discount_Amount__c", 0);
            component.set("v.proposalObject.sigmaerpdev2__Discount_Method__c", 'Product');
            component.set("v.prodis", false);
        }
            else if(document.getElementById('radio-3').checked)
            {
                alert('Discount Method "Location" is applied.');
                rate_value = document.getElementById('radio-3').value;
                for(var j=0;j<wrapperListInsertLineItems.length;j++)
                {
                    if(wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c!= 0)
                    {
                        
                        wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c=0;
                        
                    }
                    
                }
                
                var discountMethodContent = component.find('discountMethodContent');
                var proposalid = component.find('proposalid');
                $A.util.addClass(discountMethodContent, 'slds-hide');
                $A.util.addClass(proposalid, 'slds-hide');
                component.set("v.proposalObject.sigmaerpdev2__Field_Discount_Amount__c", 0);
                component.set("v.proposalObject.sigmaerpdev2__Discount_Method__c", 'Location');
                component.set("v.prodis", false);
            }
                else if(document.getElementById('radio-4').checked)
                {
                    alert('Discount Method "Proposal" is applied.');
                    rate_value = document.getElementById('radio-4').value; 
                    for(var j=0;j<wrapperListInsertLineItems.length;j++)
                    {
                        if(wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c!= 0)
                        {
                            
                            wrapperListInsertLineItems[j].LineItem.sigmaerpdev2__Discount__c=0;
                            
                        }
                        for(var i=0;i<wrapperListInsertLineItems[j].locqty.length;i++)
                        {
                            if(wrapperListInsertLineItems[j].locqty[i].locdis!=0)
                            {
                                wrapperListInsertLineItems[j].locqty[i].locdis=0;
                            }
                        }
                    }
                    var discountMethodContent = component.find('discountMethodContent');
                    var proposalid = component.find('proposalid');
                    $A.util.addClass(discountMethodContent, 'slds-hide');
                    $A.util.toggleClass(proposalid, 'slds-hide');
                    component.set("v.proposalObject.sigmaerpdev2__Discount_Method__c", 'Proposal');
                    component.set("v.prodis", true);
                }
        component.set("v.wrapperListInsertLineItems",wrapperListInsertLineItems);
        
        component.set("v.disval", rate_value);
        
    },
    handleShowModal : function(component,event,helper)
    {
        var DateIlp = component.get("v.DateIlp");
        //var selectedval=component.find('select').get('v.value');
        var selectedval = component.get("v.productId");
		        
        if(selectedval == '' || selectedval == undefined || selectedval == null){ 
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Choose product to add to proposal.');
            return; 
            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(DateIlp.sigmaerpdev2__Start_Date__c ==''){ 
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Select  Start Date.');
            return; 
            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(DateIlp.sigmaerpdev2__End_Date__c ==''){
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Select  End Date.');
            return; 
            
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(DateIlp.sigmaerpdev2__Start_Date__c > DateIlp.sigmaerpdev2__End_Date__c)
        {
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Select valid Start Date and End Date.');
            return; 
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
       // alert('add button');	
        //var proid=component.find('select').get('v.value');
        var action = component.get("c.productdetails");
        action.setParams({
            "Proid" : selectedval,
            "DateIlp" : DateIlp
        });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                              // alert(state);
                               if (state == 'SUCCESS')
                               {
                                   var wraplist = response.getReturnValue();
                                   
                                   component.set('v.wrapper',wraplist);
                                  // alert('wrappervalue'+JSON.stringify(component.get('v.wrapper')));
                                 //  alert('inside add products');
                                   /* var wrapplist=component.get('v.wrapperList');
                                    alert("state:::"+JSON.stringify(wrapplist[0]));
                                    component.set('v.wrapper',wrapplist);
                                   alert("state11111:::"+JSON.stringify(component.get('v.wrapper')));
                                   */
                                   component.set("v.isOpen", true);
                                   
                               }
                           });
        
        $A.enqueueAction(action); 
        
    },
    Save : function(component, event, helper)
    {
        var wrapperListInsertLineItems = component.get("v.wrapperListInsertLineItems");
        
        var proposalObject = component.get("v.proposalObject");
        
        var oldstatus = component.get("v.oldstatus");
        if(!(proposalObject.sigmaerpdev2__Proposal_Name__c && proposalObject.sigmaerpdev2__Account_Executive_1_acc__c && proposalObject.sigmaerpdev2__Ownership__c && proposalObject.sigmaerpdev2__Agency__c)){
            component.set("v.isErrormain", true);
			component.set("v.errorMsgmain", "Please fill all the mandatory fields.");
            return;
        }
        if(proposalObject.sigmaerpdev2__Client__c=='')
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Enter Customer.');
            return;  
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(proposalObject.sigmaerpdev2__Billing_Contact__c=='')
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Enter Billing Contact.');
            return;  
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        
        if(proposalObject.sigmaerpdev2__Status__c =='--Select--' || proposalObject.sigmaerpdev2__Status__c =='')
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Please enter Proposal Status.');
            return;
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        
        if(proposalObject.sigmaerpdev2__Account_Executive_1_acc__c ==null)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Please select Account Executive 1.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(proposalObject.sigmaerpdev2__Ownership__c == 0.0 )
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Ownership for Account Executive-1 client is required.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(proposalObject.sigmaerpdev2__Ownership__c < 0.0 )
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Ownership for Account Executive1 cannot have negative values.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(proposalObject.sigmaerpdev2__Account_Executive1__c != null && proposalObject.sigmaerpdev2__Ownership1__c == 0.0)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Ownership for Account Executive2 client is required.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(proposalObject.sigmaerpdev2__Account_Executive2__c != null && proposalObject.sigmaerpdev2__Ownership2__c == 0.0)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Ownership for Account Executive3 client is required.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(proposalObject.sigmaerpdev2__Discount__c > 100 )
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Discount value cannot be more than 100%.');
            return;
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        
        if((oldstatus == 'Signed')  && ((proposalObject.sigmaerpdev2__Status__c == 'Proposed') || (proposalObject.sigmaerpdev2__Status__c == 'Active Negotiation') || (proposalObject.sigmaerpdev2__Status__c == 'Planning')))
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Signed Proposal cannot be moved to Planning/Proposed/Active Negotiation Status.');
            return;
        }
      //  alert(proposalObject.sigmaerpdev2__Inventory_Allocated__c);
        if((proposalObject.sigmaerpdev2__Inventory_Allocated__c == true)  && (proposalObject.sigmaerpdev2__Type__c == 'Proposal for Order'))
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Cannot change the type once proposal is signed');
            return;
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        } 
        if((oldstatus == 'Contract Pending')  && ((proposalObject.sigmaerpdev2__Status__c == 'Proposed') || (proposalObject.sigmaerpdev2__Status__c == 'Active Negotiation')))
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Contract Pending Proposal cannot be moved to Proposed/Active Negotiation Status');
            return;
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if((oldstatus == 'Cancelled')  && ((proposalObject.sigmaerpdev2__Status__c == 'Signed') || (proposalObject.sigmaerpdev2__Status__c == 'Planning') ||(proposalObject.sigmaerpdev2__Status__c == 'Proposed')||(proposalObject.sigmaerpdev2__Status__c == 'Active Negotiation') ))
        {  
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Can not change cancelled status');
            return;
        }
        else if(proposalObject.sigmaerpdev2__Other_Discount__c < 0.00)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Other Discounts cannot have negative values.');
            return;
        }
            else if(proposalObject.sigmaerpdev2__Other_Charges__c < 0.00)
            {
                component.set('v.isErrormain', true);
                component.set('v.errorMsgmain', 'Other Charges cannot have negative values.');
                return;
            }
                else if(proposalObject.sigmaerpdev2__Agent_Commission__c < 0.00)
                {
                    component.set('v.isErrormain', true);
                    component.set('v.errorMsgmain', 'Agency Commission cannot have negative values.');
                    return;
                }
                    else
                    {
                        component.set("v.isErrormain",false);
                        component.set("v.errorMsgmain", "");
                    }
        if(proposalObject.sigmaerpdev2__Start_Date__c == '' || proposalObject.sigmaerpdev2__End_Date__C == '' )
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Please select Order Start Date and End Date.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(proposalObject.sigmaerpdev2__Start_Date__c >= proposalObject.sigmaerpdev2__End_Date__C  )
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Order Start Date must be lesser than End Date.');
            return; 
        }
        else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        if(wrapperListInsertLineItems.length<=0)
        {
            component.set('v.isErrormain', true);
            component.set('v.errorMsgmain', 'Choose Products and add line item to save an order.');
            return; 
            
        }else
        {
            component.set("v.isErrormain",false);
            component.set("v.errorMsgmain", "");
        }
        
        if(wrapperListInsertLineItems.length>0)
        {
           
            	for(var i=0;i<wrapperListInsertLineItems.length;i++)
                {
                    if(wrapperListInsertLineItems[i].LineItem.sigmaerpdev2__Discount__c +wrapperListInsertLineItems[i].LineItem.sigmaerpdev2__Sum_Location_Discount__c + component.get('v.proposalObject.sigmaerpdev2__Field_Discount_Amount__c') + component.get('v.proposalObject.sigmaerpdev2__Other_Discount__c') >wrapperListInsertLineItems[i].LineItem.sigmaerpdev2__Cost__c)
                    {
                        
                        component.set('v.isErrormain', true);
                        component.set('v.errorMsgmain', 'Discount amount can not greater than total amount');
                        return; 
                    }
                    else
                    {
                         component.set("v.isErrormain",false);
            			 component.set("v.errorMsgmain", "");
                    }
                }
        }
        
        component.set("v.proposalObjectList",proposalObject);
        var action = component.get("c.SaveChange");
        action.setParams({
            "proposalObject": component.get("v.proposalObjectList"),
            "oldstatus": oldstatus,
            "orderline": JSON.stringify(wrapperListInsertLineItems)
        });
        action.setCallback(this, function(response) 
                           {
                               
                               var state = response.getState();
                               component.set("v.curRecordID",response.getReturnValue());
                               
                               if (state == 'SUCCESS')
                               {
                                   component.set("v.spinner",false);
                                   var prolist = response.getReturnValue();
                                   
                                   if(response.getReturnValue() !== null)
                                   {
                                       if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one)) 
                                       {
                                           
                                           var successAlert = component.find("successAlert");
                                           $A.util.removeClass(successAlert,'slds-hide');
                                       }else{
                                           //alert('Record Saved Successfully');
                                           var toastEvent = $A.get("e.force:showToast");
                                         toastEvent.setParams({
                                        "type":"Success",
                                        "title": "Success",
                                        "message": "Record Saved Successfully"
                                        });
                                         toastEvent.fire();
                                           window.location.href = "/" + response.getReturnValue();
                                           
                                       }    
                                   } else{
                                       
                                       var successAlert = component.find("successAlert");
                                       $A.util.removeClass(successAlert,'slds-hide');
                                       var successAlertTheme = component.find("successAlertTheme");
                                       $A.util.removeClass(successAlertTheme,'slds-theme--success');
                                       $A.util.addClass(successAlertTheme,'slds-theme--error');
                                       var iconsuccess=component.find("iconsuccess");
                                       $A.util.addClass(iconsuccess,'slds-hide');
                                       var iconwarning=component.find("iconwarning");
                                       $A.util.removeClass(iconwarning,'slds-hide');
                                       var recordCreatedHeader = component.find("recordCreatedHeader");
                                       $A.util.addClass(recordCreatedHeader,'slds-hide');
                                       var recordNotCreatedHeader = component.find("recordNotCreatedHeader");
                                       $A.util.removeClass(recordNotCreatedHeader,'slds-hide');
                                       var recordCreatedOK = component.find("recordCreatedOK");
                                       $A.util.addClass(recordCreatedOK,'slds-hide');
                                       var recordCreatedCancel = component.find("recordCreatedCancel");
                                       $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                                   }   
                                   
                                   
                               }
                               else
                               {
                                   alert('record Failed');
                               }
                           });
        component.set("v.spinner",true);
        $A.enqueueAction(action); 
    },
    cancelButton:function(cmp, event){
        cmp.set("v.cancel",true);
        var mainContent = cmp.find("mainContent");
        $A.util.addClass(mainContent,'slds-hide');
        //  window.history.back();
    },
    recordCreatedOK: function(component, event, helper) 
    {
        //alert('inside recordCreatedOk'+component.get("v.curRecordID"));
        sforce.one.navigateToSObject(component.get("v.curRecordID"));        
    },
    recordCreatedCancel: function(component, event, helper) 
    {
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');        
    },
    canceldiscount : function(component, event, helper)
    {
        var discountMethodContent = component.find('discountMethodContent');
        $A.util.addClass(discountMethodContent, 'slds-hide');
        
        document.getElementById('radio-1').checked=false;
        document.getElementById('radio-2').checked=false;
        document.getElementById('radio-3').checked=false;
        document.getElementById('radio-4').checked=false;        
    },
     checkdiscount: function (component, event, helper) {
         
         var num = component.get("v.proposalObject.sigmaerpdev2__Other_Discount__c");
         // alert('Number'+num);
         setTimeout(function() { 
             if(num.includes("-"))
             {
                 alert('Enter a valid value for Other Discounts');
                 component.set("v.proposalObject.sigmaerpdev2__Other_Discount__c",'');
                 
             } 
         }, 100);
         
         var Proposal = component.get("v.proposalObject.sigmaerpdev2__Field_Discount_Amount__c");
          setTimeout(function() { 
             if(Proposal.includes("-"))
             {
                 alert('Enter a valid value for Proposal Discounts');
                 component.set("v.proposalObject.sigmaerpdev2__Field_Discount_Amount__c",'');
                 
             } 
         }, 100);
         
     }
    
})