/**
    Controller for the Lead Flow, currently not being used
    Author: Vivian
    Version: 1.0
*/
public class CRMS_CreditAssessmentController{
    public Credit_Assessment__c objCA {get;set;}
    //public Decimal repaymentAmount{get;set;}
    public CRMS_CreditAssessmentController (ApexPages.StandardController controller){
        creditAssessmentDetails(controller.getId());
    }

    public void creditAssessmentDetails(Id objCA_Id){
        //repaymentAmount = 0.0;
        list<Credit_Assessment__c> lstCA = [select Id, Total_Weekly_Amount_Repayable_Approved__c,
                                           Total_Amount_Repayable_Approved__c,AMP_Credit_Score__c,
                                            FOC__c from Credit_Assessment__c
                                            where Id =: objCA_Id];

        if(lstCA != null && !lstCA.isEmpty()){
            objCA = new Credit_Assessment__c(Id = lstCA[0].Id, AMP_Credit_Score__c = lstCA[0].AMP_Credit_Score__c);
            if(lstCA[0].FOC__c != null && lstCA[0].FOC__c != ''
            && lstCA[0].FOC__c.equalsIgnoreCase('Weekly'))
                objCA.Test__c = lstCA[0].Total_Weekly_Amount_Repayable_Approved__c;
            else
                objCA.Test__c = lstCA[0].Total_Amount_Repayable_Approved__c;
        }
    } // end of creditAssessmentDetails
    
    public list<CreditAssessmentIncomeDetails> getIncomeDetails(){
        
        list<CreditAssessmentIncomeDetails> listIncome = new list<CreditAssessmentIncomeDetails>();
        if (objCA != null){
            listIncome.add(new CreditAssessmentIncomeDetails('M1', (objCA.Paid_In_M1__c != null) ? objCA.Paid_In_M1__c : 0, (objCA.Paid_Out_M1__c != null) ? objCA.Paid_Out_M1__c : 0));
            listIncome.add(new CreditAssessmentIncomeDetails('M2', (objCA.Paid_In_M2__c != null) ? objCA.Paid_In_M2__c : 0, (objCA.Paid_Out_M2__c != null) ? objCA.Paid_Out_M2__c : 0));
            listIncome.add(new CreditAssessmentIncomeDetails('M3', (objCA.Paid_In_M3__c != null) ? objCA.Paid_In_M3__c : 0, (objCA.Paid_Out_M3__c != null) ? objCA.Paid_Out_M3__c : 0));            
        }     
        
        return listIncome;
    }
} // end of class