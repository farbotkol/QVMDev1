<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Forklift_Registration_Expiry_Date_Reminder</fullName>
        <description>&apos;Forklift Registration Expiry Date&apos; Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>paul.kadis@qvm.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>info@qvm.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <rules>
        <fullName>%27Forklift QVM Licence Expiry Date%27 Reminder</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Forklift_QVM_Licence_Expiry_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>PE</value>
        </criteriaItems>
        <description>Send Email notification 2 months prior to &apos;Forklift QVM Licence Expiry Date&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.Forklift_QVM_Licence_Expiry_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>%27Forklift Registration Expiry Date%27 Reminder</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Forklift_Registration_Expiry_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>PE</value>
        </criteriaItems>
        <description>Send email notification 2 months prior to &apos;Forklift Registration Expiry Date&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.Forklift_Registration_Expiry_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
