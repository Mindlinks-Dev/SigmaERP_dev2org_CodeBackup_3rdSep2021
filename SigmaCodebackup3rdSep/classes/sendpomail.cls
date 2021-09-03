public with sharing class  sendpomail
{
Public Static String poid{get;set;}
Public Static id povalue{get;set;}
public sendpomail(ApexPages.StandardController controller)
{
// povalue = ApexPages.currentPage().getParameters().get('id');
}

public PageReference getpoid()
{
 povalue = ApexPages.currentPage().getParameters().get('id');
poid=String.Valueof(povalue);
System.debug('poid>>>>>>>>>>'+poid);
 GeneratePOSlipCntrl.sendPOInvoiceMail(poid);
 PageReference pageRef = new PageReference('/' +povalue );
 return pageRef;
 
 }
}