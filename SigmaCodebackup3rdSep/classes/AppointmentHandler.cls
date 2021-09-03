public without sharing class  AppointmentHandler {
    
    
    @AuraEnabled
    public static MainWrapper FetchAppointements(Decimal pageNumber)
    {
        
        MainWrapper mainWrap = new MainWrapper();
        List<Innerwrapper> Appointments = new List<Innerwrapper>();
        Map<Id,sigmaerpdev2__Booking__c> ExistingAppointments = new Map<Id,sigmaerpdev2__Booking__c>();
        try{
            Integer pageSize = 27;
            Integer offset = ((Integer)pageNumber - 1) * pageSize;
            System.debug('offset>>>>>>'+offset);
            
            
            
            mainWrap.pageSize = pageSize;
            mainWrap.page = (Integer) pageNumber;
            
            
            
            Date Tommorowdate = Date.today().addDays(1);
            System.debug('Tommorowdate>>'+Tommorowdate);
            //Date Enddate = Date.today().addDays(30);
            Date Enddate = Date.today().addDays(31);
            System.debug('Enddate>>'+Enddate);  
            
            Integer totalRecords = [SELECT COUNT() FROM sigmaerpdev2__Appointment__c where sigmaerpdev2__AppointmentDate__c >=: Tommorowdate and sigmaerpdev2__AppointmentDate__c <=: Enddate];
            System.debug('totalRecords>>'+totalRecords);  
            mainWrap.total = totalRecords;
            
            
            
            List<sigmaerpdev2__Appointment__c>  appointmentList= [SELECT sigmaerpdev2__AppointmentDate__c,sigmaerpdev2__period_of_time__c,sigmaerpdev2__Time__c,
                                                                  sigmaerpdev2__Duration__c,sigmaerpdev2__Duration_Interval__c,sigmaerpdev2__Order_amount__c,sigmaerpdev2__Week_Day__c,sigmaerpdev2__Date_Value__c,sigmaerpdev2__Status__c FROM sigmaerpdev2__Appointment__c 
                                                                  where sigmaerpdev2__Status__c=:'Available' and sigmaerpdev2__AppointmentDate__c >=: Tommorowdate and sigmaerpdev2__AppointmentDate__c <=: Enddate order by sigmaerpdev2__AppointmentDate__c asc LIMIT :pageSize OFFSET :offset];
            System.debug('appointmentList.size()>>'+appointmentList.size() +' appointmentList:'+appointmentList);   
            
            
            /*List<sigmaerpdev2__Booking__c> bookingList = [Select Id,Name,sigmaerpdev2__Appointment__c from sigmaerpdev2__Booking__c where sigmaerpdev2__Appointment__c IN:appointmentList];
            System.debug('bookingList.size()>>'+bookingList.size() +' bookingList:'+bookingList);
            if(bookingList.size()>0)
            {
                
                for(sigmaerpdev2__Booking__c bookVar:bookingList)
                {
                    ExistingAppointments.put(bookVar.sigmaerpdev2__Appointment__c,bookVar);
                }
                
                
            }
            System.debug('ExistingAppointments.size()>>'+ExistingAppointments.size() +' ExistingAppointments:'+ExistingAppointments);
            */
            for(sigmaerpdev2__Appointment__c app :appointmentList)
            {
                Innerwrapper inWrap =  new Innerwrapper();
                if(ExistingAppointments.containsKey(app.Id))
                {
                    inWrap.IsDisabled = true; 
                }   
                else
                {
                    inWrap.IsDisabled = false; 
                }
                
                inWrap.Appointment = app;
                Appointments.add(inWrap);
            }
            
            
            System.debug('Appointments.size()>>'+Appointments.size() +' Appointments:'+Appointments);
            mainWrap.AppointmentList = Appointments; 
            //mainWrap.AppointmentList = appointmentList; 
            
            System.debug('mainWrap>>'+mainWrap);
        }
        
        catch (Exception ex) 
        {
            System.debug('ex:::'+ex.getMessage() +'Linenumber: '+ex.getLineNumber());
            
            return null;
            
            
        }
        return mainWrap;
    }
    
    
    @AuraEnabled
    public static BookingWrapper SaveBookingInfo(String BookingWrapperParam)
    {
       
        BookingWrapper BookWrap = new BookingWrapper();
        BookWrap = (BookingWrapper)System.JSON.deserialize(BookingWrapperParam, BookingWrapper.class);
        try{
            
            Account acc = new Account();
           
            acc.First_Name__c = BookWrap.custWrap.FirstName;
            acc.LastName__c = BookWrap.custWrap.LastName;
            acc.Name =  acc.First_Name__c +' '+ acc.LastName__c;
            acc.Know_As__c = BookWrap.custWrap.KnowAs;
            acc.Date_of_Birth__c = BookWrap.custWrap.DateofBirth;
            acc.Email__c = BookWrap.custWrap.EmailId;
            acc.Mobile_Phone_Number__c = BookWrap.custWrap.MobilePhoneNumber;
            acc.Home_Phone_Number__c = BookWrap.custWrap.HomePhoneNumber;
            acc.Address__c = BookWrap.custWrap.Address;
            acc.First_Name__c = BookWrap.custWrap.TownCity;
            acc.BillingPostalCode = BookWrap.custWrap.PostalCode;
            acc.BillingCountry = BookWrap.custWrap.Country;
            acc.Data_Protection_Policy__c = Boolean.valueOf(BookWrap.custWrap.DataProtectionPolicy);
            acc.I_confirm_that_I_do_not_have_children_un__c = Boolean.valueOf(BookWrap.custWrap.ageof18years);
            acc.I_am_registered_with_a_medical_professio__c = Boolean.valueOf(BookWrap.custWrap.registeredwithmedical); 
            acc.Do_you_have_any_access_requirements__c = BookWrap.custWrap.accessRequirements;
            acc.Will_you_be_attending_alone_or_with_a_pa__c = BookWrap.custWrap.attendingAlone;
     
            
            insert acc;
            System.debug('after insrt account:'+acc);
            
            BookWrap.CustomerId = acc.Id;
            
          
           

            sigma_Order__c order = new sigma_Order__c();
            order.AccountId__c = acc.Id;
            order.Net_Amount__c = BookWrap.Amount;
            order.Order_Created_Via__c= 'Opportunity';
            order.Orders_Status__c = 'Pending';
            order.Delivary_Date__c = System.today();
            order.TotalAmount__c = BookWrap.Amount;
            //order.OwnerId = config.sigmaerpdev2__Record_Owner__c; 
            System.debug('Before insert order>>'+order);
            insert order;
            System.debug('After insert order>>'+order);
            
            BookWrap.OrderId = order.Id;
            
            Booking__c book = new Booking__c();
            book.Appointment__c = BookWrap.Appointment.Id;
            book.Customer__c = acc.Id;
            book.Payment_Status__c = 'Pending';
            book.Customer_email__c = BookWrap.custWrap.EmailId;
            book.Order__c = order.Id;
      		book.RecordtypeId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Booking').getRecordTypeId();
           // book.Payment__c = 
            
            insert book;
            System.debug('after insrt book:'+book);
            
            BookWrap.BookingId = book.Id;
            BookWrap.AppointmentId = BookWrap.Appointment.Id;
            
            
           
    
            
            
            //For Orderline  --   
            Product_Order_Price_Book__c orderline = new Product_Order_Price_Book__c();
            orderline.Product__c = '01t2x000001mYKU';//dynamically fetch product id
            
            orderline.Quantity__c= 1;
            orderline.Net_Quantity__c= 1;
            orderline.Sigma_Order__c= order.Id;
            orderline.Order_Status__c = 'Pending';
            //orderline.Discounts__c = config.sigmaerpdev2__Discount__c;
            orderline.Total_Amount__c =  BookWrap.Amount;
            orderline.Total_Price__c = BookWrap.Amount;
            System.debug('Before insert order>>'+orderline);
            insert orderline;
            System.debug('After insert order>>'+orderline);
            
            BookWrap.Response = 'Success';
            BookWrap.Status = 'Success';    
            
            
        }
        
        catch (Exception ex) 
        {
            System.debug('ex:::'+ex.getMessage() +'Linenumber: '+ex.getLineNumber());
            BookWrap.Response = ex.getMessage() +' Linenumber: '+ex.getLineNumber();
            BookWrap.Status = 'Fail';       
            return BookWrap;
            
        }
        
        System.debug('Final BookWrap>>'+BookWrap);        
        return BookWrap;
    }
    
    
    
    @AuraEnabled
    public static List<CourseWrapper> FetchCourses()
    {
        
        List<CourseWrapper> courseWrap = new List<CourseWrapper>();
    
        List<Innerwrapper> Appointments = new List<Innerwrapper>();
      
        try{
            List<sigmaerpdev2__Course__c> CourseListFinal = new List<sigmaerpdev2__Course__c>();
            List<sigmaerpdev2__Course__c> courseList = [Select Id,Name,sigmaerpdev2__Course_code__c,sigmaerpdev2__Description__c,sigmaerpdev2__Status__c
            ,(Select Id,Name,sigmaerpdev2__Booked_Count__c,sigmaerpdev2__Course__c,sigmaerpdev2__Destination__c,sigmaerpdev2__Event_date__c,
            sigmaerpdev2__Event_end_date__c,sigmaerpdev2__Total_count__c,sigmaerpdev2__Waiting_list__c,sigmaerpdev2__Date_Format__c from sigmaerpdev2__Events__r),(Select Id,Name,Parent.Id from Attachments)from sigmaerpdev2__Course__c];
            
            if(courseList.size() > 0)
            {
                for(sigmaerpdev2__Course__c cs :courseList)
                {
                    CourseWrapper csWrap = new CourseWrapper();
                    System.debug('cs:'+cs +'cs.Attachments:'+cs.Attachments);
                    System.debug('cs.sigmaerpdev2__Events__r:'+cs.sigmaerpdev2__Events__r.size() + cs.sigmaerpdev2__Events__r);
                    csWrap.course = cs;
                    csWrap.attach = cs.Attachments;
                    List<EventWrapper> eventWrapList = new List<EventWrapper>();
                    for(sigmaerpdev2__Event__c event : cs.sigmaerpdev2__Events__r)
                    {
                        EventWrapper eventWrap = new EventWrapper();
                        eventWrap.Event = event;
                        eventWrap.IsSelected = false;
                        eventWrapList.add(eventWrap);

                    }
                    
                    csWrap.EventList = eventWrapList;
                    courseWrap.add(csWrap);
                }
                
            }
                      
                      
        }
        
        catch (Exception ex) 
        {
            System.debug('ex:::'+ex.getMessage() +'Linenumber: '+ex.getLineNumber());
            //courseWrap.CourseList = null;
            return null;
            
            
        }
        System.debug('Final courseWrap>>'+courseWrap); 
        return courseWrap;
    }
    
    
    
    @AuraEnabled
    public static BookingWrapper SaveEventInfo(String BookingWrapperParam)
    {
       
        BookingWrapper BookWrap = new BookingWrapper();
        BookWrap = (BookingWrapper)System.JSON.deserialize(BookingWrapperParam, BookingWrapper.class);
    System.debug('BookWrap:'+BookWrap);
        try{
            
            Account acc = new Account();
           
            acc.First_Name__c = BookWrap.custWrap.FirstName;
            acc.LastName__c = BookWrap.custWrap.LastName;
            acc.Name =  acc.First_Name__c +' '+ acc.LastName__c;
            acc.Email__c = BookWrap.custWrap.EmailId;
            acc.Mobile_Phone_Number__c = BookWrap.custWrap.MobilePhoneNumber;
            acc.Address__c = BookWrap.custWrap.Address;
            acc.First_Name__c = BookWrap.custWrap.TownCity;
            acc.BillingPostalCode = BookWrap.custWrap.PostalCode;
      acc.BillingCity = BookWrap.custWrap.TownCity;
      acc.BillingStreet = BookWrap.custWrap.StreeAddress;
            acc.BillingCountry = BookWrap.custWrap.Country;
      acc.How_do_you_hear_about_this_course_or_eve__c = BookWrap.custWrap.hearaboutUs;

            insert acc;
            System.debug('after insrt account:'+acc);
            
            Booking__c book = new Booking__c();
            book.Event__c = BookWrap.EventId;
            book.Customer__c = acc.Id;
            book.Payment_Status__c = 'Pending';
            book.Customer_email__c = BookWrap.custWrap.EmailId;
            book.RecordtypeId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Event booking').getRecordTypeId();
        
            
            insert book;
            System.debug('after insrt book:'+book);
            
            sigmaerpdev2__Event__c event = [Select Id,Name,sigmaerpdev2__Booked_Count__c,sigmaerpdev2__Waiting_list__c,sigmaerpdev2__Total_count__c from sigmaerpdev2__Event__c where Id=:BookWrap.EventId];
            System.debug('event:'+event);
            
            if(event.sigmaerpdev2__Booked_Count__c < event.sigmaerpdev2__Total_count__c)
            {
                event.sigmaerpdev2__Booked_Count__c = event.sigmaerpdev2__Booked_Count__c + 1;
            }else
            {
                event.sigmaerpdev2__Waiting_list__c = event.sigmaerpdev2__Waiting_list__c + 1;
            }
            
            System.debug('event before update:'+event);
            update event;
            System.debug('event before update:'+event);
            
            BookWrap.BookingId = book.Id;

            
            
           
            
            BookWrap.Response = 'Success';
            BookWrap.Status = 'Success';    
            
            
        }
        
        catch (Exception ex) 
        {
            System.debug('ex:::'+ex.getMessage() +'Linenumber: '+ex.getLineNumber());
            BookWrap.Response = ex.getMessage() +' Linenumber: '+ex.getLineNumber();
            BookWrap.Status = 'Fail';       
            return BookWrap;
            
        }
        
        System.debug('Final BookWrap>>'+BookWrap);        
        return BookWrap;
    }
    
    
    
    
    
      public class CourseWrapper{
        
        @AuraEnabled
        public sigmaerpdev2__Course__c course;
        @AuraEnabled
        public Attachment attach;
        @AuraEnabled
        public boolean IsSelected = false;
        @AuraEnabled
        public List<EventWrapper> EventList;
        
          
      }
      
      public class EventWrapper{
          
        @AuraEnabled
        public sigmaerpdev2__Event__c Event;
        @AuraEnabled
        public boolean IsSelected=false;
        
          
      }
    
    
    
    
    public class MainWrapper{
        @AuraEnabled
        public  Integer pageSize;
        @AuraEnabled
        public  Integer page;
        @AuraEnabled
        public  Integer total ;
        @AuraEnabled
        public List<Innerwrapper> AppointmentList;
        @AuraEnabled
        public Decimal duration = 0;
        @AuraEnabled
        public Decimal deposit = 0.0;
        
    }
    
    public class Innerwrapper{
        
        @AuraEnabled
        public  String weekday;
        @AuraEnabled
        public boolean IsSelected = false;
        @AuraEnabled
        public boolean IsDisabled;
        @AuraEnabled
        public sigmaerpdev2__Appointment__c Appointment;
        
    }
    
    
    
    public class BookingWrapper{
        @AuraEnabled
        public  CustomerWrapper custWrap;
        @AuraEnabled
        public sigmaerpdev2__Appointment__c Appointment;
        @AuraEnabled
        public Decimal Amount;
        @AuraEnabled
        public String BookingId;
        @AuraEnabled
        public String OrderId;
        @AuraEnabled
        public String CustomerId;
        @AuraEnabled
        public String Response;
        @AuraEnabled
        public String Status; 
        @AuraEnabled
        public String AppointmentId;
        @AuraEnabled
        public String EventId;      

    }
    
    public class CustomerWrapper{
        @AuraEnabled
        public  String FirstName;
        @AuraEnabled
        public  String LastName;
        @AuraEnabled
        public  String KnowAs ;
        @AuraEnabled
        public String JobTitle;
        @AuraEnabled
        public String CurrentEmployer ;
        @AuraEnabled
        public Date DateofBirth;
        @AuraEnabled
        public String EmailId;
        @AuraEnabled
        public String MobilePhoneNumber;
        @AuraEnabled
        public String HomePhoneNumber;
        @AuraEnabled
        public String StreeAddress;
        @AuraEnabled
        public String Address;
        @AuraEnabled
        public String TownCity;
        @AuraEnabled
        public String PostalCode;
        @AuraEnabled
        public String Country;
        @AuraEnabled
        public String DataProtectionPolicy;
        @AuraEnabled
        public String ageof18years;
        @AuraEnabled
        public String registeredwithmedical;
        @AuraEnabled
        public String accessRequirements;
        @AuraEnabled
        public String attendingAlone;
        @AuraEnabled
        public String hearaboutUs;
        @AuraEnabled
        public String PleaseconfirmAggrement;
        
        
    }
    
    
    
}