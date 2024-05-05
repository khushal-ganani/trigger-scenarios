//!! Rollup the total number of OpportunityContactRoles on the grand-parent Account object's 
//!! Rollup_Number_Of_Opp_Ships_Out__c field
trigger RollupOnGrandParent on OpportunityContactRole (after insert) {

    if (Trigger.isInsert && Trigger.isAfter) {
        Set<Id> oppIds = new Set<Id>();
        for (OpportunityContactRole oppCon : Trigger.new) {
            if (oppCon.opportunityId != null || oppCon.opportunityId != '') {
                oppIds.add(oppCon.opportunityId);
            }
        }

        List<Opportunity> oppList = [SELECT Id, AccountId, (SELECT Id FROM OpportunityContactRoles) FROM 
                                    Opportunity WHERE Id IN :oppIds];
        Map<Id, Decimal> countOccurenceMap = new Map<Id, Integer>();
        for (Opportunity opp : oppList) {
            accIds.add(opp.AccountId);
            countOccurenceMap.put(opp.Id, opp.OpportunityContactRoles.size());
        }

        List<Account> accountList = [SELECT Id, Rollup_Number_Of_Opp_Ships_Out__c, (SELECT Id FROM Opportunities)
                                    FROM Account WHERE Id IN :countOccurenceMap.keySet()];
        for (Account acc : accountList) {
            Decimal totalOppContRoles = 0;
            if (!acc.Opportunitoes.isEmpty()) {
                for (Opportunity opp : acc.Opportunities) {
                    totalOppContRoles += countOccurenceMap.get(opp.Id);
                }
            }
            acc.Rollup_Number_Of_Opp_Ships_Out__c = totalOppContRoles;
        }
    }
}
