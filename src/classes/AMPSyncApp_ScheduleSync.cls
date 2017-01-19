/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to Schedule Sync Records which are pending in Queue
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class to Schedule Sync Records which are pending in Queue
 *
 */
 
public with sharing class AMPSyncApp_ScheduleSync implements system.Schedulable {
		
   /*
	*
	* Job runs with the differnce of every 5 mins which Sync Pending Records in Queue .
	*
	*/ 
	 
	public void execute(SchedulableContext SC){
		AMPSyncApp_SyncHandler.SyncQueueWithCAIROS();		
		
        if(SC.getTriggerId() != null){
        	System.abortJob(SC.getTriggerId());
        }        
        
        Datetime sysTime = System.now().addSeconds(300);
        if(new AMPSyncApp_SyncQueue().ToalPendingRecords() >= 200){
        	sysTime = System.now().addSeconds(120);
        }        
           
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule( 'Sync Queue', chronExpression, new AMPSyncApp_ScheduleSync());        
	}
}