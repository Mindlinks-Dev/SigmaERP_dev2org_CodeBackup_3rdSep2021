global with sharing class MRGanttController
{
    global  static String csvVals{get; set;}
    global  static String RHSValuesForFields { get; set; }
    global  static String predvalue {get;set;}
    global  static String statusvalue {get;set;}
    global  static String typevalue {get;set;}
    global  static String linkValues {get;set;}
    global  static String deletetaskvalues {get;set;}
    global  static String linkidsValues {get;set;}
    
    global String GanttLibrary {get;set;}
    global  String currentRecordId {get;set;}
    global  String currentRecordIdtemp {get;set;}
    global  static String templname {get;set;}
    global  static List<Project_Resource__c> IPMupdateList {get;set;}
    global  static List<Project_Resource__c> IPMRoleIdList {get;set;}
    global  static Manufacturing_Run__c ProjectTemplateobj {get;set;}
    global  string ProjectTemplate {get;set;}
    global Boolean ProjectTempflag {get;set;}
    global  string EffectiveDate {get;set;}
    global  static List<Manufacturing_Run_Resource_Activities__c> ResactivityData {get;set;} //ProjtaskData
    global  static List<Manufacturing_Run_Resource_Activities__c> ResactivityData1 {get;set;} //ProjtaskData1
    global  static List<Manufacturing_Run_Resource_Activities__c> ResactivityData2 {get;set;} //ProjtaskData2
    global  static List<Manufacturing_Run_Resource_Activities__c> ResactivityData3 {get;set;} //ProjtaskData1_2
    global  static String jsonStringValue {get;set;}
    global  string success{get;set;}
    global  static String resValues {get;set;}
    global  static List<Holiday> holidayData {get;set;}
    global  static List<user> UsData {get;set;}
    global  static List<Project_Resource__c> resData {get;set;}
    private limitWrapper[] thousandBlocks = new limitWrapper[]{};
        global  static boolean ifcondition{get;set;}
    private final integer listLimit;
    
    
    global MRGanttController(ApexPages.StandardController controller)
    {
           
        
            try{
            GanttLibrary = getResourcePath();
            system.debug('GanttLibrary>>'+GanttLibrary);
            }
            catch(exception e)
            {
                system.debug('exception>>'+e);
            }
            system.debug('name>>>'+GanttLibrary);
            currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
            listLimit = 1000;
            currentRecordIdtemp = ApexPages.CurrentPage().getparameters().get('id');
            
            ProjectTemplateobj =[select id,Manufacturing_Run__c,Run_Date__c,Template__c from Manufacturing_Run__c where id =: currentRecordId];
            ProjectTemplate = ProjectTemplateobj.Manufacturing_Run__c;
            EffectiveDate = string.valueOf(ProjectTemplateobj.Run_Date__c);
            ProjectTempflag = ProjectTemplateobj.Template__c;
            this.getholiData();
            this.getresData();
            this.getuserData();
        
        
    } 
     // code for save task in  template
    @RemoteAction
    global  static List<Project_Resource__c> calltemplateFunc(string templname,string currentRecordIdtemp) 
    {
        List<Project_Resource__c> TeamList = new List<Project_Resource__c>();
           
            string temp=templname.remove('"');
            List<Manufacturing_Run_Resource_Activities__c> ResActList = new List<Manufacturing_Run_Resource_Activities__c>();
            
            for(Manufacturing_Run__c ProjData : [select id,Product__c,Recipe__c,End_Date__c,Manufacturing_Run__c,Run_Date__c,Name,Template__c,(select id,Duration__c ,linkId__c,Source_Link_Id__c,lag__c,Row_Number__c,Manufacture_Run_Type__c,Target_Link_Id__c,MR_Activity_Name__c,MR_Activity_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,Work_Status__c,predecessors__c,Status__c,Manufacturing_Run__c,Manufacturing_Run__r.Manufacturing_Run__c,Resource_Id__c,MR_Activity_Owner__c,Checked__c,Progress__c,Mark_as_Milestone__c  from MR_Resource_Activities__r limit 1) from Manufacturing_Run__c where id =:currentRecordIdtemp]){
                 if(ProjData.MR_Resource_Activities__r.size() != 0)
                {
                    List<Project_Resource__c> ipmteam = [select id,Name,Last_Name__c,Billing_Currency__c,Interval__c,First_Name__c,Roles__c,Manufacturing_Run__c  from Project_Resource__c where Manufacturing_Run__c =: currentRecordIdtemp AND Roles__c !=''];   // to get all the records from project ipm team removing empty roles
                    Manufacturing_Run__c proTemplate = new Manufacturing_Run__c();
                    proTemplate.Effective_Date__c = ProjData.Run_Date__c;
                    proTemplate.Manufacturing_Name__c = temp;                                    // make as dynamic from popup
                    proTemplate.Run_Date__c = ProjData.Run_Date__c;
                    proTemplate.Template__c = ProjData.Template__c;
                    proTemplate.End_Date__c = ProjData.End_Date__c;
                    insert proTemplate;                                         //inserting template
                    
                    Map<String,String> ipmteamMap = new Map<String,String>();   //map to key=>role, value=>id
                    Set<String> setrol = new Set<String>();                     //Set to remove duplicate role
                    for(Project_Resource__c teamipm:ipmteam)
                    {
                        setrol.add(teamipm.Roles__c);
                    }
                    for(String UniqueRole:setrol){
                        Project_Resource__c IPM = new Project_Resource__c();  
                        IPM.Manufacturing_Run__c = proTemplate.id;
                        IPM.Interval__c = 'Hour';
                        IPM.Billing_Currency__c = 'test';
                        IPM.Roles__c = UniqueRole;
                        TeamList.add(IPM);
                    }
                    insert TeamList; 
                }
                else
                {
                    TeamList  =  null;
                }
            }
        
        return TeamList;
    }
    
    global  pageReference getProjDatatest()
    {
        system.debug('inside getProjDatatest');
        getthousandBlocks();
        
        return null;
    }
    
    //@future
    global  limitWrapper[] getthousandBlocks()
    {
        thousandBlocks = new limitWrapper[]{};
       
            integer counter = 0;
            integer loopCount = 0;
            Manufacturing_Run_Resource_Activities__c[] tmpcase = new Manufacturing_Run_Resource_Activities__c[]{};
            string s = '\\';
            string p = '\\'+s;
            List<Project_Resource__c> IPMupdateList1 = [select id,Name,Roles__c,Last_Name__c,First_Name__c,Resource__r.Name,Resource__r.Last_Name__c,Resource__r.Roles__c from Project_Resource__c where Manufacturing_Run__c =: currentRecordId];
            List<Manufacturing_Run_Resource_Activities__c>  testData1 = [select id,Duration__c,Dashboard__c,Notes__c,Actual_Finish__c,Manufacturing_Run__r.Manufacturing_Run__c,linkId__c,Progress__c,Source_Link_Id__c,lag__c,Row_Number__c,Manufacture_Run_Type__c,Target_Link_Id__c,MR_Activity_Name__c,MR_Activity_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,Work_Status__c,predecessors__c,Status__c,Manufacturing_Run__c,Resource_Id__c,MR_Activity_Owner__c,Checked__c,Mark_as_Milestone__c   from Manufacturing_Run_Resource_Activities__c where  Manufacturing_Run__c =: currentRecordId ORDER BY Row_Number__c ASC limit 3];
            if(ProjectTemplate !=null && testData1.size() < 1)
            {
                ifcondition = true;
                List<Project_Resource__c> IPMList = IPMupdateList1.clone();
                List<Project_Resource__c> IPMNew = new List<Project_Resource__c>();
                set<String> roles=new set<String>();
                for(Project_Resource__c protask : IPMList)
                {
                    if(protask.Roles__c != null && protask.Roles__c != ''){
                        roles.add(protask.Roles__c);
                    }
                }
                
                List<String> RoleId = new List<String>();
                String roleIdStr = '';
                string bindvalue;
                string bindroles;
                for(Manufacturing_Run_Resource_Activities__c MRresActivity : [select id,Duration__c,Notes__c,Actual_Finish__c,Manufacturing_Run__r.Manufacturing_Run__c,linkId__c,Progress__c,Source_Link_Id__c,lag__c,Row_Number__c,Manufacture_Run_Type__c,Target_Link_Id__c,MR_Activity_Name__c,MR_Activity_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,Work_Status__c,predecessors__c,Status__c,Resource_Id__c,MR_Activity_Owner__c,Checked__c,Mark_as_Milestone__c from Manufacturing_Run_Resource_Activities__c where  Manufacturing_Run__c =: ProjectTemplate ORDER BY Row_Number__c ASC])
                {
                    if(MRresActivity.Resource_Id__c != null && MRresActivity.Resource_Id__c != '')
                    {
                        if(roleIdStr == ''){
                            roleIdStr = MRresActivity.Resource_Id__c;
                        }else{
                            roleIdStr = roleIdStr+','+MRresActivity.Resource_Id__c;
                        }
                    }
                    
                }
                RoleId = roleIdStr.split(',');
                Map<Id,String> IPMMap = new Map<Id,String>();
                IPMRoleIdList = [select id,Name,Roles__c,Last_Name__c,First_Name__c from Project_Resource__c where Manufacturing_Run__c =: ProjectTemplate and id IN : RoleId];
                for(Project_Resource__c MAkMap : IPMRoleIdList){
                    IPMMap.put(MAkMap.id,MAkMap.Roles__c);
                    if(!roles.contains(MAkMap.Roles__c))
                    {
                        Project_Resource__c IPLcreate = new Project_Resource__c();
                        IPLcreate.Roles__c = MAkMap.Roles__c;
                        IPLcreate.Manufacturing_Run__c = currentRecordId;
                        IPMNew.add(IPLcreate);
                        roles.add(MAkMap.Roles__c);
                    }
                }
                insert IPMNew;
                IPMupdateList = [select id,Name,Roles__c,Last_Name__c,First_Name__c,Resource__r.Name from Project_Resource__c where Manufacturing_Run__c =: currentRecordId];
                integer count =0;
                for(Manufacturing_Run_Resource_Activities__c c:[select id,Duration__c,Dashboard__c,Notes__c,Actual_Finish__c,Manufacturing_Run__r.Manufacturing_Run__c,linkId__c,Progress__c,Source_Link_Id__c,lag__c,Row_Number__c,Manufacture_Run_Type__c,Target_Link_Id__c,MR_Activity_Name__c,MR_Activity_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,Work_Status__c,predecessors__c,Status__c,Manufacturing_Run__c,Resource_Id__c,MR_Activity_Owner__c,Checked__c ,Mark_as_Milestone__c from Manufacturing_Run_Resource_Activities__c where  Manufacturing_Run__c =: ProjectTemplate ORDER BY Row_Number__c ASC ])
                {
                    count++;
                    if(c.MR_Activity_Name__c.contains('"'))
                    {
                        c.MR_Activity_Name__c = c.MR_Activity_Name__c.replace('"','\\"');
                    }
                    else if(c.MR_Activity_Name__c.contains(s))
                    {
                        c.MR_Activity_Name__c = c.MR_Activity_Name__c.replace(s,p);
                    }
                    
                    if(c.Notes__c != null && c.Notes__c.contains('"'))
                    {
                        c.Notes__c = c.Notes__c.replace('"','\\"');
                    }
                    else if(c.Notes__c != null && c.Notes__c.contains(s))
                    {
                        c.Notes__c = c.Notes__c.replace(s,p);
                    }
                    else if(c.Notes__c != null && c.Notes__c.contains('\n')){
                        c.Notes__c = c.Notes__c.replace('\n',' ');
                    }
                    if(counter < listLimit)
                    {
                        tmpcase.add(c);
                        counter++;
                    }
                    else
                    {
                        loopCount++;
                        thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                        tmpcase = new Manufacturing_Run_Resource_Activities__c[]{};
                            tmpcase.add(c);
                        counter = 0;
                    }            
                }
                
                if(thousandBlocks.size() == 0)
                {
                    loopCount++;
                    thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                }else{
                    thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                }
            }
            else
            {
                IPMupdateList = IPMupdateList1;
                for(Manufacturing_Run_Resource_Activities__c c:[select id,Duration__c,Dashboard__c,Notes__c,Actual_Finish__c,Manufacturing_Run__r.Manufacturing_Run__c,linkId__c,Progress__c,Source_Link_Id__c,lag__c,Row_Number__c,Manufacture_Run_Type__c,Target_Link_Id__c,MR_Activity_Name__c,MR_Activity_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,Work_Status__c,predecessors__c,Status__c,Manufacturing_Run__c,Resource_Id__c,MR_Activity_Owner__c,Checked__c,Mark_as_Milestone__c from Manufacturing_Run_Resource_Activities__c where  Manufacturing_Run__c =: currentRecordId ORDER BY Row_Number__c ASC ])
                {
                    if(c.MR_Activity_Name__c.contains('"'))
                    {
                        c.MR_Activity_Name__c = c.MR_Activity_Name__c.replace('"','\\"');
                    }
                    else if(c.MR_Activity_Name__c.contains(s))
                    {
                        c.MR_Activity_Name__c = c.MR_Activity_Name__c.replace(s,p);
                    }
                    
                    if(c.Notes__c != null && c.Notes__c.contains('"'))
                    {
                        c.Notes__c = c.Notes__c.replace('"','\\"');
                    }
                    else if(c.Notes__c != null && c.Notes__c.contains(s))
                    {
                        c.Notes__c = c.Notes__c.replace(s,p);
                    }
                    else if(c.Notes__c != null && c.Notes__c.contains('\n')){
                        c.Notes__c = c.Notes__c.replace('\n',' ');
                    }
                    if(counter < listLimit)
                    {
                        tmpcase.add(c);
                        counter++;
                    }
                    else
                    {
                        loopCount++;
                        thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                        tmpcase = new Manufacturing_Run_Resource_Activities__c[]{};
                            tmpcase.add(c);
                        counter = 0;
                    }            
                }
                
                if(thousandBlocks.size() == 0)
                {
                    loopCount++;
                    thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                }else{
                    thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                }
                
            }
        
        return thousandBlocks;
    }
    
    global  class limitWrapper
    {
        global  Manufacturing_Run_Resource_Activities__c [] cases {get;set;}
        global  integer blockNumber {get;set;}
        global  limitWrapper(Manufacturing_Run_Resource_Activities__c[] accs, integer i)
        {
            cases = accs;
            blockNumber = i;
        }
        
    }
    
    global  List<user> getuserData()
    {
        
            UsData = [select id,Name from user limit 100000];
                return UsData;
    }
    
    global  List<Project_Resource__c> getresData()
    {
       
            resdata = [select id,Name,Last_Name__c,First_Name__c,Roles__c  from Project_Resource__c where Manufacturing_Run__c=: currentRecordId];
           
        return resdata;
    }
    global  List<Holiday> getholiData()
    {
        
            holidayData = [SELECT Id, ActivityDate FROM Holiday Limit 10000];
        
        return holidayData;
    }
    
    @RemoteAction 
    global static errorWrapper callToSetSelectedFieldsFunc(List<String> projectTaskVal,string currenrecordid,List<String> deletetaskvalue,Boolean isSaveAsTemplate) {
        errorWrapper errwrap = new errorWrapper();
        system.debug('projectTaskVal???'+projectTaskVal);
        try
        {  
            List<Manufacturing_Run_Resource_Activities__c> sobjectList = new List<Manufacturing_Run_Resource_Activities__c>();
            List<Manufacturing_Run_Resource_Activities__c> insertsobjectList = new List<Manufacturing_Run_Resource_Activities__c>();
            List<Manufacturing_Run_Resource_Activities__c> taskdelete=new List<Manufacturing_Run_Resource_Activities__c>();
            List<Manufacturing_Run_Resource_Activities__c> insertProjTempLst=new List<Manufacturing_Run_Resource_Activities__c>();
            Manufacturing_Run__c projectUpdate = new Manufacturing_Run__c();
            if(!isSaveAsTemplate)
            {
                taskdelete = [select id from Manufacturing_Run_Resource_Activities__c where id IN: deletetaskvalue];
                projectUpdate = [select id,name  from Manufacturing_Run__c where id =: currenrecordid];
                system.debug('projectUpdate????'+projectUpdate);
            }
            for(String myObj:projectTaskVal)
            {
                system.debug('myObj????'+myObj);
                Object projVal = myObj;
                Map<String, Object> customerAttributes = (Map<String, Object>)JSON.deserializeUntyped(myObj);
                system.debug('customerAttributes????'+customerAttributes);
                Manufacturing_Run_Resource_Activities__c projObj = new Manufacturing_Run_Resource_Activities__c();
                projObj.Checked__c = boolean.valueOf(customerAttributes.get('sigmaerpdev2__Checked__c'));
                projObj.Duration__c = (decimal)customerAttributes.get('sigmaerpdev2__Duration__c');
                projObj.MR_Activity_Id__c=string.valueOf(customerAttributes.get('sigmaerpdev2__MR_Activity_Id__c'));
                projObj.lag__c=string.valueOf(customerAttributes.get('sigmaerpdev2__lag__c'));
                projObj.linkId__c=string.valueOf(customerAttributes.get('sigmaerpdev2__linkId__c'));
                projObj.Notes__c=string.valueOf(customerAttributes.get('sigmaerpdev2__Notes__c'));
                projObj.Resource_Id__c= string.valueOf(customerAttributes.get('sigmaerpdev2__Resource_Id__c'));
                projObj.source__c= string.valueOf(customerAttributes.get('sigmaerpdev2__source__c'));
                projObj.priority__c= string.valueOf(customerAttributes.get('sigmaerpdev2__priority__c'));
                projObj.Work_Status__c= string.valueOf(customerAttributes.get('sigmaerpdev2__Work_Status__c'));
                projObj.target__c= string.valueOf(customerAttributes.get('sigmaerpdev2__target__c'));
                projObj.type__c= string.valueOf(customerAttributes.get('sigmaerpdev2__type__c'));
                projObj.Manufacture_Run_Type__c= string.valueOf(customerAttributes.get('sigmaerpdev2__Manufacture_Run_Type__c'));
                projObj.WBS_Code__c= string.valueOf(customerAttributes.get('sigmaerpdev2__WBS_Code__c'));
                projObj.MR_Activity_Name__c= string.valueOf(customerAttributes.get('sigmaerpdev2__MR_Activity_Name__c'));
                projObj.Parent__c= string.valueOf(customerAttributes.get('sigmaerpdev2__Parent__c'));
                projObj.predecessors__c= string.valueOf(customerAttributes.get('sigmaerpdev2__predecessors__c'));
                projObj.Progress__c= (Decimal)customerAttributes.get('sigmaerpdev2__Progress__c');
                projObj.Row_Number__c= Integer.valueof(customerAttributes.get('sigmaerpdev2__Row_Number__c'));
                
                List<String> dateStr = new List<String>(); 
                string date1 = string.valueOf(customerAttributes.get('sigmaerpdev2__Start_Date__c'));
                dateStr = date1.split('T');
                date1 = dateStr[0]+'T00:00:00.000Z';
                date SdT = date.ValueOf(date1);
                projObj.Start_Date__c= SdT;
                List<String> enddateStr = new List<String>(); 
                string EDdate = string.valueOf(customerAttributes.get('sigmaerpdev2__End_Date__c'));
                enddateStr = EDdate.split('T');
                EDdate = enddateStr[0]+'T00:00:00.000Z';
                date dT = date.ValueOf(EDdate);
                projObj.End_Date__c = dT;
                List<String> ActualFinishdateStr = new List<String>(); 
                string ActualFinishdate = string.valueOf(customerAttributes.get('sigmaerpdev2__Actual_Finish__c'));
                if(ActualFinishdate!= null && ActualFinishdate!= ''){
                    ActualFinishdateStr = ActualFinishdate.split('T');
                    ActualFinishdate = ActualFinishdateStr[0]+'T00:00:00.000Z';
                    date AdT = date.ValueOf(ActualFinishdate);
                    projObj.Actual_Finish__c = AdT;
                }else{
                    projObj.Actual_Finish__c = null;
                }
                if(isSaveAsTemplate){
                    projObj.Manufacturing_Run__c=(id)customerAttributes.get('sfdcid');
                    insertProjTempLst.add(projObj);
                 }else{
                    if(customerAttributes.containsKey('sfdcid'))        //edit
                    {
                        projObj.id=(id)customerAttributes.get('sfdcid');
                        sobjectList.add(projObj);
                    }
                    else                                                //insert flow 
                    {
                        projObj.Manufacturing_Run__c =currenrecordid;
                        insertsobjectList.add(projObj);
                    }
                }
            }
            if(isSaveAsTemplate){
                insert insertProjTempLst;
            }else{
                update sobjectList;
                insert insertsobjectList;
                update projectUpdate;
                delete  taskdelete; 
            }
            errwrap.isSuccess = true;
            errwrap.ErrorMsg = 'Success';
        }catch(Exception ex){
            errwrap.isSuccess = false;
            errwrap.ErrorMsg = ex.getMessage();
        }
    
        return errwrap;
    }
    
    global  class errorWrapper{
        global  boolean isSuccess {get;set;}
        global  String ErrorMsg {get;set;}
    }
    public String getResourcePath() 
    {
        Default_Parameters__c fetchDHTXML;
        StaticResource resource;
            
       
       // StaticResource resource = [SELECT Name, NamespacePrefix,SystemModStamp  FROM  StaticResource  WHERE  Name ='DHTMLX' LIMIT 1];
         fetchDHTXML= [select Gantt_Library_Name__c from Default_Parameters__c Limit 1];
           resource = [SELECT Name, NamespacePrefix,SystemModStamp  FROM  StaticResource  WHERE  Name =: fetchDHTXML.Gantt_Library_Name__c LIMIT 1];
                
        if(resource!=null)
        {
            String namespace = resource.NamespacePrefix;
            String resourcePath = '/resource/' +resource.SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resource.Name;
            
            return resourcePath;
        }
        else
            return '';
      
    }
    
}