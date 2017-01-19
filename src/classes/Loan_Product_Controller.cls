public class Loan_Product_Controller {
    public ID recID {get;set;}
    public Product2 p {get;set;}    
    public boolean isNewOrEditRecord {get; set;}  
    public boolean isNewRecord {get;set;} 
    public boolean isDeleteActive {get;set;}
    public decimal selectedMinrate {get; set;}
    public decimal selectedMaxrate {get; set;}     
        
    public Loan_Product_Controller (ApexPages.StandardController stdController) {
        
        recID = ApexPages.currentPage().getParameters().get('id');
        if(recID == null)
            this.p = (Product2)stdController.getRecord();
        else
        {
            this.p = [Select Id, Name, ProductCode, Description, IsActive,Interest_type__c,
                      Product_Type__c, Country__c, Schedule_Type__c, Interest_Rate__c,Term__c, Full_Term__c,
                      Product_Name__c, Min_Interest_rate__c, Max_Interest_rate__c, Check_Name__c,CreatedById,LastModifiedById,CreatedDate,LastModifiedDate 
                      FROM Product2 Where id = :recID][0];
            
            isNewOrEditRecord=true;
            isNewRecord = false;
                                                
            if([select Id from Opportunity where Program_Product_ASO__r.Product__c  =:p.Id].size() > 0 || 
               [select Id from Operation__c where Program_Product_ASO__r.Product__c =:p.Id].size() > 0){
               /*
                *	Khurram Shahzad (02/03/2016) LMS-184
                *	Warning Message When user tries to edit the product which is associated with Loan.
                */
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There are loans in the system created with this product. Changes on this page, will affect their interest calculation.'));
                isDeleteActive = false;
            }else
                isDeleteActive = true;
        }
        if(p.Country__c == null && p.Schedule_Type__c == null) {
            //p.Country__c ='UK';
            isNewRecord = true;
            IR__c ukInterest = IR__c.getInstance();
            p.Interest_Rate__c = ukInterest.Annual_UK__c*100;   
        }
        if(isDeleteActive == null) isDeleteActive = true;
        if(isNewOrEditRecord == null) isNewOrEditRecord = false;
        if(isNewRecord == null) isNewRecord = false;
    }
    
    public List<SelectOption> getIntList()
    {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = 0; i <= 10; i ++)
            options.add(new SelectOption(string.valueof(i), string.valueof(i)));
        
        if (p.Interest_Rate__c != null && p.Min_Interest_rate__c != null && p.Max_Interest_rate__c != null)
        {
            selectedMinrate = p.Interest_Rate__c - p.Min_Interest_rate__c;
            selectedMaxrate = p.Max_Interest_rate__c - p.Interest_Rate__c;
        }
        
        return options;
    }
    
    public PageReference newRec()
    {
        isNewOrEditRecord = true;
        return null;
    }
     public PageReference save (){
                       
        try{
            p.Min_Interest_rate__c = p.Interest_Rate__c - selectedMinrate;
            p.Max_Interest_rate__c = p.Interest_Rate__c + selectedMaxrate;
            system.debug('p'+p);           
            upsert p;   
            
            Pagereference pr = new Pagereference('/apex/Loan_Product');
            //pr.getParameters().put('ID',recID);
            pr.setRedirect(true);
            return pr;
        }catch(DmlException e){
            String mess = e.getMessage();
            String existingID = mess.substringAfter('id: ').removeEnd(': []');
            system.debug('existingID:' + existingID);
            boolean checkName = mess.containsIgnoreCase('Check_Name__c');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A product with the same name already exists. You can open it <b><a href="Loan_Product?ID='+existingID+'" style="margin:0 0px;">here</a></b> ');
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, checkName ? 'A product with the same name already exists. You can open it <b><a href="Loan_Product?ID='+existingID+'" style="margin:0 0px;">here</a></b> ' : 'Sorry :/');
			ApexPages.addMessage(myMsg);
        } 
        return null;
    }    
    public PageReference deleteRecord () {
        delete p;
        
        Pagereference pr = new Pagereference('/apex/Loan_Product');
        pr.setRedirect(true);
        return pr;
    }
    public PageReference cancel () {        
        Pagereference pr = new Pagereference('/apex/Loan_Product');
        pr.setRedirect(true);
        return pr;
    }
}