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
        <fullName>Update Mobile Format</fullName>
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
        <description>Updates the mobile format to be SMS Magic compliant format from +61409947864 to 61409947864</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateMobileFormat2</fullName>
        <actions>
            <name>MobileUpdateNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.MobilePhone</field>
            <operation>startsWith</operation>
            <value>0</value>
        </criteriaItems>
        <description>Updates mobile phone from 0409947864 to 61409947864 for SMS Magic</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
