// Write a Trigger for whenever a Contact gets Inserted the Account should get Inserted with the same name as 
//the Parent of that newly inserted Contact record.
trigger interviewTrigger on Contact (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        interviewTriggerHandler.onAfterInsert(Trigger.new, Trigger.oldMap);
    }
}