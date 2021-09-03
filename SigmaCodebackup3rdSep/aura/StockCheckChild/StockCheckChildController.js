({    
    /*checkQty : function(component, event, helper) {
       // alert(component.get("v.StockCheckDetails.sigmaerpdev2__Reason_Code__c"));
		var AVQTY = component.get("v.StockCheckDetails.sigmaerpdev2__Available_Quantity__c");
        var SCQTY= component.get("v.StockCheckDetails.sigmaerpdev2__Stock_Check_Quantity__c");
	    //var Code = component.get("v.StockCheckDetails.sigmaerpdev2__Reason_Code__c");
	    var Code = component.get("v.selVal");
        //alert('line 8==='+Code);
       
        var MissedQty = 0;
        if(SCQTY != undefined && SCQTY != ''){
            MissedQty = AVQTY - SCQTY;
             component.set("v.QTY",MissedQty);
        }
        else{
            component.set("v.QTY",null);
        }
        
       if(SCQTY < 0){
             component.find("CheckQty").set("v.errors", [{message:"Please give Valid Stock Qty"}]);
            return;
        }
        else if(SCQTY!=0 && AVQTY != SCQTY && Code == '--None--'){
            component.find("ReasonCode").set("v.errors", [{message:"Please give Reason"}]);
            return;
        }
        
        else if(AVQTY == SCQTY && Code != '--None--'){
             component.find("ReasonCode").set("v.errors", [{message:"No need of Reason,Stock Qty Matched"}]);
            return;
        }
        else if(AVQTY != SCQTY && Code != '--None--'){
             component.find("ReasonCode").set("v.errors", null);
            return;
        }       
       else{
            component.find("ReasonCode").set("v.errors", null);            
        }        
    },*/
    setValues : function(component, event, helper){         
        var AVQTY = component.get("v.StockCheckDetails.sigmaerpdev2__Available_Quantity__c");
        var SCQTY= component.get("v.StockCheckDetails.sigmaerpdev2__Stock_Check_Quantity__c");
        var Code = component.get("v.selVal");
        // alert('AVQTY>>'+AVQTY);
        //       alert('SCQTY>>'+SCQTY);
        /*var MissedQty = 0;
        if(SCQTY != undefined && SCQTY != ''){
            MissedQty = AVQTY - SCQTY;
            component.set("v.QTY", MissedQty);
        }else{
            component.set("v.QTY", null);
        }*/
        var StockCheckDetails=component.get("v.StockCheckDetails");  
        if(StockCheckDetails!==undefined)
        {
            if(StockCheckDetails.sigmaerpdev2__Available_Quantity__c===0)
            {
               // alert('DIFFERENCE QTY  CANNOT BE NEGATIVE1.'+StockCheckDetails.sigmaerpdev2__Available_Quantity__c);
                //component.set("v.StockCheckDetails.sigmaerpdev2__Stock_Check_Quantity__c",0);
                component.find("checkbox").set("v.value", true); 
                component.set("v.StockCheckDetails.sigmaerpdev2__StockCheckbox__c", component.get("v.selValchkbox"));
                
                return ;
            }
        }
        if(SCQTY == 0){  
           // alert('DIFFERENCE QTY  CANNOT BE NEGATIVE2.'+SCQTY);
            component.set("v.StockCheckDetails.sigmaerpdev2__Stock_Check_Quantity__c", 0);
            component.find("checkbox").set("v.value", false); 
            component.set("v.StockCheckDetails.sigmaerpdev2__StockCheckbox__c", component.get("v.selValchkbox"));
            
        }
        
        if(SCQTY < 0){
            // alert('DIFFERENCE QTY  CANNOT BE NEGATIVE3.'+SCQTY);
            component.find("CheckQty").set("v.errors", [{message:"Enter valid value for Stock quantity."}]);
            return;
        }
        /*if(SCQTY > StockCheckDetails.sigmaerpdev2__Available_Quantity__c){ 
            alert('STOCK CHECK QTY cannot be greater then AVAILABLE QTY.');
            //component.find("CheckQty").set("v.errors", [{message:"STOCK CHECK QTY cannot be greater then AVAILABLE QTY."}]);
            component.set("v.StockCheckDetails.sigmaerpdev2__Stock_Check_Quantity__c",0);
            return ;
        }*/
        if(SCQTY!=0)
        {
            //alert('DIFFERENCE QTY  CANNOT BE NEGATIVE4.'+SCQTY);
             component.find("checkbox").set("v.value", true); 
       		 component.set("v.StockCheckDetails.sigmaerpdev2__StockCheckbox__c", component.get("v.selValchkbox"));
        }
    },
    
    chkboxChecked : function(component, event, helper){      
    
        var chkVal = component.find("checkbox").get("v.value"); 
       
        if(chkVal == false){
            component.set("v.StockCheckDetails.sigmaerpdev2__Stock_Check_Quantity__c", 0);  
            //component.set("v.QTY", null);
            component.set("v.StockCheckDetails.sigmaerpdev2__StockCheckbox__c", false);
            component.set("v.selVal", "--None--"); 
            var Code = component.get("v.selVal");        
            component.set("v.StockCheckDetails.sigmaerpdev2__Reason_Code__c", Code);
        }        
    },
    
    barcodeEnableChkbox : function(component, event, helper){         
        var selChkboxVal = component.get("v.StockCheckDetails.sigmaerpdev2__StockCheckbox__c");
       
        if(selChkboxVal)
        {
            //alert('selChkboxVal1111???'+JSON.stringify(selChkboxVal));
            component.set("v.selValchkbox", true); 
        }
        else{
             //  alert('selChkboxVal???'+JSON.stringify(selChkboxVal));
             component.set("v.selValchkbox", false);
        }
           
    },
    
    ChangeCode :function(component, event, helper) {               
        var AVQTY = component.get("v.StockCheckDetails.sigmaerpdev2__Available_Quantity__c");
        var SCQTY= component.get("v.StockCheckDetails.sigmaerpdev2__Stock_Check_Quantity__c");
        //var Code = component.get("v.StockCheckDetails.sigmaerpdev2__Reason_Code__c"); 
        var Code = component.get("v.selVal");        
        component.set("v.StockCheckDetails.sigmaerpdev2__Reason_Code__c",Code);       
        
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
    }
    
})