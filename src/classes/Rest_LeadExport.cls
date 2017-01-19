@RestResource(urlMapping='/LeadExport/*')
global class Rest_LeadExport {
    
	
    @httpget 
    global static string exportLead(){
        //List<lead> leadList = new List<Lead>();
        //leadList = [SELECT LastActivityDate, LastModifiedDate, Id, Status, Company, TA_Postcode__c, LastModifiedById, CampaignID__c, Name,
          //           	(select LastmodifiedDate,status,subject from ActivityHistories) FROM Lead order by LastModifiedDate desc]; 	
        exportLeadToFile();
        return 'Check the file';
    }
    
    @future
    global static void exportLeadToFile(){
         List<lead> leadList = new List<Lead>();
         leadList = [SELECT LastActivityDate, LastModifiedDate, Id, Status, Company, TA_Postcode__c, LastModifiedById, CampaignID__c, Name,
                     	(select LastmodifiedDate,status,subject from ActivityHistories) FROM Lead order by LastModifiedDate desc]; 		
        Document doc = new Document(
                        FolderId = UserInfo.getUserId(), // "My Personal Documents" folder
                        Name = 'LeadExport',
                        Body = Blob.valueOf(JSON.serialize(leadList)),
                        ContentType = 'application/json',
                        Type = 'txt'
                        );
        upsert doc;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    global class LeadExportWrapper{
       public ID LeadID;
       public String Name;
       public String Company;
       public String TA_PostCode;
       public String Status;
       public Date ActivityDate;
       public DateTime LastModifiedDate;
       public String LastModifiedByName;
       public  String CampaignName;
        
        public LeadExportWrapper( 
            ID LeadID,
            String Name,
            String Company,
            String TA_PostCode,
            String Status,
            Date ActivityDate,
            DateTime LastModifiedDate,
            String LastModifiedByName,
            String CampaignName){                
                    this.LeadID=LeadID;
                    this.Name=Name;
                    this.Company=Company;
                    this.TA_PostCode=TA_PostCode;
                    this.Status=Status;
                    this.ActivityDate=ActivityDate;
                    this.LastModifiedDate=LastModifiedDate;
                    this.LastModifiedByName=LastModifiedByName;
                    this.CampaignName=CampaignName;
        }
        
    }
}