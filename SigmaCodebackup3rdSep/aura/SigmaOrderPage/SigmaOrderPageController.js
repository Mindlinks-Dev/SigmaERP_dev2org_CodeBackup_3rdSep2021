({
    doInit : function(component, event, helper,page) {
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        page = page || 1;        
        var action = component.get("c.fetchSigmaOrderList");                
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
                var accs = response.getReturnValue(); 
                component.set('v.total', accs.totalSigma);
                component.set('v.page', accs.pageSigma);
                component.set('v.pages', Math.ceil(accs.totalSigma/accs.pageSizeSigma));
                component.set("v.sigmaList",accs.sigmaList);
                component.set("v.ShowforCommunity",accs.IsCommunityUser);
            }
            else if (state === "INCOMPLETE") {
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
                // do something
            }
                else if (state === "ERROR") {
                    var spinner = component.find("mySpinner");
        			$A.util.toggleClass(spinner, "slds-hide");
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
        
    },
    
    SigmaOrder : function(component, event, helper){
		component.set("v.sigmaFlag",true); 
        component.set("v.Listflag",false);
        component.set("v.RentFlag",false);
        component.set("v.TBIFlag",false);
        
        /*var action = component.get("c.OrderUsage");       
        action.setCallback( this, function(a){
            if(a.getReturnValue() != null){              
                var retval = a.getReturnValue();
                //console.log('ret val---'+JSON.stringify(retval));
                //alert(JSON.stringify(retval));
                if(retval.ou.sigmaerpdev__Standard_object__c ){
                    component.set("v.errorText",'Dont have Access to Proceed Sales Order, Please Check Sigma Order in Custom Settings Default Parameters');
                    component.set("v.isErrorflag",true);
                    component.set("v.Listflag",false);
                    component.set("v.sigmaFlag",false);
                    component.set("v.RentFlag",false);
                     component.set("v.TBIFlag",false);
                }else if(retval.OP.sigmaerpdev__Subscription_Product__c ||retval.OP.sigmaerpdev__Subscription_Renewal__c){
                  component.set("v.errorText", 'Dont have Access to Proceed Sales Order, Please UnCheck  Custom Settings Order API');
                        component.set("v.isErrorflag",true);
                        component.set("v.Listflag",false);
                        component.set("v.sigmaFlag",false);
                        component.set("v.RentFlag",false);
                        component.set("v.TBIFlag",false);  
                }
                else{                  
                    if(retval.tmi.sigmaerpdev__Order__c || retval.tmi.sigmaerpdev__Proposal__c || retval.tmi.sigmaerpdev__Proposal_for_Products__c || retval.tmi.sigmaerpdev__Proposal_to_Order__c){
                        component.set("v.errorText", 'Dont have Access to Proceed Sales Order, Please UnCheck  Custom Settings Time Based Inventory');
                        component.set("v.isErrorflag",true);
                        component.set("v.Listflag",false);
                        component.set("v.sigmaFlag",false);
                        component.set("v.RentFlag",false);
                        component.set("v.TBIFlag",false);
                    }
                    else{
                        component.set("v.isErrorflag",false);
                        component.set("v.sigmaFlag",true);
                        component.set("v.Listflag",false);
                        component.set("v.RentFlag",false);
                        component.set("v.TBIFlag",false);
                    }
                }
            }
        });
        $A.enqueueAction(action);*/
    },    
    
    RentalOrder : function(component, event, helper){
        component.set("v.sigmaFlag",false); 
        component.set("v.Listflag",false);
        component.set("v.RentFlag",true);
        component.set("v.TBIFlag",false);
        
        /*var action = component.get("c.OrderUsage");
        action.setCallback( this, function(a){
            if(a.getReturnValue() != null){
                var retval = a.getReturnValue();
                if(retval.ou.sigmaerpdev__Standard_object__c ){
                    component.set("v.errorText",'Dont have Access to Proceed Rental Order, Please Check Sigma Order in Custom Settings Default Parameters');
                    component.set("v.isErrorflag",true);
                    component.set("v.Listflag",false);
                    component.set("v.sigmaFlag",false);
                    component.set("v.RentFlag",false);
                    component.set("v.TBIFlag",false);
                }else if(retval.OP.sigmaerpdev__Subscription_Product__c ||retval.OP.sigmaerpdev__Subscription_Renewal__c){
                  component.set("v.errorText", 'Dont have Access to Proceed Rental, Please UnCheck  Custom Settings Subscription Settings');
                        component.set("v.isErrorflag",true);
                        component.set("v.Listflag",false);
                        component.set("v.sigmaFlag",false);
                        component.set("v.RentFlag",false);
                        component.set("v.TBIFlag",false);  
                }
                else{                  
                    if(retval.tmi.sigmaerpdev__Order__c || retval.tmi.sigmaerpdev__Proposal__c || retval.tmi.sigmaerpdev__Proposal_for_Products__c || retval.tmi.sigmaerpdev__Proposal_to_Order__c){
                        component.set("v.errorText", 'Dont have Access to Proceed Rental Order, Please UnCheck Sigma Order in Custom Settings Time Based Inventory');
                        component.set("v.isErrorflag",true);
                        component.set("v.Listflag",false);
                        component.set("v.sigmaFlag",false);
                        component.set("v.RentFlag",false);
                        component.set("v.TBIFlag",false);
                    }
                    else{
                        component.set("v.isErrorflag",false);
                        component.set("v.sigmaFlag",false);
                        component.set("v.Listflag",false);
                        component.set("v.RentFlag",true);
                        component.set("v.TBIFlag",false);
                    }
                }
            }
        });
        $A.enqueueAction(action);*/
    },
    
    SalesOrderTBI : function(component, event, helper) {
        component.set("v.sigmaFlag",false); 
        component.set("v.Listflag",false);
        component.set("v.RentFlag",false);
        component.set("v.TBIFlag",true);
        
      	/*var action = component.get("c.OrderUsage");
        action.setCallback( this, function(a){
            if(a.getReturnValue() != null){
                var retval = a.getReturnValue();
                if(retval.ou.sigmaerpdev__Standard_object__c || retval.ou.sigmaerpdev__Sigma_order__c){
                    component.set("v.errorText",'Dont have Access to Proceed sales Order TBI, Please Unckeck  Sigma Order or Standard order in Custom Settings Default Parameters');
                    component.set("v.isErrorflag",true);
                    component.set("v.Listflag",false);
                    component.set("v.sigmaFlag",false);
                    component.set("v.RentFlag",false);
                    component.set("v.TBIFlag",false);
                }else if(retval.OP.sigmaerpdev__Subscription_Product__c ||retval.OP.sigmaerpdev__Subscription_Renewal__c){
                  component.set("v.errorText", 'Dont have Access to Proceed Sales TBI, Please UnCheck  Custom Settings Subscription Settings');
                        component.set("v.isErrorflag",true);
                        component.set("v.Listflag",false);
                        component.set("v.sigmaFlag",false);
                        component.set("v.RentFlag",false);
                        component.set("v.TBIFlag",false);  
                }
                else{                  
                    if(retval.tmi.sigmaerpdev__Order__c == false || retval.tmi.sigmaerpdev__Proposal__c || retval.tmi.sigmaerpdev__Proposal_for_Products__c || retval.tmi.sigmaerpdev__Proposal_to_Order__c){
                        component.set("v.errorText", 'Dont have Access to Proceed sales Order TBI, Please Check  Sales Order TBI in Custom Settings Time Based Inventory');
                        component.set("v.isErrorflag",true);
                        component.set("v.Listflag",false);
                        component.set("v.sigmaFlag",false);
                        component.set("v.RentFlag",false);
                        component.set("v.TBIFlag",false);
                    }
                    else{
                        component.set("v.isErrorflag",false);
                        component.set("v.sigmaFlag",false);
                        component.set("v.Listflag",false);
                        component.set("v.RentFlag",false);
                        component.set("v.TBIFlag",true);
                    }
                }
            }
        });
        $A.enqueueAction(action);*/
    },
    
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getSigmaOrderList(component, event, helper,page);
    },
    handlesoId : function(cmp, event) {
    // alert('event'+ event.getParam("soId") );
        var salesorderId = event.getParam("soId");
        //alert('salesorderId-->>>'+salesorderId);
        if(salesorderId!=undefined && salesorderId!=null && JSON.stringify(salesorderId)!='""')
        {
            cmp.set("v.soId",salesorderId);
            cmp.set("v.issigmaFlagWithId",true);
            cmp.set("v.sigmaFlag",false);
            cmp.set("v.Listflag",false);
         }
		
    }
})