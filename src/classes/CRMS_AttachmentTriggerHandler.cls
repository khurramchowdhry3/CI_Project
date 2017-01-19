public without sharing class CRMS_AttachmentTriggerHandler 
{
	public void afterInsert(map<Id, Attachment> mapAttachment)
	{
		list<Attachment> lstAttachment = [Select a.ParentId, 
										 a.Name, a.Id, a.ContentType, a.BodyLength, a.Body 
										 From Attachment a
										 where a.Id IN:mapAttachment.keyset()];
	}
}