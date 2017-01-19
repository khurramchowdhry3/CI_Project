/**
    Handler class for the Credit Assessment trigger
    Author: CRM Superstars
    Version: 1.0
*/
public class CRMS_CreditAssessmentTriggerHandler 
{
    public static Boolean isTriggerCalled = false;
    public static Boolean flag = false;
    public static Boolean isTriggerCalledInsert = false;
    //method to update Fields of CA when Final Decision field is set to 'Approved'
    public void beforeUpdate (list<Credit_Assessment__c> listCreditAssessment, map<Id,Credit_Assessment__c> mapOld)
    {
                              
        for(Credit_Assessment__c objCA : listCreditAssessment)
        {
            //if(objCA.Offer_Term__c != mapOld.get(objCA.Id).Offer_Term__c)
            //{
                //objCA.Approved_Loan_Term__c = objCA.Offer_Term__c; 
            //}
            if(objCA.Principal_Daily_Repayments_Approved__c !=  mapOld.get(objCA.Id).Principal_Daily_Repayments_Approved__c
            	|| objCA.Interest_Daily_Repayment_Approved__c != mapOld.get(objCA.Id).Interest_Daily_Repayment_Approved__c
            	|| objCA.VAT_Daily_Repayment_Approved__c != mapOld.get(objCA.Id).VAT_Daily_Repayment_Approved__c){
            	            		            		
            		objCA.Total_Amount_Daily_Repayment_Approved__c =  objCA.Principal_Daily_Repayments_Approved__c +
            													  objCA.Interest_Daily_Repayment_Approved__c +
            													  objCA.VAT_Daily_Repayment_Approved__c;
            }
                        
            if(objCA.Principal_Weekly_Repayments_Approved__c != mapOld.get(objCA.Id).Principal_Weekly_Repayments_Approved__c
                && objCA.Interest_Weekly_Repayment_Approved__c != mapOld.get(objCA.Id).Interest_Weekly_Repayment_Approved__c){
                
                objCA.Total_Weekly_Repayment_Approved__c = objCA.Principal_Weekly_Repayments_Approved__c + objCA.Interest_Weekly_Repayment_Approved__c;             
                objCA.Total_Weekly_Amount_Repayable_Approved__c = objCA.Total_Weekly_Repayment_Approved__c * objCA.Number_of_Weekly_Repayments_Approved__c;             
            }
            
            if(objCA.Final_Decision__c == 'Approved' && mapOld.get(objCA.Id).Final_Decision__c != 'Approved')
            {
                objCA.Approved_By__c = UserInfo.getUserId();
                objCA.Approval_Date__c = date.today();
                objCA.Final_Decision_Date__c = Date.today();
                
                              
            }
            if(objCA.Final_Decision__c == 'Rejected' && mapOld.get(objCA.Id).Final_Decision__c != 'Rejected'){
                objCA.Final_Decision_Date__c = Date.today();
            }
            if((objCA.Requested_Loan_Amount__c != mapOld.get(objCA.Id).Requested_Loan_Amount__c
            || objCA.Offer_Amount__c != mapOld.get(objCA.Id).Offer_Amount__c
            || objCA.Requested_Loan_Term__c != mapOld.get(objCA.Id).Requested_Loan_Term__c
            || objCA.Offer_Term__c != mapOld.get(objCA.Id).Offer_Term__c)
            && objCA.RecordtypeId == mapOld.get(objCA.Id).RecordtypeId)
            {
                if(objCA.Requested_Loan_Amount__c > objCA.Offer_Amount__c)
                {
                    objCA.Approved_Loan_Amount__c = objCA.Offer_Amount__c;
                    objCA.Approved_Loan_Term__c = objCA.Offer_Term__c;
                    objCA.Monthly_Interest_Approved__c = !string.isEmpty(objCA.Approved_Interest_Rate__c)
                                                        ? objCA.Monthly_Interest_Approved__c :
                                                        objCA.Monthly_Interest__c;
                }
                else
                {
                    objCA.Approved_Loan_Amount__c = objCA.Requested_Loan_Amount__c;
                    objCA.Approved_Loan_Term__c = objCA.Requested_Loan_Term__c;
                    objCA.Monthly_Interest_Approved__c = !string.isEmpty(objCA.Approved_Interest_Rate__c)
                                                        ? objCA.Monthly_Interest_Approved__c :
                                                        objCA.Monthly_Interest_Requested__c;
                }
            }
            
            Credit_Assessment__c oldCA = mapOld.get(objCA.Id);            
            
            if(oldCA.Program_Product_ASO__c != objCA.Program_Product_ASO__c){
            	
            	
                Program_Product_ASO__c currPPAS = [select id, Product__r.Full_Term__c, Product__r.Interest_Rate__c from Program_Product_ASO__c where Id =: objCA.Program_Product_ASO__c limit 1];
                               
                objCA.Approved_Interest_Rate__c = string.valueOf(currPPAS.Product__r.Interest_Rate__c)+'%';
                objCA.Approved_Loan_Term__c = currPPAS.Product__r.Full_Term__c;
            }
            
            
            /*------ Validation for Approved Loan Term and Approved Interest Rate ------ */
            Program_Product_ASO__c currPPAS = [select id, Product__r.Full_Term__c, Product__r.Schedule_Type__c, Product__r.Product_Type__c, Product__r.Min_Interest_rate__c, Product__r.Max_Interest_rate__c 
                                               from Program_Product_ASO__c 
                                               where Id =: objCA.Program_Product_ASO__c];
            
            
            if (oldCA.Approved_Interest_Rate__c != objCA.Approved_Interest_Rate__c)
            {                                 
                if (integer.valueof(objCA.Approved_Interest_Rate__c.replace('%', '')) < currPPAS.Product__r.Min_Interest_rate__c || integer.valueof(objCA.Approved_Interest_Rate__c.replace('%', '')) > currPPAS.Product__r.Max_Interest_rate__c) 
                    objCA.addError('The selected Interest Rate is outside the defined band');
            }
            
            if (oldCA.Approved_Loan_Term__c != objCA.Approved_Loan_Term__c)
            {
                List<Program_Product_ASO__c> lstPPASO = [select id from Program_Product_ASO__c                                  
                                                     where Program__c =: objCA.Program__c
                                                        and Product__r.Full_Term__c =: objCA.Approved_Loan_Term__c
                                                        and Product__r.Schedule_Type__c =: currPPAS.Product__r.Schedule_Type__c
                                                        and Product__r.Product_Type__c =: currPPAS.Product__r.Product_Type__c
                                                     limit 1
                                                   ];
      
                if(lstPPASO.size() == 0)
                    objCA.addError('The selected Loan Term cannot be found among the Products defined for the current Program');
                else
                    objCA.Program_Product_ASO__c = lstPPASO[0].Id;
            }            
            
            /*------ End of Validation for Approved Loan Term and Approved Interest Rate ------ */
            
            /* -------- Calculate Approved APR ----------*/
            
             if (objCA.Program_Product_ASO__c != null 
                && (mapOld.get(objCA.Id).Approved_Loan_Amount__c != objCA.Approved_Loan_Amount__c
                || mapOld.get(objCA.Id).Program_Product_ASO__c != objCA.Program_Product_ASO__c
                || mapOld.get(objCA.Id).Approved_Interest_Rate__c != objCA.Approved_Interest_Rate__c)){ 
                
                
                double ApprovedInterestRate = double.valueof(objCA.Approved_Interest_Rate__c.replace('%', ''));
                double ApprovedLoanTerm = double.valueOf(objCA.Approved_Loan_Term__c.subString(4,7));
                
                if(this.getRepaymentNo(objCA.Approved_Loan_Term__c) != null){
	                double interestPremium = ApprovedInterestRate * ApprovedLoanTerm  / (365*100);
	                integer repaymentsNum = this.getRepaymentNo(objCA.Approved_Loan_Term__c);
	                integer daysIncrement = objCA.FOC__c == 'Daily' ? 1 : 7;  
	                
	                integer gracePeriod = integer.valueof([select id, Grace_period__c from Loan_Management__c where Program_Product_ASO__c =:objCA.Program_Product_ASO__c][0].Grace_period__c);                
	                objCA.APR_Approved__c = interestPremium*repaymentsNum*365*100/CRMS_Util.SumCollectionDays(gracePeriod, repaymentsNum, daysIncrement);
                }else objCA.addError('Invalid Loan Term for the selected Program - Product association');                
            }
        }
    }
    
    private integer getRepaymentNo(string LoanTerm){
        if(LoanTerm != null){
            string LoanTermNo = LoanTerm.subString(0,2);
            if(LoanTermNo == '03'){
                return 62;
            }else if(LoanTermNo == '04'){
                return 84;
            }else if(LoanTermNo == '05'){
                return 106;
            }else if(LoanTermNo == '06'){
                return 126;
            }else if(LoanTermNo == '07'){
                return 149;
            }else if(LoanTermNo == '08'){
                return 170;
            }else if(LoanTermNo == '09'){
                return 192;
            }else if(LoanTermNo == '12'){
                return 259;
            }
         }
         return null;
    }
            
    // method to set CreditAssessment id on all Opportunity related Owner/Guarantor/Directors
    public void afterInsert(list<Credit_Assessment__c> listCreditAssessment)
    {
        map<ID, list<ID>> OpportunitiesCAMap = new map<ID, list<ID>>();
        set<Id> setOppId = new set<Id>();
        map<id,list<Credit_Assessment__c>> mapOppId_listAssessment = new map<id,list<Credit_Assessment__c>>();
        list<Credit_Assessment__c> UpdateTotalDailyApprovedRepayment = new list<Credit_Assessment__c>(); 
        for(Credit_Assessment__c objCA : listCreditAssessment)
        {                        
            if(objCA.Opportunity__c != null)
            {
                if(OpportunitiesCAMap.get(objCA.Opportunity__c) == null){
					OpportunitiesCAMap.put(objCA.Opportunity__c, new list<ID>{objCA.Id});
				}else OpportunitiesCAMap.get(objCA.Opportunity__c).add(objCA.Id);
                
                setOppId.add(objCA.Opportunity__c);
                if(!mapOppId_listAssessment.containsKey(objCA.Opportunity__c))
                    mapOppId_listAssessment.put(objCA.Opportunity__c, new list<Credit_Assessment__c>{objCA});
                else
                    mapOppId_listAssessment.get(objCA.Opportunity__c).add(objCA);
            }
            
            if(objCA.Principal_Daily_Repayments_Approved__c != null
            	&& objCA.Interest_Daily_Repayment_Approved__c != null
            	&& objCA.VAT_Daily_Repayment_Approved__c != null){
            		
            	Credit_Assessment__c CA = new Credit_Assessment__c(
            		Id = objCA.Id,
            		Total_Amount_Daily_Repayment_Approved__c =  objCA.Principal_Daily_Repayments_Approved__c +
            													  objCA.Interest_Daily_Repayment_Approved__c +
            													  objCA.VAT_Daily_Repayment_Approved__c
            	);            	
          		UpdateTotalDailyApprovedRepayment.add(CA);	        		
            }
        }
        
        if(!setOppId.isEmpty())
        {
            list<Guarantors__c> lstGuarantor = [Select g.Opportunity__c, g.Id, g.Credit_Assessment__c 
                                                From Guarantors__c g
                                                where g.Opportunity__c IN : setOppId];
                                                
            if(lstGuarantor != null && !lstGuarantor.isEmpty())
            {
                list<Guarantors__c> lstGuarantorToUpdate = new list<Guarantors__c>();
                for(Guarantors__c objGuarantor : lstGuarantor)
                {
                    if(objGuarantor.Opportunity__c != null && mapOppId_listAssessment.get(objGuarantor.Opportunity__c) != null)
                    {
                        for(Credit_Assessment__c objCA : mapOppId_listAssessment.get(objGuarantor.Opportunity__c))
                        {
                            objGuarantor.Credit_Assessment__c = objCA.Id;
                            lstGuarantorToUpdate.add(objGuarantor);
                        }
                    }
                }
                if(!lstGuarantorToUpdate.isEmpty())
                {
                    update lstGuarantorToUpdate;
                }                
            }
        }
        
        if(UpdateTotalDailyApprovedRepayment.size()>0 && !UpdateTotalDailyApprovedRepayment.isEmpty()){
        	database.update(UpdateTotalDailyApprovedRepayment,false);
        }
        
        this.AddOpportunityDebtsToCreditAssessment(OpportunitiesCAMap);
    }
    
    private void AddOpportunityDebtsToCreditAssessment(map<ID,list<ID>> OpportunitiesMap){
    	list<Additional_Debt__c> Debts = new list<Additional_Debt__c>();
    	for(Additional_Debt__c debt : [select Id, Credit_Assessment__c,Opportunity__c from Additional_Debt__c where Opportunity__c IN:OpportunitiesMap.keyset()]){
    		for(ID key : OpportunitiesMap.get(debt.Opportunity__c)){
    			Debts.add(new Additional_Debt__c(
    				Id = debt.Id,
    				Credit_Assessment__c = key
    			));	
    		}
    	}
    	
    	if(Debts.size() > 0 && !Debts.isEmpty()){
    		Database.update(Debts, false);
    	}
    }    
     // end of afterInsert
     
    
    //method to update owner Id,Applicant name and Business legal Name from CA
    public void beforeInsert(list<Credit_Assessment__c> listCreditAssessment)
    {
        set<Id> setOppId = new set<Id>();
        list<QueueSobject> lstQueue = [Select q.SobjectType, q.QueueId, q.Id, q.Queue.Name 
                                       From QueueSobject q 
                                       where q.SobjectType = 'Credit_Assessment__c'];
        
        for(Credit_Assessment__c objCredit : listCreditAssessment)
        {
            setOppId.add(objCredit.Opportunity__c);
        }   
        
        map<Id,Opportunity> mapOpp = new map<Id,Opportunity>([Select o.RecordType.Name, o.Id, o.AccountId,
                                                            o.Primary_Contact__c 
                                                            From Opportunity o where o.Id 
                                                            IN : setOppId]);
        
        map<Id,Id> mapOppId_RecTypeStr = new map<Id,Id>();
        
        for(Opportunity objOpp : mapOpp.values())
        {
            for(QueueSobject objQueue : lstQueue)
            {
                if(objOpp.RecordType.Name.contains('UK') && objQueue.Queue.Name.contains('UK'))
                {
                    mapOppId_RecTypeStr.put(objOpp.Id, objQueue.QueueId);
                }
                if(objOpp.RecordType.Name.contains('Hong') && objQueue.Queue.Name.contains('Hong'))
                {
                    mapOppId_RecTypeStr.put(objOpp.Id, objQueue.QueueId);
                }
                if(objOpp.RecordType.Name.contains('Philippines') && objQueue.Queue.Name.contains('Philippines'))
                {
                    mapOppId_RecTypeStr.put(objOpp.Id, objQueue.QueueId);
                }
                if(objOpp.RecordType.Name.contains('Singapore') && objQueue.Queue.Name.contains('Singapore'))
                {
                    mapOppId_RecTypeStr.put(objOpp.Id, objQueue.QueueId);
                }
            }
        }
        
        for(Credit_Assessment__c objCredit : listCreditAssessment)
        {
            if(objCredit.Opportunity__c != null)
            {
                if( mapOpp.get(objCredit.Opportunity__c).AccountId != null)
                {
                    objCredit.Business_Trading_Name__c = mapOpp.get(objCredit.Opportunity__c).AccountId;                    
                }
                if( mapOpp.get(objCredit.Opportunity__c).Primary_Contact__c != null)
                {
                    objCredit.Applicant_Name__c = mapOpp.get(objCredit.Opportunity__c).Primary_Contact__c;
                }
            }
            if(mapOppId_RecTypeStr.get(objCredit.Opportunity__c) != null)
            {
                objCredit.OwnerId = mapOppId_RecTypeStr.get(objCredit.Opportunity__c);
            }
        }
    } // end of beforeInsert
    
    
    
    
    //method to create task for CA and assign them to Opportunity
    public void afterUpdate(map<Id,Credit_Assessment__c> mapNewCreditAssessment,map<Id,Credit_Assessment__c> mapOldCreditAssessment)
    {
        map<Id,String> mapOppId_Status = new map<Id,String>();
        list<Opportunity> lstOppToUpdate = new list<Opportunity>();
        list<Task> lstTaskToInsert = new list<Task>();
        list<Task>lstTaskToInsertCreditAssessment = new list<Task>();
        list<Task> lstTaskToInsertSatisfactoryCredit = new list<Task>();
        set<Id> setOwnerId = new set<Id>();
        
        map<Id,Credit_Assessment__c> mapId_Credit = new  map<Id,Credit_Assessment__c>();
        for(Credit_Assessment__c objCredit : mapNewCreditAssessment.values())
        {
            setOwnerId.add(objCredit.Opportunity__c);
            mapId_Credit.put(objCredit.Id,objCredit);
        }
        
        map<Id,Opportunity> mapOppId_Opportunity = new map<Id,Opportunity>([select Id, OwnerId, RecType_Name__c
                                                    from Opportunity where Id IN: setOwnerId]);
        
        list<Opportunity> lstOppInfoReq = new list<Opportunity>();
        for(Credit_Assessment__c objCredit : mapNewCreditAssessment.Values())
        {
                        
            String strStatus;
            
            system.debug('objCredit >>> '+objCredit);
            system.debug('Old Status >>> '+mapOldCreditAssessment.get(objCredit.Id).Status__c);
            
            if(objCredit.Status__c != mapOldCreditAssessment.get(objCredit.Id).Status__c
            && !mapOppId_Opportunity.get(objCredit.Opportunity__c).RecType_Name__c.contains('Closing'))
            {
                if(objCredit.Status__c == 'Approved')
                {
                    strStatus = 'Contract Stage';
                    //objCredit.Approved_By__c = UserInfo.getUserId() ;
                    mapOppId_Status.put(objCredit.Opportunity__c,strStatus);
                }
                else if(objCredit.Status__c == 'Rejected')
                {
                    strStatus = 'Rejected';
                    mapOppId_Status.put(objCredit.Opportunity__c,strStatus);
                }               
                
            }            
            system.debug('mapOppId_Status >>> '+mapOppId_Status);
            if(mapOppId_Opportunity.get(objCredit.Opportunity__c) != null)
            {
                Opportunity temp = new Opportunity(Id = objCredit.Opportunity__c);
                if(objCredit.Additional_Information_Required__c == 'Yes' 
                && objCredit.Additional_Information_Details__c != null && objCredit.Status__c == 'Revert'
                && mapOldCreditAssessment.get(objCredit.Id).Status__c != 'Revert'
                && mapOldCreditAssessment.get(objCredit.Id).Additional_Information_Required__c != 'Yes')
                {
                    // added on 8th April 2015
                    temp.Additional_Information_Required__c = 'Yes';
                    temp.Additional_Information_Details__c = objCredit.Additional_Information_Details__c;
                    temp.Additional_Information_Narrative__c = objCredit.Additional_Information_Narrative__c;
                    lstOppInfoReq.add(temp);
                    // added portion ends
                    Task objTask = new Task();
                    objTask.WhatId = objCredit.Opportunity__c;
                    objTask.Status = 'Not Started';
                    objTask.OwnerId = mapOppId_Opportunity.get(objCredit.Opportunity__c).OwnerId;
                    objTask.Subject = 'Additional information is required for assessment.';
                    objTask.Description = 'The following additional information is required: \n' + 
                    objCredit.Additional_Information_Details__c + '.\n' + objCredit.Additional_Information_Narrative__c;
                    objTask.Priority = 'Normal';
                    objTask.ActivityDate = date.today();
                    lstTaskToInsertCreditAssessment.add(objTask);
                }
                
                if(objCredit.Additional_Information_Satisfactory__c == 'No' 
                && objCredit.Status__c == 'Revert'
                && (objCredit.Additional_Information_Details__c != mapOldCreditAssessment.get(objCredit.Id).Additional_Information_Details__c
                || objCredit.Additional_Information_Narrative__c != mapOldCreditAssessment.get(objCredit.Id).Additional_Information_Narrative__c))
                {
                    temp.Additional_Information_Details__c = objCredit.Additional_Information_Details__c;
                    temp.Additional_Information_Narrative__c = objCredit.Additional_Information_Narrative__c;
                    temp.Additional_Information_Satisfactory__c = 'No';
                    lstOppInfoReq.add(temp);
                    Task objTaskSatis = new Task();
                    objTaskSatis.WhatId = objCredit.Opportunity__c;
                    objTaskSatis.Status = 'Not Started';
                    objTaskSatis.OwnerId = mapOppId_Opportunity.get(objCredit.Opportunity__c).OwnerId;
                    objTaskSatis.Subject = 'Additional information is not satisfactory ';
                    objTaskSatis.Description = 'The following additional information is not satisfactory: \n' + 
                    objCredit.Additional_Information_Details__c + '.\n' + objCredit.Additional_Information_Narrative__c;
                    objTaskSatis.Priority = 'Normal';
                    objTaskSatis.ActivityDate = date.today();
                    lstTaskToInsertSatisfactoryCredit.add(objTaskSatis);
                }
            }
        }
        if(!lstTaskToInsertSatisfactoryCredit.isEmpty())
        {
            insert lstTaskToInsertSatisfactoryCredit;
        }
        if(lstTaskToInsertCreditAssessment.size() > 0 && !lstTaskToInsertCreditAssessment.isEmpty())
        {
            insert lstTaskToInsertCreditAssessment;
        }
        
        // portion added on 8th April
        if(!lstOppInfoReq.isEmpty())
        {
            system.debug('lstOppInfoReq >>> '+lstOppInfoReq);
            update lstOppInfoReq;
        }//
        
        list<Opportunity> lstOpp = [Select o.StageName, o.Id, o.RecordTypeId, o.RecType_Name__c, o.OwnerId,
                                    o.Final_Decision_Approved__c, o.Final_Decision_Rejected__c
                                    From Opportunity o
                                    where o.Id IN : mapOppId_Status.Keyset()];
        
        list<RecordType> lstRecType = [Select r.SobjectType, r.Id, r.DeveloperName, r.Name 
                                       From RecordType r 
                                       where r.SobjectType = 'Opportunity' and (r.DeveloperName like '%Closing%'
                                       or r.DeveloperName like '%Outcome%')];
        
        for(Opportunity objOpp : lstOpp)
        {
            system.debug('objOpp >>> '+objOpp);
            if(mapOppId_Status.get(objOpp.Id) != Null && !objOpp.RecType_Name__c.contains('Closing'))
            {
                objOpp.StageName = mapOppId_Status.get(objOpp.Id);
                if(objOpp.StageName == 'Contract Stage'){
                    objOpp.Final_Decision_Approved__c = true;
                }else{
                        objOpp.Final_Decision_Rejected__c = true;
                }
                for(RecordType objRT : lstRecType)
                {
                    if(mapOppId_Status.get(objOpp.Id) != null & mapOppId_Status.get(objOpp.Id) == 'Contract Stage')
                    {
                        if(objRT.Name.contains('Outcome'))
                        {
                            if(objOpp.RecType_Name__c.contains('UK') && objRT.Name.contains('UK'))
                            {
                                objOpp.RecordTypeId = objRT.Id;
                            }
                            else if(objOpp.RecType_Name__c.contains('Hong') && objRT.Name.contains('Hong'))
                            {
                                objOpp.RecordTypeId = objRT.Id;
                            }
                            else if(objOpp.RecType_Name__c.contains('Philippines') && objRT.Name.contains('Philippines'))
                            {
                                objOpp.RecordTypeId = objRT.Id;
                            }
                            else if(objOpp.RecType_Name__c.contains('Singapore') && objRT.Name.contains('Singapore'))
                            {
                                objOpp.RecordTypeId = objRT.Id;
                            }
                        }   
                    }
                    else if(mapOppId_Status.get(objOpp.Id) != null & mapOppId_Status.get(objOpp.Id) == 'Rejected')
                    {
                        if(objRT.Name.contains('Closing'))
                        {
                            if(objOpp.RecType_Name__c.contains('UK') && objRT.Name.contains('UK'))
                            {
                                objOpp.RecordTypeId = objRT.Id;
                                system.debug('objOpp.RecordTypeId >>> '+objOpp.RecordTypeId);
                            }
                            else if(objOpp.RecType_Name__c.contains('Hong') && objRT.Name.contains('Hong'))
                            {
                                objOpp.RecordTypeId = objRT.Id;
                            }
                            else if(objOpp.RecType_Name__c.contains('Philippines') && objRT.Name.contains('Philippines'))
                            {
                                objOpp.RecordTypeId = objRT.Id;
                            }
                            else if(objOpp.RecType_Name__c.contains('Singapore') && objRT.Name.contains('Singapore'))
                            {
                                objOpp.RecordTypeId = objRT.Id;
                            }
                        }
                    }
                }
                
                if(mapOppId_Status.get(objOpp.Id) == 'Contract Stage')
                {
                    if(!flag)
                    {
                        flag = true;
                        Task objTask = new Task();
                        objTask.WhatId = objOpp.id;
                        objTask.Status = 'Not Started';
                        objTask.OwnerId = objOpp.OwnerId;
                        objTask.Subject = 'Credit Assessment Completed (Approved)';
                        objTask.Priority = 'High';
                        objTask.Description = 'Please notify the same to the client';
                        objTask.ActivityDate = date.today();
                        lstTaskToInsert.add(objTask);
                    }
                }
                if(mapOppId_Status.get(objOpp.Id) == 'Rejected')
                {
                    Task objTask = new Task();
                    objTask.WhatId = objOpp.id;
                    objTask.Status = 'Not Started';
                    objTask.OwnerId = objOpp.OwnerId;
                    objTask.Subject = 'Credit Assessment Completed (Rejected)';
                    objTask.Priority = 'High';
                    objTask.Description = 'Please notify the same to the client';
                    objTask.ActivityDate = date.today();
                    lstTaskToInsert.add(objTask);
                }
            }
            lstOppToUpdate.add(objOpp);
        }
        if(!lstTaskToInsert.isEmpty())
        {
            insert lstTaskToInsert;
        }       
        if(!lstOppToUpdate.isEmpty())
        {
            system.debug('Opportuntiy Status >>> '+lstOppToUpdate);
            update lstOppToUpdate;
        }     
              
        
    } // end of afterUpdate
    
    // method to set Credit Assessment status as Queued when updated on SF end
    public void setCreAsessmentDWHStatusQueued(List<Credit_Assessment__c> lstCreAssessment) {
        for (Credit_Assessment__c crA : lstCreAssessment) 
        {
            crA.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        }
        
    }
    // method to set Credit Assessment status as Synced when successfully synced with DWH
    public void setCreAsessmentDWHStatusSynced(List<Credit_Assessment__c> lstCreAssessment) {
        for (Credit_Assessment__c crA : lstCreAssessment) 
        {
            //crA.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            crA.DWH_Last_Sync__c = Datetime.now();
        }
        
    }
    // method to create/update Sync Queue records
    public void updateSyncQueueRecord(List<Credit_Assessment__c> lstCreAssessment){
        Map<Id,List<Sync_Queue__c>> creAssessmentIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> creAssessmentIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Credit_Assessment__c creAssessment : lstCreAssessment) {
            creAssessmentIdSet.add(creAssessment.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Credit_Assessment__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Credit_Assessment__c IN :creAssessmentIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (creAssessmentIdToSynchQueListMap.containsKey(syncQueue.Credit_Assessment__c) == true) {
                creAssessmentIdToSynchQueListMap.get(syncQueue.Credit_Assessment__c).add(syncQueue);
            } else {
                creAssessmentIdToSynchQueListMap.put(syncQueue.Credit_Assessment__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Credit_Assessment__c creAssessment : lstCreAssessment) {
            Sync_Queue__c[] synchQueueList = creAssessmentIdToSynchQueListMap.get(creAssessment.Id);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    //synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = creAssessment.Id;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = creAssessment.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_CREDIT_ASSESSMENT;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_CREDIT_ASSESSMENT_DELETED;
            //syncQueue.Notes__c = currentDateTime;
            synchQueueCreateList.add(syncQueue);
            
        }
        if (!synchQueueUpdateList.isEmpty()) {
            update synchQueueUpdateList;
        }
        if (!synchQueueCreateList.isEmpty()) {
            insert synchQueueCreateList;
        }
    }// end of updateSyncQueueRecord
}// end of class