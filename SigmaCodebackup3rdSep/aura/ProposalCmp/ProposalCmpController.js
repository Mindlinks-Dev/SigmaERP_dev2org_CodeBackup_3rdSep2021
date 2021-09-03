({
	doInit : function(component, event, helper,page) {
        //alert('doInit');
        page = page || 1;        
        var action = component.get("c.fetchProposalList");
        // alert('action'+action);
     //   alert('action'+JSON.stringify(action));
        action.setParams({ pageNumberProposal : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var temp = [];
                var accs = response.getReturnValue();
                component.set('v.total', accs.totalProp);
                component.set('v.page', accs.pageProp);
                component.set('v.pages', Math.ceil(accs.totalProp/accs.pageSizeProp));
                component.set("v.PropList",accs.PropList);
            }
            else if (state === "INCOMPLETE") {
                // do something
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
    },
      pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getPropList(component, event, helper,page);
    },
    Proposal:function(component,event,helper){
        /*var action = component.get("c.TBIVal");
        action.setCallback( this, function(a){
            if(a.getReturnValue() != null){
                var TBIStatus = a.getReturnValue();
                if(TBIStatus.sigmaerpdev2__Order__c || TBIStatus.sigmaerpdev2__Proposal_for_Products__c ){
                    component.set("v.errorText",'Dont have Access to Proceed New Proposal, Please Check Proposal (or) Proposal To order in Custom Settings Time Based Inventory');
                    component.set("v.isErrorflag",true);
                    component.set("v.Listflag",false);
                    component.set("v.PropFlag",false);
                    component.set("v.PropProdFlag",false);
                    component.set("v.PropsearchFlag",false);
                }else {
                    if(TBIStatus.sigmaerpdev2__Proposal__c == false && TBIStatus.sigmaerpdev2__Proposal_to_Order__c == false){
                    component.set("v.errorText",' Please Check Proposal (or) Proposal To order in Custom Settings Time Based Inventory');
                    component.set("v.isErrorflag",true);
                    component.set("v.Listflag",false);
                    component.set("v.PropFlag",false);
                    component.set("v.PropProdFlag",false);
                    component.set("v.PropsearchFlag",false);
                }
                else{
                    component.set("v.isErrorflag",false);
                    component.set("v.PropFlag",true);
                    component.set("v.Listflag",false);
                    component.set("v.PropProdFlag",false);
                    component.set("v.PropsearchFlag",false);
                    
                }
               }
            } 
        });
        $A.enqueueAction(action); */
        component.set("v.isErrorflag",false);
        component.set("v.PropFlag",true);
        component.set("v.Listflag",false);
        component.set("v.PropProdFlag",false);
        component.set("v.PropsearchFlag",false);
   },
    
     ProposalForProduct:function(component,event,helper){
        /*var action = component.get("c.TBIVal");
        action.setCallback( this, function(a){
            if(a.getReturnValue() != null){
                var TBIStatus = a.getReturnValue();
                if(TBIStatus.sigmaerpdev2__Order__c || TBIStatus.sigmaerpdev2__Proposal__c || TBIStatus.sigmaerpdev2__Proposal_to_Order__c){
                    component.set("v.errorText",'Dont have Access to Proceed New Product Proposal, Please Check Proposal to Product For Product in Custom Settings Time Based Inventory');
                    component.set("v.isErrorflag",true);
                    component.set("v.Listflag",false);
                    component.set("v.PropFlag",false);
                    component.set("v.PropProdFlag",false);
                    component.set("v.PropsearchFlag",false);
                }else{
                    if(TBIStatus.sigmaerpdev2__Proposal_for_Products__c == false){
                        component.set("v.errorText",' Please Check Proposal to Product  in Custom Settings Time Based Inventory');
                        component.set("v.isErrorflag",true);
                        component.set("v.Listflag",false);
                        component.set("v.PropFlag",false);
                        component.set("v.PropProdFlag",false);
                        component.set("v.PropsearchFlag",false);
                    } else{
                    component.set("v.isErrorflag",false);
                    component.set("v.PropFlag",false);
                    component.set("v.Listflag",false);
                    component.set("v.PropProdFlag",true);
                    component.set("v.PropsearchFlag",false);
                    
                }
                }
            } 
        });
        $A.enqueueAction(action);*/
        component.set("v.isErrorflag",false);
        component.set("v.PropFlag",false);
        component.set("v.Listflag",false);
        component.set("v.PropProdFlag",true);
        component.set("v.PropsearchFlag",false);
},
     ProposalForSearch:function(component,event,helper){                  
     	component.set("v.isErrorflag",false);
        component.set("v.PropFlag",false);
        component.set("v.Listflag",false);
        component.set("v.PropProdFlag",false);
        component.set("v.PropsearchFlag",true);
         
      /*  var action = component.get("c.TBIVal");
        action.setCallback( this, function(a){
            if(a.getReturnValue() != null){
                var TBIStatus = a.getReturnValue();
                if(TBIStatus.sigmaerpdev2__Order__c || TBIStatus.sigmaerpdev2__Proposal__c || TBIStatus.sigmaerpdev2__Proposal_to_Order__c){
                    component.set("v.errorText",'Dont have Access to Proceed Proposal to Product, Please Check Proposal to Product For Product in Custom Settings Time Based Inventory');
                    component.set("v.isErrorflag",true);
                    component.set("v.Listflag",false);
                    component.set("v.PropFlag",false);
                    component.set("v.PropProdFlag",false);
                    component.set("v.PropsearchFlag",false);
                }
                else{
                    component.set("v.isErrorflag",false);
                    component.set("v.PropFlag",false);
                    component.set("v.Listflag",false);
                    component.set("v.PropProdFlag",true);
                    component.set("v.PropsearchFlag",false);
                    
                }
            } 
        });
        $A.enqueueAction(action); 
        */
         
}


})