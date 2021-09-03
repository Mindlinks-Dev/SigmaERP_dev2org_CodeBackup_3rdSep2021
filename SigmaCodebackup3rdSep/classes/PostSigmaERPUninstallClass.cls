global with sharing class PostSigmaERPUninstallClass implements UninstallHandler 
{
   global void onUninstall(UninstallContext ctx)
    {
       // Sending mail to the customer once Uninstalled Successfully 
      /* if(CRUD_FLS_CheckUtility.checkReadPermission('User',new Set<String>{'Id','Name','Email'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Organization',new Set<String>{'Id','Name'}))
           {*/
              
            Id OrgId=ctx.organizationId();
            Id UnInstalledId=ctx.uninstallerID(); 
           
            Organization orgzName;

         orgzName =[select Id,Name from Organization where id=:OrgId];  
        String orgzName1=orgzName.Name;      
        User u;
       
           u = [Select Id,Name,Email from User where Id =:ctx.uninstallerID()]; 
       
        String toAddress= u.Email;
        String nam=u.Name;
 
        String[] toAddresses = new String[] {toAddress};
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('support@sigmaerp365.com');
        mail.setSenderDisplayName('Sigma ERP Support');
        mail.setSubject('Package Uninstalled Successfully');
        mail.setHtmlBody('Hi '+nam+',<br/><br/>Thank you for using Sigma ERP application.' + '<br/>We look forward using our product in future.'+'<br/>For any queries or feedback,write to us at support@sigmaerp365.com<br/><br/>'+'Regards,<br/> Sigma ERP Support<br/>Powered by Mindlinks Solution <br/>Visit us at http://www.mindlinkssolution.com');
        Messaging.sendEmail(new Messaging.Email[] { mail });
        //sending email to the Sales Team once SigmaERP Uninstalled
        String toAddress1= 'sales@sigmaerp365.com';
        String[] toAddresses1 = new String[]{toAddress1};
        Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
        mail1.setToAddresses(toAddresses1);
        mail1.setReplyTo('support@sigmaerp365.com');
        mail1.setSenderDisplayName('Sigma Package UnInstalled');
        mail1.setSubject('Package Uninstalled successfully');
        mail1.setHtmlBody('Package uninstalled by user : '+nam+'<br/>Organization Name is : '+orgzName1+'<br/>Email Id : '+toAddress+'<br/>Organization Id : '+OrgId);
        Messaging.sendEmail(new Messaging.Email[] {mail1});
    //}   
}
        
}