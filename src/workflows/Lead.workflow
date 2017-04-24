<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Event_Lead_Auto_Response</fullName>
        <description>Event Lead - Auto Response</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@qvm.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>QVM_Email_Templates/Event_Lead_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Event_Lead_With_Campaign_Auto_Response</fullName>
        <description>Event Lead With Campaign - Auto Response</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@qvm.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>QVM_Email_Templates/Event_Lead_With_Campaign_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Property_Lead_Auto_Response</fullName>
        <description>Property Lead - Auto Response</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@qvm.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>QVM_Email_Templates/Property_Lead_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>QVM_Property_Management_Application_Rejected</fullName>
        <description>QVM Property Management Application Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Reference1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Reference2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Nominated_Event_Organiser_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@qvm.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>QVM_Email_Templates/QVM_Events_Management_Application_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>MobileUpdateNumber</fullName>
        <field>MobilePhone</field>
        <formula>&apos;61&apos; + MID(MobilePhone, 2, 100)</formula>
        <name>MobileUpdateNumber</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMobileFormat</fullName>
        <field>MobilePhone</field>
        <formula>SUBSTITUTE(MobilePhone, &apos;+&apos;, &apos;&apos;)</formula>
        <name>Update Mobile Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>QVM Event Management Application Rejected</fullName>
        <actions>
            <name>QVM_Property_Management_Application_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Unsuccessful</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>QVM Events</value>
        </criteriaItems>
        <description>If Lead Record Type = &apos;QVM Events&apos; and Lead Status = &apos;Unsuccessful&apos;, send an email to a lead notifying that their EOI application was unsuccessful.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>QVM Property Management Application Rejected</fullName>
        <actions>
            <name>QVM_Property_Management_Application_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>QVM Property Management</value>
        </criteriaItems>
        <description>If Lead Record Type = &apos;QVM Property Management&apos; and Lead Status = &apos;Reject&apos;, send an email to a lead notifying that their EOI application was unsuccessful.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Mobile Format</fullName>
        <actions>
            <name>UpdateMobileFormat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Lead.MobilePhone</field>
            <operation>startsWith</operation>
            <value>+61</value>
        </criteriaItems>
        <description>Updates the Lead mobile format to be SMS Magic compliant format from +61409947864 to 61409947864</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Mobile Format2</fullName>
        <actions>
            <name>MobileUpdateNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.MobilePhone</field>
            <operation>startsWith</operation>
            <value>04</value>
        </criteriaItems>
        <description>Updates Lead mobile phone from 0409947864 to 61409947864 for SMS Magic</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
