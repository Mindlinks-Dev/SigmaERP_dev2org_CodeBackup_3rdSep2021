({
    doInit : function(component, event, helper){
        var recordIdFromUi = component.get("v.recordIDILP.Id");
      	//alert(recordIdFromUi);
       if(recordIdFromUi!=null)
        {
            helper.fetchProductInventory(component);
            helper.fetchIlplidata(component);
        }
    
        
    },
	computeDifferenceQuantity : function(cmp,event,helper){
        var originalQty = cmp.find('originalQty').get('v.value');
        var adjustedQty = cmp.find('adjustedQty').get('v.value');
        var diffQty = originalQty - adjustedQty;                
        cmp.set('v.diffQnty',diffQty);        
    },
    
    saveStockAdjust : function(component, event, helper) {
        //component.set("v.loaded",true);
        component.set("v.Accspinner",true);
       //return;
       var proType = component.get('v.inventoryObj.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c');
        var AdjsType = component.find('AdjustType').get('v.value');         
        var originalQty = component.find('originalQty').get('v.value');
		var adjustedQty = component.find('adjustedQty').get('v.value');
        var adjustedunitprice = component.get('v.StockAdjustmentObj.sigmaerpdev2__Unit_Price__c');
       var completeList = component.get('v.Ilplidata');
		var AddIlpli = component.get('v.AddIlpli');
        var invObj = component.get("v.inventoryObj");
      //alert('AddIlpli>>'+JSON.stringify(AddIlpli));
 //   alert('invObj>>'+JSON.stringify(invObj));
      //  component.set("v.Accspinner",false);
       // return;
        var psnlist=component.get("v.PSerialNumber");
        
           var reasonSel = component.find('reasons').get('v.value');         
        var adjustedQty1 = component.find('adjustedQty').get('v.value');
        var saDate = component.find('dateField').get('v.value');
        
		var adjustedQtysum = 0;
        
        if(AdjsType === "--None--"){            
            component.find("AdjustType").set("v.errors", [{message:"Please select the adjust Type."}]);
            component.set("v.Accspinner",false);
            return;
        }
          if(adjustedQty1 <= 0){            
            component.find("adjustedQty").set("v.errors", [{message:"Please select the adjusted quantity."}]);
            component.set("v.Accspinner",false);
            return;
        }
          if(reasonSel === "--None--"){         
            component.set("v.Accspinner",false);
            component.find("reasons").set("v.errors", [{message:"Please select reason code."}]);
            return;
        }
         if(saDate == ''){
            component.set("v.Accspinner",false);
            component.find("dateField").set("v.errors", [{message:"Please select adjusted date."}]);
            return;
        } 
      
        if(AdjsType ==='Increase Stock' && adjustedunitprice==''){            
            component.find("unitprice").set("v.errors", [{message:"Select Unit Price."}]);
            component.set("v.Accspinner",false);
            return;
        }
        if(AdjsType ==='Increase Stock' && adjustedunitprice<=0){            
            component.find("unitprice").set("v.errors", [{message:"Select Unit Price Should be Greater than 0."}]);
            component.set("v.Accspinner",false);
            return;
        }
        
     
       
     if(AdjsType == 'Reduce Stock')
	 {
		 for(var i = 0; i < completeList.length; i ++){
             if(completeList[i].sigmaerpdev2__Available_Quantity__c < completeList[i].sigmaerpdev2__bucket_field__c)
             {
                 component.set('v.isError', true);
            component.set('v.errorMsg', 'Pick Quantity should be less than or equal to available quantity.');
                  component.set("v.Accspinner",false);
            return; 
             }
		if(completeList[i].sigmaerpdev2__bucket_field__c != undefined){
		   adjustedQtysum = +adjustedQtysum + +completeList[i].sigmaerpdev2__bucket_field__c;
		}
		} 
	 }
   
        if(AdjsType == 'Reduce Stock' && adjustedQty > originalQty ){
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Adjusted quantity should be equal to or Less than the original quantity');
             component.set("v.Accspinner",false);
            return;
        }
        else if(adjustedQty != adjustedQtysum && AdjsType == 'Reduce Stock'){
           
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Sum of quantities should be equal to adjusted quantity');
               component.set("v.Accspinner",false);
            return;
        }else
        {
             
            //alert('proType>>'+JSON.stringify(proType));
           //  alert('AdjsType>>'+JSON.stringify(AdjsType));
             //alert('AddIlpli>>'+JSON.stringify(AddIlpli));
             console.log('AddIlpli>>'+JSON.stringify(AddIlpli));
             
            if(proType =='SERIALIZED' && AdjsType == 'Increase Stock'){
                for(var i = 0; i < AddIlpli.length; i++){
                     if(JSON.stringify(AddIlpli[i].sigmaerpdev2__Bin__c)==='""')
                    {
                        component.set("v.Accspinner",false);
                          component.set('v.isError', true);
            			component.set('v.errorMsg', 'Please select Bin at row '+(i+1));
                        return;
                    }
                    
                       if(AddIlpli[i].sigmaerpdev2__ILid__c == ''){
                           // alert('AddIlpli in side for>>'+JSON.stringify(AddIlpli))
                            component.set('v.isError', true);
                            component.set('v.errorMsg', 'Enter Serial numbers at row '+(i+1));
                             component.set('v.Accspinner', false);
                            return;
                        }
                    
                }
            }
            //  alert('AddIlpli>>'+JSON.stringify(AddIlpli));
            // console.log('AddIlpli>> after filetr'+JSON.stringify(AddIlpli));
            
           // return;
             if(proType =='SERIALIZED' && AdjsType == 'Increase Stock')
             {
                 component.set("v.AddIlpli",AddIlpli);
             }
			 
            if(proType =='SERIALIZED' && AdjsType == 'Increase Stock')
            {
                for(var i = 0; i < AddIlpli.length-1; i++){
                    
                    for(var j = i+1; j < AddIlpli.length; j++){
                        if(AddIlpli[i].sigmaerpdev2__ILid__c != '' && AddIlpli[j].sigmaerpdev2__ILid__c != '' && AddIlpli[i].sigmaerpdev2__ILid__c == AddIlpli[j].sigmaerpdev2__ILid__c){
                            
                            component.set('v.isError', true);
                            component.set('v.errorMsg', 'Duplicate Serial numbers found at row '+(i+1)+' & '+(j+1));
                            
                            //$A.util.removeClass(spinner,"slds-show");
                            //$A.util.addClass(spinner, "slds-hide");
                            return;
                        }
                        
                    }
                }
            }
            component.set('v.isError', false);
            component.set("v.errorMsg",null);
             
             //component.set('v.Accspinner', true);
       //alert('AddIlpli>>'+JSON.stringify(AddIlpli));
      //      return;
            helper.adjustmentsHelperMethod(component);
             
        }
        
    },    
     BackButton : function(component, event, helpe){
        //var Opprec  = component.get("v.recordId");
       /* var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": Opprec,
            "slideDevName": "detail"
        });
        sObjectEvent.fire();*/
         //window.location.href = "/one/one.app#/sObject/" + Opprec;
         component.set("v.showBA",false);
    },
    
    SelectedID : function(component, event) 
    {
		var context = event.getParam("instanceId");
		var objectId = event.getParam("sObjectId");
		var objectName = event.getParam("SObjectLabel");
       if(context === 'MyUser')
		{  
			var stockAdjustmentObjUi = component.get("v.StockAdjustmentObj");
			stockAdjustmentObjUi.sigmaerpdev2__Authorized_By__c = objectId;
            component.set("v.StockAdjustmentObj",stockAdjustmentObjUi);  
            component.set("v.userName",objectName);
		}
    },
      recordCreatedOK: function(component, event, helper) 
    {
        var recid=component.get("v.recordIDILP.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
                                   navEvt.setParams({
                                       "recordId": component.get("v.recordIDILP.Id"),
                                       "slideDevName": "related"
                                   });
                                   navEvt.fire();
       
    },
    recordCreatedCancel: function(component, event, helper) 
    {
        //var recid=component.get("v.recordId");
         //window.location.href = "/one/one.app#/sObject/" + recid;
        component.set("v.showBA",false);
        /*var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');        */
    },
    validateQuantity : function(component, event, helper) {
        component.find("AdjustType").set("v.errors", null);
        component.find("adjustedQty").set("v.errors", null);
        var originalQty = component.get('v.StockAdjustmentObj.sigmaerpdev2__Original_Qty__c');
        var adjustedQty = component.get('v.StockAdjustmentObj.sigmaerpdev2__Quantity__c');
        var adjustedType = component.get('v.StockAdjustmentObj.sigmaerpdev2__Adjust_Type__c');
        var proType = component.get('v.inventoryObj');
        
        if(adjustedType == '' || adjustedType == '--None--'){
            component.find("AdjustType").set("v.errors", [{message:"First select the adjust type."}]);
            return;
        }else if(adjustedQty > originalQty && adjustedType == 'Reduce Stock'){
            component.find("adjustedQty").set("v.errors", [{message:"Quantity should be Less than or Equal to original quantity."}]);
            return;
        }else if(adjustedQty < 1){
            component.find("adjustedQty").set("v.errors", [{message:"Adjusted quantity should not be non-negative and Zero."}]);
            return;
        }else if(proType.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c == 'SERIALIZED' && adjustedType == 'Increase Stock'){
            
            component.find("adjustedQty").set("v.errors", null);
            component.find("AdjustType").set("v.errors", null);
            var z = component.get('c.addilplitoWrap');
            $A.enqueueAction(z);
        }
            else if(proType.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c == 'BULK' && adjustedType == 'Increase Stock'){
                component.find("adjustedQty").set("v.errors", null);
                component.find("AdjustType").set("v.errors", null);
                var z = component.get('c.addilplitoWrapbulk');
                $A.enqueueAction(z);
                component.find("adjustedQty").set("v.errors", null);
            }else{
                component.find("adjustedQty").set("v.errors", null);
                component.find("AdjustType").set("v.errors", null);
            }
    },
	 addilplitoWrap :function(component, event, helper) 
    {
         // alert('addilplitoWrap');
        var adjustedQty = component.get('v.StockAdjustmentObj.sigmaerpdev2__Quantity__c');
        var WrapperArray = [];
        // let ilpliData=component.get('v.inventoryObj.sigmaerpdev2__Inventory_Location_Product_Line_Items__r');
        let ilpliData=component.get('v.Ilplidata');
       // let ilpliData=component.get('v.inventoryObj.sigmaerpdev2__Inventory_Location_Product_Line_Items__r');
       //  alert('ilpliData'+ilpliData[0].sigmaerpdev2__Unit_Price__c);
       const value='Stock Adjustment';
        for(var i= 0; i<adjustedQty; i++ ){
            WrapperArray.push({
                 'sigmaerpdev2__Adjusted_Quantity__c':1,
                'sigmaerpdev2__Recent_Adjusted_Quantity__c':1,
                'sigmaerpdev2__Lot__c':'',
                'sigmaerpdev2__Bin__c':'',
                'sigmaerpdev2__ILid__c':'',
                'sigmaerpdev2__Product_Expiry_Date__c':'',
                 'sigmaerpdev2__Unit_Price__c':0,
                'sigmaerpdev2__Stock_Type__c':value,
            });   
        }
       component.set("v.AddIlpli", WrapperArray); 
        
    },
    addilplitoWrapbulk :function(component, event, helper) {
         console.log('Ilplidata'+JSON.stringify(component.get('v.Ilplidata')));
      // alert('Ilplidata'+JSON.stringify(component.get('v.Ilplidata')));
        
       // alert('addilplitoWrapbulk');
        // alert('addilplitoWrapbulk'+JSON.stringify(component.get('v.inventoryObj.sigmaerpdev2__Inventory_Location_Product_Line_Items__r')));
         console.log('addilplitoWrapbulk'+JSON.stringify(component.get('v.inventoryObj')));
        var adjustedQty = component.get('v.StockAdjustmentObj.sigmaerpdev2__Quantity__c');
      // let ilpliData=component.get('v.inventoryObj.sigmaerpdev2__Inventory_Location_Product_Line_Items__r');
		//        let ilpliData=component.get('v.Ilplidata');

        //alert('ilpliData'+ilpliData[0].sigmaerpdev2__Unit_Price__c);
        var WrapperArray = [];
     const value='Stock Adjustment';
        WrapperArray.push({
            'sigmaerpdev2__Adjusted_Quantity__c':adjustedQty,
            'sigmaerpdev2__Recent_Adjusted_Quantity__c':adjustedQty,
            'sigmaerpdev2__Lot__c':'',
            'sigmaerpdev2__Bin__c':'',
            'sigmaerpdev2__ILid__c':'',
            'sigmaerpdev2__Product_Expiry_Date__c':'',
            'sigmaerpdev2__Unit_Price__c':0,
            'sigmaerpdev2__Stock_Type__c':value,
        });   
        
        component.set("v.AddIlpli", WrapperArray); 	
    },
    calledMe : function(component, event, helper){
        if(component.get("v.StockAdjustmentObj.sigmaerpdev2__Reason_Code__c")!='--None--')
        component.find("reasons").set("v.errors", null);
        else
        component.find("reasons").set("v.errors", [{message:"Please select the reason code."}]);
    },
    calledMe1: function(component, event, helper){
        if(component.get("v.StockAdjustmentObj.sigmaerpdev2__Date__c")!='')
        component.find("dateField").set("v.errors", null);
        else
        component.find("dateField").set("v.errors", [{message:"Please select the date$$$."}]);
    },
     processILPLI : function(component, event, helper) {
          //  component.set('v.isError', false);
            //			component.set('v.errorMsg', '');
        component.find("AdjustType").set("v.errors", null);
        component.find("adjustedQty").set("v.errors", null);
        var proType = component.get('v.inventoryObj');
        var changeType = component.get('v.StockAdjustmentObj');
        
        var originalQty = component.get('v.StockAdjustmentObj.sigmaerpdev2__Original_Qty__c');
        var adjustedQty = component.get('v.StockAdjustmentObj.sigmaerpdev2__Quantity__c');
        
        if(changeType.sigmaerpdev2__Quantity__c == ''){
            component.find("adjustedQty").set("v.errors", [{message:"Enter quantity."}]);
            return;
        }else if(changeType.sigmaerpdev2__Adjust_Type__c != 'Increase Stock' && adjustedQty > originalQty){
           
            component.find("adjustedQty").set("v.errors", [{message:"Adjusted Quantity should not greater than original Quantity."}]);
            return;
        }
        else if(proType.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c == 'SERIALIZED' && changeType.sigmaerpdev2__Adjust_Type__c == 'Increase Stock'){
            var z = component.get('c.addilplitoWrap');
            $A.enqueueAction(z);
            component.find("adjustedQty").set("v.errors", null);
        }
            else if(proType.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c == 'BULK' && changeType.sigmaerpdev2__Adjust_Type__c == 'Increase Stock'){
            var z = component.get('c.addilplitoWrapbulk');
            $A.enqueueAction(z);
            component.find("adjustedQty").set("v.errors", null);
        }else{
            component.find("adjustedQty").set("v.errors", null);
        }
    },
     cancelButton:function(cmp, event){
        window.history.back();
    },
   /* waiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "block";
    },
    
    doneWaiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "none";
    },
    */
    barCodeClear: function(component, event, helper) {
        if(!component.get('v.scannedProductBarCodeValue')){
            //$A.util.addClass(component.find('productNameDispaly'), 'slds-hide');
        }
    }

})