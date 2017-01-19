public class OpportunityTeamProcessor 
{
   @future
    public static void createOpportunityTeamMember(Set<Id> setIds) 
    {
        list<Opportunity> lstOpportunity = [select Id, Introducer__c ,RecType_Name__c,OwnerId 
        									from Opportunity where Id IN :setIds];
        
        map<String,Set<Id>> mapCountry_SetUserId = new map<String,Set<Id>>();
        list<OpportunityTeamMember> lstOpportunityTeamMember = new list<OpportunityTeamMember>();
        
        
        list<GroupMember> lstGroupMember = [Select g.UserOrGroupId, g.Id, g.GroupId, g.Group.Name 
                                            From GroupMember g 
                                            where g.Group.Name like '%UK' 
                                            or g.Group.Name like '%Kong' 
                                            or g.Group.Name like '%Singapore' 
                                            or g.Group.Name like '%Philippines'];
        
        if(lstGroupMember != null && !lstGroupMember.isEmpty())
        {
            for(GroupMember objMember : lstGroupMember)
            {
                if(objMember.Group.Name.contains('UK') && String.ValueOf(objMember.UserOrGroupId).startsWith('005'))
                {
                    if(!mapCountry_SetUserId.containsKey('UK'))
                        mapCountry_SetUserId.put('UK', new set<Id>{objMember.UserOrGroupId});
                    else
                        mapCountry_SetUserId.get('UK').add(objMember.UserOrGroupId);
                }
                
                if(objMember.Group.Name.contains('Singapore') && String.ValueOf(objMember.UserOrGroupId).startsWith('005'))
                {
                    if(!mapCountry_SetUserId.containsKey('Singapore'))
                        mapCountry_SetUserId.put('Singapore', new set<Id>{objMember.UserOrGroupId});
                    else
                        mapCountry_SetUserId.get('Singapore').add(objMember.UserOrGroupId);
                } 
                
                if(objMember.Group.Name.contains('Hong') && String.ValueOf(objMember.UserOrGroupId).startsWith('005'))
                {
                    if(!mapCountry_SetUserId.containsKey('Hong'))
                        mapCountry_SetUserId.put('Hong Kong', new set<Id>{objMember.UserOrGroupId});
                    else
                        mapCountry_SetUserId.get('Hong Kong').add(objMember.UserOrGroupId);
                }
                
                if(objMember.Group.Name.contains('Philippines') && String.ValueOf(objMember.UserOrGroupId).startsWith('005'))
                {
                    if(!mapCountry_SetUserId.containsKey('Philippines'))
                        mapCountry_SetUserId.put('Philippines', new set<Id>{objMember.UserOrGroupId});
                    else
                        mapCountry_SetUserId.get('Philippines').add(objMember.UserOrGroupId);
                }
                       
            } // end of lstGroupMember for loop
        } // end of lstGroupMember not null
        
        for(Opportunity objOpp : lstOpportunity)
        {
            System.debug('objOpp.OwnerId>>>>>'+objOpp.OwnerId);
           
                OpportunityTeamMember objOppTeammember = new OpportunityTeamMember();
                objOppTeammember.OpportunityId = objOpp.Id;
                objOppTeammember.UserId = objOpp.OwnerId;
                objOppTeammember.TeamMemberRole = 'Hunter';
                lstOpportunityTeamMember.add(objOppTeammember);
            
            if(objOpp.Introducer__c != null)
            {
                OpportunityTeamMember objChannelPartner = new OpportunityTeamMember();
                objChannelPartner.OpportunityId = objOpp.Id;
                objChannelPartner.UserId = objOpp.Introducer__c ;
                objChannelPartner.TeamMemberRole = 'Channel Partner';
                lstOpportunityTeamMember.add(objChannelPartner);
            }
            
            String strKey = '';
            if(objOpp.RecType_Name__c.contains('UK'))
            {
                strKey = 'UK';
            }
            
            else if(objOpp.RecType_Name__c.contains('Singapore'))
            {
                strKey = 'Singapore';
            }
           
            else if(objOpp.RecType_Name__c.contains('Philippines'))
            {
                strKey = 'Philippines';
            } 
           
            else if(objOpp.RecType_Name__c.contains('Kong'))
            {
                strKey = 'Hong Kong';
            } 
            
            
            if(strKey != '')
            {
                if(mapCountry_SetUserId.get(strKey) != null)
                {
	                for(Id objId : mapCountry_SetUserId.get(strKey))
	                {
	                    OpportunityTeamMember objSalesAdmin = new OpportunityTeamMember();
	                    objSalesAdmin.OpportunityId = objOpp.Id;
	                    objSalesAdmin.UserId = objId;
	                    objSalesAdmin.TeamMemberRole = 'Sales Administrator';
	                    lstOpportunityTeamMember.add(objSalesAdmin);
	                }
                }
            } // end of strKey != ''
        } // end of lstOpportunity for loop
        
        if(!lstOpportunityTeamMember.isEmpty())
        {
            insert lstOpportunityTeamMember;
        }   
	} // end of createOpportunityTeamMember
} // end of class