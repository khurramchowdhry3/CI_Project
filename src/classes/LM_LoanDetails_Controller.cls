public class LM_LoanDetails_Controller 
{
    public Id recId { get; set; }
    public Operation__c o { get; set; }
    public Loan_Management__c rules { get; set; }    
    public Decimal TotalDisbursed    {get; set;}{
        TotalDisbursed = 0;
    }
    public Boolean IsResumeActive {get; set;}
    
    public LM_LoanDetails_Controller()
    {
        recId = ApexPages.currentPage().getParameters().get('Id');
        o = [Select id, name, Program_Product_ASO__c, Program_Product_ASO__r.Program_Name__c, Program_Product_ASO__r.Product_Name__c, Loan_Disbursed_Date__c, First_Repayment_Date__c,
                Monthly_Interest__c,Loan_Amount__c, Interest_Amount__c, VAT_Amount__c, Status__c, Final_Repayment_Date__c, Actual_Number_of_Repayments__c, Remaining_Number_of_Repayments__c, Actual_Interest_Amount__c, 
                Repayment_Per_Installment__c,Actual_VAT_Amount__c,Actual_Repayment_Per_Installment__c,Actual_Principal_Amount__c, Number_of_Repayments__c, No_Bounce_Backs__c, Number_Payment_Holidays__c, Loan_Outstanding_Principal__c,
                Total_Amount_Repayable__c, Total__c, Loan_Outstanding_Interest__c, Loan_Outstanding_VAT_Amount__c, Outstanding_Fees__c, Outstanding_Fees_VAT__c, Account__r.Name, Opportunity__c, Disbursal_Approve__c, 
                Program_Product_ASO__r.Program__c, Program_Product_ASO__r.Product__r.Schedule_Type__c, Program_Product_ASO__r.Product__r.Interest_Type__c, Program_Product_ASO__r.Product__r.Interest_Rate__c,
             (Select id, Name, Event_Type__c, Event_Amount__c, IsApproved__c, Event_Date__c, Event_End_Date__c, Notes__c, Approval_date__c, ApprovedBy__c, IsActive__c, Effective_Date__c,
                    Operation__r.Program_Product_ASO__c, Operation__r.First_Repayment_Date__c
              From Loan_Management_Events__r Order By Event_Date__c Desc, Approval_date__c Desc)
             From Operation__c Where Id =:recId][0];
                          
           
           TotalDisbursed = (o.Loan_Amount__c == null ? 0 : o.Loan_Amount__c)  + 
           					(o.Interest_Amount__c == null ? 0 : o.Interest_Amount__c) + 
           					(o.VAT_Amount__c == null ? 0 : o.VAT_Amount__c);               
        
        List<Loan_Management__c> rulesList = [Select Id, Name, Documentary_Stamp_Tax__c, Value_Added_Tax__c, Max_number_of_payment_holidays__c, Repayment_method__c, Notification_days__c, 
                                                    Max_payment_holiday_duration__c, Top_ups__c, Minimum_of_principal_repaid__c, Charges_waiver__c,
                                                    Allow_Cancellation__c, Cancellation_Period__c
                                              From Loan_Management__c 
                                              Where Program_Product_ASO__c =:o.Program_Product_ASO__c];
        
        if (rulesList.size() == 1){
            rules = rulesList[0];  
            if(rules.Value_Added_Tax__c != null)
            	rules.Value_Added_Tax__c = rules.Value_Added_Tax__c.stripTrailingZeros();
            if(rules.Documentary_Stamp_Tax__c != null)
            	rules.Documentary_Stamp_Tax__c = rules.Documentary_Stamp_Tax__c.stripTrailingZeros();
        }
             
        else
        {}
        
        if(o.Status__c == 'Paused')
        {
            //List<Opportunity> rejectedOp = [SELECT StageName, (SELECT Final_Decision__c FROM Credit_Assessments__r), (SELECT Final_Decision__c FROM Operations__r)
            //                          		FROM Opportunity WHERE Related_Operation__c = :o.Id];
            
            if(([SELECT Id FROM Opportunity WHERE Related_Operation__c = :o.Id AND StageName IN ('In Progress', 'Contract Stage')].size() > 0)
               || ([SELECT Id FROM Credit_Assessment__c WHERE Opportunity__r.Related_Operation__c = :o.Id AND Final_Decision__c NOT IN ('Rejected', 'Approved')].size() > 0) 
               || (([SELECT Id FROM Credit_Assessment__c WHERE Opportunity__r.Related_Operation__c = :o.Id AND Final_Decision__c = 'Approved'].size() > 0) &&
                   ([SELECT Id FROM Operation__c WHERE Opportunity__r.Related_Operation__c = :o.Id AND Final_Decision__c != 'Rejected'].size() > 0)))
                IsResumeActive = false;
            else 
                IsResumeActive = true;
        }
        else 
            IsResumeActive = false;
        
    }

    public boolean getEventTypePageVisibility()
    {
        if (o.Status__c == 'In Progress' || o.Status__c == 'Defaulted' || o.Status__c == 'Completed' || o.Status__c == 'Disbursed' || o.Status__c == 'Pending Completion' || o.Status__c == 'Pending Cancellation' || o.Status__c == 'Paused')
            return true;
        
        return false;
    } 
    
    public List<Loan_Management_Event__c> getListLMEvents()
    {
        List<Loan_Management_Event__c> lmeList = new List<Loan_Management_Event__c>();
        
        if(o.Status__c == 'Paused')
            return lmeList;
        
        for (Loan_Management_Event__c lme : o.Loan_Management_Events__r)
        {
            if (lme.Event_Type__c == 'Payment Holiday' && lme.IsActive__c && Date.today() >= lme.Event_Date__c && Date.today() <= lme.Event_End_Date__c)
                lmeList.add(lme);
            if (lme.Event_Type__c == 'Change Collection Amount' && lme.IsActive__c && Date.today() >= lme.Event_Date__c && (lme.Event_End_Date__c == null || Date.today() <= lme.Event_End_Date__c))
                lmeList.add(lme);
            if (lme.Event_Type__c == 'Cancellation' && Date.today() >= lme.Event_Date__c)
                lmeList.add(lme);
        }
        
        return lmeList;
    }
    
    public string getAccummulatedFees()
    {
        if (o.Outstanding_Fees__c == null)
            o.Outstanding_Fees__c = 0.00;
        if (o.Outstanding_Fees_VAT__c == null)
            o.Outstanding_Fees_VAT__c = 0.00;
        
        return string.valueOf(o.Outstanding_Fees__c + o.Outstanding_Fees_VAT__c) + ' (incl. VAT ' + string.valueOf(o.Outstanding_Fees_VAT__c) + ')';
    }
    
    public PageReference WaiveAccummulatedFees()
    {
        //string getParams = '?LoanId=' + o.Id;            
        //string result = (string)LMS_Callout.GetResultsMapFromResponse(LMS_Callout.CallOutGET(LMS_Constants.AccFeesWaiverEndPoint, getParams)).get('result');
        
        //if (result != 'Success')
        //   return;
        
        Loan_Management_Event__c waiveLME = new Loan_Management_Event__c();
        waiveLME.Operation__c = o.Id;
        waiveLME.Event_Type__c = 'Waive Accummulated Fees';
        waiveLME.Event_Date__c = Date.today();
        waiveLME.IsApproved__c = true;
        waiveLME.ApprovedBy__c = UserInfo.getUserId();
        waiveLME.Approval_Date__c = DateTime.now();
        waiveLME.IsActive__c = true;
        waiveLME.Event_Amount__c = o.Outstanding_Fees__c + o.Outstanding_Fees_VAT__c; 
        
        string getParams = '?LoanId=' + o.Id + 
                                '&StartDate=' + CRMS_Util.DateToString(waiveLME.Event_Date__c, LMS_Constants.DATE_FORMAT_DWH) +
                                '&Days=' + String.valueOf(Integer.valueOf(rules.Notification_days__c) + 1) +
                                '&EventType=' + waiveLME.Event_Type__c.replaceAll(' ', '%20');
            
        waiveLME.Effective_Date__c = Date.valueOf(((string)LMS_Callout.GetResultsMapFromResponse(LMS_Callout.CallOutGET(LMS_Constants.FirstRepDayEndPoint, getParams)).get('repaymentDay')).replace('T', ' '));
        
        insert waiveLME;
            
        o.Outstanding_Fees__c = 0;
        o.Outstanding_Fees_VAT__c = 0;
        update o;
        
        PageReference page = ApexPages.currentPage();
        page.setRedirect(true);
        
        return page;
    }
    
    public PageReference WriteOffLoan()
    {
        Loan_Management_Event__c defaultedLME = new Loan_Management_Event__c();
        defaultedLME.Operation__c = o.Id;
        defaultedLME.Event_Type__c = 'Write-off';
        defaultedLME.Event_Date__c = Date.today();
        defaultedLME.Event_Amount__c =  (o.Loan_Outstanding_Principal__c == null ? 0 : o.Loan_Outstanding_Principal__c)  + 
           								(o.Loan_Outstanding_Interest__c == null ? 0 : o.Loan_Outstanding_Interest__c) + 
           								(o.Loan_Outstanding_VAT_Amount__c == null ? 0 : o.Loan_Outstanding_VAT_Amount__c);
        defaultedLME.IsApproved__c = true;
        defaultedLME.ApprovedBy__c = UserInfo.getUserId();
        defaultedLME.Approval_Date__c = DateTime.now();
        defaultedLME.IsActive__c = true;
        insert defaultedLME;
        
        o.Loan_Outstanding_Principal__c = 0;
        o.Loan_Outstanding_Interest__c = 0;
        o.Loan_Outstanding_VAT_Amount__c = 0;
        o.Status__c = 'Defaulted(Written-off)';
        update o;
        
        PageReference page = ApexPages.currentPage();
        page.setRedirect(true);
        
        return page;
    }
    
    public PageReference ResumeLoan()
    {
        LM_Resume resumeEvent = new LM_Resume(o, rules);
        resumeEvent.ResumeLoan();
        
        PageReference page = ApexPages.currentPage();
        page.setRedirect(true);
        
        return page;
    }
    
    
    public List<PieChart> getPrincipalChart()
    {
        List<PieChart> pieChart = new List<PieChart>();
        pieChart.add(new PieChart('Outstanding Principal', o.Loan_Outstanding_Principal__c));
        pieChart.add(new PieChart('Repaid Principal', o.Actual_Principal_Amount__c - o.Loan_Outstanding_Principal__c));
        
        return pieChart;
    }
    
    public List<PieChart> getInterestChart()
    {
        List<PieChart> pieChart = new List<PieChart>();
        pieChart.add(new PieChart('Outstanding Interest', o.Loan_Outstanding_Interest__c));
        pieChart.add(new PieChart('Repaid Interest', o.Actual_Interest_Amount__c - o.Loan_Outstanding_Interest__c));
        
        return pieChart;
    }
    
    public class PieChart {
        public String name { get; set; }
        public Decimal data { get; set; }
        public PieChart(String name, Decimal data) {
            this.name = name;
            this.data = data;
        }
    }
    
}