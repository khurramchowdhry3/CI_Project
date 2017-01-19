trigger AMPSales_DebtTrigger on Additional_Debt__c (before delete, before insert, before update) {
	
	if(trigger.isInsert){
		AMPSales_DebtTriggerHandler Debt = new AMPSales_DebtTriggerHandler();
		Debt.DebtsOnInsert(trigger.new);		
	}	
	/*
	if(trigger.isDelete){
		AMPSales_DebtTriggerHandler Debt = new AMPSales_DebtTriggerHandler();
		Debt.DebtsOnDelete(trigger.old);
	}*/
}