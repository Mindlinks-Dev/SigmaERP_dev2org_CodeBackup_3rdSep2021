<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Brewery_Payment_Notifications_to_Brewery</fullName>
        <ccEmails>raghavendrahgr@gmail.com</ccEmails>
        <description>Brewery Payment Notifications to Brewery</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Brewery_Payment_Notifications_to_Brewery</template>
    </alerts>
    <alerts>
        <fullName>Brewery_Payment_Notifications_to_FFTB_Admin</fullName>
        <ccEmails>raghavendrahgr@gmail.com</ccEmails>
        <description>Brewery Payment Notifications to FFTB Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Brewery_Payment_Notifications_to_FFTB_Admin</template>
    </alerts>
    <alerts>
        <fullName>Brewery_Registration_Notifications_to_Brewery</fullName>
        <ccEmails>mindlinkscloud@gmail.com</ccEmails>
        <description>Brewery Registration Notifications to Brewery</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Brewery_Registration_Notifications_to_Brewery</template>
    </alerts>
    <alerts>
        <fullName>Brewery_Registration_Notifications_to_FFTB_Admin</fullName>
        <ccEmails>mindlinkscloud@gmail.com</ccEmails>
        <description>Brewery Registration Notifications to FFTB Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Brewery_Registration_Notifications_to_FFTB_Admin</template>
    </alerts>
</Workflow>
