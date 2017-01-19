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
 * Loan Program Custom Object Class.
 *
 */ 
 
public with sharing class AMP_LoanProgram { 
 	
 	private list<Program__c> ProgramsExpiredSoon = new list<Program__c>();
	
	/*
	* Check Loan Program Validity and Send Email Alert to Program Owner.  
	*
	* Query to Program Custom Object to check the End Date of Loan Program
	* Will send Email Alert to Program Owner in case of End Date is in Next Week.
	* 
	*/
	
	public void CheckProgramValidty(){			
		
		Date CurrentDate = system.today().addDays(7); 
		
		ProgramsExpiredSoon =  [Select p.Owner.Email, p.Owner.FirstName,  
			p.OwnerId, p.Name, p.Id, p.End_Date__c From Program__c p 
			Where End_Date__c =: CurrentDate limit 10];
			
		if(ProgramsExpiredSoon.size() > 0){
			try{
				EmailTemplate Template = [Select e.Id From EmailTemplate e Where DeveloperName = 'Program_Expire_Alert' limit 1];
				Contact C = [Select Id from Contact Where Email != null limit 1];
				this.SendEmailUsingTemplate(Template.Id, C.Id);				
			}catch(QueryException ex){
				this.SendHTMLEmail();
			}
		}
	}
	
	/*
	* Send Email using Email Template from Custom Email Templates.  
	*	
	*/	
		
	private void SendEmailUsingTemplate(ID TemplateId, ID TargetObjectId){
		for(Program__c Prog : ProgramsExpiredSoon){
			string[] sendto = new string[]{Prog.Owner.Email};
			AMP_EmailAlerts.SendEmail(TargetObjectId, null,Prog.Id,TemplateId, sendto);
		}		
	}
	
	/*
	* Use string HTML Email in case of Exception.  
	*	
	*/
	
	private void SendHTMLEmail(){
		string Subject,TemplateStr;
		for(Program__c Prog : ProgramsExpiredSoon){
			string[] sendto = new string[]{Prog.Owner.Email};
			Subject = 'Program '+ prog.Name +' will expire soon';
			TemplateStr = this.SimpleEmailTemplate(Prog.Owner.FirstName,Prog.Name,Prog.End_Date__c);	
			AMP_EmailAlerts.SendEmail(sendto, null, Subject, TemplateStr);
		}		
	}
	
	/*
	* A Simple Email Template to send a messge to Loan Program Owner with Program Name and its Closing Date.  
	*	
	*/
	
	private string SimpleEmailTemplate(string OwnerName, string ProgramName, Date EndDate){
		
		string Template = 'Hi '+OwnerName +',<br/><br/>'+
						'The following program assigned to you, '+ ProgramName +'  is due to expire on '+ EndDate + '.' +
						'Please take appropriate action.<br/><br/> '+
						'Many thanks,<br/>'+
						'System Administrator';
		return Template;
	}
}