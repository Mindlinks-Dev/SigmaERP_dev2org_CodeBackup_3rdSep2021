<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Feedback_Notification_for_customer_after_Shipment</fullName>
        <description>Send Feedback Notification  for customer after Shipment</description>
        <protected>false</protected>
        <recipients>
            <field>Delivery_Person__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Survey_Email_Template_For_After_shipment_Response3</template>
    </alerts>
    <rules>
        <fullName>Survey For After Shipment</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Shipment__c.Status__c</field>
            <operation>equals</operation>
            <value>Delivered</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
