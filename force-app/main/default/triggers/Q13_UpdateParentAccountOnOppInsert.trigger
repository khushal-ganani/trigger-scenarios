// If opportunity is inserted with amount > 20000 then, update the related account record Premium__c field to true
trigger Q13_UpdateParentAccountOnOppInsert on Opportunity (after insert) {

    Set<Id> oppIdSet = new Set<Id>();
    for (Opportunity opp : Trigger.new) {
        if (opp.AccountId != null || opp.AccountId = '') {
            if (opp.Amount > 20000) {
                oppIdSet.add(opp.AccountId);
            }
        }
    }

    if (!oppIdSet.isEmpty()) {
        List<Account> accList = [SELECT Premium__c FROM Account WHERE Id IN :oppIdSet];
        for (Account acc : accList) {
            acc.Premium__c = true;
            System.debug('Show me ==> ' + acc.Premium__c);
        }
        update accList;
    }
}