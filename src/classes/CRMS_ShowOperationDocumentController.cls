/**
 * This class used to show set the flag for show sharepoint document.
 *
 * Initial Draft            Author           Date
 * Version 1.0              Yogesh          25/5/2015 

 *
 
 */
public with sharing class CRMS_ShowOperationDocumentController {
    // It is used to set the flag
    public Boolean isUK           { get;set; }
    public Boolean isHK           { get;set; }
    public Boolean isSG           { get;set; }
    public Boolean isPH           { get;set; }    
    
    //Standard controller constructor
    public CRMS_ShowOperationDocumentController(Apexpages.StandardController stdCon) {
        Id objectId = stdCon.getRecord().Id;
        isHK = false;
        isSG = false;
        isPH = false;
        isUK = false;
        Operation__c objOperation = [SELECT id,
                                            RecordType.Name
                                    FROM Operation__c 
                                    WHERE Id = :objectId
                                    LIMIT 1];
        system.debug('------ Inside controller-------->');
        If( objOperation.RecordType.Name.contains('Hong Kong') || objOperation.RecordType.Name.contains('HK') )
            isHK = true;
        If( objOperation.RecordType.Name.contains('UK') )
            isUK = true;
        If( objOperation.RecordType.Name.contains('Singapore') || objOperation.RecordType.Name.contains('SG') )
            isSG = true;
        If( objOperation.RecordType.Name.contains('Philippines') || objOperation.RecordType.Name.contains('PH') )
            isPH = true;
    } //End of constructor
}