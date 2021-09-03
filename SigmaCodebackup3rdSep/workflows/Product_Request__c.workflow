<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_on_Product_Request_submission</fullName>
        <description>Email Notification on Product Request submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>sigmadev2020@mindlinks.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Product_Request_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Technician_when_Product_Request_is_Approved</fullName>
        <description>Email alert to Technician when Product Request is Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approved_Product_Request_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Technician_when_Product_Request_is_Rejected</fullName>
        <description>Email alert to Technician when Product Request is Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Rejected_Product_Request_Email</template>
    </alerts>
    <rules>
        <fullName>Email Alert to Technician when Product Request is Approved</fullName>
        <actions>
            <name>Email_alert_to_Technician_when_Product_Request_is_Approved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Product_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Alert to Technician when Product Request is Rejected</fullName>
        <actions>
            <name>Email_alert_to_Technician_when_Product_Request_is_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Product_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Alert to Warehouse Manager when Product Request is Submitted</fullName>
        <actions>
            <name>Email_Notification_on_Product_Request_submission</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Product_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
