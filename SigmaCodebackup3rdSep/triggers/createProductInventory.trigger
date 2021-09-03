/*------------------------------------------------------------
    Author: <Authors Name>
    Company: Mindlinks Solution
    Description: A utility class for the Helper class for all Triggers 
    Inputs: "Product" - Product objects that are being triggered
            "Product" - Product object values           
             
    Test Class: CustomLookupStockInTest
    History
    <Date>         <Authors Name>   <Brief Description of Change>
   
    27-10-2016     javed Added FLS & CRUD Check.
------------------------------------------------------------*/

trigger createProductInventory on Product2 (before insert, before Update, after insert){
    //code of Merged trigger (ProductExchangePriceUpdate)
    if(trigger.isBefore){
        if(trigger.isInsert){       
            List<Product2>listOfpro = trigger.new;
            Product_Trigger_Helper.insertProduct(listOfpro);
        }
        if(trigger.isUpdate){        
            List<Product2>listOfpro = trigger.new;
            Product_Trigger_Helper.updateProduct(listOfpro);
        }   
    }
    //ends here
    
    List<Inventory__c> inventory = new List<Inventory__c>();
    public String ParentId{get;set;}    
    Default_Parameters__c param = [select Id, Parent_Id__c from Default_Parameters__c limit 1];      
    ParentId = param.Parent_Id__c;  
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            for(Product2 Prd: trigger.new){
                if(Prd.Stock_Item__c)
                    inventory.add(new Inventory__c(ProductCode__c =Prd.Id,Delivered_Qty__c=0,Total_Available_Qty__C=0,Total_Qty__c=0,Account__c=ParentId ,Quantity_To_Become_Out_Of_Stock__c=0));
            }
            if(inventory.size() > 0)
                insert inventory; 
        }
    }
}