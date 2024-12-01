// Whenever a Contact is inserted or existing contact email address is updated then create a Task for the contact using ContactChangeEvent
trigger Q16_ContactChangeEventTrigger on ContactChangeEvent (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        System.debug('Q16_ContactChangeEventTrigger fired');
        Set<Id> recordIds = new Set<Id>();
        List<Task> newTasks = new List<Task>();
        for (ContactChangeEvent event : Trigger.new) {
            EventBus.ChangeEventHeader header = event.ChangeEventHeader;
            if (event.changeType == 'CREATE' || (event.changeType == 'UPDATE' && event.changedFields.contains('Email'))) {
                for (Id recordId : event.recordIds) {
                    newTasks.add(new Task(
                        Subject = event.changeType == 'CREATE' ? 'New Contact Task' : 'Update Contact Email Address',
                        Status = 'Not Started',
                        Priority = 'Normal',
                        OwnerId = header.commitUser,
                        WhoId = recordId
                    ));
                }
            }
        }

        if (!newTasks.isEmpty()) {
            try {
                insert newTasks;
            } catch (Exception e) {
                System.debug('Error occured while creating task: ' + e.getMessage());
            }
        }
    }
}