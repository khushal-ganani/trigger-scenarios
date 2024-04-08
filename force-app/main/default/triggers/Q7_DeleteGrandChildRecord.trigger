//! if the account record field Active__c is updated to No, then delete all the related grand child 
//! OpportunityContactRole records.
trigger Q7_DeleteGrandChildRecord on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {

        // getting the Set of all thr accounts that are updated as inactive
        Set<Id> accSet = new Set<Id>();
        for (Account acc : Trigger.new) {
            if ((Account)(Trigger.oldMap.get(acc.Id)).Active__c == 'Yes' && acc.Active__c == 'No') {
                accSet.add(acc.Id);
            }
        }

        if (!accSet.isEmpty()) {
            List<OpportunityContactRole> oppContRoleList = new List<OpportunityContactRole>();
            for (Opportunity opp : [SELECT Id, (SELECT Id FROM OpportunityContactRoles) FROM Opportunity WHERE AccountId IN :accSet]) {
                if (!opp.OpportunityContactRoles.isEmpty()) {
                    for(OpportunityContactRole opContRole : opp.OpportunityContactRoles){
                        oppContRoleList.add(oppContRole);
                    }
                }
            }
            Database.DeleteResult[] deleteResult = Database.delete(oppContRoleList, false);
        }
    }
}