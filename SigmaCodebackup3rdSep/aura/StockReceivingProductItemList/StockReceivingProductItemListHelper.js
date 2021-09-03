({
	removeProductItem : function(component, index) {
        var StockInProductList = component.get("v.StockInProduct");
         var srlval = component.get("v.ProductSerNumberList");
       
        var j=index;
       
         component.set("v.srlList" , []);
        component.set("v.srlinsertList" , []);
        
        var srlist=component.get("v.srlList");
         var srlinsertList=component.get("v.srlinsertList");
        var flag=component.get("v.isflag");
      
       if(StockInProductList[j].Attribute_type == 'SERIALIZED')
       {
           component.set("v.isflag",false);
       
        for(var i=0;i<srlval.length;i++)
              {
                
                  if(StockInProductList[j].sigmaerpdev__Product__c==srlval[i].sigmaerpdev__Product_Code__c &&StockInProductList[j].sigmaerpdev__Pur_Order__c==srlval[i].sigmaerpdev__Purchase_Order__c && StockInProductList[j].sigmaerpdev__Purchase_Order__c==srlval[i].sigmaerpdev__Purchase_Order_Product__c&& StockInProductList[j].sigmaerpdev__Putaway_location__c==srlval[i].sigmaerpdev__Location__c)
                  {
                      srlist.push(srlval[i]);
                  }
                  else
                  {
                     srlinsertList.push(srlval[i]); 
                  }
                
              }
       }
       
        var action1= component.get("c.deleteProductSerialNumber");
         action1.setParams({ 
          "proSerialNumber" : JSON.stringify(srlist)
        });
         srlval.splice(srlist, 1);
         component.set("v.ProductSerNumberList", srlinsertList);
       
         $A.enqueueAction(action1);
        
        
        var action = component.get("c.deleteStockInProduct");        
        action.setParams({ 
          "StockInProduct" : JSON.stringify(StockInProductList[j])
        });
        StockInProductList.splice(index, 1);
        component.set("v.StockInProduct", StockInProductList);
        $A.enqueueAction(action);
    }
})