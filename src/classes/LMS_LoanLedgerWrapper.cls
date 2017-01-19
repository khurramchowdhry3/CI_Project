public with sharing class LMS_LoanLedgerWrapper {
	public integer repaymentNum		{get; set;}
	public DateTime	valuationDate	{get{
        TimeZone tz = UserInfo.getTimeZone();
        return valuationDate.AddSeconds(tz.getOffset(valuationDate)/1000);	// The ValuationDate is in User's local timezone after deserialization (Elisaveta Godumova, 2016-04-19)
    } set;}
	public string code				{get; set;}
	public string codeDescription	{get; set;}
	public decimal principalAmount	{get; set;}
	public decimal interestAmount	{get; set;}
	public decimal feeAmount		{get; set;}
    public decimal vatAmount		{get; set;}
    public decimal dst				{get; set;}
	public decimal openingBalance	{get; set;}
	public decimal closingBalance	{get; set;}
	public decimal feeBalance		{get; set;}
	public decimal principalBalance	{get; set;}
	public decimal interestBalance	{get; set;}
	public string result			{get; set;}
	public string message			{get; set;}
}