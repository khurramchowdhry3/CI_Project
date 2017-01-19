/**
    CRMS_OpportunityTeamProcessor class
    Author: CRM Superstars
    Version: 1.0
*/
public class CRMS_OpportunityTeamProcessor 
{
   // Insert Sales Administrators, Introducer and Owner to Opportunity Team 
   @future
    public static void createOpportunityTeamMember(Set<Id> setIds) 
    {
        list<Opportunity> lstOpportunity = [select Id, Introducer__c ,RecType_Name__c,OwnerId,
                                            Introducer__r.IsPortalEnabled
                                            from Opportunity where Id IN :setIds];
        
        map<String,Set<Id>> mapCountry_SetUserId = new map<String,Set<Id>>();
        list<OpportunityTeamMember> lstOpportunityTeamMember = new list<OpportunityTeamMember>();
        
        
        list<GroupMember> lstGroupMember = [Select g.UserOrGroupId, g.Id, g.GroupId, g.Group.Name 
                                            From GroupMember g 
                                            where g.Group.Name like '%Administrator%'];
        
        if(lstGroupMember != null && !lstGroupMember.isEmpty())
        {
            //fetch Region based System Administrator Queue and generate map of Region and Queue Id
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

        String strKey = '';
        for(Opportunity objOpp : lstOpportunity){
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
        }

        map<Id,User> mapId_User;
        if(mapCountry_SetUserId.get(strKey) != null){
            mapId_User = new map<Id,User>([SELECT Id, isActive FROM User WHERE Id
                                            IN: mapCountry_SetUserId.get(strKey)
                                            and isActive = true]);
        }
        system.debug('mapId_User>>>>>>'+mapId_User);
        
        for(Opportunity objOpp : lstOpportunity)
        {
            OpportunityTeamMember objOppTeammember = new OpportunityTeamMember();
            objOppTeammember.OpportunityId = objOpp.Id;
            objOppTeammember.UserId = objOpp.OwnerId;
            objOppTeammember.TeamMemberRole = 'New Loans Manager';
            lstOpportunityTeamMember.add(objOppTeammember);
            
            if(objOpp.Introducer__c != null && objOpp.Introducer__r.IsPortalEnabled)
            {
                OpportunityTeamMember objChannelPartner = new OpportunityTeamMember();
                objChannelPartner.OpportunityId = objOpp.Id;
                objChannelPartner.UserId = objOpp.Introducer__c ;
                objChannelPartner.TeamMemberRole = 'Channel Partner';
                lstOpportunityTeamMember.add(objChannelPartner);
            }

            if(strKey != '')
            {
                if(mapCountry_SetUserId.get(strKey) != null)
                {
                    for(Id objId : mapCountry_SetUserId.get(strKey))
                    {
                        system.debug('objId>>>>>>>'+objId);
                        system.debug('mapId_User.get(objId)>>>>>>>'+mapId_User.get(objId));
                        if(mapId_User.get(objId) != null){
	                        OpportunityTeamMember objSalesAdmin = new OpportunityTeamMember();
	                        objSalesAdmin.OpportunityId = objOpp.Id;
	                        objSalesAdmin.UserId = objId;
	                        objSalesAdmin.TeamMemberRole = 'Sales Administrator';
	                        lstOpportunityTeamMember.add(objSalesAdmin);
                        }
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