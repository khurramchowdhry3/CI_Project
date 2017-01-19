<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Unallocated_Web_Leads_HK</fullName>
        <description>Notify Unallocated Web Leads (HK)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Unallocated_Lead_Group_Hong_Kong</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Unqualified_Web_Leads</template>
    </alerts>
    <alerts>
        <fullName>Notify_Unallocated_Web_Leads_PP</fullName>
        <description>Notify Unallocated Web Leads (PP)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Unallocated_Lead_Group_Philippines</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Unqualified_Web_Leads</template>
    </alerts>
    <alerts>
        <fullName>Notify_Unallocated_Web_Leads_SG</fullName>
        <description>Notify Unallocated Web Leads (SG)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Unallocated_Lead_Group_Singapore</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Unqualified_Web_Leads</template>
    </alerts>
    <alerts>
        <fullName>Notify_Unallocated_Web_Leads_UK</fullName>
        <description>Notify Unallocated Web Leads (UK)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Unallocated_Lead_Group_UK</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Unqualified_Web_Leads</template>
    </alerts>
    <fieldUpdates>
        <fullName>Accept_Credit_Card</fullName>
        <field>Accepts_Credit_Cards__c</field>
        <literalValue>1</literalValue>
        <name>Accept Credit Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Nature</fullName>
        <field>Business_Nature__c</field>
        <literalValue>1</literalValue>
        <name>Business Nature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Registered_in_HK</fullName>
        <field>Business_Registered_in_Hong_Kong__c</field>
        <literalValue>1</literalValue>
        <name>Business Registered in HK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Registered_in_PP</fullName>
        <field>Business_Registered_in_Philippines__c</field>
        <literalValue>1</literalValue>
        <name>Business Registered in PP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Registered_in_SG</fullName>
        <field>Business_Registered_in_Singapore__c</field>
        <literalValue>1</literalValue>
        <name>Business Registered in SG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_in_Operation_in_3_months</fullName>
        <field>Business_in_Operation_Minimum_3_months__c</field>
        <literalValue>1</literalValue>
        <name>Business in Operation in 3 months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_in_Operation_in_6_months</fullName>
        <field>Business_in_Operation_Minimum_6_months__c</field>
        <literalValue>1</literalValue>
        <name>Business in Operation in 6 months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Country_Hong_Kong</fullName>
        <description>Lead Country Hong Kong</description>
        <field>Country__c</field>
        <literalValue>Hong Kong</literalValue>
        <name>Lead Country Hong Kong</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Country_Philippines</fullName>
        <field>Country__c</field>
        <literalValue>Philippines</literalValue>
        <name>Lead Country Philippines</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Country_Singapore</fullName>
        <description>Lead Country Singapore</description>
        <field>Country__c</field>
        <literalValue>Singapore</literalValue>
        <name>Lead Country Singapore</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Country_UK</fullName>
        <field>Country__c</field>
        <literalValue>UK</literalValue>
        <name>Lead Country UK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_LE_Country_Hong_Kong</fullName>
        <field>LE_Country__c</field>
        <literalValue>Hong Kong</literalValue>
        <name>Lead LE Country Hong Kong</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_LE_Country_Philippines</fullName>
        <field>LE_Country__c</field>
        <literalValue>Philippines</literalValue>
        <name>Lead LE Country Philippines</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_LE_Country_Singapore</fullName>
        <field>LE_Country__c</field>
        <literalValue>Singapore</literalValue>
        <name>Lead LE Country Singapore</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_LE_Country_UK</fullName>
        <field>LE_Country__c</field>
        <literalValue>England</literalValue>
        <name>Lead LE Country UK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Ownership_to_HK_Hunters_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>New_Business_Team_Pickup_Hong_Kong</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Ownership to HK Hunters Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Ownership_to_PP_Hunters_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>New_Business_Team_Pickup_Philippines</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Ownership to PP Hunters Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Ownership_to_SG_Hunters_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>New_Business_Team_Pickup_Singapore</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Ownership to SG Hunters Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Ownership_to_UK_Hunters_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>New_Business_Team_Pickup_UK</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Ownership to UK Hunters Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TA_Country_Hong_Kong</fullName>
        <field>TA_Country__c</field>
        <literalValue>Hong Kong</literalValue>
        <name>Lead TA Country Hong Kong</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TA_Country_Philippines</fullName>
        <field>TA_Country__c</field>
        <literalValue>Philippines</literalValue>
        <name>Lead TA Country Philippines</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TA_Country_Singapore</fullName>
        <field>TA_Country__c</field>
        <literalValue>Singapore</literalValue>
        <name>Lead TA Country Singapore</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TA_Country_UK</fullName>
        <field>TA_Country__c</field>
        <literalValue>England</literalValue>
        <name>Lead TA Country UK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualified_Hong_Kong_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Qualified_Hong_Kong</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Qualified Hong Kong RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualified_Philippines_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Qualified_Philippines</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Qualified Philippines RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualified_Singapore_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Qualified_Singapore</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Qualified Singapore RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualified_UK_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Qualified_UK</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Qualified UK RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Business_Registered_UK</fullName>
        <field>Business_Registered_in_UK__c</field>
        <literalValue>1</literalValue>
        <name>Set Business Registered in UK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Qualified</fullName>
        <field>Status</field>
        <literalValue>Qualified</literalValue>
        <name>Set Lead Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Ownership_to_Unallocated_Leads_HK</fullName>
        <field>OwnerId</field>
        <lookupValue>Unallocated_Web_Leads_Hong_Kong</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Ownership to Unallocated Leads (HK)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Ownership_to_Unallocated_Leads_PHP</fullName>
        <field>OwnerId</field>
        <lookupValue>Unallocated_Web_Leads_Philippines</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Ownership to Unallocated Leads (PHP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Ownership_to_Unallocated_Leads_SG</fullName>
        <field>OwnerId</field>
        <lookupValue>Unallocated_Web_Leads_Singapore</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Ownership to Unallocated Leads (SG)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Ownership_to_Unallocated_Leads_UK</fullName>
        <field>OwnerId</field>
        <lookupValue>Unallocated_Web_Leads_UK</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Ownership to Unallocated Leads (UK)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Building_Lead</fullName>
        <field>TA_Building_Name__c</field>
        <formula>LE_Building_Name__c</formula>
        <name>Sync Address Building [Lead]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Floor_Lead</fullName>
        <field>TA_Floor_No__c</field>
        <formula>LE_Floor_No__c</formula>
        <name>Sync Address Floor [Lead]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Line_2_Lead</fullName>
        <field>TA_Address_Line_2__c</field>
        <formula>LE_Address_Line_2__c</formula>
        <name>Sync Address Line 2 [Lead]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Line_3_Lead</fullName>
        <field>TA_Address_Line_3__c</field>
        <formula>LE_Address_Line_3__c</formula>
        <name>Sync Address Line 3 [Lead]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Postcode_Lead</fullName>
        <field>TA_Postcode__c</field>
        <formula>LE_Postcode__c</formula>
        <name>Sync Address Postcode [Lead]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Street_Name_Lead</fullName>
        <field>TA_Street_Name__c</field>
        <formula>LE_Street_Name__c</formula>
        <name>Sync Address Street Name [Lead]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Street_No_Lead</fullName>
        <field>TA_Street_Number__c</field>
        <formula>LE_Street_Number__c</formula>
        <name>Sync Address Street No. [Lead]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unqualified_HK_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Hong_Kong</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Unqualified HK RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unqualified_Philippines_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Philippines</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Unqualified Philippines RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unqualified_Singapore_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Singapore</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Unqualified Singapore RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unqualified_UK_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>UK</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Unqualified UK RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unqualified_UK_RecordType_Lead</fullName>
        <field>RecordTypeId</field>
        <lookupValue>UK</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Unqualified UK RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>%5BWF 03%5D Set Lead Country Hong Kong</fullName>
        <actions>
            <name>Lead_Country_Hong_Kong</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_LE_Country_Hong_Kong</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TA_Country_Hong_Kong</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>contains</operation>
            <value>Hong Kong</value>
        </criteriaItems>
        <description>Set Lead Country as Hong Kong</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 04%5D Set Lead Country Singapore</fullName>
        <actions>
            <name>Lead_Country_Singapore</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_LE_Country_Singapore</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TA_Country_Singapore</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>contains</operation>
            <value>Singapore</value>
        </criteriaItems>
        <description>Set Lead Country as Singapore</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 05%5D Set Lead Country Philippines</fullName>
        <actions>
            <name>Lead_Country_Philippines</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_LE_Country_Philippines</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TA_Country_Philippines</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>contains</operation>
            <value>Philippines</value>
        </criteriaItems>
        <description>Set Lead Country as Philippines</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 06%5D Set Lead Country UK</fullName>
        <actions>
            <name>Lead_Country_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_LE_Country_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TA_Country_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>contains</operation>
            <value>UK</value>
        </criteriaItems>
        <description>Set Lead Country as UK</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 07%5D Qualified Hong Kong Lead</fullName>
        <actions>
            <name>Qualified_Hong_Kong_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Qualified Hong Kong Lead</description>
        <formula>IF(CONTAINS(RecType_Name__c,&apos;Kong&apos;) &amp;&amp; Accepts_Credit_Cards__c &amp;&amp; Business_Nature__c &amp;&amp; Business_Registered_in_Hong_Kong__c &amp;&amp; Business_in_Operation_Minimum_3_months__c ,true,false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 08%5D Qualified Singapore Lead</fullName>
        <actions>
            <name>Qualified_Singapore_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Qualified Singapore Lead</description>
        <formula>IF(CONTAINS(RecType_Name__c,&apos;Singapore&apos;) &amp;&amp; Accepts_Credit_Cards__c &amp;&amp; Business_Nature__c &amp;&amp; Business_Registered_in_Singapore__c &amp;&amp; Business_in_Operation_Minimum_3_months__c,true,false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 09%5D Qualified Philippines Lead</fullName>
        <actions>
            <name>Qualified_Philippines_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Qualified Philippines Lead</description>
        <formula>IF(CONTAINS(RecType_Name__c,&apos;Philippines&apos;) &amp;&amp; Accepts_Credit_Cards__c &amp;&amp; Business_Nature__c &amp;&amp;  Business_Registered_in_Philippines__c  &amp;&amp;  Business_in_Operation_Minimum_3_months__c  ,true,false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 10%5D Qualified UK Lead</fullName>
        <actions>
            <name>Qualified_UK_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Qualified UK Lead</description>
        <formula>IF(CONTAINS(RecType_Name__c,&apos;UK&apos;) &amp;&amp; Accepts_Credit_Cards__c &amp;&amp; Business_Nature__c &amp;&amp; Business_Registered_in_UK__c &amp;&amp; Business_in_Operation_Minimum_6_months__c ,true,false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 11%5D Assign Qualified HK Lead to New Business Team Pickup</fullName>
        <actions>
            <name>Accept_Credit_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_Nature</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_Registered_in_HK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_in_Operation_in_3_months</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Ownership_to_HK_Hunters_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hong Kong Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>Partner,AMP Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Convert_Lead__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Assign Qualified HK Lead to New Business Team Pickup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 12%5D Assign Qualified SG Lead to New Business Team Pickup</fullName>
        <actions>
            <name>Accept_Credit_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_Nature</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_Registered_in_SG</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_in_Operation_in_3_months</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Ownership_to_SG_Hunters_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Singapore Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>Partner,AMP Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Convert_Lead__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Assign Qualified SG Lead to New Business Team Pickup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 13%5D Assign Qualified PP Lead to New Business Team Pickup</fullName>
        <actions>
            <name>Accept_Credit_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_Nature</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_Registered_in_PP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_in_Operation_in_3_months</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Ownership_to_PP_Hunters_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Philippines Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>Partner,AMP Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Convert_Lead__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Assign Qualified PP Lead to New Business Team Pickup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 14%5D Assign Qualified UK Lead to New Business Team Pickup</fullName>
        <actions>
            <name>Accept_Credit_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_Nature</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_in_Operation_in_6_months</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Ownership_to_UK_Hunters_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Business_Registered_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>UK Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>Partner,AMP Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Convert_Lead__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Assign Qualified UK Lead to New Business Team Pickup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 15%5D Sync LE and TA Address %5BLead%5D</fullName>
        <actions>
            <name>Sync_Address_Building_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Floor_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Line_2_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Line_3_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Postcode_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Street_Name_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Street_No_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Trading_Address_if_different__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sync LE and TA Address [Lead]</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 16%5D Set Unqualified Hong Kong Lead</fullName>
        <actions>
            <name>Set_Ownership_to_Unallocated_Leads_HK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unqualified_HK_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CurrencyIsoCode</field>
            <operation>equals</operation>
            <value>HKD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hong Kong</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Not Interested,Not Qualified,Not Interested – Opt Out</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 17%5D Set Unqualified Singapore Lead</fullName>
        <actions>
            <name>Set_Ownership_to_Unallocated_Leads_SG</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unqualified_Singapore_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CurrencyIsoCode</field>
            <operation>equals</operation>
            <value>SGD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Singapore</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Not Interested,Not Qualified,Not Interested – Opt Out</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 18%5D Set Unqualified Philippines Lead</fullName>
        <actions>
            <name>Set_Ownership_to_Unallocated_Leads_PHP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unqualified_Philippines_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CurrencyIsoCode</field>
            <operation>equals</operation>
            <value>PHP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>UK,Philippines</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Not Interested,Not Qualified,Not Interested – Opt Out</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 19%5D Set Unqualified UK Lead</fullName>
        <actions>
            <name>Set_Ownership_to_Unallocated_Leads_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unqualified_UK_RecordType_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CurrencyIsoCode</field>
            <operation>equals</operation>
            <value>GBP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>UK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Not Interested,Not Qualified,Not Interested – Opt Out</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 20%5D Unqualified Web Leads UK</fullName>
        <actions>
            <name>Notify_Unallocated_Web_Leads_UK</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>DWH Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>UK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Not Interested,Not Qualified,Not Interested – Opt Out,Unable To Contact – No number</value>
        </criteriaItems>
        <description>Notify Unallocated Web Leads (UK) Queue Users about newly created lead from web platform.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 21%5D Unqualified Web Leads HK</fullName>
        <actions>
            <name>Notify_Unallocated_Web_Leads_HK</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>DWH Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hong Kong</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Not Interested,Not Qualified,Not Interested – Opt Out,Unable To Contact – No number</value>
        </criteriaItems>
        <description>Notify Unallocated Web Leads (HK) Queue Users about newly created lead from web platform.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 22%5D Unqualified Web Leads SG</fullName>
        <actions>
            <name>Notify_Unallocated_Web_Leads_SG</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>DWH Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Singapore</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Not Interested,Not Qualified,Not Interested – Opt Out,Unable To Contact – No number</value>
        </criteriaItems>
        <description>Notify Unallocated Web Leads (SG) Queue Users about newly created lead from web platform.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 23%5D Unqualified Web Leads PP</fullName>
        <actions>
            <name>Notify_Unallocated_Web_Leads_PP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>DWH Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Philippines</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Not Interested,Not Qualified,Not Interested – Opt Out,Unable To Contact – No number</value>
        </criteriaItems>
        <description>Notify Unallocated Web Leads (PP) Queue Users about newly created lead from web platform.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Program Populate from Campaign</fullName>
        <active>false</active>
        <formula>IF( ISBLANK(Campaign.Program__c) , false, true)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
