public with sharing class AMP_Test { 
   //This is a test class to check CI 
      
   public string getDateTimeFromUnix(){
   		integer UnixTimeStamp = 147277440;   		
		DateTime dateInstance = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
		String dateTimeValue = dateInstance.addSeconds(UnixTimeStamp).format();
		return dateTimeValue;
   }       
}