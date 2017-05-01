<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_AP</fullName>
        <description>Email AP</description>
        <protected>false</protected>
        <recipients>
            <recipient>athena.haikalis@qvm.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>info@qvm.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>QVM_Email_Templates/Notify_AP_Of_New_Supplier</template>
    </alerts>
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
    <fieldUpdates>
        <fullName>UpdateAccountMobile2</fullName>
        <field>Mobile_Phone__c</field>
        <formula>&apos;61&apos; + MID(Mobile_Phone__c, 2, 100)</formula>
        <name>UpdateAccountMobile2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Mobile_Format</fullName>
        <field>Mobile_Phone__c</field>
        <formula>SUBSTITUTE(Mobile_Phone__c, &apos;+&apos;, &apos;&apos;)</formula>
        <name>Update Account Mobile Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Supplier_name_with_Prefix</fullName>
        <field>Name</field>
        <formula>Name + &quot; (Supplier)&quot;</formula>
        <name>Update Supplier name with Prefix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_non_valid_ABNs_for_BQO</fullName>
        <description>Updates ABNs that do not conform to valid ABNs in QBO To 00000000000</description>
        <field>ABN__c</field>
        <formula>&quot;00000000000&quot;</formula>
        <name>Update non valid ABNs for BQO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ABN NA To 000</fullName>
        <actions>
            <name>Update_non_valid_ABNs_for_BQO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 or 3 or 4</booleanFilter>
        <criteriaItems>
            <field>Account.ABN__c</field>
            <operation>contains</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ABN__c</field>
            <operation>contains</operation>
            <value>N/A</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ABN__c</field>
            <operation>contains</operation>
            <value>na</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ABN__c</field>
            <operation>contains</operation>
            <value>n/a</value>
        </criteriaItems>
        <description>Updates not numeric ABNs to 00000000000</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Suppliers Rename with postfix</fullName>
        <actions>
            <name>Update_Supplier_name_with_Prefix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Supplier</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notContain</operation>
            <value>(Supplier)</value>
        </criteriaItems>
        <description>Add &quot;(Supplier)&quot; Post fix to the name of all supplier accounts</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Mobile Format</fullName>
        <actions>
            <name>Update_Account_Mobile_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Mobile_Phone__c</field>
            <operation>startsWith</operation>
            <value>+61</value>
        </criteriaItems>
        <description>Updates the Account mobile format to be SMS Magic compliant format from +61409947864 to 61409947864</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Mobile Format2</fullName>
        <actions>
            <name>UpdateAccountMobile2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Mobile_Phone__c</field>
            <operation>startsWith</operation>
            <value>04</value>
        </criteriaItems>
        <description>Updates the Account mobile phone from 0409947864 to 61409947864 for SMS Magic</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
