global with sharing class ganttcontroller
{
    global static String csvVals{get; set;}
    global static String RHSValuesForFields { get; set; }
    global static String predvalue {get;set;}
    global static String statusvalue {get;set;}
    global static String typevalue {get;set;}
    global static String linkValues {get;set;}
    global static String deletetaskvalues {get;set;}
    global static String linkidsValues {get;set;}
    
    global String GanttLibrary {get;set;}
    global String currentRecordId {get;set;}
    global String currentRecordIdtemp {get;set;}
    global static String templname {get;set;}
    global static List<Project_Resource__c> IPMupdateList {get;set;}
    global static List<Project_Resource__c> IPMRoleIdList {get;set;}
    global static Project2__c ProjectTemplateobj {get;set;}
    global string ProjectTemplate {get;set;}
    global Boolean ProjectTempflag {get;set;}
    global string EffectiveDate {get;set;}
    global string StartDate {get;set;}
    global static List<Project_Task__c> ProjtaskData{get;set;}
    global static List<Project_Task__c> ProjtaskData1{get;set;}
    global static List<Project_Task__c> ProjtaskData2{get;set;}
    global static List<Project_Task__c> ProjtaskData1_2{get;set;}
    global static String jsonStringValue {get;set;}
    global string success{get;set;}
    global static String resValues {get;set;}
    global static List<Holiday> holidayData {get;set;}
    global static List<user> UsData {get;set;}
    global static List<Project_Resource__c> resData {get;set;}
    private limitWrapper[] thousandBlocks = new limitWrapper[]{};
     global static boolean ifcondition{get;set;}
    private final integer listLimit;
    global string templateId{get;set;}
    
    
    global  ganttcontroller(ApexPages.StandardController controller)
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
            ProjectTemplateobj =[select id,Project2__c,Effective_Date__c,Template__c,Start_Date__c from Project2__c where id =: currentRecordId];
            system.debug('ProjectTemplateobj >>'+ProjectTemplateobj );
            ProjectTemplate = ProjectTemplateobj.Project2__c;
            ProjectTempflag = ProjectTemplateobj.Template__c;
            StartDate = string.valueOf(ProjectTemplateobj.Start_Date__c);
            EffectiveDate = string.valueOf(ProjectTemplateobj.Effective_Date__c);
            this.getholiData();
            this.getresData();
            this.getuserData();
    } 
    
    // code for save task in  template
    @RemoteAction
    global static List<Project_Resource__c> calltemplateFunc(string templname,string currentRecordIdtemp) 
    {
        system.debug('templname'+templname);
            system.debug('currentRecordIdtemp'+currentRecordIdtemp);
        List<Project_Resource__c> TeamList = new List<Project_Resource__c>();
        
            system.debug('inside save as Template');
            string temp=templname.remove('"');
            List<Project_Task__c> ProdtaskList = new List<Project_Task__c>();
            
            for(Project2__c ProjData : [select id,Account__c,End_Date__c,Project2__c,Effective_Date__c,Name,Start_Date__c,Template__c,(select id,Duration__c ,linkId__c,Source_Link_Id__c,lag__c,Row_Number__c,Project_Type__c,Target_Link_Id__c,Project_Task_Name__c,Project_Task_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,predecessors__c,Status__c,Project__c,Resource_Id__c,Owner__c,Checked__c,Progress__c,Mark_as_Milestone__c  from Project_Tasks__r limit 1) from Project2__c where id =:currentRecordIdtemp]){
                system.debug('ProjData >>>'+ProjData );
                if(ProjData.Project_Tasks__r.size() != 0)
                {
                    List<Project_Resource__c> ipmteam = [select id,Name,Resource__c,Last_Name__c,Billing_Currency__c,Interval__c,First_Name__c,Roles__c,Project2__c from Project_Resource__c where Project2__c =: currentRecordIdtemp AND Roles__c !=''];   // to get all the records from project ipm team removing empty roles
                    Project2__c proTemplate = new Project2__c();
                    proTemplate.Effective_Date__c = ProjData.Effective_Date__c;
                    proTemplate.Name = temp;                                    // make as dynamic from popup
                    proTemplate.Start_Date__c = ProjData.Start_Date__c;
                    proTemplate.End_Date__c = ProjData.End_Date__c; //code added on 10-04-2020 -by rashmi
                    proTemplate.Template__c = true;
                    insert proTemplate;                                         //inserting template
                    system.debug('proTemplate>>'+proTemplate);
                    
                    Map<String,String> ipmteamMap = new Map<String,String>();   //map to key=>role, value=>id
                    Set<String> setrol = new Set<String>();     
                    Set<Id> setres = new Set<Id>(); 
                    //Set to remove duplicate role
                    for(Project_Resource__c teamipm:ipmteam)
                    {
                        setres.add(teamipm.Resource__c);
                        setrol.add(teamipm.Roles__c);
                        system.debug('setres-->>'+setres);
                         system.debug('setrol-->>'+setrol);
                    }
                    for(String UniqueRole:setrol){
                        system.debug('UniqueRole-->>'+UniqueRole);
                        Project_Resource__c IPM = new Project_Resource__c();  
                        
                        IPM.Project2__c = proTemplate.id;
                        IPM.Interval__c = 'Hour';
                        IPM.Billing_Currency__c = 'test';
                        IPM.Roles__c = UniqueRole;
                       
                        for(Id UniqueRes:setres)
                        {
                            system.debug('UniqueRes-->>'+UniqueRes);
                            IPM.Resource__c=UniqueRes;
                        }                        
                        TeamList.add(IPM);
                        system.debug('TeamList'+TeamList);
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
    global pageReference getProjDatatest()
    {
        getthousandBlocks();
        return null;
    }
    //@future
    global limitWrapper[] getthousandBlocks()
    {
        thousandBlocks = new limitWrapper[]{};
        
            integer counter = 0;
            integer loopCount = 0;
            Project_Task__c[] tmpcase = new Project_Task__c[]{};
                
            string s = '\\';
            string p = '\\'+s;
            List<Project_Resource__c> IPMupdateList1 = [select id,Name,Roles__c,Last_Name__c,First_Name__c from Project_Resource__c where Project2__c =: currentRecordId];
            List<Project_Task__c>  testData1 = [select id,Duration__c,Dashboard__c,Notes__c,Actual_Finish__c,Project__r.Project2__c,linkId__c,Progress__c,Source_Link_Id__c,lag__c,Row_Number__c,Project_Type__c,Target_Link_Id__c,Project_Task_Name__c,Project_Task_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,predecessors__c,Status__c,Project__c,Resource_Id__c,Owner__c,Checked__c,Mark_as_Milestone__c   from Project_Task__c where  Project__c =: currentRecordId ORDER BY Row_Number__c ASC limit 3];
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
                
                for(Project_Task__c projtask : [select id,Duration__c,Dashboard__c,Notes__c,Actual_Finish__c,Project__r.Project2__c,linkId__c,Progress__c,Source_Link_Id__c,lag__c,Row_Number__c,Project_Type__c,Target_Link_Id__c,Project_Task_Name__c,Project_Task_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,predecessors__c,Status__c,Project__c,Resource_Id__c,Owner__c,Checked__c,Mark_as_Milestone__c from Project_Task__c where  Project__c =: ProjectTemplate ORDER BY Row_Number__c ASC])
                {
                    if(projtask.Resource_Id__c != null && projtask.Resource_Id__c != '')
                    {
                        if(roleIdStr == ''){
                            roleIdStr = projtask.Resource_Id__c;
                        }else{
                            roleIdStr = roleIdStr+','+projtask.Resource_Id__c;
                        }
                    }
                    
                }
                RoleId = roleIdStr.split(',');
                Map<Id,String> IPMMap = new Map<Id,String>();
                IPMRoleIdList = [select id,Name,Roles__c,Last_Name__c,First_Name__c from Project_Resource__c where Project2__c =: ProjectTemplate and id IN : RoleId];
                for(Project_Resource__c MAkMap : IPMRoleIdList){
                    IPMMap.put(MAkMap.id,MAkMap.Roles__c);
                    if(!roles.contains(MAkMap.Roles__c))
                    {
                        Project_Resource__c IPLcreate = new Project_Resource__c();
                        IPLcreate.Roles__c = MAkMap.Roles__c;
                        IPLcreate.Project2__c = currentRecordId;
                        IPMNew.add(IPLcreate);
                        roles.add(MAkMap.Roles__c);
                    }
                }
                insert IPMNew;
                
                IPMupdateList = [select id,Name,Roles__c,Last_Name__c,First_Name__c from Project_Resource__c where Project2__c =: currentRecordId];
                integer count =0;
                for(Project_Task__c c:[select id,Duration__c,Dashboard__c,Notes__c,Actual_Finish__c,Project__r.Project2__c,linkId__c,Progress__c,Source_Link_Id__c,lag__c,Row_Number__c,Project_Type__c,Target_Link_Id__c,Project_Task_Name__c,Project_Task_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,predecessors__c,Status__c,Project__c,Resource_Id__c,Owner__c,Checked__c ,Mark_as_Milestone__c from Project_Task__c where  Project__c =: ProjectTemplate ORDER BY Row_Number__c ASC ])
                {
                    count++;
                    system.debug('count>>>'+count);
                    if(c.Project_Task_Name__c.contains('"'))
                    {
                        c.Project_Task_Name__c = c.Project_Task_Name__c.replace('"','\\"');
                    }
                    else if(c.Project_Task_Name__c.contains(s))
                    {
                        c.Project_Task_Name__c = c.Project_Task_Name__c.replace(s,p);
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
                        system.debug('counter>>>'+counter);
                    }
                    else
                    {
                        loopCount++;
                        system.debug('loopCount>>>'+loopCount);
                        thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                        tmpcase = new Project_Task__c[]{};
                            tmpcase.add(c);
                        counter = 0;
                    }            
                }
                
                if(thousandBlocks.size() == 0)
                {
                    loopCount++;
                    system.debug('loopCount>>>'+loopCount);
                    thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                }else{
                    thousandBlocks.add(new limitWrapper(tmpcase,loopCount));
                }
                
            }
            else
            {
                system.debug('inside direct project>>>>>>');
                
                
                IPMupdateList = IPMupdateList1;
                for(Project_Task__c c:[select id,Duration__c,Dashboard__c,Notes__c,Actual_Finish__c,Project__r.Project2__c,linkId__c,Progress__c,Source_Link_Id__c,lag__c,Row_Number__c,Project_Type__c,Target_Link_Id__c,Project_Task_Name__c,Project_Task_Id__c,target__c,source__c,Parent__c,type__c,ParentId__c,WBS_Code__c,Start_Date__c,End_Date__c,priority__c,predecessors__c,Status__c,Project__c,Resource_Id__c,Owner__c,Checked__c,Mark_as_Milestone__c from Project_Task__c where  Project__c =: currentRecordId ORDER BY Row_Number__c ASC ])
                {
                    if(c.Project_Task_Name__c.contains('"'))
                    {
                        c.Project_Task_Name__c = c.Project_Task_Name__c.replace('"','\\"');
                        system.debug('c.Project_Task_Name__c'+c.Project_Task_Name__c);
                    }
                    else if(c.Project_Task_Name__c.contains(s))
                    {
                        c.Project_Task_Name__c = c.Project_Task_Name__c.replace(s,p);
                        system.debug('c.Project_Task_Name__c'+c.Project_Task_Name__c);
                        
                    }
                    
                    if(c.Notes__c != null && c.Notes__c.contains('"'))
                    {
                        c.Notes__c = c.Notes__c.replace('"','\\"');
                        system.debug('c.Notes__c'+c.Notes__c);
                    }
                    else if(c.Notes__c != null && c.Notes__c.contains(s))
                    {
                        c.Notes__c = c.Notes__c.replace(s,p);
                        system.debug('c.Notes__c'+c.Notes__c);
                        
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
                        tmpcase = new Project_Task__c[]{};
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
    
    global class limitWrapper
    {
        global Project_Task__c [] cases {get;set;}
        global integer blockNumber {get;set;}
        global limitWrapper(Project_Task__c[] accs, integer i)
        {
            cases = accs;
            blockNumber = i;
        }
    }
    
    global List<user> getuserData()
    {
        UsData = [select id,Name from user limit 100000];
        return UsData;
        
    }
    
    global List<Project_Resource__c> getresData()
    {
        
        resdata = [select id,Name,Last_Name__c,First_Name__c,Roles__c  from Project_Resource__c where Project2__c=: currentRecordId];
        
        return resdata;
    }
    global List<Holiday> getholiData()
    {
        
            holidayData = [SELECT Id, ActivityDate FROM Holiday Limit 10000];
        
        return holidayData;
    }
    
    @RemoteAction 
    global static errorWrapper callToSetSelectedFieldsFunc(List<String> projectTaskVal,string currenrecordid,List<String> deletetaskvalue,Boolean isSaveAsTemplate) {
        errorWrapper errwrap = new errorWrapper();
        system.debug('projectTaskVal>>'+projectTaskVal);
        system.debug('currenrecordid>>'+currenrecordid);
        system.debug('isSaveAsTemplate>>'+isSaveAsTemplate);
        
           try
           {  
                List<Project_Task__c> sobjectList = new List<Project_Task__c>();
                List<Project_Task__c> insertsobjectList = new List<Project_Task__c>();
                List<Project_Task__c> taskdelete=new List<Project_Task__c>();
                List<Project_Task__c> insertProjTempLst=new List<Project_Task__c>();
                Project2__c projectUpdate = new Project2__c();
                if(!isSaveAsTemplate)
                {
                    taskdelete = [select id from Project_Task__c where id IN: deletetaskvalue];
                    projectUpdate = [select id from Project2__c where id =: currenrecordid];
                }
                else{
                system.debug('Came inside else');
                }
                for(String myObj:projectTaskVal)
                {
                    system.debug('myObj>>'+myObj);
                    Object projVal = myObj;
                    Map<String, Object> customerAttributes = (Map<String, Object>)JSON.deserializeUntyped(myObj);
                    system.debug('customerAttributes>>>>'+customerAttributes);
                    Project_Task__c projObj = new Project_Task__c();
                    projObj.Checked__c = boolean.valueOf(customerAttributes.get('sigmaerpdev2__Checked__c'));
                    projObj.Dashboard__c = boolean.valueOf(customerAttributes.get('sigmaerpdev2__Dashboard__c'));
                    projObj.Duration__c = (decimal)customerAttributes.get('sigmaerpdev2__Duration__c');
                    projObj.Project_Task_Id__c=string.valueOf(customerAttributes.get('sigmaerpdev2__Project_Task_Id__c'));
                    projObj.lag__c=string.valueOf(customerAttributes.get('sigmaerpdev2__lag__c'));
                    projObj.linkId__c=string.valueOf(customerAttributes.get('sigmaerpdev2__linkId__c'));
                    projObj.Notes__c=string.valueOf(customerAttributes.get('sigmaerpdev2__Notes__c'));
                    projObj.Resource_Id__c= string.valueOf(customerAttributes.get('sigmaerpdev2__Resource_Id__c'));
                    projObj.source__c= string.valueOf(customerAttributes.get('sigmaerpdev2__source__c'));
                    projObj.priority__c= string.valueOf(customerAttributes.get('sigmaerpdev2__priority__c'));
                    projObj.target__c= string.valueOf(customerAttributes.get('sigmaerpdev2__target__c'));
                    projObj.type__c= string.valueOf(customerAttributes.get('sigmaerpdev2__type__c'));
                    projObj.Project_Type__c= string.valueOf(customerAttributes.get('sigmaerpdev2__Project_Type__c'));
                    projObj.WBS_Code__c= string.valueOf(customerAttributes.get('sigmaerpdev2__WBS_Code__c'));
                    if(customerAttributes.get('sigmaerpdev2__Mark_as_Milestone__c')!=null)
                    	projObj.Mark_as_Milestone__c= boolean.valueOf(customerAttributes.get('sigmaerpdev2__Mark_as_Milestone__c'));
                    projObj.Project_Task_Name__c= string.valueOf(customerAttributes.get('sigmaerpdev2__Project_Task_Name__c'));
                    projObj.Parent__c= string.valueOf(customerAttributes.get('sigmaerpdev2__Parent__c'));
                    projObj.predecessors__c= string.valueOf(customerAttributes.get('sigmaerpdev2__predecessors__c'));
                    projObj.Progress__c= (Decimal)customerAttributes.get('sigmaerpdev2__Progress__c');
                    projObj.Row_Number__c= Integer.valueof(customerAttributes.get('sigmaerpdev2__Row_Number__c'));
                    
                    system.debug('projObj>>>'+projObj);
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
                    system.debug('ActualFinishdate>>'+ActualFinishdate);
                    if(ActualFinishdate!= null && ActualFinishdate!= ''){
                        ActualFinishdateStr = ActualFinishdate.split('T');
                        ActualFinishdate = ActualFinishdateStr[0]+'T00:00:00.000Z';
                        date AdT = date.ValueOf(ActualFinishdate);
                        projObj.Actual_Finish__c = AdT;
                    }else{
                        projObj.Actual_Finish__c = null;
                    }
                    system.debug('isSaveAsTemplate>>'+isSaveAsTemplate);
                    if(isSaveAsTemplate){
                        system.debug('sfdcid'+customerAttributes.get('sfdcid'));
                        projObj.Project__c=(id)customerAttributes.get('sfdcid');
                        insertProjTempLst.add(projObj);
                        system.debug('insertProjTempLst>>'+insertProjTempLst);
                    }else{
                        if(customerAttributes.containsKey('sfdcid'))        //edit
                        {
                            projObj.id=(id)customerAttributes.get('sfdcid');
                            sobjectList.add(projObj);
                            system.debug('sobjectList>>'+sobjectList);
                        }
                        else                                                //insert flow 
                        {
                            system.debug('currenrecordid>>'+currenrecordid);
                            projObj.Project__c =currenrecordid;
                            insertsobjectList.add(projObj);
                            system.debug('insertsobjectList>>'+insertsobjectList);
                        }
                    }
                }
                if(isSaveAsTemplate){
                    insert insertProjTempLst;
                    errwrap.currenttemplateId = insertProjTempLst[0].Project__c;
                    system.debug('insertsobjectList>>'+insertProjTempLst);
                }else{
                    update sobjectList;
                    system.debug('sobjectList>>'+sobjectList);
                    insert insertsobjectList;
                    system.debug('insertsobjectList>'+insertsobjectList);
                    update projectUpdate;
                    system.debug('projectUpdate>'+projectUpdate);
                    delete  taskdelete; 
                    system.debug('taskdelete>'+taskdelete);
                }
                errwrap.isSuccess = true;
                errwrap.ErrorMsg = 'Success';
            }catch(Exception ex){
                errwrap.isSuccess = false;
                errwrap.ErrorMsg = ex.getMessage();
            }
        return errwrap;
    }
    
    global class errorWrapper{
        global boolean isSuccess {get;set;}
        global String ErrorMsg {get;set;}
        global string currenttemplateId{get;set;}
    }
    public String getResourcePath() 
    {
		Default_Parameters__c fetchDHTXML;
        StaticResource resource;
        
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