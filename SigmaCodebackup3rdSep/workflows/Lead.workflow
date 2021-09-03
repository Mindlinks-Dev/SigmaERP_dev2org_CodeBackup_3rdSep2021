<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Brewery_Request_For_Demo_to_FFTB_Admin</fullName>
        <ccEmails>mindlinkscloud@gmail.com</ccEmails>
        <description>Brewery Request For Demo to FFTB Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Brewery_Request_For_Demo_to_FFTB_Admin</template>
    </alerts>
    <rules>
        <fullName>New Lead Notification For Fftb Admin</fullName>
        <actions>
            <name>Brewery_Request_For_Demo_to_FFTB_Admin</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Title</field>
            <operation>equals</operation>
            <value>Request demo</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
