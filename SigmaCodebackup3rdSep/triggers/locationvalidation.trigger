trigger locationvalidation on Product_Price__c(before insert,before update)
{
    List<Product_Price__c> newprice = Trigger.New;
    System.debug('newprice '+newprice );
  List<Product_Price__c> pricerecords =[select id,name,Product_Id__c,Location__c from Product_Price__c where Product_Id__c=:newprice[0].Product_Id__c];
    
     if(trigger.isinsert)
     {
     
      for(Product_Price__c price :pricerecords)
       {
           if(newprice[0].Product_Id__c==price.Product_Id__c && newprice[0].Location__c==price.Location__c)
           {
                newprice[0].addError('This location already has product price.');

           }
       }
     }
     if(Trigger.isUpdate)
     {
     
      for(Product_Price__c price :pricerecords)
       {
           if(newprice[0].id!=price.id&& newprice[0].Location__c==price.Location__c)
           {
                newprice[0].addError('This location already has product price.');

           }
       }
     }
}