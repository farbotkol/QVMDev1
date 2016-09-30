<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PO_Approval_Email</fullName>
        <description>PO Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>QVM_Email_Templates/PO_Approved</template>
    </alerts>
    <alerts>
        <fullName>PO_Rejected_Email</fullName>
        <description>PO Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>QVM_Email_Templates/PO_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approve_PO</fullName>
        <field>PO_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Approve PO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
