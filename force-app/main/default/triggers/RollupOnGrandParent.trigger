trigger RollupOnGrandParent on OpportunityContactRole (after insert) {

    if (Trigger.isInsert && Trigger.isAfter) {
        Set<Id> oppIds = new Set<Id>();
        for (OpportunityContactRole oppCon : Trigger.new) {
            oppIds.add(oppCon.opportunityId);
        }

        List<Opportunity> oppList = [SELECT Id, AccountId, Account.Number_of_OppotunityContactRoled__c FROM Opportunity
                                    WHERE Id IN :oppIds];
        for (Opportunity opp : oppList) {
            
        }
    }
}