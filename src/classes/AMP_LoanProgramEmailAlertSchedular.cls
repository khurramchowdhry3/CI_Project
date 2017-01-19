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
 * Schedule Job which runs every morning at 9 AM from Mon to Friday to Check Loan Programs Validity. 
 *
 */ 

global class AMP_LoanProgramEmailAlertSchedular implements system.Schedulable{
	/*
	*
	* Job which runs on every morning 9AM from Monday to Friday to check Validity of Loan Programs.
	*
	*/
	
	public void execute(SchedulableContext SC){
		AMP_LoanProgram Program = new AMP_LoanProgram();
		Program.CheckProgramValidty();
		//system.schedule('Email Alert on Program Closing Date', '0 0 9 ? * MON-FRI', new AMP_LoanProgramEmailAlertSchedular());
	}
}