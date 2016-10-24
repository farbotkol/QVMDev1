<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateContactMobile2</fullName>
        <field>MobilePhone</field>
        <formula>&apos;61&apos; + MID(MobilePhone, 2, 100)</formula>
        <name>UpdateContactMobile2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Mobile_Format</fullName>
        <field>MobilePhone</field>
        <formula>SUBSTITUTE(MobilePhone, &apos;+&apos;, &apos;&apos;)</formula>
        <name>Update Contact Mobile Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Contact Mobile Format2</fullName>
        <actions>
            <name>UpdateContactMobile2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.MobilePhone</field>
            <operation>startsWith</operation>
            <value>04</value>
        </criteriaItems>
        <description>Updates mobile phone from 0409947864 to 61409947864 for SMS Magic</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Contact Mobile Phone Format</fullName>
        <actions>
            <name>Update_Contact_Mobile_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.MobilePhone</field>
            <operation>startsWith</operation>
            <value>+61</value>
        </criteriaItems>
        <description>Updates the Contact mobile format to be SMS Magic compliant format from +61409947864 to 61409947864</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
