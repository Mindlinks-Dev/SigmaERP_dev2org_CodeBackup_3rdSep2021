({
    doInit : function(component, event, helper) {
       
    },
    
	
    addProducts : function(component,event,helper)
    {
       
        var rowIndex =event.getSource().get("v.name");
        component.set("v.isOpen", true);
        var Popupval = component.get("v.StockInProduct");
        
         var srlval = component.get("v.ProductSerNumberList");
       
        component.set("v.srlList" , []);
        var srlist=component.get("v.srlList");
       
       var flag=component.get("v.isflag");
        
       if(Popupval[rowIndex].Attribute_type == 'SERIALIZED')
       {
        for(var i=0;i<srlval.length;i++)
              {
                // if(flag==false)
                  //  {
                      
                         if(Popupval[rowIndex].sigmaerpdev__Product__c==srlval[i].sigmaerpdev__Product_Code__c && Popupval[rowIndex].sigmaerpdev__Pur_Order__c==srlval[i].sigmaerpdev__Purchase_Order__c &&  Popupval[rowIndex].sigmaerpdev__Purchase_Order__c==srlval[i].sigmaerpdev__Purchase_Order_Product__c  &&  Popupval[rowIndex].sigmaerpdev__Putaway_location__c==srlval[i].sigmaerpdev__Location__c)
                         {
                           
                            var index=i;
                            srlist.push(srlval[i]);
                        }
                   /* }
                  else
                  {
                      if(Popupval[rowIndex].sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__c==srlval[i].sigmaerpdev__Product_Code__c)
                      {
                          srlist.push(srlval[i]);
                      }
                  }*/
                   
           	  }
       }
        component.set("v.isloc",true);
		var appEvent  = $A.get("e.c:carryStockInEvent");
        appEvent.setParams({"stockIn" : Popupval[rowIndex],
                            "srlno" :srlist,
                            "rowIndex": rowIndex, 
                            "index": index
                           });
        appEvent.fire();
        
    },
    handleRemoveProductItemClick : function(component, event, helper) {
       var self = this;  // safe reference
		 var TestDelete1 = component.find('ModalDelete');
        $A.util.removeClass(TestDelete1, 'slds-hide');
         var index = event.target.dataset.index;
        component.set("v.index",index);
   },
    cancelModalDelete : function(component, event, helper) {
       
        var cancelModalDelete = component.find('ModalDelete');
        $A.util.addClass(cancelModalDelete, 'slds-hide');
    },
     confirmModalDelete : function(component, event, helper) 
    {
       var abc=  component.get("v.index");
        helper.removeProductItem(component, abc);
        var confirmModalDelete = component.find('ModalDelete');
        $A.util.addClass(confirmModalDelete, 'slds-hide');
    }
   
})