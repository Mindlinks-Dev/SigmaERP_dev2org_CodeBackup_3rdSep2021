public with sharing class Product_Trigger_Helper 
{
    public static void insertProduct(List<Product2> listOfpro)
    {
        Map<Id,Id>ProCurrIds=new Map<Id,Id>();
        System.debug('listOfpro=='+listOfpro);
        for(Product2 pro : listOfpro)
        {
            if(pro.Currency__c!=null )
            {
                ProCurrIds.put(pro.Id,pro.Currency__c);
                System.debug('ProCurrIds::'+ProCurrIds);
            }
        }
        System.debug('ProCurrIds::'+ProCurrIds);
        List<Id>currIds=ProCurrIds.values();
        if(currIds!=null &&  currIds.size()>0)
        {
            System.debug('currIds::'+currIds);
            List<Currency_Exchange_Rate__c> currExRate = [select id,Rate__c from Currency_Exchange_Rate__c where Currency__c =:currIds limit 1];
            System.debug('currExRate::'+currExRate);
            List<Currency__c>  crr=[select id,name,Symbol__c from Currency__c where id=:currIds limit 1]; 
            System.debug('crr::'+crr);
            // List<Product2>products= [select Product_Price__c,Exchange_Selling_Price__c,Exchange_Average_Selling_Price__c,Buying_Price__c from  Product2 where id=:ProCurrIds.keySet()];
            List<Product2>productsNew =new List<Product2>();
            System.debug('listOfpro::'+listOfpro);
            for(Product2 pro : listOfpro)
            {
                Product2 p=new Product2();
                if(pro.Product_Price__c!=null && currExRate[0].Rate__c!=null )
                {
                    Double amt=pro.Product_Price__c*currExRate[0].Rate__c;
                    string amtwithSymbol=crr[0].Symbol__c+amt;
                    system.debug('amtwithSymbol>>>'+amtwithSymbol); 
                    // String Rate=currExRate[0].Rate__c+'';
                    //  String ProductPrice= pro.Product_Price__c+'';
                    if(amtwithSymbol!=null)
                    {
                        pro.Exchange_Selling_Price__c=amtwithSymbol;
                    } 
                }
                if(pro.Buying_Price__c!=null && currExRate[0].Rate__c!=null)
                {
                    Double amt2=pro.Buying_Price__c*currExRate[0].Rate__c;
                    string amtwithSymbol2=crr[0].Symbol__c+amt2;
                    system.debug('amtwithSymbol>>>'+amtwithSymbol2);
                    if(amtwithSymbol2!=null)
                    {
                        pro.Exchange_Average_Selling_Price__c=amtwithSymbol2;     
                    }  
                }    
            }
        } 
    }
    public static void updateProduct(List<Product2> listOfpro)
    {
        Map<Id,Id>ProCurrIds=new Map<Id,Id>();
        System.debug('listOfpro=='+listOfpro);
        for(Product2 pro : listOfpro)
        {
            if(pro.Currency__c!=null)
            {
                ProCurrIds.put(pro.Id,pro.Currency__c);
                System.debug('ProCurrIds::'+ProCurrIds);
            }
        }
        System.debug('ProCurrIds::'+ProCurrIds);
        List<Id>currIds=ProCurrIds.values();
        if(currIds!=null &&  currIds.size()>0)
        {
            System.debug('currIds::'+currIds);
            List<Currency_Exchange_Rate__c> currExRate = [select id,Rate__c from Currency_Exchange_Rate__c where Currency__c =:currIds limit 1];
            System.debug('currExRate::'+currExRate);
            List<Currency__c>  crr=[select id,name,Symbol__c from Currency__c where id=:currIds limit 1]; 
            System.debug('crr::'+crr);
            // List<Product2>products= [select Product_Price__c,Exchange_Selling_Price__c,Exchange_Average_Selling_Price__c,Buying_Price__c from  Product2 where id=:ProCurrIds.keySet()];
            List<Product2>productsNew =new List<Product2>();
            System.debug('listOfpro::'+listOfpro);
            for(Product2 pro : listOfpro)
            {
                Product2 p=new Product2();
                if(pro.Product_Price__c!=null && currExRate[0].Rate__c!=null )
                {
                    Double amt=pro.Product_Price__c*currExRate[0].Rate__c;
                    string amtwithSymbol=crr[0].Symbol__c+amt;
                    system.debug('amtwithSymbol>>>'+amtwithSymbol); 
                    // String Rate=currExRate[0].Rate__c+'';
                    //  String ProductPrice= pro.Product_Price__c+'';
                    if(amtwithSymbol!=null)
                    {
                        pro.Exchange_Selling_Price__c=amtwithSymbol;
                    }
                }
                if(pro.Buying_Price__c!=null && currExRate[0].Rate__c!=null)
                {
                    Double amt2=pro.Buying_Price__c*currExRate[0].Rate__c;
                    string amtwithSymbol2=crr[0].Symbol__c+amt2;
                    system.debug('amtwithSymbol>>>'+amtwithSymbol2);
                    if(amtwithSymbol2!=null)
                    {
                        pro.Exchange_Average_Selling_Price__c=amtwithSymbol2;     
                    }  
                }   
            }
        }
    }  
}