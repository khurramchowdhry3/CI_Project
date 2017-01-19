public with sharing class LMS_LoanScheduleWrapper {
	
	public DateTime	schedulePayDate	{get{
        TimeZone tz = UserInfo.getTimeZone();
        return schedulePayDate.AddSeconds(tz.getOffset(schedulePayDate)/1000); // The SchedulePayDate is in User's local timezone after deserialization (Elisaveta Godumova, 2016-04-19)
    } set;}
	public integer repaymentNum		{get; set;}
	public decimal principalAmount	{get; set;}
	public decimal interestAmount	{get; set;}
	public decimal feeAmount		{get; set;}
    public decimal interestVATAmount				{get; set;}
	public decimal totalRepaymentPerInstallment		{get; set;}
	public decimal remainingPrincipal				{get; set;}
	public decimal openingBalance	{get; set;}
	public decimal closingBalance	{get; set;}
	public string result			{get; set;}
	public string message			{get; set;}
}