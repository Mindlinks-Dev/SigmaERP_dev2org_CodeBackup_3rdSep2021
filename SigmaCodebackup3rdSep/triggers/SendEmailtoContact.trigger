trigger SendEmailtoContact on Account (before update, after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Set<Id> setAccountIds = new Set<Id>();
        List<String> sendTo = new List<String>();
        List<String> conId = new List<String>();
        List<Contact> con = new List<Contact>();
        for(Account acc : trigger.New){
            if(acc.Industry == 'Healthcare')
            {
                setAccountIds.add(acc.Id);
                System.debug('setAccountIds::' + setAccountIds);
            }
        }
        
        if(!setAccountIds.isEmpty()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'markantony@gmail.com'];
            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
                mail1.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            System.debug('owea'+owea);
            
            for(Contact c : [SELECT lastname,email  FROM Contact WHERE AccountId IN:setAccountIds]){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String> {c.Id});
                mail1.setOrgWideEmailAddressId(owea.get(0).Id);
                mail.setSubject('Test Subject');
                String body='<html>'+
                    '<body style="font-family: sans-serif;color:#434245;font-size:110%;background:black;margin:0;padding:0;color:black;">'+
                    '<div class="content" style="padding: 1% 0%;">'+
                    '<div class="grid" style="display:flex;margin: 5%;">'+
                    '<div class="col col-1" style="background:white;padding:2%;width:30%;">'+
                    '<img src="https://sigma-mvp-dev2-dev-ed--c.documentforce.com/servlet/servlet.ImageServer?id=0152x0000001E2W&oid=00D2x000003sFlp&lastMod=1595414839000" style="width:200px;"/>'+
                    '</div>'+
                    '<div class="col col-2" style="background:#ffd930;text-align:center;padding: 4%;">'+
                    '<h3>If you have a moment to spare, would you be willing to answer a few questions? </h3>'+
                    '<h3>We would greatly appreciate your feedback.</h3>'+
                    '<br/>'+
                    '<a style="border: 1px solid #dddbda;transition: border .15s linear;background-color: black;color:white;border-color: black;padding:10px 40px;border-radius:20px;color:white;text-decoration:none;margin:0 auto;font-weight:bold;" href="https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/Survey/TakeSurvey?id=a2J2x0000008rFYEAY&cId='+c.Id+'&caId=none" class="survery-btn">Take the Survey</a>'+
                    '</div>'+
                    '</div>'+
                    '</div>'+
                    '</body>'+
                    '</html>'; 
                
                //String body = '<a href="https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/Survey/TakeSurvey?id=a2J2x0000008rFYEAY&cId='+c.Id+'&caId=none">Open Survey</a>';
                System.debug('body>>>'+body);
                mail.setHtmlBody(body);          
                // mail.setPlainTextBody('Test Mail');
                mails.add(mail);
            }
            try{
                
                if(mails.size() > 0) {
                    Messaging.sendEmail(mails);
                }                     
            }
            catch(Exception e){
                System.debug('-----Exception------' +e);        
            }
            
        }
    }
    
}