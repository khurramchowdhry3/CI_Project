//Author: Miroslav Handzhiev, Xoomworks
//After Campaign Member creation update corresponding Leads
//for the purpose of populating CampaignID__c on Lead
//Populating happens on Lead Trigger
trigger CampaignMemberTrigger on CampaignMember (after insert) {
    if(trigger.isAfter && trigger.isInsert) {
        Map<ID,ID> leadIDcampaignIDMap = new Map<ID,ID>();
        Set<ID> leadID = new Set<ID>();
        List<Lead> l = new List<Lead>();
        for(CampaignMember cm : trigger.new) {
            leadIDcampaignIDMap.put(cm.LeadId, cm.CampaignId);
            leadID.add(cm.LeadId);
        }
        
        l = [Select id from Lead where id in :leadID];
        if(!l.isEmpty())
        {
            update l;
        }
        
    }
}