//Author: Miroslav Handzhiev, Xoomworks
@isTest(seeAllData=false)
public class CampaignMemberTrigger_Test {
     static testMethod void testCampaignMemberTrigger()
     {
         
         
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
         
          list<User> lstAdminUser = [Select u.ProfileId, u.IsActive, u.Id, u.Profile.Name, u.Profile_Name__c From User u 
                                    where u.Profile.Name like '%Admin%' And u.IsActive = true];
          list<RecordType> lstUKCampaign = [Select r.SobjectType, r.Name, r.IsActive, r.Id, r.DeveloperName 
                                From RecordType r where SobjectType = 'Campaign' and DeveloperName ='UK'];
          list<RecordType> lstUK = [Select r.SobjectType, r.Name, r.IsActive, r.Id, r.DeveloperName 
                                From RecordType r where SobjectType = 'Lead' and DeveloperName ='UK'];
         Test.startTest(); 
         Campaign c = new Campaign();
            c.Name = 'M Campaign';
            c.RecordTypeId = lstUKCampaign[0].id;
            insert c;
                
                
                
            Lead objLead1 = new Lead();
            objLead1.Convert_Lead__c = false;
            objLead1.RecordTypeId = lstUK[0].Id;
            objLead1.LastName='Holmes';
            objLead1.FirstName='Sherlock';
            objLead1.Business_Position__c = 'Owner';
            objLead1.Company='Bakers';
            objLead1.Status='Open';
            objLead1.Email = 'test5@gmail.com';
            objLead1.Accepts_Credit_Cards__c = true;
            objLead1.TA_Country__c= 'UK';
            objLead1.OwnerId = lstAdminUser[0].Id;
            insert objLead1;
         
         CampaignMember cm = new CampaignMember();
         cm.LeadId = objLead1.Id;
         cm.CampaignId = c.Id;
         insert cm;
         Test.stopTest();
         List<Lead> resList = [Select CampaignID__c from Lead where id = :objLead1.Id];
         system.assertEquals(c.Id, resList[0].CampaignID__c);
         
         
     }

}