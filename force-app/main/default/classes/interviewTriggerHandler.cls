public with sharing class interviewTriggerHandler {
    public static void onAfterInsert(List<Contact> conList, Map<Id,Contact> conMap){
        List<Account> accList = new List<Account>();
        for (Contact con : conList) {
            accList.add(new Account(
                Name = con.FirstName + ' ' + con.lastName 
            ));
        }
        Database.SaveResult[] saveResult = Database.insert(accList, false);

        Set<String> contactNames = new Set<String>();
        for (Contact con : conList) {
            contactNames.add(con.FirstName + ' ' + con.lastName);
        }

        Map<String, Id> accountNamesMap = new Map<String, Id>();
        List<Account> matchingAccounts = [SELECT Id, Name FROM Account WHERE Name IN :contactNames];
        for (Account acc : matchingAccounts){
            accountNamesMap.put(acc.Name, acc.Id);
        }

        for (Contact con : conList) {
            String name = con.FirstName + ' ' + con.lastName;
            con.AccountId = accountNamesMap.get(name);
        }
    }
}