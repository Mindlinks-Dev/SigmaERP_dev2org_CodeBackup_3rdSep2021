public with sharing class projectresourcedata
{
  @InvocableMethod
  public static void projectresourcedataobj(List<Id> LeadIds){
   
  Decimal totalestimateffort = 0;
  Decimal totalactualeffort=0;
  Decimal totalexpectedbillingamount=0;
  Decimal totalactualbillingamount =0;
  String billingcurrency;
  Id ResourceId;
  String interval; 
  List<Project2__c> ListProject = new List<Project2__c>();
  Set<Id>ProjectId =new Set<Id>();
  List<Project_Resource__c> ListProjectResource = new List<Project_Resource__c>();
    if(LeadIds.size() > 0){
      ListProjectResource=[Select id,name,Resource__c,Project2__c,Estimated_Effort__c,Billing_Currency__c,Actual_Effort__c,Actual_Billing_Amount__c,Excepted_Billing_Amount__c,Interval__c from Project_Resource__c where id IN:LeadIds];
      system.debug('ListProject>>'+ListProjectResource);
      for(Project_Resource__c ProRes :ListProjectResource){
        if(ProRes.Project2__c !=null)
        {
          ProjectId.add(ProRes.Project2__c);   
          interval = ProRes.Interval__c;         
        }

      }
    }


    if(ProjectId.size() > 0) {
      ListProject = [SELECT Id, Name,Interval__c,Total_Estimated_Effort__c,Total_Actual_Effort__c,Total_Expected_Billing_Amount__c,Total_Actual_Billing_Amount__c,(Select id,name,Resource__c,Project2__c,Estimated_Effort__c,Actual_Effort__c,Actual_Billing_Amount__c,Billing_Currency__c,Excepted_Billing_Amount__c,Interval__c from Project_Resources__r) FROM Project2__c WHERE Id IN : ProjectId];  
      system.debug('ListProject>>>'+ListProject);
      for(Project2__c pro :ListProject)
      {
          for(Project_Resource__c prores :pro.Project_Resources__r)
          {
                  
          totalestimateffort += ProRes.Estimated_Effort__c;
          totalactualeffort +=ProRes.Actual_Effort__c;
          totalexpectedbillingamount +=ProRes.Excepted_Billing_Amount__c;
          totalactualbillingamount += ProRes.Actual_Billing_Amount__c;
          billingcurrency += prores.Billing_Currency__c;
		  ResourceId = prores.Resource__c;
           
          }
        pro.Total_Estimated_Effort__c = totalestimateffort;
        pro.Total_Actual_Effort__c = totalactualeffort;
        pro.Total_Expected_Billing_Amount__c = totalexpectedbillingamount;
        pro.Total_Actual_Billing_Amount__c = totalactualbillingamount;
        pro.Interval__c = interval;
          
                
      }
      //update ListProject;
      
      try {
        update ListProject;
          } 
        catch(DmlException e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
                }
            
      }
  //}
  }
}