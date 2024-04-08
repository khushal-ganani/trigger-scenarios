// trigger Q8_AvoidDeleteAccountWithOpp on Account (before delete) {
//     if (Trigger.isBefore && Trigger.isDelete) {
//         for (Account acc : [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :Trigger.old]) {
//             if (acc.Opportunities.size() > 0) {
//                 acc.addError('You cannot delete an Account with associated Opportunities.');
//             }
//         }
//     }
// }

//! Avoid deletion of Account records with reltaed opportunities
// trigger Q8_AvoidDeleteAccountWithOpp on Account (before delete) {
//     if (Trigger.isBefore && Trigger.isDelete) {
//         // Query all Accounts with their related Opportunities
//         Map<Id, Account> accountsWithOpps = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :Trigger.old]);
        
//         // Check each Account for associated Opportunities
//         for (Account acc : Trigger.old) {
//             if (accountsWithOpps.containsKey(acc.Id) && accountsWithOpps.get(acc.Id).Opportunities.size() > 0) {
//                 acc.addError('You cannot delete an Account with associated Opportunities.');
//             }
//         }
//     }
// }

trigger Q8_AvoidDeleteAccountWithOpp on Account (before delete) {
    if(Trigger.isBefore){
        Set<Id> accIds = new Set<Id>();
        List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :Trigger.old];
        for(Opportunity opp : opps){
            accIds.add(opp.AccountId);
        }
        for(Account acc : Trigger.old){
            if(accIds.contains(acc.Id)){
                acc.addError('Cannot delete account with related opportunities.');
            }
        }
    }
}
