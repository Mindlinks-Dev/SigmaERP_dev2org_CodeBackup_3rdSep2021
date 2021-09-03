public with sharing class TBIOrderController
{
  
   public class WrappedILP
    {
        @AuraEnabled
        public Id locationId;
        @AuraEnabled
        public Id ILPId;
        @AuraEnabled
        public String partnerName;
        @AuraEnabled
        public String LocationName;
        @AuraEnabled
        public Integer Availableqty;
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
   public class wrapperListInsertLineItems
    {
        @AuraEnabled
        public Product_Order_Price_Book__c LineItem;
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
        public Integer Quantity;
        @AuraEnabled
        public Integer locdis;
        @AuraEnabled
        public Decimal loccost;
        
    }
  
    public class wrapperListCharge
    {
        @AuraEnabled
        public List<Other_Chanrges__c> OtherCharges;
        
    }
    
    public class OtherCharges
    {
        @AuraEnabled
        public Other_Chanrges__c indivOC;
        @AuraEnabled
        public Id PrdId;
        
    }
    @AuraEnabled  
    public static List<Product2> getProducts()
    {
        List<Product2> ProductList;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name'}))
        {*/
            system.debug('inside fls ::');
            ProductList = new List<Product2>();
            ProductList = [select id, Name from Product2 where Active__c = true Order By Name];
            
        //}
        return   ProductList;
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
    System.debug('DateIlp'+DateIlp); 
    /*
    replace with TBIOrderController*/
    wrapperList wrapper;
    /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Price__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Partner__r.Name','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.Name','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Price__c',new Set<String>{'id','Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.Name','sigmaerpdev2__End_Date__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__Product_Id__c','sigmaerpdev2__Status__c','sigmaerpdev2__Production_Cost__c'})
    
)
    {*/
        system.debug('inside productdetails fls ::');
    List<wrapperList> WrapList;
    //to get start and end date of the month.
    Date firstDayOfMonth = (DateIlp.Start_Date__c).toStartOfMonth();
    System.debug('firstDayOfMonth'+firstDayOfMonth.format()); 
    Date getLastMonthDate = (DateIlp.End_Date__c);
    System.debug('getLastMonthDate'+getLastMonthDate); 
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

    Product2 proList = [select id, Name,(select id, name, Net_Quantity__c, Received_Quantity__c, Inventory_Location__c, Partner__r.Name, Inventory_Location__r.Location__c, Inventory_Location__r.Location__r.Name,Start_Date__c,End_Date__c  from Inventory_Location_Products__r where ((Start_Date__c >=: firstDayOfMonth) And (End_Date__c <=: lastDayOfMonth) And (Net_Quantity__c >= 0))),
    (select id, Name,Cost__c,Location__c,Location__r.Name,End_Date__c,Start_Date__c,Product_Id__c, Status__c,Production_Cost__c  from Product_Prices__r where Product_Id__c =:proId AND (Start_Date__c >=: firstDayOfMonth) And (End_Date__c <=: lastDayOfMonth)  AND (Status__c = 'Active')) from Product2 where id =: Proid];

    System.debug('proList'+proList); 
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

    }

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
        List<Product_Price__c> ppList = PPListMap.get(LocationId);
        Decimal costForNumberOfdays=0.00;
        for(Product_Price__c indPP : ppList)
        {
        System.debug('getDaysInMonthMap'+getDaysInMonthMap);
        System.debug('indPP.Start_Date__c'+indPP.Start_Date__c);
        DayInMonthValue = getDaysInMonthMap.get(indPP.Start_Date__c);
        Date daysInMonth = indPP.Start_Date__c;
        Integer daysforMonth = date.daysInMonth(daysInMonth.year(),daysInMonth.month());

        costForNumberOfdays = costForNumberOfdays + ((indPP.Cost__c /daysforMonth) * DayInMonthValue);

        }
        pp.Cost__c = costForNumberOfdays.setScale(2);
        pp.Location__c = LocationId;
        PPMap.put(LocationId,pp);
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
    System.debug('LocAndILPList:::'+LocAndILPList);
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
    List<WrappedILP> WrapILPList;             
    if(validLocAndILPList.size() > 0)
    {
        WrapILPList = new List<WrappedILP>();
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
            ilp.partnerName=IlpOneToGetLocName.Partner__r.Name;
            ilp.LocationName=IlpOneToGetLocName.Inventory_Location__r.Location__r.Name;
            ilp.Availableqty=toGetMinVal[0];
            ilp.checkBox=false;
            ilp.pp=PPMap.get(IlpOneToGetLocName.Inventory_Location__r.Location__c);
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
    System.debug('WrapList::'+wrapper);   
    
   // }
    return   wrapper;    
}


 @AuraEnabled     
public static id SaveChange(Sigma_Order__c SalesOrderObject,String orderline)
    {
      /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Setup_Conversion_Rate_Euro__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__OrderLineLocation__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Setup_Conversion_Rate_Euro__c',new Set<String>{'sigmaerpdev2__Conversion_Rate__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Other_Discount_Euro__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Other_Discount_Euro__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Sigma_Order__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Order_Status__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Discount_Euro__c','sigmaerpdev2__Product__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Total_Amount__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Product__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__OrderLineLocation__c',new Set<String>{'sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Location__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Product__c','sigmaerpdev2__Status__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Location_Discount_Euro__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id','sigmaerpdev2__Gross_Amount__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Line_level_Discount__c','sigmaerpdev2__Location_Level_Discount__c','sigmaerpdev2__Agency_Commission__c','Name','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__BillingPersonNew__r.Name','sigmaerpdev2__Net_Amount__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__OrderLineLocation__c',new Set<String>{'sigmaerpdev2__Order_Line__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Billing_Person__c','sigmaerpdev2__Net_Amount__c'})
                    
    )
        
        {*/
            system.debug('SaveChange::');
            
    Setup_Conversion_Rate_Euro__c convertionrate=[Select Conversion_Rate__c from Setup_Conversion_Rate_Euro__c Limit 1];
       // Integer num=1;
        System.debug('orderline:::'+orderline);
        decimal NoofProducts=0;
        wrapperListInsertLineItems[] values = ( wrapperListInsertLineItems[])JSON.deserialize(orderline,  wrapperListInsertLineItems[].class);
        System.debug('values:::'+values);
         System.debug('SalesOrderObject:::'+SalesOrderObject);
         Account ACC =[Select id,name,Customer_Type__c from Account where id =:SalesOrderObject.AccountId__c];
    system.debug('ACC>>'+ACC);
     SalesOrderObject.Customer_Type__c = ACC.Customer_Type__c;
            SalesOrderObject.Field_Discount_Amount__c = SalesOrderObject.Field_Discount_Amount__c;
           SalesOrderObject.Orders_Status__c = 'Pending';
            SalesOrderObject.Order_Created_Via__c = 'Time Based Inventory';
              if(SalesOrderObject.Other_Charges__c == null)
            {
                SalesOrderObject.Other_Charges__c = 0.00;
            }
            if(SalesOrderObject.Field_Discount_Amount__c == null)
            {
                SalesOrderObject.Field_Discount_Amount__c = 0.00;
            }
            if(SalesOrderObject.Other_Discount__c == null)
            {
                SalesOrderObject.Other_Discount__c = 0.00;
            }
            
            SalesOrderObject.Other_Charges_Euro__c = (SalesOrderObject.Other_Charges__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
            SalesOrderObject.Field_Discount_Amount_Euro__c = (SalesOrderObject.Field_Discount_Amount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
            SalesOrderObject.Other_Discount_Euro__c = (SalesOrderObject.Other_Discount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
          
          insert salesOrderObject;
         System.debug('SalesOrderObject:::'+salesOrderObject);
        
         
           List<Product_Order_Price_Book__c> LineItemList = new List<Product_Order_Price_Book__c>();
            
            List<OrderLineLocation__c> changeCLIL = new List<OrderLineLocation__c>();
            Map<id, List<locationquantity>> orderlineloc= new Map<id, List<locationquantity>>();
      system.debug('Size>>'+values.size());
            for(wrapperListInsertLineItems genList: values)
            {
        system.debug('insidefor');
              Product_Order_Price_Book__c OCreatePB = genList.LineItem;
                
                if ((Schema.sObjectType.Product_Order_Price_Book__c.isAccessible()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.isCreateable()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.isUpdateable()) &&
                        (Schema.sObjectType.Sigma_Order__c.isAccessible()) &&
                        (Schema.sObjectType.Sigma_Order__c.isCreateable()) &&
                        (Schema.sObjectType.Sigma_Order__c.isUpdateable()) &&
                        (Schema.sObjectType.Product_Price__c.isAccessible()) &&
                        (Schema.sObjectType.Product_Price__c.isCreateable()) &&
                        (Schema.sObjectType.Product_Price__c.isUpdateable()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.fields.Sigma_Order__c.isAccessible()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.fields.Sigma_Order__c.isCreateable()) 
                       )
                    {
                        
                        OCreatePB.Sigma_Order__c = salesOrderObject.Id;
                    }
                    if ((Schema.sObjectType.Product_Order_Price_Book__c.isAccessible()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.isCreateable()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.isUpdateable()) &&
                        (Schema.sObjectType.Product_Price__c.isAccessible()) &&
                        (Schema.sObjectType.Product_Price__c.isCreateable()) &&
                        (Schema.sObjectType.Product_Price__c.isUpdateable()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.fields.Order_Status__c.isAccessible()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.fields.Order_Status__c.isCreateable()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.fields.Order_Status__c.isUpdateable()) 
                       )
                    {
                        
                        OCreatePB.Order_Status__c = 'Pending';
                    }
                    if ((Schema.sObjectType.Product_Order_Price_Book__c.isAccessible()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.isCreateable()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.isUpdateable()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.fields.Total_Price__c.isAccessible()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.fields.Total_Price__c.isCreateable()) &&
                        (Schema.sObjectType.Product_Order_Price_Book__c.fields.Total_Price__c.isUpdateable()) 
                       )
                    {
                      OCreatePB.Total_Price__c = genList.LineItem.Cost__c;
                    }
                    
                OCreatePB.Cost_Euro__c=(OCreatePB.Cost__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);

                OCreatePB.Discount_Euro__c=(OCreatePB.Discount__c * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                OCreatePB.Net_Quantity__c = genList.LineItem.Quantity__c;
               // OCreatePB.Total_Amount__c = OCreatePB.Total_Price__c/ OCreatePB.Net_Quantity__c;
                NoofProducts+=OCreatePB.Net_Quantity__c;
                orderlineloc.put(OCreatePB.Product__c,genList.locqty);
                System.debug('orderlineloc>>'+orderlineloc);
                LineItemList.add(OCreatePB);
        system.debug('LineItemList>>'+LineItemList);
            }
            
            insert LineItemList;
      
          for(Product_Order_Price_Book__c IndLine:LineItemList)
          {
        system.debug('in2ndfor');
            if(orderlineloc.ContainsKey(IndLine.Product__c))
            {
               List<locationquantity> justRef = orderlineloc.get(IndLine.Product__c);
                        System.debug('justRef::'+justRef);
              for(locationquantity justPP :justRef)
              {
          system.debug('infor3');
                  String location=justPP.locid;
                 OrderLineLocation__c ListToAdd = new OrderLineLocation__c();
                  ListToAdd.Order_Line__c = IndLine.id;
                    ListToAdd.Inventory_Location_Product__c =justPP.ILPId;
                  ListToAdd.Location__c=justPP.locid;
                  ListToAdd.Start_Date__c =IndLine.Start_Date__c;
                  ListToAdd.End_Date__c = IndLine.End_Date__c;
                  ListToAdd.Cost__c = justPP.loccost;
                  ListToAdd.Unit_Price__c = justPP.loccost;
                  ListToAdd.Product__c = IndLine.Product__c;
                  ListToAdd.Status__c = 'Pending';
                  ListToAdd.Quantity__c = justPP.Quantity;
                   ListToAdd.Location_Discount__c = justPP.locdis;
                   ListToAdd.Location_Discount_Euro__c = (justPP.locdis * (1/convertionrate.Conversion_Rate__c)).setScale(2);
                 changeCLIL.add(ListToAdd);   
         
              }
            }
          }
      system.debug('changeCLIL>>'+changeCLIL);
        insert changeCLIL;


        Sigma_Order__c orerat=[Select Id,Customer_Type__c,Net_Quantity__c,Tax_Amount__c,Tax__c,AccountId__c,Gross_Amount__c,Other_Charges__c ,Field_Discount_Amount__c ,Other_Discount__c ,Line_level_Discount__c ,Location_Level_Discount__c,Agency_Commission__c,Name,Total_Amount__c,BillingPersonNew__r.Name,Net_Amount__c from Sigma_Order__c where id =: salesOrderObject.id];
        System.debug('orerat:::'+orerat);
        //Code for TAX
        orerat.Net_Amount__c=orerat.Total_Amount__c;
        Double TaxOnBillAmount = 0;
        List<Tax__c> taxObj = TaxCntr.getTax(orerat.AccountId__c);
        Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
        String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
        Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
        String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
        
        if(fedTaxType == 'Percentage'){
            TaxOnBillAmount = (orerat.Net_Amount__c * federalTax)/100;
        }else{
            TaxOnBillAmount = orerat.Net_Amount__c + federalTax;
        }               
        if(stateTaxType == 'Percentage'){
            TaxOnBillAmount = (TaxOnBillAmount + (orerat.Net_Amount__c * stateTax)/100);
        }else{
            TaxOnBillAmount = (TaxOnBillAmount + (orerat.Net_Amount__c + stateTax));
        }        
        orerat.Tax_Amount__c = TaxOnBillAmount;
        orerat.Tax__c = federalTax+stateTax;
        //orerat.Net_Amount__c=orerat.Total_Amount__c;
        orerat.Billing_Person__c=orerat.BillingPersonNew__r.Name;
        orerat.TotalAmount__c=orerat.Net_Amount__c+TaxOnBillAmount;
        orerat.Net_Quantity__c=NoofProducts;
        update orerat;
        System.debug('SalesOrderObject:::'+orerat);
    
    //update credit user detail
   /* if(orerat.Customer_Type__c=='Credit Customer')
    {
      Dimension_Tag__c creditdetails;
            creditdetails = [select id,Ordered_Amount__c from Dimension_Tag__c where Account__c=:orerat.AccountId__c limit 1];
      if(creditdetails!=null){
        if(orerat.TotalAmount__c!=null){
           if(creditdetails.Ordered_Amount__c==null)
                        creditdetails.Ordered_Amount__c=0;
                        creditdetails.Ordered_Amount__c+=orerat.TotalAmount__c;
                        system.debug('Ordered_Amount__c---2>>>'+creditdetails.Ordered_Amount__c);
          
        }
      
      }
    update creditdetails;
        system.debug('creditdetails>>>'+creditdetails);
    } */
        
       // }
        return SalesOrderObject.id;
    }
  
   @AuraEnabled
        public static void deleteIndividualproposalline(List<Proposal_Item__c> ProposalLines) //,Integer index
        { 
         /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal_Item__c')
         ){*/
             
            System.debug('orderLines --'+ProposalLines);
            if(ProposalLines.size()>0)
            {
                system.debug('before delete');
                delete ProposalLines;
                system.debug('afetr delete');
            }
            //}
        }
}