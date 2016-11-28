<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Creator_that_case_has_been_closed</fullName>
        <description>Email Creator that case has been closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>QVM_Email_Templates/CaseClosed</template>
    </alerts>
    <rules>
        <fullName>Case Closed</fullName>
        <actions>
            <name>Email_Creator_that_case_has_been_closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Retrieve Offense Rule Description</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Offense_Rule__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Retrieve the rule description for the chosen offense.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
