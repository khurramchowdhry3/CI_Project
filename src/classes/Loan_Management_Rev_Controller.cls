public class Loan_Management_Rev_Controller {
    
    public string selectedProgram { get; set; }
    public string selectedStatus { get; set; }
    
    public integer totalRecs { get; set; }
    public integer OffsetSize { get; set; }
    public integer LimitSize { get; set; }
    
    public string sortColumn { get; set;}
    public string prevSortColumn { get; set; }
    public string sortOrder { get; set; }
    
    public Id selectedId { get; set; }
    public string SearchText    {get; set;}
        
    public Loan_Management_Rev_Controller(ApexPages.StandardController stdController)
    {
        selectedProgram = 'All';
        selectedStatus = 'All';
        
        totalRecs = 0;
        OffsetSize = 0;
        LimitSize = 20;
        
        sortColumn = 'Id';
        prevSortColumn = 'Id';
        sortOrder = 'ASC';
                
    }
    
    public List<SelectOption> getPrograms()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All', 'All'));
        
        List<Program__c> programs = [Select Id, Name from Program__c Order By Name];
        
        for (Program__c pr : programs)
        {
            options.add(new SelectOption(pr.Id, pr.Name));
        }
        
        return options;
    }
    
    public List<SelectOption> getStatuses()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All', 'All'));
        
        Schema.DescribeFieldResult fieldResult = Operation__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry e : ple)
        {
            options.add(new SelectOption(e.getValue(), e.getLabel()));
        }
        
        return options;
    }
    
    public void FindOperationsByClient(){
        totalRecs = 0;
        OffsetSize = 0;
        LimitSize = 20;
    }
    
    public List<Operation__c> getOperations()
    {
        string SearchString = '';
        List<Operation__c> operations = new List<Operation__c>();
        string strQuery = 'select id, name, Account__r.Name, Loan_Amount__c, Loan_Outstanding_Principal__c, Loan_Disbursed_Date__c, Status__c, ';
        strQuery += '(select Id, Event_Type__c from Loan_Management_Events__r where (Event_Type__c = \'Change Collection Amount\' and IsActive__c = true and Event_Date__c <= TODAY and (Event_End_Date__c >= TODAY or Event_End_Date__c = null))';
        strQuery += ' OR (Event_Type__c = \'Payment Holiday\' and Event_Date__c <= TODAY and Event_End_Date__c >= TODAY and IsActive__c = true )) ';
        strQuery += ' from Operation__c where Id != null';
        string strCountQuery = 'select count() from Operation__c where Id != null';
                
        if (selectedProgram != 'All')
        {
            strQuery = strQuery + ' and Program_Product_ASO__c in (select id from Program_Product_ASO__c where Program__c =:selectedProgram)';
            strCountQuery = strCountQuery + ' and Program_Product_ASO__c in (select id from Program_Product_ASO__c where Program__c =:selectedProgram)';
        } 

        if (selectedStatus != 'All')
        {
            strQuery = strQuery + ' and Status__c =:selectedStatus';
            strCountQuery = strCountQuery + ' and Status__c =:selectedStatus';
        }
        
        if(SearchText != null && SearchText.trim() != ''){
            SearchText = string.escapeSingleQuotes(EncodingUtil.urlDecode(SearchText, 'UTF-8'));
            SearchString =  '%'+SearchText+'%'; 
            system.debug('SearchString :: '+SearchString);
            strQuery = strQuery + ' AND Account__r.Name LIKE : SearchString';
            strCountQuery = strCountQuery + ' AND Account__r.Name LIKE : SearchString';
        }
        
        totalRecs = Database.countQuery(strCountQuery);
                
        strQuery = strQuery + ' ORDER BY ' + sortColumn + ' ' + sortOrder + ' NULLS ' + (sortOrder == 'ASC' ? 'FIRST' : 'LAST');
        strQuery = strQuery + ' LIMIT :LimitSize OFFSET :OffsetSize';
        system.debug('strQuery :: '+strQuery);        
        operations = Database.query(strQuery);        
        
        prevSortColumn = sortColumn;
        
        return operations;
    }
    
    public void FirstPage()
    {
        OffsetSize = 0;
    }
    
    public void previous()
    {
        OffsetSize = OffsetSize - LimitSize;
    }
    
    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
    }
    
    public void LastPage()
    {
        OffsetSize = totalrecs - math.mod(totalRecs, LimitSize);
    } 
    
    public void sortOrder()
    {
        if (sortColumn == prevSortColumn && sortOrder == 'ASC')
            sortOrder = 'DESC';        
        else
            sortOrder = 'ASC';
        
    }
    
}