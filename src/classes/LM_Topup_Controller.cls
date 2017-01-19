public with sharing class LM_Topup_Controller extends LM_ComponentController
{
    private Operation__c o;
         
    public override void extendedSetterActions()
    {    	
        if(!bIsComponentInitialized) //The setter is called multiple times and we don't want to overwrite if initialization is already done
        {
            super.extendedSetterActions();
            
            o = ((LM_EventProcessor_Controller)pageController).o;
            
            lme.Event_Date__c = Date.today();
            decimal totalPrincipalAmount = o.Loan_Amount__c;
            decimal repaidPrincipalAmount =  totalPrincipalAmount - (o.Loan_Outstanding_Principal__c == null ? totalPrincipalAmount : o.Loan_Outstanding_Principal__c);
            
            if (rulesEngine != null)
            {
                if (!rulesEngine.Top_ups__c)
                {
                    disableCalculation();
                    infoMessage = 'Top-ups are not allowed for the product used by this loan';                
                }
                else if(rulesEngine.Top_ups__c && (rulesEngine.Minimum_of_principal_repaid__c == null || rulesEngine.Minimum_of_principal_repaid__c == 0))
                {
                    disableCalculation();
                    infoMessage = 'Minimum % of Principal Repaid has not been configured. Please check the Rules Engine.';
                    
                }
                else if (repaidPrincipalAmount < (rulesEngine.Minimum_of_principal_repaid__c/100)*totalPrincipalAmount)
                {
                    disableCalculation();
                    infoMessage = 'Minimum % of Principal Repaid has not been reached. Top-ups are not allowed for this loan yet.';
                    
                }
            } 
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
			return [Select p.Full_Term__c From Product2 p
                    Where Id IN (Select Product__c
                                 From Program_Product_ASO__c 
                                 Where Program__c =: o.Program_Product_ASO__r.Program__c And Program__r.isActive__c = true 
                                 	And Product__r.Schedule_Type__c =: o.Program_Product_ASO__r.Product__r.Schedule_Type__c 
                                	And Product__r.Interest_Type__c =: o.Program_Product_ASO__r.Product__r.Interest_Type__c
                                	And Product__r.Interest_Rate__c =: o.Program_Product_ASO__r.Product__r.Interest_Rate__c)
                    Order By Full_Term__c];
            
		}catch(QueryException ex){
			return null;
		}
	}
}