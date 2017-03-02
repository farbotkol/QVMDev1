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
    <alerts>
        <fullName>Review_Date_Email_Alert_for_OHS_Cases</fullName>
        <description>&apos;Review Date&apos; Email Alert for OHS Cases</description>
        <protected>false</protected>
        <recipients>
            <recipient>petros.kosonen@qvm.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>QVM_Email_Templates/OHS_Case_Review_Date</template>
    </alerts>
    <rules>
        <fullName>%27Review Date%27 is 3 months away</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Review_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notify Petros Kosonen when &apos;Review Date&apos; in OHS case is 3 months away</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Review_Date_Email_Alert_for_OHS_Cases</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Review_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
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
</Workflow>
