({
	doInit : function(component, event, helper) {
		//var inputVal = component.get("v.productinner");
        var prev = component.get("v.productinner");
        alert(JSON.stringify(prev));
	},
      ChangeCode :function(component, event, helper) { 
         //alert('AVQTY'+AVQTY);
        var AVQTY = component.get("v.productinner.quantity");
        var SCQTY= component.get("v.productinner.selQuantity");
        //var Code = component.get("v.StockCheckDetails.sigmaerpdev__Reason_Code__c"); 
        var Code = component.get("v.productinner.resons");        
        component.set("v.productinner.resons",Code);       
        
        if(AVQTY == SCQTY && Code !='--None--'){
            //alert('if1');
            //component.find("ReasonCode").set("v.errors", [{message:"there is no mismatch Stock Qty"}]);
            return;
        }
        else if(AVQTY != SCQTY && Code =='--None--'){
            // alert('if2');
            //component.find("ReasonCode").set("v.errors", [{message:"there is no mismatch Stock Qty"}]);
            return;
        }
            else if(AVQTY != SCQTY && Code != '--None--'){
                //  alert('if3');
                component.find("ReasonCode").set("v.errors", null);
                
            }
    },
    
    validateQuantity:function(cmp, event, helper){
        //alert('inns');
         var qty = cmp.get("v.productinner.selQuantity");
        var qty1=cmp.get("v.productinner.quantity");
        //alert('qty'+qty);
        /* if(qty !== null)
            {
                 if(qty < 0)
                {
                    var msg = "Quantity should Positive ";
                    cmp.set("v.errorMsg", msg);
                    cmp.set("v.isError",true);
                    cmp.set("v.validatess",true);
                    return;
                    
                }else{
                     cmp.set("v.isError",false);
                     cmp.set("v.validatess",false);
                }
            }
              */  
              /*  if(qty>qty1)
                {
                    
                    var msg = "Received qty is greater than available qty ";
                    cmp.set("v.errorMsg", msg);
                    cmp.set("v.isError",true);
                    cmp.set("v.validatess",true);
                    return;
                }else{
                     cmp.set("v.isError",false);
                     cmp.set("v.validatess",false);
                }*/
                    
                }
   
})