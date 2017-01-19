/*
    This is the controller for Lead Flow visualforce page 
*/

public class CRMS_LeadManagementController 
{
    public boolean booleanPartner {get;set;}
    public Flow.Interview.New_Lead_Flow myflow {get;set;}
    String leadID;
    String baseUrl;
    
    public CRMS_LeadManagementController(ApexPages.StandardController controller)
    {
        leadID = apexpages.currentpage().getparameters().get('id');
        baseUrl = System.URL.getCurrentRequestUrl().toExternalForm();
        getUserType();
    }
    
    public void getUserType()
    {
        list<User>lstUser = [Select u.Profile_Name__c, u.Id From User u where u.Id =: userinfo.getuserid() limit 1];
        if((lstUser[0].Profile_Name__c.contains('Partner') && !lstUser[0].Profile_Name__c.contains('ships'))
        || baseUrl.contains('partner'))
        {
            booleanPartner = true;
        }
        else
        {
            booleanPartner = false;
        }
    } // end of getFinishlocation
    
    public PageReference getFinishLocation()
    {
        PageReference p = new PageReference('/'+leadID);
        p.setRedirect(true);
        return p;
    }
} // end of class