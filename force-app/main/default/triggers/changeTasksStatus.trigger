trigger changeTasksStatus on Case (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        Set<Id> caseIds = new Set<Id>();
        for (Case cs : Trigger.new) {
            if (cs.Status == 'Escalated' && ((Case)Trigger.oldMap.get(cs.Id)).Status != 'Escalated') {
                caseIds.add(cs.Id);
            }
        }

        List<Task> taskList = [SELECT Id, Status FROM Task WHERE WhatId IN :caseIds];
        for (Task tsk : taskList) {
            tsk.Status = 'In-Progress';
        }

        update taskList;
    }
}