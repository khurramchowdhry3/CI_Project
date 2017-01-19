<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HK_Record_Type_on_Account</fullName>
        <description>Account Updated with HK Record Type.</description>
        <field>RecordTypeId</field>
        <lookupValue>Prospect_Hong_Kong</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>HK Record Type on Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HK_Record_Type_on_Person_Account</fullName>
        <description>Person Account Updated with HK Record Type.</description>
        <field>RecordTypeId</field>
        <lookupValue>Person_Hong_Kong</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>HK Record Type on Person Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PP_Record_Type_on_Account</fullName>
        <description>Account Record Type is Updated to PP.</description>
        <field>RecordTypeId</field>
        <lookupValue>Prospect_Philippines</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PP Record Type on Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PP_Record_Type_on_Person_Account</fullName>
        <description>Person Account Record Type is Updated to PP.</description>
        <field>RecordTypeId</field>
        <lookupValue>Person_Philippines</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PP Record Type on Person Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SG_Record_Type_on_Account</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Prospect_Singapore</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SG Record Type on Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SG_Record_Type_on_Person_Account</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Person_Singapore</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SG Record Type on Person Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_WF_Triggered</fullName>
        <field>isWFtriggered__c</field>
        <literalValue>1</literalValue>
        <name>Set Account WF Triggered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Building_Account</fullName>
        <field>TA_Building_Name__c</field>
        <formula>LE_Building_Name__c</formula>
        <name>Sync Address Building [Account]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Floor_Account</fullName>
        <field>TA_Floor_No__c</field>
        <formula>LE_Floor_No__c</formula>
        <name>Sync Address Floor [Account]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Line_2_Account</fullName>
        <field>TA_Address_Line_2__c</field>
        <formula>LE_Address_Line_2__c</formula>
        <name>Sync Address Line 2 [Account]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Line_3_Account</fullName>
        <field>TA_Address_Line_3__c</field>
        <formula>LE_Address_Line_3__c</formula>
        <name>Sync Address Line 3 [Account]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Postcode_Account</fullName>
        <field>TA_Postcode__c</field>
        <formula>LE_Postcode__c</formula>
        <name>Sync Address Postcode [Account]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Street_Name_Account</fullName>
        <field>TA_Street_Name__c</field>
        <formula>LE_Street_Name__c</formula>
        <name>Sync Address Street Name [Account]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Address_Street_No_Account</fullName>
        <field>TA_Street_Number__c</field>
        <formula>LE_Street_Number__c</formula>
        <name>Sync Address Street No. [Account]</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UK_Record_Type_on_Account</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Prospect_UK</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UK Record Type on Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UK_Record_Type_on_Person_Account</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Person_UK</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UK Record Type on Person Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Type_as_Client</fullName>
        <field>Type</field>
        <literalValue>Client</literalValue>
        <name>Update Account Type as Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Type_as_Prospect</fullName>
        <field>Type</field>
        <literalValue>Prospect</literalValue>
        <name>Update Account Type as Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>%5BWF 16%5D Person Account Created UK</fullName>
        <actions>
            <name>UK_Record_Type_on_Person_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Home_Country__pc</field>
            <operation>equals</operation>
            <value>England,Scotland,Wales,Ireland,Northern Ireland</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Person Account Record Type is Updated to UK.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 17%5D Person Account Created HK</fullName>
        <actions>
            <name>HK_Record_Type_on_Person_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Home_Country__pc</field>
            <operation>equals</operation>
            <value>Hong Kong</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Person Account Record Type is Updated to Hong Kong.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 18%5D Person Account Created SG</fullName>
        <actions>
            <name>SG_Record_Type_on_Person_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Home_Country__pc</field>
            <operation>equals</operation>
            <value>Singapore</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Person Account Record Type is Updated to Singapore.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 19%5D Person Account Created PP</fullName>
        <actions>
            <name>PP_Record_Type_on_Person_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Home_Country__pc</field>
            <operation>equals</operation>
            <value>Philippines</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Person Account Record Type is Updated to Philippines.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 20%5D Account Created UK</fullName>
        <actions>
            <name>Set_Account_WF_Triggered</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UK_Record_Type_on_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Account_Type_as_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>2 AND 4 AND 5 AND (1 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Account.LE_Country__c</field>
            <operation>equals</operation>
            <value>England,Scotland,Wales,Ireland,Northern Ireland,UK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.TA_Country__c</field>
            <operation>equals</operation>
            <value>England,Scotland,Wales,Ireland,Northern Ireland,UK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Converted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.isWFtriggered__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Account Record Type is Updated to UK.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 21%5D Account Created HK</fullName>
        <actions>
            <name>HK_Record_Type_on_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Account_WF_Triggered</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Account_Type_as_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>3 AND 4 AND 5 AND ( 1 OR 2 )</booleanFilter>
        <criteriaItems>
            <field>Account.LE_Country__c</field>
            <operation>equals</operation>
            <value>Hong Kong</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.TA_Country__c</field>
            <operation>equals</operation>
            <value>Hong Kong</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Converted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.isWFtriggered__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Account Record Type is Updated to Hong Kong.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 22%5D Account Created PP</fullName>
        <actions>
            <name>PP_Record_Type_on_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Account_WF_Triggered</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Account_Type_as_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>3 AND 4 AND 5 AND ( 1 OR 2 )</booleanFilter>
        <criteriaItems>
            <field>Account.LE_Country__c</field>
            <operation>equals</operation>
            <value>Philippines</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.TA_Country__c</field>
            <operation>equals</operation>
            <value>Philippines</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Converted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.isWFtriggered__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Account Created PP</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 23%5D Account Created SG</fullName>
        <actions>
            <name>SG_Record_Type_on_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Account_WF_Triggered</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Account_Type_as_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>3 AND 4 AND 5 AND ( 1 OR 2 )</booleanFilter>
        <criteriaItems>
            <field>Account.LE_Country__c</field>
            <operation>equals</operation>
            <value>Singapore</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.TA_Country__c</field>
            <operation>equals</operation>
            <value>Singapore</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Converted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.isWFtriggered__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Account Record Type is Updated to Singapore.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 24%5D Sync LE and TA Address %5BAccount%5D</fullName>
        <actions>
            <name>Sync_Address_Building_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Floor_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Line_2_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Line_3_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Postcode_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Street_Name_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sync_Address_Street_No_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Trading_Address_if_different__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notContain</operation>
            <value>Premise</value>
        </criteriaItems>
        <description>Sync LE and TA Address [Account]</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 26%5D Update Account Type as Client</fullName>
        <actions>
            <name>Update_Account_Type_as_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Client</value>
        </criteriaItems>
        <description>Update Account Type as Client</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
