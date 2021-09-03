({
	doInit : function(component, event, helper) {
        alert('calling doinit');
        helper.showInvoicesH(component, event, helper);
		
	},
     close : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
        selectAllInvoice : function(component, event, helper){
        var SigmaOrderSalesInvoice=component.get("v.SigmaOrderSalesInvoice");
        if(component.get("v.selectAllFlag")){        
            for(var i=0;i<SigmaOrderSalesInvoice.length;i++){            
                SigmaOrderSalesInvoice[i].selected=true;
            }
        }
        else{        
            for(var i=0;i<SigmaOrderSalesInvoice.length;i++){            
                SigmaOrderSalesInvoice[i].selected=false;
            }            
        }
        component.set("v.SigmaOrderSalesInvoice",SigmaOrderSalesInvoice);
    },
    paySalesInvoice : function(component, event, helper){  
          alert('HIiii');
        var SigmaOrderSalesInvoice = component.get("v.SigmaOrderSalesInvoice");
      
         alert(JSON.stringify(component.get("v.SigmaOrderSalesInvoice")));
       
        var selected=[];
        for(var i=0;i<SigmaOrderSalesInvoice.length;i++){
            if(SigmaOrderSalesInvoice[i].selected == true){
                selected.push(SigmaOrderSalesInvoice[i]);
            }
        }
        if(selected.length > 0){
            component.set("v.selectedSalesInvoice",selected);
            alert('hello'+JSON.stringify(component.get("v.selectedSalesInvoice")));
            var evt = $A.get("e.force:navigateToComponent");
            console.log('evt'+evt);
            evt.setParams({
                componentDef: "c:CreditpaymentCalling",
                componentAttributes :{
                    "selectedSalesInvoice": component.get("v.selectedSalesInvoice"),
                   // "accountDetails":component.get("v.accountDetails"),
                    "recordId" : component.get("v.SigmaorderID"),
                    //"companyId" : component.get("v.companyId"),
                    //"currCode" : component.get("v.curCode")
                }
            });       
            evt.fire();
        }
        else{
            alert('Select atleast one Invoice to make Payment.');
            return;
        }       
    }
})