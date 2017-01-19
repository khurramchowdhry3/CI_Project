public class Loan_DisbursalSummary_Controller {
    public Operation__c r { get; set; }
    public Credit_Assessment__c ca { get; set; }
    public Loan_Management__c rules { get; set; }
    public Boolean isError { get; set; }
    public string AdditionalInformation    { get; set; }
    private LM_LoanInitialParametersResult params { get; set; }
    public string ReturnURL	{get; set;}
    public string Disbursal_Decision	{get; set;}
    public integer difference {get; set;}{
    	difference = 0;
    }
    private integer GracePeriod = 0;
    
     
    public Loan_DisbursalSummary_Controller (ApexPages.StandardController stdController) 
    {        
        ID recID = ApexPages.currentPage().getParameters().get('id');
		ReturnURL = ApexPages.currentPage().getParameters().get('retURL');
		if(ReturnURL == null)
	    	ReturnURL = '/'+recID;
        
        this.r = [SELECT Id, 
        			Name, 
        			RecordType.Name, 
        			Owner.Name,        			
        			Disbursal_Type__c,
        			Disbursal_More_Info__c,
        			Interest_Amount__c,
        			Outstanding_Fees__c,
        			Loan_Amount__c,
        			Principal_Daily_Repayments__c,
        			Loan_Term__c,
        			Interest_Daily_Repayment__c,
        			Total_Daily_Repayment__c,
        			Monthly_Interest__c,
        			Total_Amount_Repayable__c,
        			Frequency_of_Collection__c,
        			Advanced_Notification_Sent_Date__c,
        			Generate_Advanced_Notification_Date__c,
        			Generate_Welcome_Pack_Date__c,
        			DD_Reference_number__c, 
        			Advanced_Notification_Sent_to_Customer__c,
        			Welcome_Pack_Sent_Date__c,
        			Flag_for_DDI_Batch_File__c,
        			DDI_Batch_File_Date__c,
        			Ready_for_Finance_Approval__c,
        			Loan_Disbursed__c,
        			Payment_Received__c,
        			Final_Collection_Date__c,
        			Repayment_Per_Installment__c,
        			Actual_Repayment_Per_Installment__c,
        			DWH_Status__c,
        			DWH_Last_Sync__c,
        			Welcome_Pack_Sent_to_Customer__c,
        			Opportunity__r.id, 
        			Opportunity__r.Signed_Application_Form_Received_Date__c, 
        			Opportunity__r.Signed_Application_Form_Received__c, 
        			Opportunity__r.Type, 
                  	Opportunity__r.Related_Operation__c, 
                  	Loan_Disbursed_Date__c, 
                  	First_Repayment_Date__c, 
                  	Final_Repayment_Date__c, 
                  	Date_of_Final_Collection__c, 
                  	Number_of_Repayments__c, 
                  	Actual_Interest_Amount__c, 
                  	Loan_Outstanding_Interest__c, 
                  	Actual_Principal_Amount__c, 
                  	Loan_Outstanding_Principal__c, 
                  	Actual_Number_of_Repayments__c, 
                  	Remaining_Number_of_Repayments__c, 
                  	Contract_Signed_and_Received__c, 
                  	Status__c,
                  	Final_Decision__c,
                  	Final_Decision_Date__c, 
                  	Contract_Signed_Received_Date__c, 
                  	Flag_for_DDM_Batch_File__c, 
                  	DDM_Batch_File_Date__c, 
                  	DD_Mandate_Acceptance_Date__c, 
                  	DD_Mandate_Acceptance_Received__c,
                  	Disbursal_Approval_Date__c,
                  	Account__c, 
                  	Disbursal_Approve__c,                  	
                  	Disbursal_Approved_By__c,
                  	Additional_Information_Narrative__c,
                  	Disbursal_Reject_Reason__c,
                  	Final_Disburse_Decision__c,
                 	Program_Product_ASO__c, 
                 	Program_Product_ASO__r.Product__r.Term__c, 
                 	Program_Product_ASO__r.Association_Name__c, 
                 	CreatedByID,
                 	LastModifiedById,
                 	CreatedDate,
                 	LastModifiedDate 
                 FROM Operation__c Where id = :recID][0];
        
        if(r.Loan_Disbursed_Date__c == null)
        	r.Loan_Disbursed_Date__c = Date.Today();
        
        AdditionalInformation = r.Additional_Information_Narrative__c;
        Disbursal_Decision = r.Final_Decision__c;
        
        ca = [SELECT Id, Approved_Loan_Amount__c, AMP_Credit_Score__c, Approved_By__c, Approved_Loan_Term__c  
              FROM Credit_Assessment__c 
              WHERE Opportunity__c = :r.Opportunity__r.id][0];
        
        List<Loan_Management__c> reList = [Select ID, Max_number_of_payment_holidays__c, Grace_period__c, Notification_days__c 
                                            From Loan_Management__c 
                                            Where Program_Product_ASO__c = :r.Program_Product_ASO__c];
        if(reList.isEmpty() ) 
        {
            isError = true;             
            //r.adderror('Rules Engine not Found!');
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Rules Engine not Found!'));
        }
        else
        {
            rules = reList[0];
        }        
              
         system.debug('r.First_Repayment_Date__c >>> '+r.First_Repayment_Date__c);        
        if(r.First_Repayment_Date__c == null)
        	this.CalculateRepaymentBegins(); 
    }
    
    public void CalculateRepaymentBegins(){    	
    	Date RepaymentDate;    	
    	RepaymentDate =  r.First_Repayment_Date__c = r.Loan_Disbursed_Date__c;    	
    	if(rules != null && rules.Grace_period__c != null){
    		RepaymentDate = RepaymentDate.addDays(integer.valueOf(rules.Grace_period__c)); 
        	GracePeriod = integer.valueOf(rules.Grace_period__c);
    	}	
    	
    	system.debug('GracePeriod >>> '+GracePeriod); 	
    	system.debug('RepaymentDate >>> '+RepaymentDate);
    	   
        Date StartOfWeek = r.Loan_Disbursed_Date__c.toStartofWeek();
        system.debug('StartOfWeek >>> '+StartOfWeek); 
        integer NumOfDays =  StartOfWeek.daysBetween(RepaymentDate);       
        DateTime WeekDT = DateTime.newInstance(StartOfWeek, Time.newInstance(0, 0, 0, 0));
        String StartOfWeekDay = WeekDT.format('EEEE');
        
        system.debug('NumOfDays >>> '+NumOfDays); 
        
        if(StartOfWeekDay == 'Sunday' && GracePeriod > 1 && (NumOfDays > 5 || NumOfDays == 0)){     	
        	r.First_Repayment_Date__c = r.First_Repayment_Date__c.addDays(GracePeriod + 2);
        	GracePeriod += 2;	        	
        }else if(StartOfWeekDay == 'Monday' && GracePeriod > 1 && (NumOfDays > 4 || NumOfDays == 0)){	        	
        	r.First_Repayment_Date__c = r.First_Repayment_Date__c.addDays(GracePeriod + 2);
        	GracePeriod += 2;	        	
        }else {
        	r.First_Repayment_Date__c = RepaymentDate;
        }
                
        difference = Date.Today().daysBetween(r.First_Repayment_Date__c);
        system.debug('difference >>> '+difference);
        
        system.debug('r.First_Repayment_Date__c Final >>> '+r.First_Repayment_Date__c); 
    }  
            
    private string OperationStatus(string oppType)
    {
        if (oppType == 'Restructure')
            return 'Restructured';
        if (oppType == 'Renewal')
            return 'Renewed';
        if (oppType == 'Top-up')
            return 'Topped-Up'; 
        
        return '';
    }
    
    public pagereference approve(){
        try{
    		 if(r.Final_Decision__c == 'Approved' 
    		 	&& (r.Final_Decision_Date__c == null
    		 		|| r.Disbursal_Approval_Date__c == null
    		 		|| r.First_Repayment_Date__c == null
    		 		|| r.Disbursal_Approved_By__c == null
    		 		|| r.Loan_Disbursed__c == false
    		 		|| r.Disbursal_Approve__c == false)){
	        	r.Disbursal_Approve__c = true;
		        r.Loan_Disbursed__c = true;		       
		        r.Final_Decision_Date__c = Date.today();
		        r.Disbursal_Approval_Date__c = Date.today();
		        r.Status__c = 'Disbursed';
		        
		        if(r.Opportunity__r.Type == 'Restructure' || r.Opportunity__r.Type == 'Renewal' || r.Opportunity__r.Type == 'Top-up')
		        {
		            Operation__c oldOperation = new Operation__c(Id = r.Opportunity__r.Related_Operation__c, Status__c = OperationStatus(r.Opportunity__r.Type));
		            //update oldOperation;
		        }        
		        
		        calloutLoanInitialParameters();
		              
		        //r.First_Repayment_Date__c = CRMS_Util.AddBusinessDays(r.Loan_Disbursed_Date__c, Integer.valueOf(rules.Grace_period__c));
		        //r.Final_Repayment_Date__c = CRMS_Util.AddBusinessDays(r.Loan_Disbursed_Date__c, Integer.valueOf(r.Number_of_Repayments__c));
		        
		      	System.debug('ELL2');
		        System.debug(params.FirstRepaymentDate);
		        
		        if(params.Result != 'Error' && params.Result != null){
			        //r.First_Repayment_Date__c = Date.valueOf(params.FirstRepaymentDate);
			        r.Final_Repayment_Date__c = Date.valueOf(params.FinalRepaymentDate);
			        r.Date_of_Final_Collection__c = CRMS_Util.AddBusinessDays(r.Final_Repayment_Date__c, -1*Integer.valueOf(rules.Notification_days__c));
			        r.Actual_Interest_Amount__c = params.interestAmount;
			        r.Loan_Outstanding_Interest__c = params.interestAmount;
			        r.Interest_Amount__c = params.interestAmount;
			        r.Actual_VAT_Amount__c = params.vatAmount;
			        r.Loan_Outstanding_VAT_Amount__c = params.vatAmount;
			        r.VAT_Amount__c = params.vatAmount;
			        r.Repayment_Per_Installment__c = params.repaymentPerInstallment;
			        r.Actual_Repayment_Per_Installment__c = params.repaymentPerInstallment;
			        
			        r.Loan_Amount__c = params.principalAmount;
			        r.Actual_Principal_Amount__c = params.principalAmount;
			        r.Loan_Outstanding_Principal__c = params.principalAmount;
			        r.Total_Amount_Repayable__c = (params.principalAmount == null ? 0 : params.principalAmount)  + (params.interestAmount == null ? 0 : params.interestAmount);
			        r.Actual_Number_of_Repayments__c = params.repaymentsNum;
			        r.Remaining_Number_of_Repayments__c = params.repaymentsNum;			        
		        }else {r.adderror(params.Reason); return null;}        		
		       	        
		        /*
		        r.First_Repayment_Date__c = Date.valueOf(params.FirstRepaymentDate);
		        r.Final_Repayment_Date__c = Date.valueOf(params.FinalRepaymentDate);
		        r.Date_of_Final_Collection__c = CRMS_Util.AddBusinessDays(r.Final_Repayment_Date__c, -1*Integer.valueOf(rules.Notification_days__c));
		        r.Actual_Interest_Amount__c = params.ActualInterestAmount;
		        r.Loan_Outstanding_Interest__c = params.RemainingInterestAmount;
		        r.Actual_Principal_Amount__c = params.ActualPrincipalAmount;
		        r.Loan_Outstanding_Principal__c = params.RemainingPrincipalAmount;
		        r.Total_Amount_Repayable__c = params.ActualPrincipalAmount + params.ActualInterestAmount;
		        r.Actual_Number_of_Repayments__c = params.ActualRepaymentsNum;
		        r.Remaining_Number_of_Repayments__c = params.RemainingRepaymentsNum;
		        
		        */
		        
	        }else if(r.Final_Decision__c == 'Rejected' && r.Final_Decision_Date__c == null){
	        	r.Status__c = 'Rejected';
	        	r.Final_Decision_Date__c = Date.Today();
	        	r.Loan_Disbursed_Date__c = null;
	        	r.First_Repayment_Date__c = null;	        	
	        } 
	        
	        update r;        	
        }catch(Exception ex){
        	if(ex.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION){
        		r.adderror('Reject Reason cannot be blank');
        	}else r.adderror(ex.getmessage());
        	return null;
        }        
	    return new Pagereference(ReturnURL);
    }
    
    public PageReference save() {
        update r;
        Pagereference pr = new Pagereference('/apex/Loan_DisbursalSummary');
        pr.getParameters().put('ID',r.id);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference SaveAndNew(){
    	return null;
    }
    
    public PageReference info(){
        r.Disbursal_More_Info__c = true;
        r.Additional_Information_Narrative__c = AdditionalInformation;
        update r;        
        Pagereference pr = new Pagereference('/apex/Loan_DisbursalSummary');
        pr.getParameters().put('ID',r.id);
        pr.setRedirect(true);
        return pr;
    }    
    public PageReference cancel(){
        PageReference pr = new PageReference('/apex/Loan_Management_Rev');
        pr.setRedirect(true);
        return pr;
    }
    
    private void calloutLoanInitialParameters()
    {       
        String Headers;
        String ResponseString; 
        System.HttpRequest request = new System.HttpRequest();
        request.setHeader(CRMS_Constants.CONTENT_TYPE, CRMS_Constants.CONTENT_TYPE_JSON); 
        request.setMethod(CRMS_Constants.CALLOUT_METHOD_GET);
                
        request.setEndpoint(Label.DWH_Endpoint + LMS_Constants.loanParamsEndPoint + '?LoanId='+r.Id);
        request.setTimeout(CRMS_Constants.CALLOUT_DEFAULT_TIMEOUT);
        request.setHeader(CRMS_Constants.REQUEST_HEADER_DATE, CRMS_Util.generateDateForAuth());
        request.setHeader(CRMS_Constants.REQUEST_HEADER_AUTH, CRMS_Util.generateAuthKey(CRMS_Constants.CALLOUT_METHOD_GET, LMS_Constants.loanParamsEndPoint));
        
        System.HttpResponse response;
        
        if(!TEST.isRunningTest())
        {
            response = new System.Http().send(request);      
            processResponse(response);
        }
    }
    
    public void processResponse(System.HttpResponse response)
    {
        System.debug('ELLIE');
        System.debug(response);
        
       if(response.getStatus() == 'OK')
       {
           Map<String, Object> m =  (Map<String, Object>)JSON.deserializeUntyped(response.getBody()); 
           String responseResultJSON = JSON.serialize(m.get('results'));
           System.debug(responseResultJSON);           
           params = ((List<LM_LoanInitialParametersResult>)JSON.deserialize(responseResultJSON, List<LM_LoanInitialParametersResult>.class))[0];
           system.debug(params);
           if(responseResultJSON == 'null')
           {               
               responseResultJSON = JSON.serialize(m.get('message'));
               r.adderror('Http request failed with: ' + responseResultJSON);
               //ApexPages.message error = new ApexPages.Message(ApexPages.Severity.ERROR, 'Http request failed with: ' + responseResultJSON);
               //ApexPages.addMessage(error);
           }
           else if(params.Result == 'Error')
           {
               r.adderror(params.Reason);
               //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, params.Reason);
               //ApexPages.addMessage(myMsg);       
           }
       }
       else{
           r.adderror('Http request failed');
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Http request failed');
           //ApexPages.addMessage(myMsg);
       }
    }
}