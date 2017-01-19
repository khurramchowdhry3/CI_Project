/**
    Extension for the CRMS_SendEmailInlinePage VF Page
    Author: Saket Johsi
    Created Date: 27/03/2015        Version: 1.0
*/

public class CRMS_SendEmailInlinePageController {

    public Opportunity objOpportunity           { get;set; }
    
    //Standard controller constructor
    public CRMS_SendEmailInlinePageController(Apexpages.StandardController stdCon) {
        Id objectId = stdCon.getRecord().Id;
        objOpportunity = [SELECT StageName, Application_Form_Completed__c,
                                Application_Email_Sent__c,
                                Id
                            FROM Opportunity 
                            WHERE Id = :objectId
                            LIMIT 1];
    } //End of constructor

    //Method to call the send email function
    public void sendMail() {
        List<Id> lstObjectId = new List<Id> { objOpportunity.Id };
            
        afterInsertUpdate(lstObjectId);
       
    } //End of sendMail() method
    
    // Used to send an email template 
    
     public static void afterInsertUpdate(list<Id> listOppID ){
        List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>();
        List<String> ccList = new List<String>(); 
        Reply_To_Email_Address__c replyToEmailAddress;
        
        List<Guarantors__c> relatedOppRecord = [SELECT id, Account__r.PersonContactId, Opportunity__c, Opportunity__r.recordtype.Name
                                                FROM Guarantors__c 
                                                WHERE Opportunity__c IN : listOppID];
                                                
        // Fetch email template records. 
        List<EmailTemplate> listTemplateId = [SELECT id, Name 
                                              FROM EmailTemplate 
                                              WHERE name LIKE : '%'+ CRMS_Constants.docName +'%'];
        Map<String, ID> mapTemplateNameANDId = new Map<String, ID>();
        for(EmailTemplate emailTemplate : listTemplateId){
            mapTemplateNameANDId.put(emailTemplate.Name, emailTemplate.id );
        }                            
        List<Opportunity> lstOpp = new List<Opportunity> ();
        lstOpp = [SELECT Id, Application_Email_Sent__c,Owner.Email FROM Opportunity WHERE Id IN :listOppID];
         for (Opportunity tempShitSecondTimeOpportunity : lstOpp)    {
             ccList.add(tempShitSecondTimeOpportunity.Owner.Email);
         }   
                
        if( relatedOppRecord != null ){
            // send email to every contact
            for( Guarantors__c owner : relatedOppRecord ){
                
                //create a mail object to send a single email.
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                if( owner.Opportunity__r.recordtype.Name.contains(CRMS_Constants.hongKong) 
                    || owner.Opportunity__r.recordtype.Name.contains(CRMS_Constants.hk)){
                    mail.setTemplateId(mapTemplateNameANDId.get(CRMS_Constants.hkTemplate));
                    replyToEmailAddress = Reply_To_Email_Address__c.getValues(CRMS_Constants.hk);
                }else if( owner.Opportunity__r.recordtype.Name.contains(CRMS_Constants.uk) ){
                    replyToEmailAddress = Reply_To_Email_Address__c.getValues(CRMS_Constants.uk);
                    mail.setTemplateId(mapTemplateNameANDId.get(CRMS_Constants.ukTemplate));
                }else if( owner.Opportunity__r.recordtype.Name.contains(CRMS_Constants.singapore) 
                    || owner.Opportunity__r.recordtype.Name.contains(CRMS_Constants.sg) ){
                    replyToEmailAddress = Reply_To_Email_Address__c.getValues(CRMS_Constants.sg);
                    mail.setTemplateId(mapTemplateNameANDId.get(CRMS_Constants.sgTemplate));
                }else if( owner.Opportunity__r.recordtype.Name.contains(CRMS_Constants.philippines) 
                    || owner.Opportunity__r.recordtype.Name.contains(CRMS_Constants.ph) ){
                    replyToEmailAddress = Reply_To_Email_Address__c.getValues(CRMS_Constants.ph);
                    mail.setTemplateId(mapTemplateNameANDId.get(CRMS_Constants.phTemplate));
                }
                if( replyToEmailAddress != null )
                    
                    mail.setReplyTo(replyToEmailAddress.Reply_To__c);  
                
                if(ccList!=null&&!ccList.isEmpty()) {
                    mail.setCcAddresses(ccList);
                }
                
                mail.setTargetObjectId(owner.Account__r.PersonContactId);
                
                mail.setWhatId(owner.Opportunity__c);
                listEmail.add(mail);
            }
            //send the email
            try {
                List<Messaging.SendEmailResult> result = Messaging.sendEmail(listEmail);
                for(Opportunity objOpp : lstOpp)
                    objOpp.Application_Email_Sent__c = true;
            }
            catch (System.EmailException ex) {
                for(Opportunity objOpp : lstOpp)
                    objOpp.Application_Email_Sent__c = false;
            }
            update lstOpp;
        }
    } // end of afterInsertUpdate
}