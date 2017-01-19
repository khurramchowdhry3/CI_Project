public class AMP_Utils {
	public static String getCurrencyISOByCountryCode(String country){
        if(country == 'UK') return 'GBP';
        else if (country == 'HK') return 'HKD';
        
        else if (country == 'SG') return 'SGD';
        
        else if (country == 'PH') return 'PHP';
        
        else return 'GBP';    
    }
    public static Task createTask (String subject,String description, String status,String priority, ID assignedTo, ID relatedTo, Date dueDate){
        Task t = new Task(Subject = subject, Description = description,
                         Status = status, Priority = priority,
                         OwnerId  = assignedTo, WhatId  = relatedTo,
                         ActivityDate  = dueDate);
        return t;
    }
}