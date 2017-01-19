public class LMS_CalculationFieldDescriptor {
    public string fieldName { get; set; }
    public string fieldDisplayName { get; set; }
    public string fieldType { get; set; }
    
    public LMS_CalculationFieldDescriptor(string name, string displayName, string dataType)
    {
        fieldName = name;
        fieldDisplayName = displayName;
        fieldType = dataType;
    }
    
    public string fieldFormat
    {
        get 
        {
            string format = '{0}';
            if ( fieldType == 'Decimal')
                format = '{0, number, ##,##0.00}';
            
            if ( fieldType == 'DateTime')
                format = '{0, date, dd/MM/yyyy}';
            
            if ( fieldType == 'Percent')
                format = '{0, number, ##,##0.00}%';
            
            return format;
        }
    }
    
    public string fieldStyleClass
    {
        get
        {
            if (fieldName.containsIgnoreCase('total'))
                return 'bold';
            
            return '';
        }
    }
}