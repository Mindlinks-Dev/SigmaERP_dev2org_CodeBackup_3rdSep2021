({
	helperMethod : function() {
		
	},
    toggleClass: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.removeClass(modal,className+'hide');
		$A.util.addClass(modal,className+'open');
	},
    showPopupHelper: function(component, componentId, className){
        var modal = component.find(componentId); 
        $A.util.removeClass(modal, className+'hide'); 
        $A.util.addClass(modal, className+'open'); 
    },
    hidePopupHelper: function(component, componentId, className){ 
        var modal = component.find(componentId); 
        $A.util.addClass(modal, className+'hide'); 
        $A.util.removeClass(modal, className+'open'); 
       
    },
    
    removeProductItem : function(component, index) {
        var PSerialNumberList = component.get("v.PSerialNumber");
       
         var i=index;
       
       var action = component.get("c.removeProductSerialNumber");        
        action.setParams({ 
          "proSerialNumber" : JSON.stringify(PSerialNumberList[i])
        });
        PSerialNumberList.splice(index, 1);
        component.set("v.PSerialNumber", PSerialNumberList);
       $A.enqueueAction(action);
    },
    SPN : function(component,event,helper) {
      
         var savePSerialNumber=component.get("v.PSerialNumber");
          var  sInPro=component.get("v.StockInProduct");
          var ProductId;
          var POPID=sInPro.sigmaerpdev__Purchase_Order__c;
          this.upsertProductID(component, POPID, function(a) {
               ProductId=a.getReturnValue();
              
             });  
		
	},
    
     upsertProductID:function(component, POPID, callback) {
        var ProductId;
        var action = component.get("c.getProductId"); 
             action.setParams({"POPNumber":POPID});
             action.setCallback(this, function(a) {
                 var state = a.getState();
                  if(state==='SUCCESS') 
                 {
                   ProductId=a.getReturnValue();
                   var savePSerialNumber=component.get("v.PSerialNumber");
                   var  sInPro=component.get("v.StockInProduct");
                   var  slen=savePSerialNumber.length;
                   
                   for(var i=0; i < slen;i++)
          		   { 
                       savePSerialNumber[i].sigmaerpdev__Stock_Receiving_Product__c = sInPro.sigmaerpdev__pur_Order__c;
                      savePSerialNumber[i].sigmaerpdev__Location__c=sInPro.sigmaerpdev__Putaway_location__c;
                      savePSerialNumber[i].sigmaerpdev__Product_Code__c=ProductId;
                   }
                     var ss=component.get("v.PSerialNumber");
         		  	 var updateEvent =component.getEvent("GenerateProductSerialNumber");
                	 updateEvent.setParams({"ProductSerialNumber" : ss});
        				updateEvent.fire(); 
                    helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
                     helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');         
                 }
       
             });
             $A.enqueueAction(action);
    }
})