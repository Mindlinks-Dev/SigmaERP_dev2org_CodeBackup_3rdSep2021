<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Feedback_Notification_for_customer</fullName>
        <description>Send Feedback Notification  for customer</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Survey_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Feedback_Notification_for_customer_after_Shipment</fullName>
        <description>Send Feedback Notification for customer after Shipment</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Person__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Survey_Email_Template_For_After_shipment_Response3</template>
    </alerts>
    <alerts>
        <fullName>To_Send_Survey_for_Shipment</fullName>
        <description>To Send Survey for Shipment</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Person__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Survey_Email_Template_For_After_shipment_Response3</template>
    </alerts>
    <rules>
        <fullName>Survey FeedBack</fullName>
        <actions>
            <name>Send_Feedback_Notification_for_customer_after_Shipment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(

	TEXT(Status__c) =&apos;Delivered&apos;,
				TEXT(Shipment__r.Status__c) =&apos;Delivered&apos;,
				NOT ( ISBLANK ( Contact_Person__r.Id ) ),
 				NOT ( ISBLANK ( Contact_Person__r.Email  ) )
		 		 
  				
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
