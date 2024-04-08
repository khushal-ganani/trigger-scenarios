public with sharing class AccountController {
    
    @AuraEnabled
    public static List<Account> getAccounts() {
        List<Account> accList = [SELECT Id, Name FROM Account LIMIT 5];
        return accList;
    }
}