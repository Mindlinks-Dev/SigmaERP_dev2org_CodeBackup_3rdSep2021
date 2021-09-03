public with sharing  class ProposalController
{
    public class WrappedILP
    {
        @AuraEnabled
        public Id locationId;
       @AuraEnabled
        public Id ILPId;
        @AuraEnabled
        public String LocationName;
        @AuraEnabled
        public Decimal Availableqty;
        @AuraEnabled
        public Integer Quantity;
        @AuraEnabled
        public Boolean checkBox;
        @AuraEnabled
        public Product_Price__c pp;
        @AuraEnabled
        public Integer daysCount;
        @AuraEnabled
        public Decimal locationDiscount;
		
    }
	
	
    public class wrapperList
    {
        @AuraEnabled
        public String ProName;
        @AuraEnabled
        public List<WrappedILP> ilpUiList;
        @AuraEnabled
        public decimal lineitemDiscount;
        @AuraEnabled
        public Id ProId;
        @AuraEnabled
        public Inventory_Location_Product__c lineItemDate;

    }
    public class wrappereditflow
    {
        @AuraEnabled
        public List<wrapperListInsertLineItems> wrapperListInsertLineItems;
        @AuraEnabled
        public List<wrapperList> wrapperList;
        @AuraEnabled
        public  Proposal__c proposalobj {get;set;}
    }
    public class wrapperListInsertLineItems
    {
        @AuraEnabled
        public Proposal_Item__c LineItem;
        @AuraEnabled
        public String proname;
        @AuraEnabled
        public List<locationquantity> locqty;
    }
    public class locationquantity
    {
        @AuraEnabled
        public Id locid;
        @AuraEnabled
        public Id ILPId;
        @AuraEnabled
        public decimal Quantity;
        @AuraEnabled
        public decimal locdis;
        @AuraEnabled
        public decimal loccost;

    }
    @AuraEnabled
    public static List<String> getProposalStatus()
    {
        List<String> options = new List<String>();
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal__c')
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal__c',new set<String>{'sigmaerpdev2__Status__c'}))
            {*/
                Schema.DescribeFieldResult fieldResult = Proposal__c.Status__c.getDescribe();
                options.add('--Select--');
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for (Schema.PicklistEntry f: ple) 
                {
                    options.add(f.getLabel());
                }
           // }
        return options;
    }
    @AuraEnabled  
    public static List<Product2> getProducts()
    {
        List<Product2> ProductList;
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev2__Active__c'}))
        {*/
            ProductList = new List<Product2>();
            ProductList = [select id, Name from Product2 where Active__c = true Order By Name];
        //}
        return ProductList;
    }
    public  static Map<Date, Integer> getDaysInMonth(Date Sdate, Date Edate)
    {
        Map<Date, Integer> DaysMap = new Map<Date, Integer>();
        Integer numberDays = 0;
        Date firstDate = Date.newInstance(Sdate.Year(), Sdate.Month(), Sdate.Day());
        Date secondDate = Date.newInstance(Edate.Year(), Edate.Month(), Edate.Day());
        Integer monthsBetween = firstDate.monthsBetween(secondDate);
        monthsBetween = monthsBetween+ 1;
        Integer SDateYear = Sdate.Year();
        Integer SDateMonth = Sdate.Month();
        Integer newMonth = 0;
        
        for(Integer i =0; i < monthsBetween; i++)
        {
            date newDate;
            numberDays =0;
            newMonth = 0;
            newDate = firstDate.addMonths(i);
            Date MatchPriceDate = Date.valueof(newDate.year()+'-'+newDate.Month()+'-01');
            numberDays = date.daysInMonth(newDate.year() , newDate.month());
            if(i == 0)
            {
                if(Sdate.day() >1)
                {
                    numberDays = numberDays - Sdate.Day();
                    numberDays = numberDays+1;
                }
            }
            if(i == monthsBetween-1)
            {
                numberDays = Edate.Day();
            }
            if(i==0 && Sdate.Month() == Edate.Month() && Sdate.Year() == Edate.Year())
            {
                if(Sdate.day() >1)
                {
                    numberDays = Edate.Day() - Sdate.Day();
                    numberDays = numberDays+1;
                }
                else
                {
                    numberDays =  Edate.Day();
                }
            }
            DaysMap.put(MatchPriceDate, numberDays);
            i = i++;
        }
        return DaysMap;
    }
    
    @AuraEnabled  
    public static wrapperList productdetails(String Proid,Inventory_Location_Product__c DateIlp)
    {
        
        wrapperList wrapper;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Price__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Partner__r.Name','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.Name','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Price__c',new set<String>{'id','Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.Name','sigmaerpdev2__End_Date__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__Product_Id__c','sigmaerpdev2__Status__c','sigmaerpdev2__Production_Cost__c'})
        )
        {
            List<wrapperList> WrapList;
            //to get start and end date of the month.
            Date firstDayOfMonth = (DateIlp.Start_Date__c).toStartOfMonth();
            Date getLastMonthDate = (DateIlp.End_Date__c);
            Integer dayNumbers = Date.daysInMonth((getLastMonthDate).year(), (getLastMonthDate).month());
            Date lastDayOfMonth = Date.newInstance(getLastMonthDate.year(), getLastMonthDate.month(), dayNumbers);
            // To have List of months
            Set<Integer> MonthInteger = new Set<Integer>();
            MonthInteger.add(DateIlp.Start_Date__c.month());
            Integer differanceMonth = (DateIlp.Start_Date__c).monthsBetween(DateIlp.End_Date__c);
            if(differanceMonth > 0)
            {
                Date ref = DateIlp.Start_Date__c.addMonths(1);
                for(Integer i = 0; i< differanceMonth; i++)
                {
                    MonthInteger.add(ref.month());
                    ref = ref.addMonths(1);
                }
            }
            map<id,Map<Integer,Inventory_Location_Product__c>> LocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
            map<id,Map<Integer,Inventory_Location_Product__c>> validLocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
                  
            map<id,Map<Integer,Product_Price__c>> LocAndPPList = new map<id,Map<Integer,Product_Price__c>>();
            map<id,Map<Integer,Product_Price__c>> validLocAndPPList = new map<id,Map<Integer,Product_Price__c>>();
             
            Product2 proList = [select id, Name,(select id, name, Net_Quantity__c, Received_Quantity__c, Inventory_Location__c, Partner__r.Name,  Inventory_Location__r.Location__c, Inventory_Location__r.Location__r.Name, Start_Date__c,End_Date__c  from Inventory_Location_Products__r where ((Start_Date__c >=: firstDayOfMonth) And (End_Date__c <=: lastDayOfMonth) And (Net_Quantity__c >= 0))),
                           (select id, Name,Cost__c,Location__c,Location__r.Name,End_Date__c,Start_Date__c,Product_Id__c, Status__c,Production_Cost__c  from Product_Prices__r where Product_Id__c =:proId AND (Start_Date__c >=: firstDayOfMonth) And (End_Date__c <=: lastDayOfMonth)  AND (Status__c = 'Active')) from Product2 where id =: Proid];

               System.debug('uuuuuuuuuuuuuuuuuuu'+proList);
            String PRONAME='';
            Id PROId1;
            Product2 pro=proList;
            Map<Id, List<Product_Price__c>> PPListMap = new Map<Id, List<Product_Price__c>> ();
                   
            Integer NumberofDays = 0;
            Date startDate = Date.newInstance(DateIlp.Start_Date__c.Year(), DateIlp.Start_Date__c.Month(), DateIlp.Start_Date__c.Day());
            Date dueDate = Date.newInstance(DateIlp.End_Date__c.Year(), DateIlp.End_Date__c.Month(), DateIlp.End_Date__c.Day());
            NumberofDays = startDate.daysBetween(dueDate);
            NumberofDays = NumberofDays+1;
            Map<Date,Integer> getDaysInMonthMap =  getDaysInMonth(DateIlp.Start_Date__c, DateIlp.End_Date__c);  
            System.debug('getDaysInMonthMap'+getDaysInMonthMap); 
            Map<Id, Product_Price__c> PPMap = new Map<Id, Product_Price__c> ();
            //product Price
            for(Product_Price__c PPList : pro.Product_Prices__r)
            {
            if(LocAndPPList.containsKey(PPList.Location__c))
            {
                LocAndPPList.get(PPList.Location__c).put(PPList.Start_Date__c.month(),PPList);
            }
            else
            {
                LocAndPPList.put(PPList.Location__c, new Map<Integer, Product_Price__c>{(PPList.Start_Date__c.month()) => PPList});
            }

            }//end of inner for loop  

            if(LocAndPPList.size() > 0)
            {
                for(Id LocId : LocAndPPList.keySet())
                {
                    Boolean checkNumberOfMonth = true;
                    Map<Integer,Product_Price__c> oneLocppList = LocAndPPList.get(LocId);
                    for(Integer MonInteger : MonthInteger)
                    {
                        if(!(oneLocppList.ContainsKey(MonInteger)))
                        {
                            checkNumberOfMonth = false;
                        }
                    }
                    if(checkNumberOfMonth)
                    {
                        validLocAndPPList.put(LocId,oneLocppList);
                    }
                }
            }
            if(validLocAndPPList.size() > 0)
            {
                for(Id locId : validLocAndPPList.keySet())
                {
                    List<Product_Price__c> PPListValid = new List<Product_Price__c>();
                    for(Integer intMonth : validLocAndPPList.get(locId).keySet())
                    {
                        PPListValid.add(validLocAndPPList.get(locId).get(intMonth));
                    }
                    PPListMap.put(locId, PPListValid);
                }
            }
            for(Id LocationId : PPListMap.keySet())
            {
                Product_Price__c pp = new Product_Price__c();
                pp.Cost__c = 0.00;
                Integer DayInMonthValue =0;
                Integer total=0;
                List<Product_Price__c> ppList = PPListMap.get(LocationId);
                system.debug('ppList>>>'+ppList);
                Decimal costForNumberOfdays=0.00;
                for(Product_Price__c indPP : ppList)
                {
                    System.debug('getDaysInMonthMap'+getDaysInMonthMap);
                    System.debug('indPP.Start_Date__c'+indPP.Start_Date__c);
                    DayInMonthValue = getDaysInMonthMap.get(indPP.Start_Date__c);
                    system.debug('month>>>>'+DayInMonthValue);
                    Date daysInMonth = indPP.Start_Date__c;
                    system.debug('daysInMonth>>>>>'+daysInMonth);
                    system.debug('cost issssssssssssssss'+indpp.Cost__c);   
                    //Integer cost = (integer)indPP.Cost__c;
                   // system.debug('costvalue>>'+cost);
                    Integer daysforMonth = date.daysInMonth(daysInMonth.year(),daysInMonth.month());
                    system.debug('daysforMonth>>>'+daysforMonth);
                    system.debug('costForNumberOfdays>>>++++'+costForNumberOfdays);
                    //total= (cost/daysforMonth);
                   // system.debug('total>>>'+total);
                    costForNumberOfdays = costForNumberOfdays +(( indPP.Cost__c /daysforMonth)*DayInMonthValue);
                    system.debug('costForNumberOfdays>>>'+costForNumberOfdays);
                }
                pp.Cost__c = costForNumberOfdays.setScale(2);
                system.debug('cost>>>>>>>'+pp.Cost__c);
                pp.Location__c = LocationId;
                PPMap.put(LocationId,pp);
                //System.debug('locaaaaaaaaaaaaaaaaaation Id'+LocationId);
            }
            PRONAME = pro.Name;
            PROId1 = pro.Id;
            System.debug('pro.Inventory_Location_Products__r:::'+pro.Inventory_Location_Products__r);
            for(Inventory_Location_Product__c ilp : pro.Inventory_Location_Products__r)
            {
                if(LocAndILPList.containsKey(ilp.Inventory_Location__c))
                {
                    LocAndILPList.get(ilp.Inventory_Location__c).put(ilp.Start_Date__c.month(),ilp);
                }
                else{
                    LocAndILPList.put(ilp.Inventory_Location__c, new Map<Integer, Inventory_Location_Product__c>{(ilp.Start_Date__c.month()) => ilp});
                }
            }
           // System.debug('LocAndILPList:::::::::::::::'+LocAndILPList);
            if(LocAndILPList.size() > 0)
            {
                for(Id LocId : LocAndILPList.keySet())
                {
                    Boolean checkNumberOfMonth = true;
                    Map<Integer,Inventory_Location_Product__c> oneLocIlpList = LocAndILPList.get(LocId);
                    System.debug('oneLocIlpList:::'+oneLocIlpList);
                    System.debug('MonthInteger:::'+MonthInteger);                
                    for(Integer MonInteger : MonthInteger)
                    {
                        if(!(oneLocIlpList.ContainsKey(MonInteger)))
                        {
                            checkNumberOfMonth = false;
                        }
                    }
                    if(checkNumberOfMonth)
                    {
                        validLocAndILPList.put(LocId,oneLocIlpList);
                    }
                }
            }
            System.debug('validLocAndILPList:::'+validLocAndILPList);  
            List<WrappedILP> WrapILPList= new List<WrappedILP>();            
            if(validLocAndILPList.size() > 0)
            {
                for(Id locId : validLocAndILPList.keySet())
                {
                    Map<Integer,Inventory_Location_Product__c> oneLocIlpList = validLocAndILPList.get(LocId);
                    Inventory_Location_Product__c IlpOneToGetLocName = new Inventory_Location_Product__c();
                    List<Integer> toGetMinVal = new List<Integer>();
                    for(Integer mon : oneLocIlpList.keySet())
                    {
                        IlpOneToGetLocName = oneLocIlpList.get(mon);
                        toGetMinVal.add(Integer.valueOf(IlpOneToGetLocName.Net_Quantity__c));
                    }
                    toGetMinVal.sort();
                    System.debug('IlpOneToGetLocName::::'+IlpOneToGetLocName);

                    WrappedILP ilp=new WrappedILP();
					
                    ilp.locationId=IlpOneToGetLocName.Inventory_Location__r.Location__c;
                    ilp.ILPId=IlpOneToGetLocName.id;
                    ilp.LocationName=IlpOneToGetLocName.Inventory_Location__r.Location__r.Name;
                    ilp.Availableqty=toGetMinVal[0];
                    ilp.checkBox=false;
                    System.debug('abcd'+PPMap.get(IlpOneToGetLocName.Inventory_Location__r.Location__c));
                    if(PPMap.get(IlpOneToGetLocName.Inventory_Location__r.Location__c)==null)
                    {
                        Product_Price__c proprice=new Product_Price__c();
                        proprice.Cost__c=0;
                        ilp.pp=proprice; 
                    }
                    else
                    {
                      ilp.pp=PPMap.get(IlpOneToGetLocName.Inventory_Location__r.Location__c);   
                    }
                   
                    ilp.daysCount=NumberofDays;
                    ilp.Quantity=0;
                    ilp.locationDiscount=0;
                    WrapILPList.add(ilp);

                }
            }
            wrapper=new wrapperList();
            wrapper.ProName=PRONAME;
            wrapper.ilpUiList=WrapILPList;
            wrapper.lineitemDiscount=0.00;
            wrapper.ProId=PROId1;
            wrapper.lineItemDate=DateIlp;
            System.debug('wrapper::'+wrapper);
            
        }
        return wrapper;        
    }
	
	
    @AuraEnabled     
    public static wrappereditflow editrecord(String proposalid)
    {
        
        wrappereditflow editflow;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__ProposalLineItemLocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Price__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__ProposalLineItemLocation__c')
        
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal__c',new set<String>{'Id','Name','sigmaerpdev2__Proposal_Name__c','sigmaerpdev2__Inventory_Allocated__c','sigmaerpdev2__Client__c','sigmaerpdev2__Client__r.Name','sigmaerpdev2__Agency__c','sigmaerpdev2__Agency__r.Name','sigmaerpdev2__Contact__c','sigmaerpdev2__Billing_Contact__c','sigmaerpdev2__Billing_Contact__r.Name','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Account_Executive__c','sigmaerpdev2__Account_Executive__r.Name','sigmaerpdev2__Account_Executive1__c','sigmaerpdev2__Account_Executive1__r.Name','sigmaerpdev2__Account_Executive2__c','sigmaerpdev2__Account_Executive2__r.Name','sigmaerpdev2__Ownership__c','sigmaerpdev2__Ownership1__c','sigmaerpdev2__Ownership2__c','sigmaerpdev2__Is_Order_Created__c','sigmaerpdev2__Industry_Exclusively__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Status__c','sigmaerpdev2__Payment_Terms__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Charges_Comments__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Other_Discount_Comments__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Discount_Method_Option_Value__c','sigmaerpdev2__Discount_Method__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Agent_Commission__c','sigmaerpdev2__Agent_Commission_Euro__c','sigmaerpdev2__Agency_Percent__c','sigmaerpdev2__Billing_Start_Date__c','sigmaerpdev2__Billing_End_Date__c','sigmaerpdev2__Deduct_from_Net__c','sigmaerpdev2__Account_Executive_1_acc__c','sigmaerpdev2__Account_Executive_2_Acc__c','sigmaerpdev2__Account_Executive_3_Acc__c','sigmaerpdev2__Account_Executive_1_acc__r.Name','sigmaerpdev2__Account_Executive_2_Acc__r.Name','sigmaerpdev2__Account_Executive_3_Acc__r.Name','sigmaerpdev2__Type__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Sum_Location_Discount__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Product__r.Name'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Proposal_Item__c',new Set<String>{'sigmaerpdev2__Proposal__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__ProposalLineItemLocation__c',new Set<String>{'id','sigmaerpdev2__Product_Inventory_Location__c','sigmaerpdev2__Product_Inventory_Location__r.sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Location__c','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Location_Discount_Euro__c','sigmaerpdev2__Production_Cost__c','sigmaerpdev2__Production_Cost_Euro__c','sigmaerpdev2__Monthly_Impressions__c','sigmaerpdev2__Cost__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Price__c',new Set<String>{'id','Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Monthly_Impressions__c','sigmaerpdev2__Cost_Value__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__Product_Id__c','sigmaerpdev2__Status__c','sigmaerpdev2__Production_Cost__c','sigmaerpdev2__HiddenSelectedUnits__c','sigmaerpdev2__Location__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev2__Products__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.Name','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Number_of_Screens__c','sigmaerpdev2__Message__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__ProposalLineItemLocation__c',new Set<String>{'id','sigmaerpdev2__Product_Inventory_Location__c','sigmaerpdev2__Product_Inventory_Location__r.sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Location__c','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Location_Discount_Euro__c','sigmaerpdev2__Production_Cost__c','sigmaerpdev2__Production_Cost_Euro__c','sigmaerpdev2__Monthly_Impressions__c','sigmaerpdev2__Cost__c'})
        )
        {
            
            Proposal__c proposalobj1=[select Id,Name,Proposal_Name__c,Inventory_Allocated__c,Client__c,Client__r.Name,Agency__c,Agency__r.Name,Contact__c,Billing_Contact__c,Billing_Contact__r.Name,Start_Date__c,End_Date__c,Account_Executive__c,Account_Executive__r.Name,Account_Executive1__c,Account_Executive1__r.Name,Account_Executive2__c,Account_Executive2__r.Name,Ownership__c,Ownership1__c,
                                 Ownership2__c,Is_Order_Created__c,Industry_Exclusively__c,Discount__c,Status__c,Payment_Terms__c,Field_Discount_Amount__c,Other_Charges_Comments__c,Other_Charges__c,Other_Discount_Comments__c,Other_Discount__c,
                     Discount_Method_Option_Value__c,Discount_Method__c,Other_Charges_Euro__c,Other_Discount_Euro__c,Field_Discount_Amount_Euro__c,Agent_Commission__c,Agent_Commission_Euro__c,Agency_Percent__c,
                     Billing_Start_Date__c, Billing_End_Date__c,Deduct_from_Net__c,Account_Executive_1_acc__c,Account_Executive_2_Acc__c,Account_Executive_3_Acc__c,Account_Executive_1_acc__r.Name,Account_Executive_2_Acc__r.Name,Account_Executive_3_Acc__r.Name,Type__c from Proposal__c where id=:proposalid];
                     
            List<Proposal_Item__c> proposalitems =[select Id, Name,Product__c,Quantity__c,Cost__c,Sum_Location_Discount__c,Discount__c,Start_Date__c,End_Date__c from Proposal_Item__c WHERE Proposal__c=:proposalid ];
            Map<id,Proposal_Item__c> getproposal=new Map<id,Proposal_Item__c>();
            for(Proposal_Item__c tempPropList :proposalitems)
            {
                getproposal.put(tempPropList.id,tempPropList);
            }
                                                               
            List<Proposal_Item__c> proposalline =[select Id, Name,Product__c,Quantity__c,Cost__c,Sum_Location_Discount__c,Discount__c,Start_Date__c,End_Date__c,Proposal__c,Product__r.Name,
                                                            (select id,Product_Inventory_Location__c,Product_Inventory_Location__r.Net_Quantity__c,Quantity__c , Product_Price__c, Location__c,
                                  Location_Discount__c,Location_Discount_Euro__c,Production_Cost__c,
                                  Production_Cost_Euro__c,Monthly_Impressions__c,Cost__c from CampaignLineItemLocations__r) 
                                   from Proposal_Item__c WHERE Proposal__c=:proposalid ];

            system.debug('proposalline'+proposalline);
            List<Id> ProId = new List<Id>();
            Map<Id, decimal> productIdAndLineItemDiscount = new Map<Id, decimal>();
            Map<id,wrapperListInsertLineItems> LineMap = new Map<id,wrapperListInsertLineItems>();
            Map<Id,Date> PraPosalStartDateMap = new Map<Id,Date>();
            Map<Id,Date> PraPosalEndDateMap = new Map<Id,Date>();
            Set<Id> PrposalIDs = new Set<Id>(); 
            List<wrapperListInsertLineItems> proposalitemlist=new List<wrapperListInsertLineItems>();
            Map<id,Integer> refvalue = new Map<id,Integer>();
            Map<id,Decimal> refvalueLocationDiscount = new Map<id,Decimal>();
            Map<id,ProposalLineItemLocation__c> newApp = new Map<id,ProposalLineItemLocation__c>();
            Map<id,Map<Id,Integer>> NewMap = new Map<id,Map<Id,Integer>>();
            Map<id,Map<Id,Decimal>> LocationDiscountNewMap = new Map<id,Map<Id,Decimal>>();
            Map<id,Map<Id,ProposalLineItemLocation__c>> ChildItemLoc = new Map<id,Map<Id,ProposalLineItemLocation__c>>();

            for(Proposal_Item__c tempPropList :proposalline)
            {
                id produtId = tempPropList.Product__c;
                wrapperListInsertLineItems proposalitem=new wrapperListInsertLineItems();
                proposalitem.LineItem=getproposal.get(tempPropList.id);
                proposalitem.proname=tempPropList.Product__r.Name;
                LineMap.put(Id.valueOf(tempPropList.Product__c),proposalitem);
                ProId.add(tempPropList.Product__c);
                productIdAndLineItemDiscount.put(tempPropList.Product__c, tempPropList.Discount__c);
                PraPosalStartDateMap.put(tempPropList.Product__c,tempPropList.Start_Date__c);
                PraPosalEndDateMap.put(tempPropList.Product__c,tempPropList.End_Date__c);
                PrposalIDs.add(tempPropList.Id);

                List<locationquantity> locdatalist=new List<locationquantity>();
                for(ProposalLineItemLocation__c Change: tempPropList.CampaignLineItemLocations__r)
                {
                    locationquantity locdata=new locationquantity();
                    locdata.locid=Change.Location__c;
                    locdata.ILPId=Change.Product_Inventory_Location__c;
                    locdata.Quantity=Change.Quantity__c;
                    locdata.locdis=Change.Location_Discount__c;
                    locdata.loccost=Change.Cost__c;

                    locdatalist.add(locdata);
                    refvalue.put(Change.Location__c, Integer.valueOf(Change.Quantity__c));
                    refvalueLocationDiscount.put(Change.Location__c, Change.Location_Discount__c);
                    newApp.put(Change.Location__c,Change);
                }//end of locationitem for loop

                proposalitem.locqty=locdatalist;
                proposalitemlist.add(proposalitem); 
                NewMap.put(produtId,refvalue);
                LocationDiscountNewMap.put(produtId, refvalueLocationDiscount);
                ChildItemLoc.put(produtId,newApp);
            }//end of proposalitem for loop

            Map<id,Date> startdate1 = new  Map<id,Date>();
            Map<id,Date>  enddate = new  Map<id,Date>();
            for(id proid1 : ProId)
            {
                Date RefStart = PraPosalStartDateMap.get(proid1);
                Date RefEnd = PraPosalEndDateMap.get(proid1);
                //to get Start date and end date
                Date firstDayOfMonth = (RefStart).toStartOfMonth();
                startdate1.put(proid1,firstDayOfMonth);
                Date getLastMonthDate = (RefEnd);
                Integer dayNumbers = Date.daysInMonth((getLastMonthDate).year(), (getLastMonthDate).month());
                Date lastDayOfMonth = Date.newInstance(getLastMonthDate.year(), getLastMonthDate.month(), dayNumbers);
                enddate.put(proid1,lastDayOfMonth);
                system.debug('startdate'+startdate1);
                system.debug('enddate'+enddate);
            }

            List<Product2> proList = [select id, Name,(select id, name,Products__c, Net_Quantity__c, Received_Quantity__c,Inventory_Location__c, Inventory_Location__r.Location__r.Name, Start_Date__c, End_Date__c,Number_of_Screens__c, Message__c,Inventory_Location__r.Location__c  from Inventory_Location_Products__r where Net_Quantity__c >= 0),
            (select id, Name,Cost__c,Monthly_Impressions__c,Cost_Value__c,End_Date__c,Start_Date__c,Product_Id__c,Status__c,Production_Cost__c,HiddenSelectedUnits__c,Location__c from Product_Prices__r where Product_Id__c =:ProId AND Status__c = 'Active') from Product2 where id =: ProId];
            map<id,Map<Integer,Inventory_Location_Product__c>> LocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
            map<id,Map<Integer,Inventory_Location_Product__c>> validLocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();

            Map<Id, Product_Price__c> PPMap = new Map<Id, Product_Price__c> ();
            List<wrapperList> editwrapperlist=new List<wrapperList>();    
            for(Product2 pro: proList)
            {
                Integer NumberofDays = 0;
                Integer DayInMonthValue = 0;
                Decimal editProductionCost =0.00;
                Map<id,Integer> JustToCheck = new Map<id,Integer>();
                Map<id,Decimal> GetLocationDiscountMap = new Map<id,Decimal>();

                JustToCheck = (Map<id,Integer>)NewMap.get(pro.id);          
                GetLocationDiscountMap = (Map<id,Decimal>)LocationDiscountNewMap.get(pro.id);
                Date RefStart = PraPosalStartDateMap.get(pro.id);
                Date RefEnd = PraPosalEndDateMap.get(pro.id);
                Date startDate = Date.newInstance(RefStart.Year(), RefStart.Month(), RefStart.Day());
                Date dueDate = Date.newInstance(RefEnd.Year(), RefEnd.Month(), RefEnd.Day());
                NumberofDays = startDate.daysBetween(dueDate);
                NumberofDays = NumberofDays+1; 
                Map<Id, List<Product_Price__c>> PPListMap = new Map<Id, List<Product_Price__c>> ();
                for(Product_Price__c PPList : pro.Product_Prices__r)
                {
                    if(startdate1.containsKey(PPList.Product_Id__c) && PPList.Start_Date__c >=startdate1.get(PPList.Product_Id__c) &&PPList.End_Date__c <= enddate.get(PPList.Product_Id__c))
                    {
                        if(PPListMap.containsKey(PPList.Location__c))
                        {
                            PPListMap.get(PPList.Location__c).add(PPList);
                        }
                        else
                        {
                            PPListMap.put(PPList.Location__c, new List<Product_Price__c>{PPList});
                        }
                    }
                }
                Map<Date,Integer> getDaysInMonthMap =  getDaysInMonth(RefStart, RefEnd);
                for(Id LocationId : PPListMap.keySet())
                {
                    Product_Price__c pp = new Product_Price__c();
                    pp.Cost__c = 0.00;
                    DayInMonthValue = 0;
                    editProductionCost=0.00;
                    List<Product_Price__c> ppList = PPListMap.get(LocationId);
                    for(Product_Price__c indPP : ppList)
                    { 
                        DayInMonthValue = getDaysInMonthMap.get(indPP.Start_Date__c);
                        Date daysInMonth = indPP.Start_Date__c;
                        Integer daysforMonth = date.daysInMonth(daysInMonth.year(),daysInMonth.month());
                        editProductionCost +=  ((indPP.Cost__c /daysforMonth) * DayInMonthValue) ;
                    }
                    pp.Cost__c = editProductionCost.setScale(2);
                    pp.Location__c = LocationId;
                    PPMap.put(LocationId,pp);   
                }
                for(Inventory_Location_Product__c ilp : pro.Inventory_Location_Products__r)
                {
                    if(LocAndILPList.containsKey(ilp.Inventory_Location__c))
                    {
                        if(ilp.Start_Date__c!=null)
                        {
                            LocAndILPList.get(ilp.Inventory_Location__c).put(ilp.Start_Date__c.month(),ilp);
                        }
                        
                    }
                    else{
                        if(ilp.Start_Date__c!=null)
                        {
                            LocAndILPList.put(ilp.Inventory_Location__c, new Map<Integer, Inventory_Location_Product__c>{(ilp.Start_Date__c.month()) => ilp});
                        }
                        
                    }
                }
                Set<Integer> MonthInteger = new Set<Integer>();
                MonthInteger.add(RefStart.month());
                Integer differanceMonth = (RefStart).monthsBetween(RefEnd);
                if(differanceMonth > 0)
                {
                    Date ref = RefStart.addMonths(1);
                    for(Integer i = 0; i< differanceMonth; i++)
                    {
                        MonthInteger.add(ref.month());
                        ref = ref.addMonths(1);
                    }
                }
                if(LocAndILPList.size() > 0)
                {
                    for(Id LocId : LocAndILPList.keySet())
                    {
                        Boolean checkNumberOfMonth = true;
                        Map<Integer,Inventory_Location_Product__c> oneLocIlpList = LocAndILPList.get(LocId);
                        System.debug('oneLocIlpList:::'+oneLocIlpList);
                        System.debug('MonthInteger:::'+MonthInteger);                
                        for(Integer MonInteger : MonthInteger)
                        {
                            if(!(oneLocIlpList.ContainsKey(MonInteger)))
                            {
                                checkNumberOfMonth = false;
                            }
                        }
                        if(checkNumberOfMonth)
                        {
                        validLocAndILPList.put(LocId,oneLocIlpList);
                        }
                    }
                }
                System.debug('validLocAndILPList:::'+validLocAndILPList);
                List<WrappedILP> WrapILPList= new List<WrappedILP>();             
                if(validLocAndILPList.size() > 0)
                {

                    for(Id locId : validLocAndILPList.keySet())
                    {
                        Map<Integer,Inventory_Location_Product__c> oneLocIlpList = validLocAndILPList.get(LocId);
                        Inventory_Location_Product__c IlpOneToGetLocName = new Inventory_Location_Product__c();
                        List<Integer> toGetMinVal = new List<Integer>();

                        for(Integer mon : oneLocIlpList.keySet())
                        {
                            IlpOneToGetLocName = oneLocIlpList.get(mon);
                            toGetMinVal.add(Integer.valueOf(IlpOneToGetLocName.Net_Quantity__c));
                        }
                        toGetMinVal.sort();
                        System.debug('IlpOneToGetLocName::::'+IlpOneToGetLocName);
				   
                        WrappedILP ilp=new WrappedILP();
						
                       ilp.locationId=IlpOneToGetLocName.Inventory_Location__r.Location__c;
                        ilp.ILPId=IlpOneToGetLocName.id;
                        ilp.LocationName=IlpOneToGetLocName.Inventory_Location__r.Location__r.Name;
                        ilp.Availableqty=toGetMinVal[0];
                        if(JustToCheck.containsKey(IlpOneToGetLocName.Inventory_Location__r.Location__c))
                        {
                            ilp.checkBox=true;
                            ilp.Quantity=JustToCheck.get(IlpOneToGetLocName.Inventory_Location__r.Location__c);
                            ilp.locationDiscount=GetLocationDiscountMap.get(IlpOneToGetLocName.Inventory_Location__r.Location__c);
                        }
                        else
                        {
                            ilp.checkBox=false;
                            ilp.Quantity=0;
                            ilp.locationDiscount=0;
                        }
                        ilp.pp=PPMap.get(IlpOneToGetLocName.Inventory_Location__r.Location__c);
                        ilp.daysCount=NumberofDays;
                        WrapILPList.add(ilp);

                    }
                    wrapperList wrapper=new wrapperList();
                    wrapper.ProName=pro.Name;
                    wrapper.ilpUiList=WrapILPList;
                    wrapper.lineitemDiscount=productIdAndLineItemDiscount.get(pro.id);
                    wrapper.ProId=pro.id;
                    
                    Inventory_Location_Product__c forDatePopUp = new Inventory_Location_Product__c();
                    forDatePopUp.Start_Date__c = PraPosalStartDateMap.get(pro.id);
                    forDatePopUp.End_Date__c = PraPosalEndDateMap.get(pro.id);
                    wrapper.lineItemDate=forDatePopUp;
                    editwrapperlist.add(wrapper);
                }

            }
        editflow=new wrappereditflow();
        editflow.wrapperListInsertLineItems=proposalitemlist;
        editflow.wrapperList=editwrapperlist;
        editflow.proposalobj=proposalobj1;
        
        }
        return editflow;
    }

 @AuraEnabled     
public static id SaveChange(List<Proposal__c> proposalObject,String oldstatus,String orderline)
    {
    
    system.debug('proposal::'+proposalObject[0]);
        
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal_Item__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__ProposalLineItemLocation__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Price__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Setup_Conversion_Rate_Euro__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Time_Base_Inventory__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__ProposalLineItemLocation__c')
   
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Setup_Conversion_Rate_Euro__c',new Set<String>{'sigmaerpdev2__Conversion_Rate__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal__c',new Set<String>{'sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Agent_Commission__c','sigmaerpdev2__AVR_Commission__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Agent_Commission_Euro__c','sigmaerpdev2__AVR_Commission_Euro__c','sigmaerpdev2__Status__c','sigmaerpdev2__Inventory_Allocated__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Proposal__c',new Set<String>{'sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Agent_Commission__c','sigmaerpdev2__AVR_Commission__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Agent_Commission_Euro__c','sigmaerpdev2__AVR_Commission_Euro__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Discount__c','sigmaerpdev2__Proposal__r.Name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Location__r.Name','sigmaerpdev2__Location__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__OtherCharges__c','sigmaerpdev2__CPM_Euro__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Discount_Euro__c','sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Sum_Location_Discount__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Proposal_Item__c',new Set<String>{'sigmaerpdev2__Proposal__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__ProposalLineItemLocation__c',new Set<String>{'id','sigmaerpdev2__Product_Inventory_Location__c','sigmaerpdev2__Product_Inventory_Location__r.sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Location__c','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Location__r.Name','sigmaerpdev2__Location_Discount_Euro__c','sigmaerpdev2__Production_Cost__c','sigmaerpdev2__Production_Cost_Euro__c','sigmaerpdev2__Monthly_Impressions__c','sigmaerpdev2__Cost__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__ProposalLineItemLocation__c',new Set<String>{'sigmaerpdev2__Proposal_Line_Item__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Proposal_Item__c',new Set<String>{'sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Discount_Euro__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Sum_Location_Discount__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__ProposalLineItemLocation__c',new Set<String>{'sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Product_Inventory_Location__c','sigmaerpdev2__Location__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Location_Discount_Euro__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Time_Base_Inventory__c',new Set<String>{'sigmaerpdev2__Proposal__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__ProposalLineItemLocation__c',new Set<String>{'id','sigmaerpdev2__Product_Inventory_Location__c','sigmaerpdev2__Product_Inventory_Location__r.sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Location__c','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Location_Discount_Euro__c','sigmaerpdev2__Production_Cost__c','sigmaerpdev2__Production_Cost_Euro__c','sigmaerpdev2__Monthly_Impressions__c','sigmaerpdev2__Cost__c'})
    ) 
    {  
     system.debug('inside fls ');
        Setup_Conversion_Rate_Euro__c convertionrate=[Select Conversion_Rate__c from Setup_Conversion_Rate_Euro__c Limit 1];
        wrapperListInsertLineItems[] values = ( wrapperListInsertLineItems[])JSON.deserialize(orderline, wrapperListInsertLineItems[].class);
        proposalObject[0].Usage_Type__c='Service';
        if(proposalObject[0].Other_Charges__c == null)
            {
                proposalObject[0].Other_Charges__c = 0.00;
            }
            if(proposalObject[0].Field_Discount_Amount__c == null)
            {
                proposalObject[0].Field_Discount_Amount__c = 0.00;
            }
            if(proposalObject[0].Other_Discount__c == null)
            {
                proposalObject[0].Other_Discount__c = 0.00;
            }
            if(proposalObject[0].Agent_Commission__c == null)
            {
                proposalObject[0].Agent_Commission__c = 0.00;
            }
            if(proposalObject[0].AVR_Commission__c == null)
            {
                proposalObject[0].AVR_Commission__c = 0.00;
            }
            proposalObject[0].Other_Charges_Euro__c = (proposalObject[0].Other_Charges__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
            proposalObject[0].Field_Discount_Amount_Euro__c = (proposalObject[0].Field_Discount_Amount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
            proposalObject[0].Other_Discount_Euro__c = (proposalObject[0].Other_Discount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
            proposalObject[0].Agent_Commission_Euro__c = (proposalObject[0].Agent_Commission__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
            proposalObject[0].AVR_Commission_Euro__c = (proposalObject[0].AVR_Commission__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
           //proposalObject.sigmaerpdev2__Is_Order_Created__c=true;
           upsert proposalObject[0];

            List<Proposal_Item__c> proposalline =[select Id, Name, Discount__c, Proposal__c,Proposal__r.Name,Product__r.Name,Cost__c,Location__r.Name,Location__c,Product__c,
                 Quantity__c,Start_Date__c,End_Date__c,OtherCharges__c,CPM_Euro__c,Other_Charges_Euro__c,Discount_Euro__c,Cost_Euro__c,(select id,Product_Inventory_Location__c,Product_Inventory_Location__r.Net_Quantity__c, Quantity__c, Product_Price__c, Location__c,
                 Location_Discount__c, Location__r.Name,Location_Discount_Euro__c,Production_Cost__c,Production_Cost_Euro__c,Monthly_Impressions__c,Cost__c from CampaignLineItemLocations__r),Sum_Location_Discount__c from Proposal_Item__c WHERE Proposal__c=:proposalObject[0].id ];
         
       
          Map<id,Map<Id,ProposalLineItemLocation__c>> NewMap = new Map<id,Map<Id,ProposalLineItemLocation__c>>();
          Map<id,Proposal_Item__c> linevalue = new Map<id,Proposal_Item__c>();
          Map<id,ProposalLineItemLocation__c> refvalue = new Map<id,ProposalLineItemLocation__c>();

          for(Proposal_Item__c tempPropList :proposalline)
          {
            for(ProposalLineItemLocation__c Change: tempPropList.CampaignLineItemLocations__r)
            {
                 // refvalue.put(Change.sigmaerpdev2__Location__c, Change);
                 refvalue.put(Change.Product_Inventory_Location__c, Change);
            }
            NewMap.put(tempPropList.Product__c,refvalue);
            linevalue.put(tempPropList.Product__c,tempPropList);
      
          }
             System.debug('NewMap::'+NewMap);
            List<Proposal_Item__c> LineItemList = new List<Proposal_Item__c>();
             List<Proposal_Item__c> updateLineItemList = new List<Proposal_Item__c>();
                
                  List<ProposalLineItemLocation__c> changeCLIL = new List<ProposalLineItemLocation__c>();
              List<ProposalLineItemLocation__c> updatechangeCLIL = new List<ProposalLineItemLocation__c>();
            Map<id, List<locationquantity>> updateorderlineloc= new Map<id, List<locationquantity>>();
         Map<id, List<locationquantity>> orderlineloc= new Map<id, List<locationquantity>>();
              
            for(wrapperListInsertLineItems genList: values)
            { 
                System.debug('genList.LineItem'+genList.LineItem);

                if(!linevalue.containsKey(genList.LineItem.Product__c))
                {
                Proposal_Item__c OCreatePB = genList.LineItem;

                if ((Schema.sObjectType.Proposal_Item__c.isAccessible()) &&
                (Schema.sObjectType.Proposal_Item__c.isCreateable()) &&
                (Schema.sObjectType.Proposal_Item__c.isUpdateable()) &&
                (Schema.sObjectType.Proposal__c.isAccessible()) &&
                (Schema.sObjectType.Proposal__c.isCreateable()) &&
                (Schema.sObjectType.Proposal__c.isUpdateable()) &&
                (Schema.sObjectType.Product_Price__c.isAccessible()) &&
                (Schema.sObjectType.Product_Price__c.isCreateable()) &&
                (Schema.sObjectType.Product_Price__c.isUpdateable()) &&
                (Schema.sObjectType.Proposal_Item__c.fields.Proposal__c.isAccessible()) &&
                (Schema.sObjectType.Proposal_Item__c.fields.Proposal__c.isCreateable()) 
                )
                {

                OCreatePB.Proposal__c = proposalObject[0].Id;
                }
                     OCreatePB.Cost_Euro__c=(OCreatePB.Cost__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
               //system.debug('OCreatePB.sigmaerpdev2__Discount__c>>>>>>>>'+OCreatePB.Discount__c);
                    if(OCreatePB.Discount__c != null){
                   OCreatePB.Discount_Euro__c=(OCreatePB.Discount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
  
                    }
                orderlineloc.put(OCreatePB.Product__c,genList.locqty);


                LineItemList.add(OCreatePB);
                }
                else 
                {
                System.debug('genList.LineItem');
                Proposal_Item__c OCreatePB=linevalue.get(genList.LineItem.Product__c);
                OCreatePB.Quantity__c=genList.LineItem.Quantity__c;
                OCreatePB.Start_Date__c=genList.LineItem.Start_Date__c;
                OCreatePB.End_Date__c=genList.LineItem.End_Date__c;
                OCreatePB.Cost__c=genList.LineItem.Cost__c;
                OCreatePB.Sum_Location_Discount__c=genList.LineItem.Sum_Location_Discount__c;
                OCreatePB.Discount__c=genList.LineItem.Discount__c;

                if ((Schema.sObjectType.Proposal_Item__c.isAccessible()) &&
                (Schema.sObjectType.Proposal_Item__c.isCreateable()) &&
                (Schema.sObjectType.Proposal_Item__c.isUpdateable()) &&
                (Schema.sObjectType.Proposal__c.isAccessible()) &&
                (Schema.sObjectType.Proposal__c.isCreateable()) &&
                (Schema.sObjectType.Proposal__c.isUpdateable()) &&
                (Schema.sObjectType.Product_Price__c.isAccessible()) &&
                (Schema.sObjectType.Product_Price__c.isCreateable()) &&
                (Schema.sObjectType.Product_Price__c.isUpdateable()) &&
                (Schema.sObjectType.Proposal_Item__c.fields.Proposal__c.isAccessible()) &&
                (Schema.sObjectType.Proposal_Item__c.fields.Proposal__c.isCreateable()) 
                )
                {
                    //OCreatePB.sigmaerpdev2__Proposal__c = proposalObject.Id;
                }
                     OCreatePB.Cost_Euro__c=(OCreatePB.Cost__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                 //system.debug('OCreatePB.sigmaerpdev2__Discount__c>>>>>>>>'+OCreatePB.Discount__c);
                   if(OCreatePB.Discount__c != null){
                    OCreatePB.Discount_Euro__c=(OCreatePB.Discount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                  }
                       updateorderlineloc.put(OCreatePB.Product__c,genList.locqty);

                System.debug('genList.LineItem'+OCreatePB);
                updateLineItemList.add(OCreatePB);  
                }
            }
                
            insert LineItemList;
            update updateLineItemList;
          
         
           
          for(Proposal_Item__c IndLine:LineItemList)
        {
          if(orderlineloc.ContainsKey(IndLine.Product__c))
            {
               List<locationquantity> justRef = orderlineloc.get(IndLine.Product__c);
              for(locationquantity justPP :justRef)
              {
                system.debug('in1sttime');
                ProposalLineItemLocation__c ListToAdd = new ProposalLineItemLocation__c();
                ListToAdd.Proposal_Line_Item__c = IndLine.id;
                ListToAdd.Product_Inventory_Location__c =justPP.ILPId;
                ListToAdd.Location__c =justPP.locid;
                ListToAdd.Cost__c = justPP.loccost;
                ListToAdd.Product__c = IndLine.Product__c;
                ListToAdd.Quantity__c = justPP.Quantity;
                ListToAdd.Location_Discount__c = justPP.locdis;
                ListToAdd.Location_Discount_Euro__c = justPP.locdis * (1/convertionrate.Conversion_Rate__c);
                changeCLIL.add(ListToAdd);  
                system.debug('changeCLIL>>+>>'+changeCLIL);             
              }
            }
        }
        for(Proposal_Item__c IndLine:updateLineItemList)
        {
              if(NewMap.ContainsKey(IndLine.Product__c))
              {
                  system.debug('NewMap>>++..'+NewMap);
                  List<locationquantity> updatejustRef = updateorderlineloc.get(IndLine.Product__c);
                  system.debug('updatejustRef>>'+updatejustRef);
                  for(locationquantity justPP :updatejustRef)
                  {
                    if(NewMap.get(IndLine.Product__c).containsKey(justPP.ILPId))
                    {
                        system.debug('innewmap');
                     ProposalLineItemLocation__c updateListToAdd = NewMap.get(IndLine.Product__c).get(justPP.ILPId);
                   system.debug('updateListToAdd>>'+updateListToAdd);
                      updateListToAdd.Product_Inventory_Location__c =justPP.ILPId;
                      updateListToAdd.Location__c =justPP.locid;
                      updateListToAdd.Cost__c = justPP.loccost;
                      updateListToAdd.Cost_Euro__c=justPP.loccost * (1/convertionrate.Conversion_Rate__c);
                      updateListToAdd.Product__c = IndLine.Product__c;
                      updateListToAdd.Quantity__c = justPP.Quantity;
                      updateListToAdd.Location_Discount__c = justPP.locdis;
                      updateListToAdd.Location_Discount_Euro__c = justPP.locdis * (1/convertionrate.Conversion_Rate__c);
                      updatechangeCLIL.add(updateListToAdd); 
                        system.debug('updatechangeCLIL>>'+updatechangeCLIL);
                    }
                    else
                    {
                        system.debug('insideelseeee');
                      ProposalLineItemLocation__c ListToAdd = new ProposalLineItemLocation__c();
                      ListToAdd.Proposal_Line_Item__c = IndLine.id;
                      ListToAdd.Product_Inventory_Location__c =justPP.ILPId;
                      ListToAdd.Location__c =justPP.locid;
                      ListToAdd.Cost__c = justPP.loccost;
                      ListToAdd.Cost_Euro__c=justPP.loccost * (1/convertionrate.Conversion_Rate__c);
                      ListToAdd.Product__c = IndLine.Product__c;
                      ListToAdd.Quantity__c = justPP.Quantity;
                      ListToAdd.Location_Discount__c = justPP.locdis;
                      ListToAdd.Location_Discount_Euro__c = justPP.locdis * (1/convertionrate.Conversion_Rate__c);
                      changeCLIL.add(ListToAdd);
                      system.debug('changeCLIL>>>...'+changeCLIL);
                    }
                  }
              }
        }
        
        upsert changeCLIL;
        system.debug('changeCLIL>>'+changeCLIL);
        update updatechangeCLIL;
        system.debug('updatechangeCLIL'+updatechangeCLIL);
       
        //Signed process
        LineItemList.addall(updateLineItemList); 
        changeCLIL.addall(updatechangeCLIL);
        
           Time_Base_Inventory__c TBI=[select Proposal__c from Time_Base_Inventory__c limit 1];
        if((proposalObject[0].Status__c == 'Contract Pending' || proposalObject[0].Status__c == 'Signed') && proposalObject[0].Type__c == 'Proposal')
        {
            system.debug('inproposal');
            Boolean Execute; 
     // if(TBI.sigmaerpdev2__Proposal__c ==true)
      //{
            Execute = AllocateInventoryCntrl.AllocateInventory(LineItemList, changeCLIL);
            proposalObject[0].Inventory_Allocated__c=true;   
      //}
            update proposalObject[0];  
        }
        //Cancel process
        if(((oldstatus == 'Signed' || oldstatus == 'Contract Pending') && proposalObject[0].Status__c == 'Cancelled') ||((oldstatus == 'Signed' || oldstatus == 'Contract Pending') && (proposalObject[0].Status__c == 'Planning')))
        {
      //if(TBI.sigmaerpdev2__Proposal__c ==true)
     // {
            Boolean cancel = AllocateInventoryCntrl.DeAllocateInventory(proposalObject[0].Id);
     // }
        }
    }    
    return proposalObject[0].id;
  }
    @AuraEnabled  
public static wrapperList Proposalforproductdetails(String Proid)
 {
    wrapperList wrapper;
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
    && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name','sigmaerpdev2__Product_Price__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','name','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'})
    )
    {
        system.debug('inside fls ');
       
        List<wrapperList> WrapList;
        List<WrappedILP> WrapILPList = new List<WrappedILP>();  
       // map<id,Map<Integer,Inventory_Location_Product__c>> LocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
       // map<id,Map<Integer,Inventory_Location_Product__c>> validLocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
		Product_Price__c pp= new Product_Price__c();
		Default_Parameters__c Dp = Default_Parameters__c.getInstance('Elift Merchant');
            string priceBook = Dp.priceBook_for_orders__c;
			
	   Product2 proList = [select id, Name,Product_Price__c,(select id, name, sigmaerpdev2__Available_Qty__c,Start_Date__c,End_Date__c  from Product_Inventory__r where sigmaerpdev2__Available_Qty__c >= 0),(select id,UnitPrice,Pricebook2Id,Product2Id,ProductCode from PricebookEntries where product2id =: Proid AND Pricebook2Id =: priceBook)from Product2 where id =: Proid];
	
	    if(proList.PricebookEntries.size()>0)
		{
			for(PricebookEntry PBE :proList.PricebookEntries)
			{
				pp.Cost__c=PBE.UnitPrice; 
            }
		}
		else
		{
			pp.Cost__c=0;
		}
		
	   for(sigmaerpdev2__Inventory__c pi : proList.Product_Inventory__r)
        {
           /* Product_Price__c pp= new Product_Price__c();
            if(proList.Product_Price__c==0 ||proList.Product_Price__c==null)
            {
                 pp.Cost__c=0;
            }else
            {
                pp.Cost__c=proList.Product_Price__c; 
            }*/
           
            WrappedILP ilpwap=new WrappedILP();
            ilpwap.locationId=pi.id;
            ilpwap.LocationName=pi.Name;
            ilpwap.Availableqty=Integer.valueof(pi.sigmaerpdev2__Available_Qty__c);
            ilpwap.checkBox=false;
            ilpwap.pp=pp;
            ilpwap.Quantity=0;
            ilpwap.locationDiscount=0;
            WrapILPList.add(ilpwap);
        }
        wrapper=new wrapperList();
        wrapper.ProName=proList.Name;
        wrapper.ilpUiList=WrapILPList;
        wrapper.lineitemDiscount=0.00;
        wrapper.ProId=proList.Id;
    }
    return   wrapper;        
}

  @AuraEnabled     
public static id SaveProposalforproduct(Proposal__c proposalObject,String oldstatus,String orderline)
    { 
        
        system.debug('djskn');
     if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Setup_Conversion_Rate_Euro__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal_Item__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Discount__c','sigmaerpdev2__Proposal__r.Name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Inventory_Location__r.Name','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__OtherCharges__c','sigmaerpdev2__CPM_Euro__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Discount_Euro__c','sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Sum_Location_Discount__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Proposal_Item__c',new Set<String>{'sigmaerpdev2__Proposal__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Setup_Conversion_Rate_Euro__c',new Set<String>{'sigmaerpdev2__Conversion_Rate__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal__c',new Set<String>{'sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Agent_Commission__c','sigmaerpdev2__AVR_Commission__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Agent_Commission_Euro__c','sigmaerpdev2__AVR_Commission_Euro__c','sigmaerpdev2__Status__c','sigmaerpdev2__Inventory_Allocated__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Proposal__c',new Set<String>{'sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Agent_Commission__c','sigmaerpdev2__AVR_Commission__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Agent_Commission_Euro__c','sigmaerpdev2__AVR_Commission_Euro__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Proposal_Item__c',new Set<String>{'sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Discount_Euro__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Sum_Location_Discount__c','sigmaerpdev2__Discount_Euro__c','sigmaerpdev2__Product__c','sigmaerpdev2__Location__c'})
    
        )
        {
            
        Setup_Conversion_Rate_Euro__c convertionrate=[Select Conversion_Rate__c from Setup_Conversion_Rate_Euro__c Limit 1];
     
        wrapperListInsertLineItems[] values = ( wrapperListInsertLineItems[])JSON.deserialize(orderline, wrapperListInsertLineItems[].class);
       System.debug('values::'+values);
       proposalObject.Usage_Type__c='Product';
      if(proposalObject.Other_Charges__c == null)
                {
                    proposalObject.Other_Charges__c = 0.00;
                }
                if(proposalObject.Field_Discount_Amount__c == null)
                {
                    proposalObject.Field_Discount_Amount__c = 0.00;
                }
                if(proposalObject.Other_Discount__c == null)
                {
                    proposalObject.Other_Discount__c = 0.00;
                }
                if(proposalObject.Agent_Commission__c == null)
                {
                    proposalObject.Agent_Commission__c = 0.00;
                }
                if(proposalObject.AVR_Commission__c == null)
                {
                    proposalObject.AVR_Commission__c = 0.00;
                }
                proposalObject.Other_Charges_Euro__c = (proposalObject.Other_Charges__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                proposalObject.Field_Discount_Amount_Euro__c = (proposalObject.Field_Discount_Amount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                proposalObject.Other_Discount_Euro__c = (proposalObject.Other_Discount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                proposalObject.Agent_Commission_Euro__c = (proposalObject.Agent_Commission__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                proposalObject.AVR_Commission_Euro__c = (proposalObject.AVR_Commission__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
        upsert proposalObject;
       
        List<Proposal_Item__c> proposalline =[select Id, Name, Discount__c, Proposal__c,Proposal__r.Name,Product__r.Name,Cost__c,Inventory_Location__r.Name,Inventory_Location__c,Product__c,
             Quantity__c,Start_Date__c,End_Date__c,OtherCharges__c,CPM_Euro__c,Other_Charges_Euro__c,Discount_Euro__c,Cost_Euro__c,Sum_Location_Discount__c from Proposal_Item__c WHERE Proposal__c=:proposalObject.id ];
     
        Map<id,Proposal_Item__c> linevalue = new Map<id,Proposal_Item__c>();
      
      for(Proposal_Item__c tempPropList :proposalline)
      {
        linevalue.put(tempPropList.Product__c,tempPropList);
      } 
        List<Proposal_Item__c> LineItemList = new List<Proposal_Item__c>();
        List<Proposal_Item__c> updateLineItemList = new List<Proposal_Item__c>();
        Map<id, List<locationquantity>> updateorderlineloc= new Map<id, List<locationquantity>>();
        Map<id, List<locationquantity>> orderlineloc= new Map<id, List<locationquantity>>();  
        for(wrapperListInsertLineItems genList: values)
        { 
             
            if(!linevalue.containsKey(genList.LineItem.Product__c))
            {
               Proposal_Item__c OCreatePB = genList.LineItem;
              
               if ((Schema.sObjectType.Proposal_Item__c.isAccessible()) &&
                            (Schema.sObjectType.Proposal_Item__c.isCreateable()) &&
                            (Schema.sObjectType.Proposal_Item__c.isUpdateable()) &&
                            (Schema.sObjectType.Proposal__c.isAccessible()) &&
                            (Schema.sObjectType.Proposal__c.isCreateable()) &&
                            (Schema.sObjectType.Proposal__c.isUpdateable()) &&
                            (Schema.sObjectType.Product_Price__c.isAccessible()) &&
                            (Schema.sObjectType.Product_Price__c.isCreateable()) &&
                            (Schema.sObjectType.Product_Price__c.isUpdateable()) &&
                            (Schema.sObjectType.Proposal_Item__c.fields.Proposal__c.isAccessible()) &&
                            (Schema.sObjectType.Proposal_Item__c.fields.Proposal__c.isCreateable()) 
                           )
                        {
                            OCreatePB.Proposal__c = proposalObject.Id;
                        }
                        OCreatePB.Cost_Euro__c=(OCreatePB.Cost__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                       if(OCreatePB.Discount__c != null){ 
                      OCreatePB.Discount_Euro__c=(OCreatePB.Discount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                       }
                           // orderlineloc.put(OCreatePB.sigmaerpdev2__Product__c,genList.locqty);
                      // OCreatePB.Location__c=genList.locqty[0].locid;
                      
                        LineItemList.add(OCreatePB);
            }
            else 
            {
              System.debug('genList.LineItem');
              Proposal_Item__c OCreatePB=linevalue.get(genList.LineItem.Product__c);
              OCreatePB.Quantity__c=genList.LineItem.Quantity__c;
              OCreatePB.Start_Date__c=genList.LineItem.Start_Date__c;
              OCreatePB.End_Date__c=genList.LineItem.End_Date__c;
              OCreatePB.Cost__c=genList.LineItem.Cost__c;
              OCreatePB.Sum_Location_Discount__c=genList.LineItem.Sum_Location_Discount__c;
              OCreatePB.Discount__c=genList.LineItem.Discount__c;
                if(OCreatePB.Discount__c != null){
                OCreatePB.Discount_Euro__c=(OCreatePB.Discount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
  
                }
               // OCreatePB.Location__c=genList.locqty[0].locid;
              OCreatePB.Cost_Euro__c=(OCreatePB.Cost__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                      
              updateorderlineloc.put(OCreatePB.Product__c,genList.locqty);
              
                      System.debug('genList.LineItem'+OCreatePB);
              updateLineItemList.add(OCreatePB);  
            }       
        }    
      insert LineItemList;
      update updateLineItemList;
      
       }
        return proposalObject.id;
  }
   @AuraEnabled     
    public static wrappereditflow Proposalforproedit(String proposalid)
    {
        

        system.debug('djskn');
        wrappereditflow editflow;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal__c',new Set<String>{'Id','Name','sigmaerpdev2__Proposal_Name__c','sigmaerpdev2__Client__c','sigmaerpdev2__Client__r.Name','sigmaerpdev2__Agency__c','sigmaerpdev2__Agency__r.Name','sigmaerpdev2__Contact__c','sigmaerpdev2__Billing_Contact__c','sigmaerpdev2__Billing_Contact__r.Name','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Account_Executive__c','sigmaerpdev2__Account_Executive__r.Name','sigmaerpdev2__Account_Executive1__c','sigmaerpdev2__Account_Executive1__r.Name','sigmaerpdev2__Account_Executive2__c','sigmaerpdev2__Account_Executive2__r.Name','sigmaerpdev2__Ownership__c','sigmaerpdev2__Ownership1__c','sigmaerpdev2__Ownership2__c','sigmaerpdev2__Is_Order_Created__c','sigmaerpdev2__Industry_Exclusively__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Status__c','sigmaerpdev2__Payment_Terms__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Charges_Comments__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Other_Discount_Comments__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Discount_Method_Option_Value__c','sigmaerpdev2__Discount_Method__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Agent_Commission__c','sigmaerpdev2__Agent_Commission_Euro__c','sigmaerpdev2__Agency_Percent__c','sigmaerpdev2__Billing_Start_Date__c','sigmaerpdev2__Billing_End_Date__c','sigmaerpdev2__Deduct_from_Net__c','sigmaerpdev2__Account_Executive_1_acc__c','sigmaerpdev2__Account_Executive_2_Acc__c','sigmaerpdev2__Account_Executive_3_Acc__c','sigmaerpdev2__Account_Executive_1_acc__r.Name','sigmaerpdev2__Account_Executive_2_Acc__r.Name','sigmaerpdev2__Account_Executive_3_Acc__r.Name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Product__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Sum_Location_Discount__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Proposal__c','sigmaerpdev2__Product__r.Name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name','sigmaerpdev2__Product_Price__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev2__Products__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.Name','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c,sigmaerpdev2__Number_of_Screens__c','sigmaerpdev2__Message__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c'})
        
        
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Proposal_Item__c',new Set<String>{'sigmaerpdev2__Proposal__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Proposal__c',new Set<String>{'sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Agent_Commission__c','sigmaerpdev2__AVR_Commission__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Agent_Commission_Euro__c','sigmaerpdev2__AVR_Commission_Euro__c'})
        
        )
        {
        
        
            Proposal__c proposalobj1=[select Id,Name,Proposal_Name__c,Client__c,Client__r.Name,Agency__c,Agency__r.Name,Contact__c,Billing_Contact__c,Billing_Contact__r.Name,Start_Date__c,End_Date__c,Account_Executive__c,Account_Executive__r.Name,Account_Executive1__c,Account_Executive1__r.Name,Account_Executive2__c,Account_Executive2__r.Name,Ownership__c,Ownership1__c,
                     Ownership2__c,Is_Order_Created__c,Industry_Exclusively__c,Discount__c,Status__c,Payment_Terms__c,Field_Discount_Amount__c,Other_Charges_Comments__c,Other_Charges__c,Other_Discount_Comments__c,Other_Discount__c,
                     Discount_Method_Option_Value__c,Discount_Method__c,Other_Charges_Euro__c,Other_Discount_Euro__c,Field_Discount_Amount_Euro__c,Agent_Commission__c,Agent_Commission_Euro__c,Agency_Percent__c,
                     Billing_Start_Date__c, Billing_End_Date__c,Deduct_from_Net__c,Account_Executive_1_acc__c,Account_Executive_2_Acc__c,Account_Executive_3_Acc__c,Account_Executive_1_acc__r.Name,Account_Executive_2_Acc__r.Name,Account_Executive_3_Acc__r.Name from Proposal__c where id=:proposalid];
                     
            List<Proposal_Item__c> proposalline =[select Id, Name,Location__c,Product__c,Inventory_Location__c,Inventory_Location__r.Location__c,Quantity__c,Cost__c,Sum_Location_Discount__c,Discount__c,Proposal__c,Product__r.Name from Proposal_Item__c WHERE Proposal__c=:proposalid ];

            system.debug('proposalline'+proposalline);
            List<Id> ProId = new List<Id>();
            Map<Id, decimal> productIdAndLineItemDiscount = new Map<Id, decimal>();
             Map<Id, decimal> productCost = new Map<Id, decimal>();
            Map<id,wrapperListInsertLineItems> LineMap = new Map<id,wrapperListInsertLineItems>();
           
            Set<Id> PrposalIDs = new Set<Id>(); 
            List<wrapperListInsertLineItems> proposalitemlist=new List<wrapperListInsertLineItems>();
           
           Map<Id,Integer> NewMap = new Map<Id,Integer>();
              List<locationquantity> locdatalist=new List<locationquantity>();
            for(Proposal_Item__c tempPropList :proposalline)
            {
                id produtId = tempPropList.Product__c;
                wrapperListInsertLineItems proposalitem=new wrapperListInsertLineItems();
                proposalitem.LineItem=tempPropList;
                proposalitem.proname=tempPropList.Product__r.Name;
                
                LineMap.put(Id.valueOf(tempPropList.Product__c),proposalitem);
                ProId.add(tempPropList.Product__c);
                productIdAndLineItemDiscount.put(tempPropList.Product__c, tempPropList.Discount__c);
                productCost.put(tempPropList.Product__c, tempPropList.Cost__c);
               
                PrposalIDs.add(tempPropList.Id);
                locationquantity locdata=new locationquantity();
                    locdata.locid=tempPropList.Location__c;
                    locdata.ILPId=tempPropList.Inventory_Location__c;
                    locdata.Quantity=tempPropList.Quantity__c;
                    locdata.locdis=0;
                    locdata.loccost=tempPropList.Cost__c;
                     locdatalist.add(locdata);
                       proposalitem.locqty=locdatalist;
                proposalitemlist.add(proposalitem); 
                NewMap.put(tempPropList.Product__c,Integer.valueOf(tempPropList.Quantity__c));
               
            }//end of proposalitem for loop

            List<Product2> proList = [select id, Name,Product_Price__c,(select id, name,Products__c, Net_Quantity__c,Received_Quantity__c,Inventory_Location__c, Inventory_Location__r.Location__r.Name, Start_Date__c, End_Date__c,Number_of_Screens__c, Message__c,Inventory_Location__r.Location__c  from Inventory_Location_Products__r where Net_Quantity__c >= 0) from Product2 where id =: ProId];
         
            List<wrapperList> editwrapperlist=new List<wrapperList>();    
            for(Product2 pro: proList)
            {
              
                List<WrappedILP> WrapILPList= new List<WrappedILP>();             
               

                    for(Inventory_Location_Product__c ilp : pro.Inventory_Location_Products__r)
                    {
                       List<Integer> toGetMinVal = new List<Integer>();
                        Product_Price__c pp= new Product_Price__c();
                        pp.Cost__c=productCost.get(ilp.Products__c)/NewMap.get(ilp.Products__c);
                        
                            toGetMinVal.add(Integer.valueOf(ilp.Net_Quantity__c));
                       
                        toGetMinVal.sort();
                        WrappedILP ilpwrap=new WrappedILP();
                        ilpwrap.locationId=ilp.Inventory_Location__r.Location__c;
                        ilpwrap.ILPId=ilp.id;
                        ilpwrap.LocationName=ilp.Inventory_Location__r.Location__r.Name;
                        ilpwrap.Availableqty=toGetMinVal[0];
                        if(NewMap.containsKey(ilp.Products__c))
                        {
                            ilpwrap.checkBox=true;
                            ilpwrap.Quantity=NewMap.get(ilp.Products__c);
                         }
                        else
                        {
                            ilpwrap.checkBox=false;
                            ilpwrap.Quantity=0;
                        }
                        ilpwrap.pp=pp;
                        WrapILPList.add(ilpwrap);

                    }
                    wrapperList wrapper=new wrapperList();
                    wrapper.ProName=pro.Name;
                    wrapper.ilpUiList=WrapILPList;
                    wrapper.lineitemDiscount=productIdAndLineItemDiscount.get(pro.id);
                    wrapper.ProId=pro.id;
                  
                    editwrapperlist.add(wrapper);
               

            }
            editflow=new wrappereditflow();
            editflow.wrapperListInsertLineItems=proposalitemlist;
            editflow.wrapperList=editwrapperlist;
            editflow.proposalobj=proposalobj1;
            
        }
        return editflow;
    }

}