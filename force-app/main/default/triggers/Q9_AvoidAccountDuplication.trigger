//! Avoid inserting of Account records with the same name as existing records (Avoid Dupliation)
trigger Q9_AvoidAccountDuplication on Account (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {

        Set<String> accNameSet = new Set<String>();
        for (Account acc : Trigger.new) {
            accNameSet.add(acc.Name.toLowerCase());
        }

        List<Account> duplicateAccounts = [SELECT Id, Name FROM Account WHERE Name IN :accNameSet];

        if (!duplicateAccounts.isEmpty()) {
            List<String> existingNameList = new List<String>();
            for (Account acc : duplicateAccounts) {
                existingNameList.add(acc.Name.toLowerCase());
            }
            
            for (Account acc : Trigger.new) {
                if (existingNameList.contains(acc.Name.toLowerCase())) {
                    acc.addError('Account with Name as '+acc.Name+' already exists!');
                }
            }
        }
    }
}