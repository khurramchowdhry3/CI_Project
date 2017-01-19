<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Additional_Information_Is_Required</fullName>
        <description>Additional Information Is Required</description>
        <protected>false</protected>
        <recipients>
            <recipient>New Loans Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Administrator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/CR01_Additional_Information_Required</template>
    </alerts>
    <alerts>
        <fullName>All_Document_Received</fullName>
        <description>All Document Received</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Documents_Received_Alert</template>
    </alerts>
    <alerts>
        <fullName>Notify_New_Business_Team_HK</fullName>
        <description>Notify New Business Team (HK)</description>
        <protected>false</protected>
        <recipients>
            <recipient>New_Business_Team_Hong_Kong</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>dominic.rockman@amplifi-capital.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Web_Application_Recieved</template>
    </alerts>
    <alerts>
        <fullName>Notify_New_Business_Team_PP</fullName>
        <description>Notify New Business Team (PP)</description>
        <protected>false</protected>
        <recipients>
            <recipient>New_Business_Team_Philippines</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>dominic.rockman@amplifi-capital.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Web_Application_Recieved</template>
    </alerts>
    <alerts>
        <fullName>Notify_New_Business_Team_SG</fullName>
        <description>Notify New Business Team (SG)</description>
        <protected>false</protected>
        <recipients>
            <recipient>New_Business_Team_Singapore</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>dominic.rockman@amplifi-capital.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Web_Application_Recieved</template>
    </alerts>
    <alerts>
        <fullName>Notify_New_Loans_Manager_on_Opportunity_Creation</fullName>
        <description>Notify New Loans Manager on Opportunity Creation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opportunity_Created_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_Opportunity_Team_on_Credit_Assessment_Approval</fullName>
        <description>Notify Opportunity Team on Credit Assessment Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>New Loans Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Administrator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Credit_Assessment_Completed_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notify_Opportunity_Team_on_Credit_Assessment_Rejection</fullName>
        <description>Notify Opportunity Team on Credit Assessment Rejection</description>
        <protected>false</protected>
        <recipients>
            <recipient>New Loans Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Administrator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Credit_Assessment_Completed_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Signed_Application_Form_Received</fullName>
        <description>Signed Application Form Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>New Loans Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Administrator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Signed_Application_Form_Received</template>
    </alerts>
    <alerts>
        <fullName>Web_Application_Created</fullName>
        <description>Web Application Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>New_Business_Team_UK</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>dominic.rockman@amplifi-capital.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMP_Credit_Templates/Web_Application_Recieved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Application_ID_Update</fullName>
        <field>Application_ID2__c</field>
        <formula>Account.Client_ID__c + 
if (
 or(
  isnull(Account.Number_of_Applications__c),
  isblank(Account.Number_of_Applications__c),
  Account.Number_of_Applications__c = 0
 ),
 &apos;001&apos;,
 if (
  Account.Number_of_Applications__c &lt;10,
  &apos;00&apos;,
  if (
   Account.Number_of_Applications__c &lt; 100,
   &apos;0&apos;,
   &apos;&apos;
   )
  ) 
  +
  text(Account.Number_of_Applications__c+1)
 )</formula>
        <name>Application ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hong_Kong_Application</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Application_Hong_Kong</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Hong Kong Application</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Stage_Approved_Field_Update</fullName>
        <field>StageName</field>
        <literalValue>Accepted</literalValue>
        <name>Opportunity Stage Approved Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Stage_Declined_Field_Update</fullName>
        <field>StageName</field>
        <literalValue>Application Revised</literalValue>
        <name>Opportunity Stage Declined Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Philippines_Application</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Application_Philippines</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Philippines Application</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revised_Offer_Status_Declined</fullName>
        <field>StageName</field>
        <literalValue>Rejected</literalValue>
        <name>Revised Offer Status Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Avg_Monthly_Card_Sales</fullName>
        <field>Average_Monthly_Card_Sales_Volume__c</field>
        <formula>Average_Monthly_Card_Sales__c</formula>
        <name>Set Account Avg Monthly Card Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Avg_Monthly_Sales</fullName>
        <field>Ave_Monthly_Sales__c</field>
        <formula>Ave_Monthly_Sales__c</formula>
        <name>Set Account Avg Monthly Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Monthly_Rental</fullName>
        <field>Monthly_Rent__c</field>
        <formula>Monthly_Rental__c</formula>
        <name>Set Account Monthly Rental</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_Hong_Kong_Interest_Rate</fullName>
        <field>Monthly_Interest__c</field>
        <formula>0.30</formula>
        <name>Set Default Hong Kong Interest Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_Philippines_Interest_Rate</fullName>
        <field>Monthly_Interest__c</field>
        <formula>0.30</formula>
        <name>Set Default Philippines Interest Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_Singapore_Interest_Rate</fullName>
        <field>Monthly_Interest__c</field>
        <formula>0.30</formula>
        <name>Set Default Singapore Interest Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Final_Decision_Approved_False</fullName>
        <field>Final_Decision_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Set Final Decision Approved False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Final_Decision_Rejected_False</fullName>
        <field>Final_Decision_Rejected__c</field>
        <literalValue>0</literalValue>
        <name>Set Final Decision Rejected False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Recordtype_Closing_HK</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closing_Hong_Kong</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Opportunity Recordtype Closing HK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Recordtype_Closing_PP</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closing_Philippines</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Opportunity Recordtype Closing PP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Recordtype_Closing_SG</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closing_Singapore</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Opportunity Recordtype Closing SG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Recordtype_Closing_UK</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closing_UK</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Opportunity Recordtype Closing UK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Stage_Won</fullName>
        <field>StageName</field>
        <literalValue>(Won) Signed</literalValue>
        <name>Set Opportunity Stage Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Singapore_Application</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Application_Singapore</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Singapore Application</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_App_Revised</fullName>
        <field>StageName</field>
        <literalValue>Application Revised</literalValue>
        <name>Stage: App Revised</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecordType_as_Client_HK</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Client_Hong_Kong</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Account RecordType as Client(HK)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecordType_as_Client_PP</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Client_Philippines</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Account RecordType as Client(PP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecordType_as_Client_SG</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Client_Singapore</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Account RecordType as Client(SG)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_RecordType_as_Client_UK</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Client_UK</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Account RecordType as Client(UK)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Conditional_Offer_Amount</fullName>
        <field>Conditional_Offer_Amount__c</field>
        <formula>if (
 or(isblank(Average_Monthly_Card_Sales__c), isblank(Conditional_Approval_Multiplier__c)),
 0,
 Average_Monthly_Card_Sales__c * Conditional_Approval_Multiplier__c
)</formula>
        <name>Update Conditional Offer Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_Stage_Assessment_In_Progress</fullName>
        <description>Updates Opportunity Stage-Assessment In Progress when the application form is recievd through docusign.</description>
        <field>StageName</field>
        <literalValue>Assessment In Progress</literalValue>
        <name>Update Opp Stage-Assessment In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Task_Created_Chkbox</fullName>
        <field>Opportunity_Task_Created__c</field>
        <literalValue>1</literalValue>
        <name>Update Opportunity Task Created Chkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WF_01_Opportunity_Name_Update</fullName>
        <description>Substitutes blank values in opportunity name with Name.</description>
        <field>Name</field>
        <formula>Account.Client_ID__c + 
if (
 or(
  isnull(Account.Number_of_Applications__c),
  isblank(Account.Number_of_Applications__c),
  Account.Number_of_Applications__c = 0
 ),
 &apos;001&apos;,
 if (
  Account.Number_of_Applications__c &lt;10,
  &apos;00&apos;,
  if (
   Account.Number_of_Applications__c &lt; 100,
   &apos;0&apos;,
   &apos;&apos;
   )
  ) 
  +
  text(Account.Number_of_Applications__c+1)
 )
 +
&apos; &apos; +
Account.Name</formula>
        <name>WF_01_Opportunity Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>%5BWF 102%5D Additional Info Not Satisfactory</fullName>
        <actions>
            <name>Additional_Information_Is_Required</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Additional_Information_Satisfactory__c) = &apos;No&apos;,OR(ISCHANGED(Additional_Information_Narrative__c),ISCHANGED(Additional_Information_Details__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 27%5D Opportunity Created</fullName>
        <actions>
            <name>Application_ID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_01_Opportunity_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Runs when opportunity is created.  Updates include name.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 28%5D Create follow-up task for AMP New Loans Manager</fullName>
        <actions>
            <name>Update_Opportunity_Task_Created_Chkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Created</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Creates a task for the opportunity owner when a lead is converted.</description>
        <formula>AND(ISCHANGED(OwnerId),NOT(ISNEW()), Opportunity_Task_Created__c  = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 29%5D Opportunity Stage Approved Update</fullName>
        <actions>
            <name>Opportunity_Stage_Approved_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Offer_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome UK,Outcome Hong Kong,Outcome Singapore,Outcome Philippines</value>
        </criteriaItems>
        <description>Update Opportunity Stage Accepted when Offer Status equals Accepted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 30%5D Opportunity Stage Declined Update</fullName>
        <actions>
            <name>Opportunity_Stage_Declined_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome UK,Outcome Hong Kong,Outcome Singapore,Outcome Philippines</value>
        </criteriaItems>
        <description>Update Opportunity Stage Declined  when Opportuntiy:Offer Status equal Declined</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 31%5D Opportunity Created HK</fullName>
        <actions>
            <name>Hong_Kong_Application</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Default_Hong_Kong_Interest_Rate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Country__c</field>
            <operation>equals</operation>
            <value>Hong Kong</value>
        </criteriaItems>
        <description>Change opportunity recordtype to Hong Kong Application</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 32%5D Opportunity Created Philippines</fullName>
        <actions>
            <name>Philippines_Application</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Default_Philippines_Interest_Rate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Country__c</field>
            <operation>equals</operation>
            <value>Philippines</value>
        </criteriaItems>
        <description>Change opportunity recordtype to Philippines Application</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 33%5D Opportunity Created Singapore</fullName>
        <actions>
            <name>Set_Default_Singapore_Interest_Rate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Singapore_Application</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Country__c</field>
            <operation>equals</operation>
            <value>Singapore</value>
        </criteriaItems>
        <description>Change opportunity recordtype to Singapore Application</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 34%5D Docusign Signed and Received</fullName>
        <actions>
            <name>Signed_Application_Form_Received</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Opp_Stage_Assessment_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Signed_Application_Form_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Application_Form_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Required_Documents_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Documents_Processed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Documents_Received_Kofax__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If Signed Application Form Received Checkbox is set to true then Send an Email to Opportunity Owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 35%5D Calculate Conditional Offer Amount</fullName>
        <actions>
            <name>Update_Conditional_Offer_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculate Conditional Offer Amount based on Ave Card Sales and Monthly Rental</description>
        <formula>OR(  ISCHANGED(Conditional_Approval_Multiplier__c),  ISCHANGED(Average_Monthly_Card_Sales__c),  ISCHANGED(Monthly_Rental__c),  ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 36%5D Update Account Avg Monthly Card Sales</fullName>
        <actions>
            <name>Set_Account_Avg_Monthly_Card_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Account Avg Monthly Card Sales</description>
        <formula>ISCHANGED( Average_Monthly_Card_Sales__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 37%5D Update Account Avg Monthly Sales</fullName>
        <actions>
            <name>Set_Account_Avg_Monthly_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Account Avg Monthly Sales</description>
        <formula>ISCHANGED( Ave_Monthly_Sales__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 38%5D Update Account Monthly Rental</fullName>
        <actions>
            <name>Set_Account_Monthly_Rental</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Account Monthly Rental</description>
        <formula>ISCHANGED( Monthly_Rental__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 39%5D Documents Alert</fullName>
        <actions>
            <name>All_Document_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Documents_Processed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Documents Alert when Documents Processed EQUALS True</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 40%5D Opportunity Contract Signed %28UK%29</fullName>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opportunity_Stage_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome UK</value>
        </criteriaItems>
        <description>Opportunity Contract Signed (UK) when Opportunity: Contract Signed EQUALS True AND Opportunity: Opportunity Record Type EQUALS Outcome UK</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 41%5D Opportunity Contract Signed %28HK%29</fullName>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_HK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opportunity_Stage_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome Hong Kong</value>
        </criteriaItems>
        <description>Opportunity Contract Signed (HK) when Opportunity: Contract Signed EQUALS True AND Opportunity: Opportunity Record Type EQUALS Outcome Hong Kong</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 42%5D Opportunity Contract Signed %28SG%29</fullName>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_SG</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opportunity_Stage_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome Singapore</value>
        </criteriaItems>
        <description>Opportunity Contract Signed (SG) when Opportunity: Contract Signed EQUALS True AND Opportunity: Opportunity Record Type EQUALS Outcome Singapore</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 43%5D Opportunity Contract Signed %28PP%29</fullName>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_PP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opportunity_Stage_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome Philippines</value>
        </criteriaItems>
        <description>Opportunity Contract Signed (PP) when Opportunity: Contract Signed EQUALS True AND Opportunity: Opportunity Record Type EQUALS Outcome Philippines</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 44%5D Set Prospect Account Record type as Client%28UK%29</fullName>
        <actions>
            <name>Update_Account_RecordType_as_Client_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>UK</value>
        </criteriaItems>
        <description>When Contract Signed is set to true then rule will change the record type of account as Client for UK.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 45%5D Set Prospect Account Record type as Client%28HK%29</fullName>
        <actions>
            <name>Update_Account_RecordType_as_Client_HK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Hong Kong</value>
        </criteriaItems>
        <description>When Contract Signed is set to true then rule will change the record type of account as Client for Hong Kong.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 46%5D Set Prospect Account Record type as Client%28SG%29</fullName>
        <actions>
            <name>Update_Account_RecordType_as_Client_SG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Singapore</value>
        </criteriaItems>
        <description>When Contract Signed is set to true then rule will change the record type of account as Client for Singapore.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 47%5D Set Prospect Account Record type as Client%28PP%29</fullName>
        <actions>
            <name>Update_Account_RecordType_as_Client_PP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Philippines</value>
        </criteriaItems>
        <description>When Contract Signed is set to true then rule will change the record type of account as Client for Philippines.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 48%5D Additional Info Required Notification to Sales Manager</fullName>
        <actions>
            <name>Additional_Information_Is_Required</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Additional_Information_Required__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Opportunity: Additional Information Required EQUALS Yes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 49%5D Revised Offer Status Approved</fullName>
        <actions>
            <name>Opportunity_Stage_Approved_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Offer_Presented_to_Client__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Revised_Offer_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome UK,Outcome Hong Kong,Outcome Singapore,Outcome Philippines</value>
        </criteriaItems>
        <description>Update Stage if Revised Offer Status is Approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 50%5D Revised Offer Status Declined %28UK%29</fullName>
        <actions>
            <name>Revised_Offer_Status_Declined</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Offer_Presented_to_Client__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Revised_Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome UK</value>
        </criteriaItems>
        <description>Update Stage and Recordtype if Revised Offer Status is Declined (UK)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 51%5D Revised Offer Status Declined %28HK%29</fullName>
        <actions>
            <name>Revised_Offer_Status_Declined</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_HK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Offer_Presented_to_Client__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Revised_Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome Hong Kong</value>
        </criteriaItems>
        <description>Update Stage and Recordtype if Revised Offer Status is Declined (HK)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 52%5D Revised Offer Status Declined %28SG%29</fullName>
        <actions>
            <name>Revised_Offer_Status_Declined</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_SG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Offer_Presented_to_Client__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Revised_Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome Singapore</value>
        </criteriaItems>
        <description>Update Stage and Recordtype if Revised Offer Status is Declined (SG)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 53%5D Revised Offer Status Declined %28PP%29</fullName>
        <actions>
            <name>Revised_Offer_Status_Declined</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_PP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Offer_Presented_to_Client__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Revised_Offer_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outcome Philippines</value>
        </criteriaItems>
        <description>Update Stage and Recordtype if Revised Offer Status is Declined (PP)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 79%5D Opportunity Owner Changed</fullName>
        <actions>
            <name>Notify_New_Loans_Manager_on_Opportunity_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR ( ISNEW()  ,ISCHANGED( OwnerId ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 81%5D Opportunity Closed Lost %28UK%29</fullName>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>UK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Application withdrawn by customer,Application withdrawn by AMPLIFI Capital,No Response from Client,Loan Withdrawn</value>
        </criteriaItems>
        <description>UK Opportunity has been lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 82%5D Opportunity Closed Lost %28HK%29</fullName>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_HK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Hong</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Application withdrawn by customer,Application withdrawn by AMPLIFI Capital,No Response from Client,Loan Withdrawn</value>
        </criteriaItems>
        <description>HK Opportunity has been lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 83%5D Opportunity Closed Lost %28SG%29</fullName>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_SG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Singapore</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Application withdrawn by customer,Application withdrawn by AMPLIFI Capital,No Response from Client,Loan Withdrawn</value>
        </criteriaItems>
        <description>SG Opportunity has been lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 84%5D Opportunity Closed Lost %28PP%29</fullName>
        <actions>
            <name>Set_Opportunity_Recordtype_Closing_PP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>contains</operation>
            <value>Philippines</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Application withdrawn by customer,Application withdrawn by AMPLIFI Capital,No Response from Client,Loan Withdrawn</value>
        </criteriaItems>
        <description>Philippines Opportunity has been lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 87%5D Credit Assessment Approved</fullName>
        <actions>
            <name>Notify_Opportunity_Team_on_Credit_Assessment_Approval</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Final_Decision_Approved_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Final_Decision_Approved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set Final Decision Approved checkbox as false</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 88%5D Credit Assessment Rejected</fullName>
        <actions>
            <name>Notify_Opportunity_Team_on_Credit_Assessment_Rejection</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Final_Decision_Rejected_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Final_Decision_Rejected__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set Final Decision Rejected checkbox as false</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 89%5D Web Application Recieved UK</fullName>
        <actions>
            <name>Web_Application_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>DWH Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application UK</value>
        </criteriaItems>
        <description>Notify New Business Team (UK) Group users about newly received application from Web.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 90%5D Web Application Received HK</fullName>
        <actions>
            <name>Notify_New_Business_Team_HK</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>DWH Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application Hong Kong</value>
        </criteriaItems>
        <description>Notify New Business Team (HK) Group users about newly received application from Web.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 91%5D Web Application Recieved SG</fullName>
        <actions>
            <name>Notify_New_Business_Team_SG</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>DWH Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application Singapore</value>
        </criteriaItems>
        <description>Notify New Business Team (SG) Group users about newly received application from Web.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%5BWF 92%5D Web Application Recieved PP</fullName>
        <actions>
            <name>Notify_New_Business_Team_PP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>DWH Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application Philippines</value>
        </criteriaItems>
        <description>Notify New Business Team (PP) Group users about newly received application from Web.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Loan Witdrawn</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Loan Withdrawn</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Opportunity_Created</fullName>
        <assignedToType>owner</assignedToType>
        <description>An opportunity has been assigned to you please follow up with the client.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Opportunity Created</subject>
    </tasks>
</Workflow>
