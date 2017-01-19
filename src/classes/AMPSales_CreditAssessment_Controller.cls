public with sharing class AMPSales_CreditAssessment_Controller {
	
	public Credit_Assessment__c CreditAssessment	{get; set;}{
		CreditAssessment = new Credit_Assessment__c();
	}
	public string ApprovedInterestRate	{get; set;}
	public string ReturnURL	{get; set;}
	
	public AMPSales_CreditAssessment_Controller(ApexPages.StandardController StdCntlr_CreditAssessment){
		Credit_Assessment__c ContexttRecord = (Credit_Assessment__c)StdCntlr_CreditAssessment.getRecord();
		CreditAssessment = this.getCreditAssessmentRecord(ContexttRecord.Id);
		ApprovedInterestRate = CreditAssessment.Approved_Interest_Rate__c;
		ReturnURL = ApexPages.currentPage().getParameters().get('retURL');
	}
	
	private Credit_Assessment__c getCreditAssessmentRecord(ID RecordId){
		try{
			return [Select c.Status__c, 
					c.RecordType.Name, 
					c.RecordTypeId, 
					c.Program__c, 
					c.Program_Product_ASO__c, 
					c.Opportunity__c, 
					c.Narrative_Box__c, 
					c.Name,
					c.Id,
					c.Owner.Name, 
					c.Final_Decision__c, 
					c.Final_Decision_Date__c, 
					c.DWH_Status__c, 
					c.DWH_Last_Sync__c, 
					c.Business_Trading_Name__c, 
					c.Business_IQ_Score__c, 
					c.Approved_Loan_Term__c, 
					c.Approved_Loan_Amount__c, 
					c.Approved_Interest_Rate__c, 
					c.Approved_By__c, 
					c.Approval_Date__c, 
					c.Applicant_Name__c, 
					c.Additional_Information_Satisfactory__c, 
					c.Additional_Information_Required__c, 
					c.Additional_Information_Narrative__c,
					c.Additional_Information_Details__c, 
					c.AMP_Credit_Score__c 
				From Credit_Assessment__c c where Id =:RecordId limit 1];			
		}catch(QueryException ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
		}
		return null;
	}
	
	public void updateApprovedInterestRates(){
		this.getApprovedInerestRates();
	}
	
	public list<selectoption> getApprovedInerestRates(){
		list<selectoption> InterestRates = new list<selectoption>();
		Product2 SelectedProduct = 	this.getMinAndMaxInterestRateForProduct(CreditAssessment.Program_Product_ASO__c);
					
		Schema.DescribeFieldResult ApprovedInterestRates = Credit_Assessment__c.Approved_Interest_Rate__c.getDescribe();        
		for(Schema.PicklistEntry picklist: ApprovedInterestRates.getPicklistValues()){
			if(SelectedProduct != null){
				if(integer.valueof(picklist.getValue().replace('%', '')) >= SelectedProduct.Min_Interest_rate__c
					&& integer.valueof(picklist.getValue().replace('%', '')) <= SelectedProduct.Max_Interest_rate__c){
					InterestRates.add(new selectoption(picklist.getValue(), picklist.getLabel()));	
				}
			}else InterestRates.add(new selectoption(picklist.getValue(), picklist.getLabel()));
		}
		return InterestRates;
	}
	
	private Product2 getMinAndMaxInterestRateForProduct(ID ProductId){
		try{
			Program_Product_ASO__c ProgramProduct = [Select p.Product__r.Max_Interest_rate__c, 
														p.Product__r.Min_Interest_rate__c,
														p.Product__r.Full_Term__c 
													From Program_Product_ASO__c p where p.Id =:ProductId];
		
			if(ProgramProduct != null){
				CreditAssessment.Approved_Loan_Term__c = ProgramProduct.product__r.Full_Term__c;
				return ProgramProduct.product__r;
			}			
		}catch(QueryException ex){}		
		return null;
	}
	
	public PageReference Save(){
		try{
			CreditAssessment.Approved_Interest_Rate__c = ApprovedInterestRate;
			Database.update(CreditAssessment);
		}catch(DMLException ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
			return null;
		}
		return new Pagereference(ReturnURL);
	}
}