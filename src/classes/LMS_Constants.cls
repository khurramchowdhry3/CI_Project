public without sharing class LMS_Constants 
{
    public static final String DATE_FORMAT_DWH = 'yyyy-MM-dd';
    public static final String endpointValue = '/api/LoanManagementCalculationResult';
    public static final String loanParamsEndPoint = '/api/LoanInitialParameters';
    public static final string LoanScheduleEndPoint = '/api/LoanSchedule';
    public static final string LoanLedgerEndPoint = '/api/LoanLedger';
    public static final string LoanFeesEndPoint = '/api/LoanFees';
    public static final string FirstRepDayEndPoint = '/api/EffectiveDate';
    public static final string AccFeesWaiverEndPoint = '/api/AccFeesWaiver';
    
	public static final Map<String, List<LMS_CalculationFieldDescriptor>> mapEventTypeCalculationFields;
    static {
        mapEventTypeCalculationFields = new Map<string, List<LMS_CalculationFieldDescriptor>> 
                { 	'Bounce Back' => new List<LMS_CalculationFieldDescriptor>
                                    { 	new LMS_CalculationFieldDescriptor('loanEndDate', 'New Loan End Date', 'DateTime'),
                                        new LMS_CalculationFieldDescriptor('principalAmount', 'Principal', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('interestAmount', 'Interest', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('interestVATAmount', 'Interest VAT', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('accFeesAmountWithVAT', 'Fee', 'String'), 
                                        //new LMS_CalculationFieldDescriptor('accFeesVATAmount', 'Fee VAT', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('eventFeeAmountWithVAT', 'Reversal Fee', 'String'), 
                                        //new LMS_CalculationFieldDescriptor('eventFeeVATAmount', 'Reversal Fee VAT', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('totalAmount', 'Total', 'Decimal')
                                    },
                    'One off' => new List<LMS_CalculationFieldDescriptor>
                                    { 	new LMS_CalculationFieldDescriptor('loanEndDate', 'New Loan End Date', 'DateTime'),
                                        new LMS_CalculationFieldDescriptor('principalAmount', 'Principal', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('interestAmount', 'Interest', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('interestVATAmount', 'Interest VAT', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('accFeesAmountWithVAT', 'Fee', 'String'), 
                                        //new LMS_CalculationFieldDescriptor('accFeesVATAmount', 'Fee VAT', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('eventFeeAmountWithVAT', 'Handling Fee', 'String'), 
                                        //new LMS_CalculationFieldDescriptor('eventFeeVATAmount', 'Handling Fee VAT', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('totalAmount', 'Total', 'Decimal')
                                    },
                    'Payment Holiday' => new List<LMS_CalculationFieldDescriptor>
                                        { 	new LMS_CalculationFieldDescriptor('loanEndDate', 'New Loan End Date', 'DateTime'),
                                            new LMS_CalculationFieldDescriptor('principalAmount', 'Principal', 'Decimal'), 
                                            new LMS_CalculationFieldDescriptor('interestAmount', 'Interest', 'Decimal'), 
                                            new LMS_CalculationFieldDescriptor('interestVATAmount', 'Interest VAT', 'Decimal'), 
                                            new LMS_CalculationFieldDescriptor('accFeesAmountWithVAT', 'Fee', 'String'), 
                                            //new LMS_CalculationFieldDescriptor('accFeesVATAmount', 'Fee VAT', 'Decimal'), 
                                            new LMS_CalculationFieldDescriptor('totalAmount', 'Total', 'Decimal')     
                                        },
                    'Debt Collection' => new List<LMS_CalculationFieldDescriptor>
                                        { 	new LMS_CalculationFieldDescriptor('principalAmount', 'Outstanding Principal', 'Decimal'), 
                                            new LMS_CalculationFieldDescriptor('interestAmount', 'Outstanding Interest', 'Decimal'), 
                                            new LMS_CalculationFieldDescriptor('interestVATAmount', 'Outstanding Interest VAT', 'Decimal'),
                                            //new LMS_CalculationFieldDescriptor('eventFeeAmountWithVAT', 'Handling Fee', 'String'), 
                                            new LMS_CalculationFieldDescriptor('totalAmount', 'Total', 'Decimal')
                                        },
                    'Restructure' => new List<LMS_CalculationFieldDescriptor>
                                    { 	new LMS_CalculationFieldDescriptor('principalAmount', 'Principal to Transfer', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('accFeesAmountWithVAT', 'Fee to Transfer', 'String'), 
                                        //new LMS_CalculationFieldDescriptor('accFeesVATAmount', 'Fee Amount VAT to Transfer', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('eventFeeAmountWithVAT', 'Restructure Fee', 'String'), 
                                        //new LMS_CalculationFieldDescriptor('eventFeeVATAmount', 'Restructure Fee VAT', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('totalAmountNoInterest', 'Total Restructured Amount', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('loanTerm', 'New Loan Term', 'String'),
                                        new LMS_CalculationFieldDescriptor('loanInterest', 'Loan Interest', 'Percent'),
										new LMS_CalculationFieldDescriptor('loanFrequency', 'Loan Frequency', 'String'),                                        
                                        new LMS_CalculationFieldDescriptor('repaymentsNum', 'No. of Repayments', 'Integer'),
                                        new LMS_CalculationFieldDescriptor('repaymentPerInstallment', 'Amount per Installment', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('totalAmount', 'Total Amount Repayable', 'Decimal')
                                    },
                    'Top-up' => new List<LMS_CalculationFieldDescriptor>
                                    { 	new LMS_CalculationFieldDescriptor('eventAmount', 'New Requested Amount', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('principalAmount', 'Principal to Transfer', 'Decimal'), 
                                        new LMS_CalculationFieldDescriptor('accFeesAmountWithVAT', 'Fee to Transfer', 'String'), 
                                        //new LMS_CalculationFieldDescriptor('accFeesVATAmount', 'Fee Amount VAT to Transfer', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('totalAmountNoInterest', 'Total Top-up Amount', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('loanTerm', 'New Loan Term', 'String'),                                        
                                        new LMS_CalculationFieldDescriptor('loanInterest', 'Loan Interest', 'Percent'),
                                        new LMS_CalculationFieldDescriptor('loanFrequency', 'Loan Frequency', 'String'),                               
                                        new LMS_CalculationFieldDescriptor('repaymentsNum', 'No. of Repayments', 'Integer'),
                                        new LMS_CalculationFieldDescriptor('repaymentPerInstallment', 'Amount per Installment', 'Decimal'),
                                        new LMS_CalculationFieldDescriptor('totalAmount', 'Total Amount Repayable', 'Decimal')
                                    },
                    'Early Repayment' => new List<LMS_CalculationFieldDescriptor>
                                        { 	new LMS_CalculationFieldDescriptor('loanEndDate', 'New Loan End Date', 'DateTime'),
                                            new LMS_CalculationFieldDescriptor('principalAmount', 'Outstanding Principal', 'Decimal'), 
                                            new LMS_CalculationFieldDescriptor('accFeesAmountWithVAT', 'Outstanding Fee', 'String'), 
                                            //new LMS_CalculationFieldDescriptor('accFeesVATAmount', 'Outstanding Fee VAT', 'Decimal'), 
                                            new LMS_CalculationFieldDescriptor('eventFeeAmountWithVAT', 'Early Repayment Fee', 'String'), 
                                            //new LMS_CalculationFieldDescriptor('eventFeeVATAmount', 'Early Repayment Fee VAT', 'Decimal'),
                                            new LMS_CalculationFieldDescriptor('totalAmount', 'Total', 'Decimal')
                                        },
                    'Renewal' => null,
                    'Cancellation' => null,
                    'Change Collection Amount' => new List<LMS_CalculationFieldDescriptor>
                                        {    new LMS_CalculationFieldDescriptor('loanEndDate', 'New Loan End Date', 'DateTime'),
                                             new LMS_CalculationFieldDescriptor('principalAmount', 'Principal', 'Decimal'),
                                             new LMS_CalculationFieldDescriptor('interestAmount', 'Interest', 'Decimal'),
                                             new LMS_CalculationFieldDescriptor('interestVATAmount', 'Interest VAT', 'Decimal'),
                                             new LMS_CalculationFieldDescriptor('accFeesAmountWithVAT', 'Fee', 'String'),
                                             new LMS_CalculationFieldDescriptor('totalAmount','Total','Decimal')
                                             
                                        }
                    };
        }
    
    
}