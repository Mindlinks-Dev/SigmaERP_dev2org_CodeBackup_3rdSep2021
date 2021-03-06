<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_to_notify_WO_rejection</fullName>
        <description>Email alert to notify WO rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Order_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Notify_the_technician_that_work_order_has_been_assigned_to_him_her</fullName>
        <description>Notify the technician that work order has been assigned to him/her.</description>
        <protected>false</protected>
        <recipients>
            <field>AssignTo__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Order_AssignedTech</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Manager_to_notify_that_WO_has_been_assigned_to_a_Field_Technician</fullName>
        <description>Send Email to Manager to notify that WO has been assigned to a Field Technician</description>
        <protected>false</protected>
        <recipients>
            <field>FFP_MR_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_Customer_that_Work_Order_has_been_assigned_to_Technician</template>
    </alerts>
    <alerts>
        <fullName>Send_Feedback_Notification_for_customer_after_Work_Order</fullName>
        <description>Send Feedback Notification for customer after Work Order</description>
        <protected>false</protected>
        <recipients>
            <field>FFP_MR_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Response3</template>
    </alerts>
    <alerts>
        <fullName>Service_Completed_mail_to_service_desk</fullName>
        <description>Service Completed mail to service desk</description>
        <protected>false</protected>
        <recipients>
            <field>AssignTo__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Order_Completed</template>
    </alerts>
    <alerts>
        <fullName>Service_Invoiced_notification_to_service_agent</fullName>
        <description>Service Invoiced notification to service agent</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>AssignTo__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Invoice_Alert</template>
    </alerts>
    <alerts>
        <fullName>WorkOrderSurveyNew</fullName>
        <ccEmails>chalukya5246@gmail.com</ccEmails>
        <description>WorkOrderSurveyNew</description>
        <protected>false</protected>
        <recipients>
            <field>FFP_MR_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WorkOrderSurvey</template>
    </alerts>
    <alerts>
        <fullName>WorkOrder_Completed_Notification_to_field_technician</fullName>
        <description>WorkOrder Completed Notification to field technician</description>
        <protected>false</protected>
        <recipients>
            <field>AssignTo__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Order_Completed_For_Field_Technician</template>
    </alerts>
    <fieldUpdates>
        <fullName>Another_Visit_Needed</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Invoiced_to_Customer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Another Visit Needed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangePageLayout_Invoiced</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Invoiced_to_Customer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ChangePageLayout Invoiced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CompletedPageForAndroid</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CompletedForAndroid</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CompletedPageForAndroid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>For_Check_In_Work_Order</fullName>
        <field>RecordTypeId</field>
        <lookupValue>In_Progress</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>For Check-In Work Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Assigned_WO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Update_One</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Accepted_WO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Update_Two</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Completed_WO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Country</fullName>
        <field>Service_Country__c</field>
        <formula>Account__r.ShippingCountry</formula>
        <name>Service Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Field</fullName>
        <field>Email_Field__c</field>
        <formula>Contact_Email__c</formula>
        <name>Update Email Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Local_contact_number</fullName>
        <field>Local_Contact_Number__c</field>
        <formula>Customer_Contact__c</formula>
        <name>Update Local contact number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_City</fullName>
        <field>Service_City__c</field>
        <formula>Account__r.ShippingCity</formula>
        <name>Update Service City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_State</fullName>
        <field>Service_State_Province__c</field>
        <formula>Account__r.ShippingState</formula>
        <name>Update Service State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Street</fullName>
        <field>Shipping_Street__c</field>
        <formula>FFP_MR_Contact__r.MailingStreet</formula>
        <name>Update Service Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Streets</fullName>
        <field>Service_Street__c</field>
        <formula>Account__r.ShippingStreet</formula>
        <name>Update Service Streets</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Zip</fullName>
        <field>Service_Zip_Postal_Code__c</field>
        <formula>Account__r.ShippingPostalCode</formula>
        <name>Update Service Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_local_contact</fullName>
        <field>Local_Contact__c</field>
        <formula>Customer_Contact__c</formula>
        <name>Update local contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Assign Local contact</fullName>
        <actions>
            <name>Update_local_contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Local_Contact__c</field>
            <operation>equals</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign contact</fullName>
        <actions>
            <name>Update_Local_contact_number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Local_Contact_Number__c</field>
            <operation>equals</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Email from ContactEmail</fullName>
        <actions>
            <name>Update_Email_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Contact_Email__c</field>
            <operation>equals</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Work_Order__c.Contact_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>For Accepted WO</fullName>
        <actions>
            <name>Record_Type_Update_One</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>For Assigned WO</fullName>
        <actions>
            <name>Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Assigned</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>For Assigned WorkOrder</fullName>
        <actions>
            <name>Send_Email_to_Manager_to_notify_that_WO_has_been_assigned_to_a_Field_Technician</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Assigned</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>For Assigned WorkOrder_Notify_Technician</fullName>
        <actions>
            <name>Notify_the_technician_that_work_order_has_been_assigned_to_him_her</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Assigned</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>For Check-In Work Order</fullName>
        <actions>
            <name>For_Check_In_Work_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(PRIORVALUE(Status__c),&apos;Accepted&apos;) &amp;&amp; ISPICKVAL(Status__c, &apos;In Progress&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>For New WO</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>For Rejected Work Order</fullName>
        <actions>
            <name>Email_alert_to_notify_WO_rejection</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Generate Invoice WO</fullName>
        <actions>
            <name>Record_Type_Update_Two</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Work_Order__c.NonAndroidDevicesCheck__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Generate Invoice WO_Android</fullName>
        <actions>
            <name>CompletedPageForAndroid</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Hide Signature%26SendToCustomer Button</fullName>
        <actions>
            <name>ChangePageLayout_Invoiced</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Invoiced to Customer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Completed notification to field Technician</fullName>
        <actions>
            <name>WorkOrder_Completed_Notification_to_field_technician</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Completed notification to service agent</fullName>
        <actions>
            <name>Service_Completed_mail_to_service_desk</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Country</fullName>
        <actions>
            <name>Service_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Service_Country__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service Invoiced notification to service agent</fullName>
        <actions>
            <name>Service_Invoiced_notification_to_service_agent</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Invoiced to Customer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service State%2FProvince</fullName>
        <actions>
            <name>Update_Service_State</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Service_State_Province__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service Street</fullName>
        <actions>
            <name>Update_Service_Streets</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Service_Street__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service Zip</fullName>
        <actions>
            <name>Update_Service_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Shipping_Zip_Postal_Code__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service city</fullName>
        <actions>
            <name>Update_Service_City</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Service_City__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Survey FeedBack For Work Order</fullName>
        <actions>
            <name>Send_Feedback_Notification_for_customer_after_Work_Order</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WorkOrderSurvey</fullName>
        <actions>
            <name>WorkOrderSurveyNew</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
