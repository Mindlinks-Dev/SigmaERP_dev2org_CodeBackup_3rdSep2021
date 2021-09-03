<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateSourceField</fullName>
        <field>Source__c</field>
        <literalValue>Shipment</literalValue>
        <name>UpdateSourceField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>UpdateSourceFieldInSurveyInvitationObject</fullName>
        <actions>
            <name>UpdateSourceField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SurveyInvitation.SurveyId</field>
            <operation>equals</operation>
            <value>CustomerResponseSurvey</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
