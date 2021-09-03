/* Controller associated with pages rendering the survey.
* Used by SurveyPage, ResultsPage, TakeSurvey
*/
global virtual without sharing class ViewSurveyController {
    public String customId                              {get; set;} //added 4/9/2020
    public String objectAPIName                    {get; set;} //8/9/2020
    public String  qQuestion                      {get; set;}
    public Boolean qRequired                      {get; set;}
    public String  qChoices                       {get; set;}
    public String surveyName                        {get; set;}
    public String surveyHeader                {get; set;}
    public String surveyId                          {get; 
                                                     set{
                                                         this.surveyId = value;
                                                         init();
                                                     }
                                                    }   
    public String renderSurveyPreview           {get; set;}  
    public String questionName                    {get; set;}  
    public String questionType                    {get; set;}
    public Boolean questionRequired             {get; set;}
    public List<SelectOption> singleOptions   {get; set;} 
    public List<SFQuestion> allQuestions        {get; set;}
    public List<String> responses                   {get; set;}
    public Integer allQuestionsSize               {get; set;}
    public String  templateURL                {get; set;}
    public String  surveyThankYouText         {get; set;}
    public String surveyContainerCss {get; set;}
    public String  surveyThankYouURL          {get; set;}
    public String  caseId                     {get; set;}
    public String contactId {get;set;}
    public String anonymousAnswer {get;set;}
    public List<SelectOption> anonymousOrUser {get;set;}
    public Boolean isInternal {get;set;}
    public String baseURL {get;set;}
    
    public String userId{get;set;}
    public String userName{get;set;}
    public String surveyTakerId {get;set;}
    public Boolean thankYouRendered{get;set;}
    public Boolean thankYouMessage{get;set;}
    public List<String> newOrder {get;set;}
    
    private integer totalRecs = 0;    
    private integer OffsetSize = 0;  
    private integer LimitSize= 1;  
    
    public Map<String,String> qnAndSelOption = new Map<String,String>();
    public Map<String,String> qnAndSelOptionFull = new Map<String,String>();
    
    public String quesId{get;set;}
    public String userSelOption{get;set;}
    
    public Boolean disabl {get;set;}
    public Boolean enab {get;set;}
    public Boolean enabsubm {get; set;}
    public integer Totalsize;
    
    public boolean timer {get; set;}
    
    
    /* Retrieves the list of questions, the survey name, after retrieving the 
necessary parameters from the url.
*/
    //------------------------------------------------------------------------------// 
    public ViewSurveyController(ApexPages.StandardController stdController) {
        // Get url parameters
        customId =Apexpages.currentPage().getParameters().get('customId'); //added 4/9/2020
        objectAPIName =Apexpages.currentPage().getParameters().get('objectAPIName'); //08/09/2020
        system.debug('objectAPIName>>'+objectAPIName);
        system.debug('customId>>'+customId);
        surveyId = Apexpages.currentPage().getParameters().get('id');
        caseId   = Apexpages.currentPage().getParameters().get('caId');
        contactId = Apexpages.currentPage().getParameters().get('cId'); 
        
        if(caseId ==null || caseId.length()<15){
            caseId = 'none';
        }
        if(contactId ==null || contactId.length()<15){
            contactId = 'none';
        }
        surveyId = String.escapeSingleQuotes(surveyId);
        caseId = String.escapeSingleQuotes(caseId);
        contactId = String.escapeSingleQuotes(contactId);
        // By default the preview is not showing up
        renderSurveyPreview = 'false';
        
        init();
    } 
    
    
    public ViewSurveyController(viewShareSurveyComponentController controller)
    {
        surveyId = Apexpages.currentPage().getParameters().get('id');
        caseId   = Apexpages.currentPage().getParameters().get('caId');
        contactId = Apexpages.currentPage().getParameters().get('cId'); 
        if(caseId ==null || caseId.length()<15){
            caseId = 'none';
        }
        if(contactId ==null || contactId.length()<15){
            contactId = 'none';
        }       
        surveyId = String.escapeSingleQuotes(surveyId);
        caseId = String.escapeSingleQuotes(caseId);
        contactId = String.escapeSingleQuotes(contactId);
        // By default the preview is not showing up
        renderSurveyPreview = 'false';
        init();
    }
    
    
    public void init()
    {
        String qString = 'select Survey__c from SurveyTaker__c  where Survey__c = \''+ surveyId+'\''+' and '+ objectAPIName +'='+'\''+ customId+'\'';
        system.debug('qString>>>'+qString);
        List<sObject> sobjList = Database.query(qString); 
        system.debug('sobjList'+qString);
        system.debug('queryParentObject'+sobjList.size());
        if(sobjList.size() > 0)
        {
            system.debug('jai hind');
            enabsubm=true;
            enab=true;
            
        }
        
        System.debug('init line 95....');
        if (surveyId != null){ 
            // Retrieve all necessary information to be displayed on the page
            allQuestions = new List<SFQuestion>();
            
            setupQuestionList();
            setSurveyNameAndThankYou(surveyId);
            anonymousOrUser = new List<SelectOption>();
            anonymousOrUser.add(new SelectOption('Anonymous',System.Label.LABS_SF_Anonymous));
            anonymousOrUser.add(new SelectOption('User','User ' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName()));
            anonymousAnswer =  (userInfo.getUserType() == 'Guest')?'Anonymous':'';
            isInternal = (userInfo.getUserType() == 'Guest')?false: true;
            newOrder = new List<String>();
            String urlBase = URL.getSalesforceBaseUrl().toExternalForm();
            baseURL = urlBase;
            
            userId = UserInfo.getUserId();
            userName = UserInfo.getName();
            
            thankYouRendered=false;
            thankYouMessage=false;       
        }       
    }    
    //----------------------------------------------------------------------------//    
    
    /* Called during the setup of the page. 
Retrieve questions and responses from DB and inserts them in 2 lists. */
    public Integer setupQuestionList(){
        getAQuestion();         
        return allQuestions.size(); 
    }
    
    
    /** Sets the survey's name variable
*  param: sID   The survey ID as specified in the DB
*/
    public void setSurveyNameAndThankYou(String sId){
        Survey__c s = new Survey__c();
        try{
            List<Schema.SobjectField> fields = new List<Schema.SobjectField>{
                Schema.Survey__c.fields.URL__c,Schema.Survey__c.fields.Thank_You_Text__c,
                    Schema.Survey__c.fields.thankYouText__c,Schema.Survey__c.fields.thankYouLink__c,
                    Schema.Survey__c.fields.Survey_Header__c,Schema.Survey__c.fields.Survey_Container_CSS__c
                    };
                        Util.AccessController.assertAuthorizedToView(Schema.Survey__c.getSobjectType(), fields);
            s = [SELECT Name, Id, URL__c, Thank_You_Text__c, thankYouText__c, thankYouLink__c, Survey_Header__c, Survey_Container_CSS__c FROM Survey__c WHERE Id =:sId];
            surveyName = s.Name;
            surveyHeader = s.Survey_Header__c;
            templateURL = s.URL__c+'id='+sId;//+'&cId={!Contact.Id}'+'&caId='+'{!Case.id}';
            surveyThankYouText = s.Thank_You_Text__c;
            if (surveyThankYouText == null)
            {
                surveyThankYouText = System.Label.LABS_SF_Survey_Submitted_Thank_you;
            }
            surveyThankYouURL = s.thankYouLink__c;
            surveyContainerCss = s.Survey_Container_CSS__c;
        }catch(SFDCAccessControlException e){ Util.log('ViewSurveyController:setSurveyNameAndThankYou():SFDCAccessControlException' + e.getMessage());
                                            }catch(Exception e){Util.log('ViewSurveyController:setSurveyNameAndThankYou():Exception:' + e.getMessage());Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Survey not found: Maybe check user permission to this record'));}
        
    }
    
    //------------------------------------------------------------------------------//   
    public Pagereference updateSurveyName(){
        Survey__c s = new Survey__c();
        try{
            List<Schema.SobjectField> fields = new List<Schema.SobjectField>{
                Schema.Survey__c.fields.URL__c,Schema.Survey__c.fields.thankYouLink__c,
                    Schema.Survey__c.fields.thankYouText__c
                    };
                        Util.AccessController.assertAuthorizedToUpdate(Schema.Survey__c.getSobjectType(), fields);
            
            s = [SELECT Name, Id, URL__c, thankYouText__c, thankYouLink__c FROM Survey__c WHERE Id =:surveyId];
            s.Name = surveyName;
            update s;
        }catch(SFDCAccessControlException e){ Util.log('ViewSurveyController:updateSurveyName():SFDCAccessControlException' + e.getMessage());
                                            }catch(Exception e){Apexpages.addMessages(e);}
        return null;
    } 
    
    //------------------------------------------------------------------------------//      
    public Pagereference updateSurveyThankYouAndLink(){
        Survey__c s = new Survey__c();
        try{
            List<Schema.SobjectField> fields = new List<Schema.SobjectField>{
                Schema.Survey__c.fields.URL__c,Schema.Survey__c.fields.thankYouLink__c,
                    Schema.Survey__c.fields.thankYouText__c
                    };
                        Util.AccessController.assertAuthorizedToUpdate(Schema.Survey__c.getSobjectType(), fields);
            
            s = [SELECT Name, Id, URL__c, thankYouText__c, thankYouLink__c FROM Survey__c WHERE Id =:surveyId];
            s.thankYouText__c = surveyThankYouText;
            s.thankYouLink__c = surveyThankYouURL;
            
            update s;
        }catch(SFDCAccessControlException e){ Util.log('ViewSurveyController:updateSurveyThankYouAndLink():SFDCAccessControlException' + e.getMessage());
                                            }catch(Exception e){Apexpages.addMessages(e);}
        
        return null;
    }
    
    //------------------------------------------------------------------------------//    
    /** When requested from the page - when the user clicks on 'Update Order' -
this function will reorganize the list so that it is displayed in the new order
*/
    public Pagereference refreshQuestionList(){
        setupQuestionList();
        return null;
    }
    
    
    /*
private static boolean checkRequired(String response, Survey_Question__c question){
if(question.Required__c == true){
if(response == null || response =='NO RESPONSE')
return false;
}
return true;
} 
/**/
    
    /** Redirects the page that displays the detailed results of the survey, 
from all users who took the survey.
*/
    public PageReference resultPage() {
        return new PageReference('/apex/ResultsPage?id='+surveyId);
    }
    
    
    //------------------------------------------------------------------------------//  
    
    //------------------------------------------------------------------------------//  
    
    /** 
*/
    public List<String> getResponses() {
        List<SurveyQuestionResponse__c> qr = [Select Survey_Question__c, SurveyTaker__c, Response__c, Name From SurveyQuestionResponse__c limit 100];
        List<String> resp = new List<String>();
        for (SurveyQuestionResponse__c r : qr) {
            resp.add(r.Response__c);
        }
        
        return resp;
    }  
    
    
    
    /** Fills up the List of questions to be displayed on the Visualforce page
*/   
    public List<SFQuestion> getAQuestion() {
        
        List<Survey_Question__c> sizeofQuestions = [select id ,name from Survey_Question__c  WHERE Survey__c =: surveyId];
        System.debug('sizeofQuestions>>>>'+sizeofQuestions); 
        Totalsize= sizeofQuestions.size();
        System.debug('TotalSize>>>>'+TotalSize); 
        qQuestion = '';
        qChoices ='';
        List<Schema.SobjectField> fields = new List<Schema.SobjectField>{
            Schema.Survey_Question__c.fields.Type__c,Schema.Survey_Question__c.fields.Survey__c,
                Schema.Survey_Question__c.fields.Required__c,Schema.Survey_Question__c.fields.Question__c,
                Schema.Survey_Question__c.fields.OrderNumber__c,Schema.Survey_Question__c.fields.Choices__c
                };
                    Util.AccessController.assertAuthorizedToView(Schema.Survey_Question__c.getSobjectType(), fields);
        List<Survey_Question__c> allQuestionsObject = 
            [Select s.Type__c, s.Id, s.Survey__c, s.Required__c, s.Question__c, 
             s.OrderNumber__c, s.Name, s.Choices__c 
             From Survey_Question__c s 
             WHERE s.Survey__c =: surveyId ORDER BY s.OrderNumber__c LIMIT :LimitSize OFFSET :OffsetSize ]; 
        allQuestions = new List<SFQuestion>();
        
        
        Double old_OrderNumber = 0;
        Double new_OrderNumber;
        Double difference = 0;
        /* Make sure that the order number follow each other (after deleting a question, orders might not do so) */
        for (Survey_Question__c q : allQuestionsObject){ 
            new_OrderNumber = q.OrderNumber__c;
            difference = new_OrderNumber - old_OrderNumber - 1;
            if (difference > 0) {
                Double dd = double.valueOf(difference);
                Integer newOrderInt = dd.intValue();
                q.OrderNumber__c -= Integer.valueOf(newOrderInt); 
            }
            old_OrderNumber = q.OrderNumber__c;
            SFQuestion theQ = new SFQuestion(q);
            allQuestions.add(theQ);
        }
        allQuestionsSize = allQuestions.size();
        return allQuestions;
    }   
    
    public void submitResults()
    {
        System.debug('anonymousAnswer::' + anonymousAnswer);
        system.debug('qnAndSelOption123======'+qnAndSelOption);
        
        String qString = 'select Survey__c from SurveyTaker__c  where Survey__c = \''+ surveyId+'\''+' and '+ objectAPIName +'='+'\''+ customId+'\'';
        system.debug('qString>>>'+qString);
        List<sObject> sobjList = Database.query(qstring); 
        system.debug('sobjList'+qString);
        system.debug('queryParentObject'+sobjList);
        if(sobjList.size() > 0)
        {
            system.debug('jai hind');
            enabsubm=true;
            enab=true;
            
        }
        
        List <SurveyQuestionResponse__c> sqrList = new List<SurveyQuestionResponse__c>();
        System.debug('sqrlist Start>>>'+sqrList);
        try {
            
            List<Schema.SobjectField> fields = new List<Schema.SobjectField>{
                Schema.SurveyQuestionResponse__c.fields.Response__c,Schema.SurveyQuestionResponse__c.fields.Survey_Question__c,
                    Schema.SurveyQuestionResponse__c.fields.SurveyTaker__c
                    };
                        Util.AccessController.assertAuthorizedToCreate(Schema.SurveyQuestionResponse__c.getSobjectType(), fields);
            system.debug('allQuestions?????'+allQuestions.size());
            
            
            for (String s : qnAndSelOption.keySet())
            {
                SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
                System.debug('s>>>'+s);
                sqr.Survey_Question__c = s;
                sqr.Response__c =qnAndSelOption.get(s);
                sqrList.add(sqr);
                System.debug('InSideForloop>>>'+sqrList);
            } 
            System.debug('sqrList>>>'+sqrList);
            
            if(AddSurveyTaker())
            {
                for (SurveyQuestionResponse__c sqr : sqrList)
                {
                    sqr.SurveyTaker__c = surveyTakerId;
                }
                //insert sqrList;
                System.debug('sqrlist End>>>'+sqrList);
                ViewSurveyControllerWithoutSharing.createSurveyQuestionResponse(sqrList);
                thankYouMessage=true;
                thankYouRendered=true;
            }
            System.debug('customId>>'+customId);
            
        }catch(SFDCAccessControlException e)
        { Util.log('ViewSurveyController:submitResults():SFDCAccessControlException' + e.getMessage()); 
         Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Some error occured while saving response'));
        }
        catch(Exception e){ if(isInternal) {
            Util.log(e.getMessage()); Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Some error occured while saving response'));            }
                          }
        
        
    }
    
    public void submitContinue(){
        thankYouRendered=true; 
        enab=true;
        
    }
    public void previous(){       
        OffsetSize = (OffsetSize-LimitSize);  
        getAQuestion();
    }
    
    public void next(){ 
        //  OffsetSize = OffsetSize + LimitSize;
        System.debug('OffsetSize>>>'+OffsetSize);
        system.debug('allQuestions==='+allQuestions);
        
        for(SFQuestion q : allQuestions)
        {
            if (q.renderSelectRadio == 'true') {
                
                if (q.required && (q.selectedOption == null || q.selectedOption == '')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select the option and proceed.'));
                    return;
                }
                OffsetSize = OffsetSize + LimitSize;
                getAQuestion();
            }
            
        }
        
        if(OffsetSize == (Totalsize-1))
        {
            disabl = true;
            String qString = 'select Survey__c from SurveyTaker__c  where Survey__c = \''+ surveyId+'\''+' and '+ objectAPIName +'='+'\''+ customId+'\'';
            system.debug('qString>>>'+qString);
            List<sObject> sobjList = Database.query(qstring); 
            system.debug('sobjList'+qString);
            system.debug('queryParentObject'+sobjList);
            if(sobjList.size() > 0)
            {
                system.debug('jai hind');
                enabsubm=true;
                enab=true;
                
            }
            else
            {
                enab=false;
            }
        }
        else
        {
            enab=true;
        }
    }
    
    
    
    //public void selectOption()
    public void selectOption()
    {
        system.debug('selectoption times');
        String quesId = '';
        String selAns = '';
        for(SFQuestion q : allQuestions){ 
            
            system.debug('q>>>>>'+q);
            system.debug('q>>>>>'+q.selectedOption);
            if (q.selectedOption == null || q.selectedOption == '') {
                system.debug('if');
                qnAndSelOption.put(q.Id, q.singleOptions.get(Integer.valueOf(q.selectedOption)).getLabel());
            } else {
                system.debug('else');
                qnAndSelOption.put(q.Id, q.singleOptions.get(Integer.valueOf(q.selectedOption)).getLabel());
            }
            
            System.debug('optionsinmap>>>'+qnAndSelOption);         
        }
        
    }
    
    public boolean getprev(){        
        if(OffsetSize == 0){         
            return true;          
        }        
        else {      
            return false;         
        }        
    }
    
    public boolean getnxt(){        
        if((OffsetSize + LimitSize) > totalRecs){            
            return true;           
        }        
        else { 
            return false;            
        }        
    }        
    public Boolean AddSurveyTaker()
    {
        Boolean retVal = false;
        String userId;
        
        String qString = 'select Survey__c from SurveyTaker__c  where Survey__c = \''+ surveyId+'\''+' and '+ objectAPIName +'='+'\''+ customId+'\'';
        system.debug('qString>>>'+qString);
        List<sObject> sobjList = Database.query(qstring); 
        system.debug('sobjList'+qString);
        system.debug('queryParentObject'+sobjList);
        if(sobjList.size() > 0)
        {
            system.debug('jai hind');
            enabsubm=true;
            enab=true;
            
        }
        
        
        if (surveyId == null) { return false;        }
        if(caseId!= null && (caseId.toUpperCase() =='NONE'|| caseId.length()<15)){
            caseId = null;
        }
        if(contactId != null && (contactId.toUpperCase() =='NONE'|| contactId.length()<15)){
            contactId = null;
        }
        if (anonymousAnswer != 'Anonymous'){ userId = UserInfo.getUserId(); }  else{ userId = null; }
        
        
        SurveyTaker__c st = new SurveyTaker__c();
        
        try {
            List<Schema.SobjectField> fields = new List<Schema.SobjectField>{
                Schema.SurveyTaker__c.fields.Survey__c, Schema.SurveyTaker__c.fields.Taken__c, Schema.SurveyTaker__c.fields.User__c
                    };
                        Util.AccessController.assertAuthorizedToView(Schema.SurveyTaker__c.getSobjectType(), fields);
            
            Util.AccessController.assertAuthorizedToCreate(Schema.SurveyTaker__c.getSobjectType(), fields);
            
            if(anonymousAnswer != 'Anonymous')
            {
                //If survey is taken by Contact OR Case already then no need to take it again
                List<SurveyTaker__c> check = [Select Contact__c, Survey__c, Case__c, User__c From SurveyTaker__c Where Survey__c=:surveyId and 
                                              ((Contact__c != null and Contact__c=:contactId) or (Case__c!= null and Case__c = :caseId)
                                               or (User__c!= null and User__c = :userId))];
                if(check != null && check.size()>0){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LABS_SF_You_have_already_taken_this_survey));
                    
                    return false;
                }
            }
            
            st.Contact__c  = (contactId == null)?null: String.escapeSingleQuotes(contactId);
            st.Survey__c = surveyId;
            st.Taken__c = 'true';
            st.Case__c = (caseId == null)?null: String.escapeSingleQuotes(caseId);
            st.User__c = userId;
            st.put(objectAPIName, customId);
            ViewSurveyControllerWithoutSharing.createSurveyTaken(st);
            surveyTakerId = st.Id;
            retVal = true;
        }catch(SFDCAccessControlException e){ Util.log('ViewSurveyController:AddSurveyTaker():SFDCAccessControlException' + e.getMessage());
                                            }catch(Exception e){Apexpages.addMessages(e);}
        return retVal;
    }
    
    
}