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
</Workflow>
