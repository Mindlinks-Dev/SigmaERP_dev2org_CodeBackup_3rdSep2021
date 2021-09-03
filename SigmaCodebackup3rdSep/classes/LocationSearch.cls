/*=====================================================================================================
Author   : Vikas
Company  : Mindlinks Solution Pvt Ltd.
Class    : Location Search View
Date     : 09-09-2019                
=======================================================================================================*/

public with sharing class LocationSearch{
    public class mainWrap
    {
        @auraenabled
        public List<locWrap> locList{get;set;} 
        @auraenabled
        public Integer totalRows{get;set;}      
        public mainWrap(List<locWrap> locList, Integer totalRows)
        {
            this.locList = locList;
            this.totalRows = totalRows;
        }
    }
    
    public class locWrap
    {
        @auraenabled
        public List<zoneWrap> zoneList{get;set;}
        @auraenabled
        public String locName{get;set;}
        @auraenabled
        public Id locId{get;set;}
        public locWrap(List<zoneWrap> zoneList, String locName, Id locId)
        {
            this.zoneList = zoneList;
            this.locName = locName;
            this.locId = locId;
        }
    }
    
    public class zoneWrap
    {
        @auraenabled
        public List<binWrap> binList{get;set;}
        @auraenabled
        public String zoneName{get;set;}
        @auraenabled
        public Id zoneId{get;set;}
        public zoneWrap(List<binWrap> binList, String zoneName, Id zoneId)
        {
            this.binList = binList;
            this.zoneName = zoneName;
            this.zoneId = zoneId;
        }
    }
    
    public class binWrap
    {       
        @auraenabled
        public String binName{get;set;}
        @auraenabled
        public Id binId{get;set;}
        public binWrap(String binName, Id binId)
        {    
            this.binName = binName;
            this.binId = binId;
        }
    }
    
    @auraenabled         
    public static mainWrap fetchLocations(String LocId, String limits , String offsets){
        Integer intlimits = integer.valueof(limits);
        Integer intoffsets = integer.valueof(offsets);
        
        List<AggregateResult> result;
        Integer rowscount; 
        
        Map<Id, List<locWrap>> locFinalMapList = new Map<Id, List<locWrap>>();
        List<locWrap> locWrapList = new List<locWrap>();
        Set<Id> locSet = new Set<Id>();
        List<Sublevel_location__c> subLevelList = new List<Sublevel_location__c>();
        if(LocId != null && LocId != ''){
            subLevelList = [select Inventory_Location__r.Location__c,Inventory_Location__r.Location__r.Name,id,name,(select zone__c, id,name from Zone_Sublevel_locations__r) 
                            from Sublevel_location__c where Inventory_Location__r.Location__c = :LocId and RecordType.Name != 'Bin'];             
            result = [SELECT COUNT(Id) total FROM Sublevel_location__c where Location__c = :LocId and RecordType.Name != 'Bin'];
            rowscount = (Integer)result[0].get('total');
        }else{            
            subLevelList = [select Inventory_Location__r.Location__c,Inventory_Location__r.Location__r.Name,id,name,(select zone__c, id,name from Zone_Sublevel_locations__r) 
                            from Sublevel_location__c where RecordType.Name != 'Bin' and Inventory_Location__r.Location__r.Name != null order by createddate desc Limit :intlimits Offset :intoffsets];             
            result = [SELECT COUNT(Id) total FROM Sublevel_location__c GROUP BY Inventory_Location__r.Location__r.Name HAVING COUNT(Id) > 1];            
            rowscount = result.size();
        }
        
        Map<Id, List<zoneWrap>> locZoneMapList = new Map<Id, List<zoneWrap>>();
        Map<Id, String> locNameMap = new Map<Id, String>();
        
        if(subLevelList.size() > 0){
            for(Sublevel_location__c subObj : subLevelList){
                if(subObj.Inventory_Location__r.Location__c != null){
                    List<zoneWrap> zoneList = new List<zoneWrap>();
                    locSet.add(subObj.Inventory_Location__r.Location__c);
                    locNameMap.put(subObj.Inventory_Location__r.Location__c, subObj.Inventory_Location__r.Location__r.Name);
                    List<binWrap> binWrapList = new List<binWrap>();                
                    for(Sublevel_location__c binObj : subObj.Zone_Sublevel_locations__r){               
                        if(subObj.Id == binObj.zone__c){
                            binWrap binWrapObj = new binWrap(null, null);
                            binWrapObj.binName = binObj.Name;
                            binWrapObj.binId = binObj.Id;
                            binWrapList.add(binWrapObj);                    
                        }
                    }
                    if(!locZoneMapList.containsKey(subObj.Inventory_Location__r.Location__c)){
                        zoneList.add(new zoneWrap(binWrapList, subObj.name,subObj.Id)); 
                    }else{
                        zoneList = locZoneMapList.get(subObj.Inventory_Location__r.Location__c);
                        zoneList.add(new zoneWrap(binWrapList, subObj.name, subObj.Id)); 
                    }
                    locZoneMapList.put(subObj.Inventory_Location__r.Location__c, zoneList);
                }   
            }
            
            if(locZoneMapList.size() > 0){
                for(Id locationId : locZoneMapList.keySet()){
                    locWrapList.add(new locWrap(locZoneMapList.get(locationId), locNameMap.get(locationId), locationId));
                }
            }
            return new mainWrap(locWrapList, rowscount);     
        }else{
            return null;
        }
    }
}