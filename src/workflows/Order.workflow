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
    <fieldUpdates>
        <fullName>Approved_Upto_0</fullName>
        <field>Approved_UpTo__c</field>
        <formula>0</formula>
        <name>Approved Upto 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Upto_10000000</fullName>
        <field>Approved_UpTo__c</field>
        <formula>10000000</formula>
        <name>Approved Upto 10000000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Upto_25000</fullName>
        <field>Approved_UpTo__c</field>
        <formula>25000</formula>
        <name>Approved Upto 25000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Upto_5000</fullName>
        <field>Approved_UpTo__c</field>
        <formula>5000</formula>
        <name>Approved Upto 5000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Upto_50000</fullName>
        <field>Approved_UpTo__c</field>
        <formula>50000</formula>
        <name>Approved Upto 50000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Value</fullName>
        <field>Approved_Value__c</field>
        <formula>TotalAmount</formula>
        <name>Update Approved Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Value_to_10000</fullName>
        <field>Approved_UpTo__c</field>
        <formula>10000</formula>
        <name>Update Approved Value to 10000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Order_Owner_to_Finance</fullName>
        <field>OwnerId</field>
        <lookupValue>luke.farbotko@qvmtest.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Order Owner to Finance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Confirmed For Invoicing</fullName>
        <actions>
            <name>Update_Order_Owner_to_Finance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.Status</field>
            <operation>equals</operation>
            <value>Confirmed for Invoicing</value>
        </criteriaItems>
        <description>Once an order has been confirmed its then sent off to finance to process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
