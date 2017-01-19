/**
 * AMP Loan Management System
 * 
 * This file is part of the AMP Loan Management Project
 * Loan Management System for Sales & Admin Peoples.
 *
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Send Email Alerts to Users.
 *
 */ 
 
public with sharing class AMP_EmailAlerts {
	
	/*
     *  Send Single Email Message to User, Contact or Lead by using Salesforce Email Templates. 
     *	This requires following parameters.
     *  
     *  @ToRecipients : Email Address of Recipients
     *  
     *  @ccRecipients : Eamil Address of CC Recipients.
     *
     *  @TargetObjectID : The ID of the contact, lead, or user to which the email will be sent.
	 *					  The ID you specify sets the context and ensures that merge fields in the template contain the correct data.
     *  
     *  @EmailTemplateID : Must be a Email Template Id to which you want to use for email message.
     *       
     */   
		
	public static void SendEmail(ID ToRecipient, string[] ccRecipients, ID TargetObjectId, ID EmailTemplateID, string[] Recipients){
        Messaging.Singleemailmessage myMail = new Messaging.Singleemailmessage();
        
        MyMail.setWhatId(TargetObjectId);
        MyMail.setToAddresses(Recipients);
        MyMail.setCcAddresses(ccRecipients);
        MyMail.setTargetObjectId(ToRecipient);
        MyMail.setTemplateId(EmailTemplateID);
        myMail.setSaveAsActivity(false);                 
        try{
        	if(!test.isRunningTest())
        		Messaging.sendEmail(new Messaging.Singleemailmessage[] {myMail});
        }catch(Exception ex){}        
    }
    
    /*
     *  Send Single Email Message to User, Contact or Lead by using HTML Email Template. 
     *	This requires following parameters.
     *  
     *  @ToRecipients : Email Address of Recipients.
     *
     *  @ccRecipients : Eamil Address of CC Recipients.
     *  
     *  @Subject : Subject of Email Alert, could be any thing in string.                 
     *  
     *  @HTMLEmailTemplate : HTML Email Template as string to email message .
     *       
     */    
    
    public static void SendEmail(string[] ToRecipients, string[] ccRecipients, string Subject, string HTMLEmailTemplate){
        Messaging.Singleemailmessage myMail = new Messaging.Singleemailmessage();
        
        MyMail.setToAddresses(ToRecipients); 
        MyMail.setCcAddresses(ccRecipients);        
        myMail.setSubject(Subject);
        MyMail.setHtmlBody(HTMLEmailTemplate);
        myMail.setSaveAsActivity(false);                 
        try{
        	if(!test.isRunningTest())
        		Messaging.sendEmail(new Messaging.Singleemailmessage[] {myMail});
        }catch(Exception ex){}
    }
}