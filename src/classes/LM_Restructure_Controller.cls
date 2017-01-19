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
 * Loan Management Restructure Event Controller extension Class to Restructure the Loan Ammount.
 * This controller class enforce the sharing rules for the current user. 
 */ 

public with sharing class LM_Restructure_Controller extends LM_ComponentController {
		
	private Operation__c Operation;
    public Boolean hasRulesEngine {get; set;}
			
	public override void extendedSetterActions()
    {
        if(!bIsComponentInitialized) //The setter is called multiple times and we don't want to overwrite if initialization is already done
        {
            super.extendedSetterActions();
            
            Operation = ((LM_EventProcessor_Controller)pageController).o;
            lme.Event_Date__c = Date.today();
        }
    }
	
	public list<selectOption> getLoanTerms(){
		list<selectOption> Terms = new list<selectOption>();
		Terms.add(new selectOption('','--None--'));
		try{
			for(Product2 Prod : this.getProductFullLoanTerm()){
				Terms.add(new selectOption(Prod.Full_Term__c, Prod.Full_Term__c));
			}			
		}catch(Exception ex){}		
		return Terms;		
	}
	
	private list<Product2> getProductFullLoanTerm(){
		try{			
			return [Select Full_Term__c From Product2
                    Where Id IN (Select Product__c
                                 From Program_Product_ASO__c 
                                 Where Program__c =: Operation.Program_Product_ASO__r.Program__c And Program__r.isActive__c = true 
                                 	And Product__r.Schedule_Type__c =: Operation.Program_Product_ASO__r.Product__r.Schedule_Type__c 
                                	And Product__r.Interest_Type__c =: Operation.Program_Product_ASO__r.Product__r.Interest_Type__c
                                	And Product__r.Interest_Rate__c =: Operation.Program_Product_ASO__r.Product__r.Interest_Rate__c)
                    Order By Full_Term__c];
		}catch(QueryException ex){
			return null;
		}
	}
    
    public void checkForRulesEngine(){
        hasRulesEngine = [Select Rules_Engine__c
                          From Program_Product_ASO__c 
                          Where Program__c =: Operation.Program_Product_ASO__r.Program__c And Program__r.isActive__c = true 
                          And Product__r.Schedule_Type__c =: Operation.Program_Product_ASO__r.Product__r.Schedule_Type__c 
                          And Product__r.Interest_Type__c =: Operation.Program_Product_ASO__r.Product__r.Interest_Type__c
                          And Product__r.Interest_Rate__c =: Operation.Program_Product_ASO__r.Product__r.Interest_Rate__c
                          And Product__r.Full_term__c =: lme.Event_Loan_Term__c
                          And Rules_Engine__c = true].size() > 0;
        
    }
}