<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Supplier_Upon_Approval</fullName>
        <description>Email Supplier Upon Approval</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>QVM_Email_Templates/Supplier_Approved_Notice</template>
    </alerts>
    <alerts>
        <fullName>Email_Supplier_Upon_Rejection</fullName>
        <description>Email Supplier Upon Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_Suppliers_Upon_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Lock_Supplier_Approved</fullName>
        <field>Supplier_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Lock Supplier Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
