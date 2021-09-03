({
	loadPOStatus : function (component,event)
    {
     //   alert('hi');
        var CheckApprFlag = component.get("c.getApprDetails");
        CheckApprFlag.setCallback(this, function(a) {
         //  alert('response>>'+a.getReturnValue().sigmaerpdev2__Approval_Process_Not_Needed__c);
            component.set("v.CheckAppflag",a.getReturnValue().sigmaerpdev2__Approval_Process_Not_Needed__c);
            //code ends here
            var action = component.get("c.getPOStatus");
            var inputsel = component.find("InputSelectDynamic");
            var opts=[];
            action.setCallback(this, function(a) 
                               {
                                   var savedOrderDetails = a.getReturnValue();
                                   if(component.get("v.CheckAppflag")!= true)
                                   {
                                       for(var i=0;i< savedOrderDetails.length;i++)
                                       {
                                           if((component.get("v.selectedStatus") == 'Approved' || component.get("v.selectedStatus") == 'Rejected' ) || (savedOrderDetails[i]!='Approved' && savedOrderDetails[i]!='Rejected'))
                                               opts.push({"class": "optionClass", label: savedOrderDetails[i], value: savedOrderDetails[i]});
                                       }
                                       inputsel.set("v.options", opts);
                                       component.set("v.Status","Open");
                                   }
                                   else{
                                       for(var i=0;i< savedOrderDetails.length;i++)
                                       {
                                           
                                           if((component.get("v.selectedStatus") == 'Open' || component.get("v.selectedStatus") == 'Closed' || component.get("v.selectedStatus")  == 'Approved' || component.get("v.selectedStatus")  == 'Rejected') || (savedOrderDetails[i]!='Open' && savedOrderDetails[i]!='Closed' && savedOrderDetails[i]!='Approved' && savedOrderDetails[i]!='Rejected' ))
                                               opts.push({"class": "optionClass", label: savedOrderDetails[i], value: savedOrderDetails[i]});
                                       }
                                       inputsel.set("v.options", opts);
                                       
                                       component.set("v.Status","Submitted");
                                       component.set("v.POSubmitted",true);

                                   }
                                   //code ends here
                                   
                                   //component.set("v.NewPurchaseOrder.sigmaerpdev__Status__c","Approved");
                                   //component.set("v.NewPurchaseOrder.sigmaerpdev__Status__c","Rejected");
                               });
            $A.enqueueAction(action);
        });
        $A.enqueueAction(CheckApprFlag);
        // end   
    },
})