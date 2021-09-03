<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Appointment_Booking_email_to_admin</fullName>
        <description>Appointment Booking email to admin</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Appointment_Booking_email_to_admin</template>
    </alerts>
    <alerts>
        <fullName>Appointment_booking</fullName>
        <description>Appointment booking email to customer</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Appointment_booking_email</template>
    </alerts>
</Workflow>
