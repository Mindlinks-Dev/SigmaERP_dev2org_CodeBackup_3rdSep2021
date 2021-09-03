/*=====================================================================================================
Author   : Samad Ali,sandhya
Company  : Mindlinks Solution Pvt Ltd.
Class    : InventoryClass ,InventoryLocation
Date     : 05-07-2018              
=======================================================================================================*/
public with sharing class InventoryClass
{
    @AuraEnabled
    public static SoPaginationHelper fetchStappOrderList(Decimal pageNumber)
    {
        SoPaginationHelper r;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','Name','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','createddate'}))
        {*/
            Integer pageSize = 10;
            Integer offset = ((Integer)pageNumber - 1) * pageSize;
            r =  new SoPaginationHelper();
            r.pageSize = pageSize;
            r.page = (Integer) pageNumber;
            r.total = [SELECT count() FROM Inventory__c];
            //for FFTB purpose added code to get community user
            Id UserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserId];
            Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c)
            {
                r.soList = [select id,Name,Product_Name__c,ProductCode__c,Total_Qty__c,Available_Qty__c,Delivered_Qty__c,Reserved_Qty__c,Shipped_Qty__c from Inventory__c where ProductCode__r.Brewery_Account__c =: currentuser.Contact.AccountId order by createddate desc limit :pageSize offset :offset];
                r.total = [SELECT count() FROM Inventory__c where ProductCode__r.Brewery_Account__c =: currentuser.Contact.AccountId];
                r.IsCommunityUser = true;
            }
            else
            {
                r.soList = [select id,Name,Product_Name__c,Total_Qty__c,Available_Qty__c,Delivered_Qty__c,Reserved_Qty__c,Shipped_Qty__c from Inventory__c
                        order by createddate desc limit :pageSize offset :offset];
                r.total = [SELECT count() FROM Inventory__c];
                r.IsCommunityUser = false;
            }
        //}
        return r;
    }
    
    //code for Inventory Location Component
    @AuraEnabled
    public static SoPaginationHelper fetchILList(Decimal pageNumberIL)
    {
        SoPaginationHelper IL;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new Set<String>{'id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.Name','createddate','CreatedById'}))
        {*/
            Integer pageSize = 10;
            Integer offset = ((Integer)pageNumberIL - 1) * pageSize;
            IL =  new SoPaginationHelper();
            IL.pageSizeIL = pageSize;
            IL.pageIL = (Integer) pageNumberIL;
            Id UserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name from User where Id =: UserId];
            Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c)
            {
                IL.totalIL = [SELECT count() FROM Inventory_Location__c where CreatedById =: UserId];
                IL.ILList = [select id,Name,Location__c,Location__r.Name,createddate,CreatedById from Inventory_Location__c where CreatedById =: UserId order by createddate desc limit :pageSize offset :offset];
                IL.IsCommunityUser = true;
            }
            else
            {
                IL.totalIL = [SELECT count() FROM Inventory_Location__c];
                IL.ILList = [select id,Name,Location__c,Location__r.Name,createddate,CreatedById from Inventory_Location__c
                         order by createddate desc limit :pageSize offset :offset];
                IL.IsCommunityUser = false;
            }
            
       // }
        return IL;
    }
    
    @AuraEnabled
    public static string SaveIL(List<Inventory_Location__c> InvLoc)
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')){*/
        if(InvLoc.size() > 0){        
            insert InvLoc;
        }  
        //}       
        return InvLoc[0].Id;
    }
    
    @AuraEnabled
    public static String deleteInvLoc(Id LocID){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new set<String>{'id'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
          ){*/
              try{        
                  //delete package and its package products
                  List<Inventory_Location__c> delInvLocList = [select id from Inventory_Location__c where id = :LocID];
                  delete delInvLocList;
                  //ends here
              }
              catch(Exception e){
                  System.debug('Exception in Order Delete>>>>>'+e.getMessage());
                  return null;
              }
         // }
        return null;
    }
    
    @AuraEnabled
    public static string SaveILPRecord(List<Inventory_Location_Product__c> InvProd){
        
        List<Inventory_Location_Product__c> InvProdlist =  new List<Inventory_Location_Product__c>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Increased_Adjusted_Quantity__c','sigmaerpdev2__Reduced_Adjusted_Quantity__c','sigmaerpdev2__Rental_Delivered_Quantity__c','sigmaerpdev2__AdjustedReceivedqty__c','sigmaerpdev2__AvailableAdjustedQty__c'}))
        {*/
            if(InvProd.size() > 0)
            { 
                for(Inventory_Location_Product__c ILP: InvProd)
                {
                    ILP.Delivered_Quantity__c = 0;
                    ILP.Increased_Adjusted_Quantity__c =0;
                    ILP.Reduced_Adjusted_Quantity__c =0;
                    ILP.Rental_Delivered_Quantity__c = 0;
                    ILP.AdjustedReceivedqty__c = 0;
                    ILP.AvailableAdjustedQty__c = 0;
                    InvProdlist.add(ILP);
                }
                insert InvProdlist;
            } 
        //}
        return InvProdlist[0].Id;
    }
    
    @AuraEnabled
    public static List<Inventory_Location__c> CheckduplicateIL(String InvLocId)
    {
        
        
        List<Inventory_Location__c> CheckIL;
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new Set<String>{'Id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.Name'}))
        {*/
        CheckIL = [select Id,Name,Location__c,Location__r.Name from Inventory_Location__c where Location__r.Name =: InvLocId];
       // }
        if(!CheckIL.isEmpty())
        return CheckIL;
        else
        return null;
    }
    
    @AuraEnabled
    public static CommunityURLWrapper fetchJSONHelpMenu()
    {    
        CommunityURLWrapper Wrpadata = new CommunityURLWrapper();
        Id UserId= UserInfo.getUserId();
         
         Community_Configuration__c Custset= new Community_Configuration__c();
            Custset = [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
        User currentuser = [select Id,Profile.Name from User where Id =: UserId];
        StaticResource sr= [select id, body from StaticResource Where Name = 'JsonProdInvMM'];
        string allContent = sr.body.toString();
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(allContent);
        List<Object> trails = (List<Object>) results.get('Menu');        
        Wrpadata.listObjects = trails;
        Wrpadata.COmmURL = Custset.Retailer_Community_URL__c;
        if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c)
            Wrpadata.CommunityUser = true;
        else
            Wrpadata.CommunityUser = false;
        return Wrpadata; 
    }
    public class CommunityURLWrapper
    {
        @AuraEnabled
        public List<object> listObjects;
        @AuraEnabled
        public String COmmURL;
        @AuraEnabled
        public boolean CommunityUser;
    }
}