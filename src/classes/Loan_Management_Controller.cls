public class Loan_Management_Controller {
    private final static String endpointValue = '/api/LoanScheduleDetails';
    private final static String DATE_FORMAT_FRONT = 'dd/MM/yyyy';
    private final static String DATE_FORMAT_DWH = 'yyyy-MM-dd';
    private List<Opportunity> oppList;
    private Opportunity lastCreatedOppCopy;
    
    public string clientID {get;set;}
    public string clientName {get;set;}
    public List<Account> clientList {get;set;}
    public List<Loan_Ledger__c> loanList {get;set;}
    public List<String> availableTermValues {get;set;}
    Account a;
    List<Operation__c> currentOpList = new List<Operation__c>();
    public Operation__c currentOperation {get;set;}
    public Loan_Ledger__c lr {get;set;}
    public Decimal progress {get;set;}
    public ID AccountID{get;set;}    
    public Boolean isSearchedAccountLedgers {get;set;}
    public Boolean isSearchedProgramLedgers {get;set;}
    public String isCalculation {get;set;}
    public String screenSelected {get;set;}
    public String selectedProgram {get;set;}
    
    public boolean paymentReceived {get;set;}
    public boolean agreedByClient {get;set;}
    
    public String EventStartDate {get;set;}
    public String EventEndDate {get;set;}
    public String EventAmount {get;set;}
    public String EventLoanTerm {get;set;}
    public String EventProcessMethod {get;set;}
    public String EventAmountAllocation1 {get;set;}
    public String EventAmountAllocation2 {get;set;} 
    
    
    public String newEndDate {get;set;}    
    public String loanStartDate {get;set;}
    public String loanEndDate {get;set;}
    public Boolean waiveCharges {get;set;}
    public Boolean waiveVat {get;set;}
    public String maxHolidayDur {get;set;}
    public String notDays {get;set;}
        
    /****** Khurram Shahzad 05/02/16 LMS-144 ********/ 
    
    public string Borrowed_Ammount  {get; set;}  
    public string Outstanding_Amount    {get; set;}
    public string BB_Amount {get; set;} 
    //public string Event_Amount    {get; set;}
    //public string Event_Amount_Allocation1    {get; set;} 
    //public string Event_Amount_Allocation2    {get; set;} 
    public string Loan_Charges  {get; set;} 
    public string Loan_VAT  {get; set;} 
    //public string New_Repayment_Amount_PerInstallment {get; set;} 
    public string New_Total_Interest_Amount {get; set;} 
    public string New_Total_Principal_Amount    {get; set;} 
    public string Total_Amount  {get; set;} 
    //public string Total_Amount_Per_Installment    {get; set;} 
       
    
    public Loan_Management_Controller (){
        AccountID = ApexPages.currentPage().getParameters().get('accountID');
        screenSelected = ApexPages.currentPage().getParameters().get('screenSelected');
        isCalculation = ApexPages.currentPage().getParameters().get('calculation');
        system.debug('AccountID :'+AccountID);
        if (lr==null) {
            lr = new Loan_Ledger__c(NumAvailablePaymentHolidays__c =0);
            maxHolidayDur = '0';
            notDays = '0';
        }
        
        if(currentOpList == null) currentOpList = new List<Operation__c>();
        
        if(AccountID !=null) {
                lr = [SELECT Id, CurrencyIsoCode, LoanID__c,LoanID__r.Name, LoanStartDate__c, LoanEndDate__c, Borrowed_Amount__c, 
                      Outstanding_Amount__c, NewLoanEndDate__c, NumAvailablePaymentHolidays__c, Rules_Engine__c,Rules_Engine__r.Charges_waiver__c,
                      Rules_Engine__r.Max_payment_holiday_duration__c, Rules_Engine__r.Notification_days__c,Move_to_Suspension__c,
                      NewTotalPrincipalAmount__c, NewTotalInterestAmount__c, LoanCharges__c, LoanVAT__c,
                      NewRepaymentAmountPerInstallment__c, Account__c, Sign_Off_Date__c,Agreed_by_client__c,
                      EventStartDate__c, EventEndDate__c, EventAmount__c, EventProcessMethod__c, EventLoanTerm__c,
                      EventAmountAllocation1__c, EventAmountAllocation2__c,BB_Num__c,BB_Date__c,BB_Amount__c,
                      waiveCharges__c ,waiveVAT__c,Progress__c, Account__r.Name,
                      Rules_Engine__r.Repayment_method__c,
                      Total_Amount__c,Program_Product_ASO__r.Program__c,
                      Program_Product_ASO__r.Product__r.Schedule_Type__c, Program_Product_ASO__r.Product__r.Interest_Type__c,
                      Program_Product_ASO_Temp__c
                      FROM Loan_Ledger__c where Account__c = :AccountID and Status__c IN ('Disbursed', 'In Progress', 'Suspended', 'Paused')][0];
                     
            
            if(lr == null) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Loans Exist for this Account'));}
            
            isSearchedAccountLedgers = false;
            isSearchedProgramLedgers = false;
            maxHolidayDur = lr.Rules_Engine__r.Max_payment_holiday_duration__c != null ? lr.Rules_Engine__r.Max_payment_holiday_duration__c : '0';
             if(lr.Rules_Engine__r.Notification_days__c != null) notDays = lr.Rules_Engine__r.Notification_days__c;
            loanStartDate = lr.LoanStartDate__c != null ? lr.LoanStartDate__c.format(DATE_FORMAT_FRONT) : null; 
            loanEndDate = lr.LoanEndDate__c != null ? lr.LoanEndDate__c.format(DATE_FORMAT_FRONT) : null; 
            newEndDate = lr.NewLoanEndDate__c != null ? lr.NewLoanEndDate__c.format(DATE_FORMAT_FRONT) : null; 
            
            //EventStartDate = lr.EventStartDate__c != null ? lr.EventStartDate__c.format(DATE_FORMAT_FRONT) : null;
            //EventEndDate = lr.EventEndDate__c != null ? lr.EventEndDate__c.format(DATE_FORMAT_FRONT) : null;
            //EventAmount  = lr.EventAmount__c != null ? String.ValueOf(lr.EventAmount__c) : null;
            //EventLoanTerm = lr.EventLoanTerm__c != null ? lr.EventLoanTerm__c : null;
            //EventProcessMethod = lr.EventProcessMethod__c != null ? lr.EventProcessMethod__c : 'Keep Installment';
            //EventAmountAllocation1 = lr.EventAmountAllocation1__c != null ? String.ValueOf(lr.EventAmountAllocation1__c) : null;
            //EventAmountAllocation2 = lr.EventAmountAllocation2__c != null ? String.ValueOf(lr.EventAmountAllocation2__c) : null;
            
            if(isCalculation != 'true') {                 
                newEndDate = null;
                lr.NewLoanEndDate__c = null;
                lr.NewTotalPrincipalAmount__c = 0;
                lr.NewTotalInterestAmount__c = 0;
                lr.LoanCharges__c = 0;
                lr.LoanVAT__c = 0;
                lr.Total_Amount__c = 0;
                lr.EventStartDate__c = null;
                lr.waiveCharges__c = false;
                lr.waiveVAT__c = false;
                EventLoanTerm = 'null';
                EventProcessMethod = 'null';
            }
            
            if(isCalculation == 'true') {
                EventStartDate = lr.EventStartDate__c != null ? lr.EventStartDate__c.format(DATE_FORMAT_FRONT) : null;
                EventEndDate = lr.EventEndDate__c != null ? lr.EventEndDate__c.format(DATE_FORMAT_FRONT) : null;
                EventAmount  = lr.EventAmount__c != null ? String.ValueOf(lr.EventAmount__c) : null;
                EventLoanTerm = lr.EventLoanTerm__c != null ? lr.EventLoanTerm__c : 'null';
                EventProcessMethod = lr.EventProcessMethod__c != null ? lr.EventProcessMethod__c : 'null';
                EventAmountAllocation1 = lr.EventAmountAllocation1__c != null ? String.ValueOf(lr.EventAmountAllocation1__c) : null;
                EventAmountAllocation2 = lr.EventAmountAllocation2__c != null ? String.ValueOf(lr.EventAmountAllocation2__c) : null;
            }
            
            /****** Khurram Shahzad 05/02/16 LMS-144 ********/ 
            
            if(lr.Borrowed_Amount__c != null){
                Borrowed_Ammount =  this.AddTrailingZeroAfterDecimalPoint(lr.Borrowed_Amount__c.format());              
            }
            if(lr.Outstanding_Amount__c != null){               
                Outstanding_Amount = this.AddTrailingZeroAfterDecimalPoint(lr.Outstanding_Amount__c.format());
            }
            if(lr.BB_Amount__c != null){
                BB_Amount = this.AddTrailingZeroAfterDecimalPoint(lr.BB_Amount__c.format());
            }
            /*
            if(lr.EventAmount__c != null){
                Event_Amount = this.AddTrailingZeroAfterDecimalPoint(lr.EventAmount__c.format());
            }
            if(lr.EventAmountAllocation1__c != null){
                Event_Amount_Allocation1 = this.AddTrailingZeroAfterDecimalPoint(lr.EventAmountAllocation1__c.format());
            }
            if(lr.EventAmountAllocation2__c != null){
                Event_Amount_Allocation2 = this.AddTrailingZeroAfterDecimalPoint(lr.EventAmountAllocation2__c.format());
            }*/
            if(lr.LoanCharges__c != null){
                Loan_Charges = this.AddTrailingZeroAfterDecimalPoint(lr.LoanCharges__c.format());
            }
            if(lr.LoanVAT__c != null){
                Loan_VAT = this.AddTrailingZeroAfterDecimalPoint(lr.LoanVAT__c.format());
            }
            /*
            if(lr.NewRepaymentAmountPerInstallment__c != null){
                New_Repayment_Amount_PerInstallment = this.AddTrailingZeroAfterDecimalPoint(lr.NewRepaymentAmountPerInstallment__c.format());
            }*/
            if(lr.NewTotalInterestAmount__c != null){
                New_Total_Interest_Amount = this.AddTrailingZeroAfterDecimalPoint(lr.NewTotalInterestAmount__c.format());
            }
            if(lr.NewTotalPrincipalAmount__c != null){
                New_Total_Principal_Amount = this.AddTrailingZeroAfterDecimalPoint(lr.NewTotalPrincipalAmount__c.format());
            }
            if(lr.Total_Amount__c != null){
                Total_Amount = this.AddTrailingZeroAfterDecimalPoint(lr.Total_Amount__c.format());
            }
            /*
            if(lr.Total_Amount_Per_Installment__c != null){
                Total_Amount_Per_Installment = this.AddTrailingZeroAfterDecimalPoint(lr.Total_Amount_Per_Installment__c.format());
            }*/                      
            
            /****** Khurram Shahzad 05/02/16 LMS-144 ********/
            

            waiveCharges = lr.waiveCharges__c;
            waiveVat = lr.waiveVAT__c;            
           
        currentOpList = [Select Id,Status__c From Operation__c Where Id = :lr.LoanID__c Limit 1];
        if(!currentOpList.isEmpty()){
                currentOperation = currentOpList[0];
        }
                system.debug('lr:' + lr);
        }
        getAvailableLoanTermFromProgram();
    }
   
    /****** Khurram Shahzad 05/02/16 LMS-144 ********/     
    
    private string AddTrailingZeroAfterDecimalPoint(string NumberString){
        if(!NumberString.contains('.')){
            NumberString += '.00'; 
        }
        return NumberString;
    } 
   
    /****** Khurram Shahzad 05/02/16 LMS-144 ********/ 
    
    public void getClients () {
        isSearchedAccountLedgers = true;
        AccountID = null;
        if(clientList==null) clientList = new List<Account>();
        system.debug('clientID:'+clientID +' clientName:'+clientName);
        if(clientID!=null&&clientID!='') {
            String searchClientID = '%' + clientID + '%';
            clientList = [SELECT Id,Name,Client_ID__c  FROM Account WHERE Type = 'Client' AND Client_ID__c LIKE :searchClientID Order By Name];
            //clientID = null;
            system.Debug('clientList:' + clientList);
            
        }
        else if(clientName!=null&&clientName!='') {
            String searchClientName = '%' + clientName + '%';
            clientList = [SELECT Id,Name,Client_ID__c  FROM Account WHERE Type = 'Client' AND Name LIKE :searchClientName Order By Name];
            //clientName = null;
            
            system.Debug('clientList:' + clientList);
        }
    }
    public List<SelectOption> getProgramsWithLedger(){
        List<SelectOption> optns = new List<SelectOption>();
        Map <Id,String> progNameMap = new Map <Id,String>();
        
        List<Loan_Ledger__c> ledg = new List<Loan_Ledger__c>();
        ledg = [Select LoanID__r.Program_Product_ASO__r.Program__c, LoanID__r.Program_Product_ASO__r.Program__r.Name From Loan_Ledger__c Where  LoanID__r.Program_Product_ASO__c != null];
        Map<ID,String> programNameMap = new Map <ID,String>();
        
        for(Loan_Ledger__c tempLedger : ledg){
            programNameMap.put(tempLedger.LoanID__r.Program_Product_ASO__r.Program__c, tempLedger.LoanID__r.Program_Product_ASO__r.Program__r.Name);
            //optns.add(new SelectOption(tempLedger.LoanID__r.Program_Product_ASO__r.Program__c,tempLedger.LoanID__r.Program_Product_ASO__r.Program__r.Name));
        } 
        
        for(ID tempProgID : programNameMap.keySet()){
            optns.add(new SelectOption(tempProgID,programNameMap.get(tempProgID)));
        }
        
        return optns;
    }
    
    public void getLedgerFromProgram (){
        
        isSearchedProgramLedgers = true;
        loanList = new List<Loan_Ledger__c>();
        
                system.debug('selectedProgram:'+selectedProgram);
        
        loanList = [Select Id,Account__c,Account__r.Name,LoanEndDate__c,Outstanding_Amount__c,LoanID__c, LoanID__r.Name, LoanID__r.Status__c, LoanID__r.Loan_Disbursed_Date__c,
                    LoanID__r.Total_Amount_Repayable__c, Total_Amount_Per_Installment__c,BB_Num__c 
                    From Loan_Ledger__c Where LoanID__r.Program_Product_ASO__c != '' And LoanID__r.Program_Product_ASO__r.Program__c = :selectedProgram ];
    }
    
    public void getAvailableLoanTermFromProgram(){ 
        availableTermValues = new List<String>();
        List<SelectOption> optns = new List<SelectOption>();
        List<Program_Product_ASO__c> prods = new List<Program_Product_ASO__c>();
        prods = [Select Product__r.Term__c, Product__r.Full_Term__c 
                 From Program_Product_ASO__c 
                 Where Program__c = :lr.Program_Product_ASO__r.Program__c And Program__r.isActive__c = true 
                 And Product__r.Schedule_Type__c = :lr.Program_Product_ASO__r.Product__r.Schedule_Type__c 
                 And Product__r.Interest_Type__c = :lr.Program_Product_ASO__r.Product__r.Interest_Type__c];
        for(Program_Product_ASO__c tempAso : prods){ 
            optns.add(new SelectOption(tempAso.Product__r.Term__c,tempAso.Product__r.Full_Term__c));
            availableTermValues.add(tempAso.Product__r.Term__c);
        }         
        //return optns;
    }    
    public Pagereference calculation (){
        system.debug('Manual Calculation');
        String Headers;
        String ResponseString; 
        System.HttpRequest request = new System.HttpRequest();
        request.setHeader(CRMS_Constants.CONTENT_TYPE, CRMS_Constants.CONTENT_TYPE_JSON); 
        request.setMethod('GET');  
      
        system.debug('Ellie');
        system.debug(EventProcessMethod);
              
        if(screenSelected == 'debtSection') {
            EventStartDate = Datetime.now().format(DATE_FORMAT_FRONT);
            EventEndDate = ''; 
        } 
        
        if(screenSelected == 'bounceBackSection')
        {
            EventStartDate = lr.BB_Date__c.format(DATE_FORMAT_FRONT);
            EventAmount = String.valueOf(lr.BB_Amount__c);
        }
        
        EventStartDate = formatDateForDWH(EventStartDate);
        if(EventEndDate != '') EventEndDate = formatDateForDWH(EventEndDate);
        String getParams = '?LoanId='+lr.LoanID__c+
            '&InputFromScreen='+screenSelected+
            '&EventStartDate='+EventStartDate +
            '&EventEndDate='+EventEndDate +
            '&EventAmount='+EventAmount+
            '&LoanTerm='+EventLoanTerm+
            '&EventProcessMethod='+EventProcessMethod.replaceAll(' ', '%20')+
            '&PaymentReceived='+paymentReceived+
            '&PrincipalAllocation='+EventAmountAllocation1+
            '&InterestAllocation='+EventAmountAllocation2;  
        
        request.setEndpoint(Label.DWH_Endpoint+endpointValue+getParams);
        request.setTimeout(CRMS_Constants.CALLOUT_DEFAULT_TIMEOUT);
        request.setHeader(CRMS_Constants.REQUEST_HEADER_DATE, CRMS_Util.generateDateForAuth());
        request.setHeader(CRMS_Constants.REQUEST_HEADER_AUTH, CRMS_Util.generateAuthKey(CRMS_Constants.CALLOUT_METHOD_GET, endpointValue));
        
        system.debug('RequesT:'+request);
        system.debug('RequesT toString:'+request.toString());
        System.HttpResponse response;
        
        if(!TEST.isRunningTest()) {
            response = new System.Http().send(request);      
            calculationResponse(response);}

        Pagereference pr = new Pagereference('/apex/Loan_Management');
        pr.getParameters().put('accountID',accountID);
        pr.getParameters().put('screenSelected',screenSelected);
        pr.getParameters().put('calculation','true');
        pr.setRedirect(true);
        return pr;
    }
    public void calculationResponse(System.HttpResponse response){
      system.debug('Response body:'+response);

       if(response.getStatus() == 'OK'){
           Map<String, Object> m =  (Map<String, Object>)  JSON.deserializeUntyped(response.getBody()); 
           String responseResultJSON = JSON.serialize(m.get('results'));
           system.debug('responseResultJSON:' + responseResultJSON);
           if(responseResultJSON == 'null') {               
                String responseResultJSON1 = JSON.serialize(m.get('message'));
               ApexPages.message error = new ApexPages.Message(ApexPages.Severity.ERROR, 'Http request failed with: ' + responseResultJSON1);
               ApexPages.addMessage(error);
           }
           responseResultJSON = responseResultJSON.removeStart('[').removeEnd(']');
           Map<String, Object> responseResult =  (Map<String, Object>)  JSON.deserializeUntyped(responseResultJSON); 
           //system.debug('responseResult:' + responseResult);
           
           String result = (String) responseResult.get('result'); 
           system.debug('result:'+result);
           if(result != 'Error'){
           Decimal loanChargesAmountFromDWH = (Decimal) responseResult.get('loanChargesAmount'); 
           Decimal loanVATAmountFromDWH = (Decimal) responseResult.get('loanVATAmount'); 
           Decimal newInterestAmountFromDWH = (Decimal) responseResult.get('newInterestAmount'); 
           Decimal newPrincipalAmountFromDWH = (Decimal) responseResult.get('newPrincipalAmount'); 
           String newEndDateFromDWH = String.ValueOf(responseResult.get('newEndDate'));
           String newProgramProductID = String.valueOf(responseResult.get('programProductSFId'));
            if(newEndDateFromDWH != null) {newEndDateFromDWH = newEndDateFromDWH.removeEnd('T00:00:00');
                                              lr.NewLoanEndDate__c =  System.Date.valueOf(newEndDateFromDWH); }
           if(loanChargesAmountFromDWH != null) lr.LoanCharges__c = loanChargesAmountFromDWH;
           if(loanVATAmountFromDWH != null) lr.LoanVAT__c = loanVATAmountFromDWH;
           if(newInterestAmountFromDWH != null) lr.NewTotalInterestAmount__c  = newInterestAmountFromDWH;
           if(newPrincipalAmountFromDWH != null) lr.NewTotalPrincipalAmount__c  = newPrincipalAmountFromDWH;
           
           lr.Agreed_by_Client__c = false;
           lr.Sign_Off_Date__c = null;    
           lr.DWH_Status__c = null; 
               
           lr.EventStartDate__c = EventStartDate !='' ? System.Date.valueOf(EventStartDate) : null;
           lr.EventEndDate__c = EventEndDate !='' ? System.Date.valueOf(EventEndDate) : null;
           lr.EventAmount__c = EventAmount != '' ? Decimal.valueOf(EventAmount) : null;
           lr.EventLoanTerm__c = EventLoanTerm;
           lr.EventProcessMethod__c = EventProcessMethod;
           lr.EventAmountAllocation1__c = EventAmountAllocation1 != '' ? Decimal.valueOf(EventAmountAllocation1) : null;
           lr.EventAmountAllocation2__c = EventAmountAllocation2 != '' ? Decimal.valueOf(EventAmountAllocation2) : null;
           lr.Program_Product_ASO_Temp__c = newProgramProductID;    
           lr.Total_Amount__c = lr.NewTotalPrincipalAmount__c + lr.NewTotalInterestAmount__c + lr.LoanCharges__c + lr.LoanVAT__c;
           lr.waiveCharges__c = waiveCharges;
           lr.waiveVAT__c = waiveVat;
           system.debug('After Calculation LR:'+lr); 
           update lr;               
           
       } else {            
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error on retrieving the data');
           ApexPages.addMessage(myMsg);
       }
       }

    }
    public PageReference signOff (){
        if(agreedByClient == true) {            
           lr.InputFromScreen__c = screenSelected;
           lr.Agreed_by_client__c = agreedByClient;
           lr.Sign_Off_Date__c = Date.today();
            
            if (screenSelected == 'earlyRepaymentSection') {
                lr.EventAmount__c = lr.NewTotalPrincipalAmount__c;
            } else if (screenSelected == 'restructureSection' || screenSelected == 'topUpSection'){
                cloneOpportunity();
            } else if (screenSelected == 'bounceBackSection'){
                handleBounceBackDetails();
            }
            
           update lr;
        }
        
        Pagereference pr = new Pagereference('/apex/Loan_Management');
        pr.getParameters().put('accountID',accountID);
        pr.getParameters().put('screenSelected','approvalSection');
        pr.setRedirect(true);
        return pr;
    }
    public PageReference moveToSuspension (){
        
        lr.Move_to_Suspension__c = true;
        lr.InputFromScreen__c = 'debtSection';
        lr.Sign_Off_Date__c = Date.today();
        lr.Agreed_by_client__c = true;
        lr.Status__c = 'Suspended';
        lr.EventStartDate__c = Date.today();
        lr.EventEndDate__c = null;
        
        update lr;
        
        
        if(currentOperation != null) {
            currentOperation.Status__c = 'Suspended';
            update currentOperation;
        }
        
        Pagereference pr = new Pagereference('/apex/Loan_Management');
        pr.getParameters().put('accountID',accountID);
        pr.getParameters().put('screenSelected','debtSection');
        pr.setRedirect(true);
        return pr;
    }
    private void cloneOpportunity () {
        oppList = new List <Opportunity>();
        oppList = [SELECT PartnerAccountId, SyncedQuoteId,   Monthly_Interest__c,  
                   Credit_Check_Status__c, Principal_Daily_Repayment__c, Introducer__c, Loan_Term_In_Months__c, No_of_Repayments_Daily__c, Interest_Daily_Repayment__c,
                   Total_Amount_Repayable_Daily__c, Quotation_Total_Repaid_Daily__c, Rent_Electronic_Sales__c, Credit_File_Disclosure__c, Data_Protection_Act_Declaration__c, 
                   GAA_Declaration__c, Is_Cloned__c, Loan_Term_In_Days__c, Lead_Owner_Id__c, Loan_Purpose__c, Profile_Name__c, Conditional_Approval_Multiplier__c,
                   Ave_Monthly_Sales__c, Monthly_Rental__c, Interest_Weekly_Repayment__c, Principal_Weekly_Repayment__c, No_of_Repayments_Weekly__c, 
                   Landlord_Contact_Details__c, Total_Amount_Repayable_Weekly__c, Country__c, Generate_Application_Form__c, Quotation_Total_Repaid_Weekly__c, 
                   Has_any_Relationship_with_AMP_Directors__c, Average_Monthly_Card_Sales__c, Name_of_AMP_Personnel__c, Job_Title__c, Relationship_to_the_Applicant__c,
                   Agreed_that_no_Relationship_Exists__c,  Experian_Credit_Score__c, Signed_Application_Form_Received__c, CSE_Credit_Score__c, 
                   Additional_Information_Required__c, Person_Account__c, Additional_Information_Details__c, Additional_Information_Satisfactory__c, Offer_Presented_to_Client__c,
                   Revised_Offer_Status__c,  Primary_Contact_Business_Position__c, Signed_Application_Form_Received_Date__c, 
                   Owner_Profile_Name__c, Application_Form__c, DWH_Import__c, DWH_Last_Sync__c, DWH_Status__c, Application_Number__c, Offer_Status__c, 
                   Application_ID2__c, Application_Form_Completed__c, IsClient__c, RecType_Name__c, Opportunity_Task_Created__c, Requested_Loan_Term__c, 
                   Additional_Information_Narrative__c, Application_Email_Sent__c, Test_date__c, Partner_Website_Tracker__c, Total_Repayment__c, Annual_Calculation__c, 
                   Number_of_Employees__c, Number_of_Outlets__c, FOC__c, Final_Decision_Approved__c, Final_Decision_Rejected__c, Disbursed_Date__c, 
                   Conditional_Offer_Amount__c, LeadID__c, Opportunity_Account_Name__c, CountryISO__c, Primary_Contact__c, Primary_Contact_Email__c, 
                   Primary_Contact_Phone__c, Program__c,  
                    Program_Product_ASO__c, Loan_Term__c, Entity_Type__c, Loan_Interest__c, Loan_Frequency__c, Type, LeadSource, 
                   IsClosed, IsWon, CloseDate, Amount, StageName, Description, Name, RecordTypeId, AccountId, IsDeleted, Id, Probability, ExpectedRevenue, 
                   TotalOpportunityQuantity, NextStep, CurrencyIsoCode, CampaignId 
                   From Opportunity 
                   Where AccountId = :AccountID 
                   Order By CreatedDate Desc
                   Limit 1];
        
        if(!oppList.isEmpty()) lastCreatedOppCopy = oppList[0];
        List <RecordType> oppApplicationRecTypes = new List<RecordType>();
        oppApplicationRecTypes = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType Where SobjectType  = 'Opportunity' And Name Like '%Application%'];
        for(RecordType rt : oppApplicationRecTypes){
            if(rt.name.contains(lastCreatedOppCopy.Country__c)){
                lastCreatedOppCopy.RecordTypeId = rt.Id;
                break;
            }
        }
        lastCreatedOppCopy.id = null;
        
        Integer appID = Integer.valueOf(lastCreatedOppCopy.Application_ID2__c);
        appID ++;
        lastCreatedOppCopy.Application_ID2__c = String.valueOf(appID);
        
        if(lr.Program_Product_ASO_Temp__c != null) lastCreatedOppCopy.Program_Product_ASO__c = lr.Program_Product_ASO_Temp__c;
        lastCreatedOppCopy.Amount = lr.NewTotalPrincipalAmount__c;
        lastCreatedOppCopy.StageName = 'In Progress';
        if(lr.InputFromScreen__c == 'restructureSection') {
            lastCreatedOppCopy.Type = 'Restructure';
            currentOperation.Status__c = 'Paused';
            lr.Status__c = 'Paused';
        }else if (lr.InputFromScreen__c == 'topUpSection'){
            lastCreatedOppCopy.Type = 'Top-up';
            currentOperation.Status__c = 'Paused';
            lr.Status__c = 'Paused';
        }
        
        insert lastCreatedOppCopy;
        update currentOperation;
        update lr;
    }
    
    private String formatDateForDWH(String inputDate){
       String resultDate;
       String[] newDateElements = inputDate.split('/');
       resultDate = newDateElements[2]+'-'+newDateElements[1]+'-'+newDateElements[0];
        
       return resultDate;
    }
    
    private void handleBounceBackDetails(){              
        lr.EventStartDate__c = lr.BB_Date__c;
        lr.EventAmount__c = lr.BB_Amount__c;
        lr.EventProcessMethod__c = lr.Rules_Engine__r.Repayment_method__c != null ? lr.Rules_Engine__r.Repayment_method__c : 'Add to the end of the term';
        lr.BB_Date__c = null;
        lr.BB_Amount__c = null;
        lr.isTaskCreated__c = false;
        List<Task> pendingTasks = new List<Task>();
        pendingTasks = [SELECT Id, Status FROM Task Where WhatId = :lr.LoanID__c And Priority = 'High'];
        for(Task tempTask : pendingTasks){
            tempTask.Status = 'Completed';
        }
        update pendingTasks;
        
    }  
}