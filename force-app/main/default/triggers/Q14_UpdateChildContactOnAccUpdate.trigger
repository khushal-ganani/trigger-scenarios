// update the related contacts by filling the Account website in Company_Website__c field of Contact when the related Account is updated.
trigger Q14_UpdateChildContactOnAccUpdate on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {

        // // getting the ids of the updated accounts with website changed
        // Set<Id> accountIds = new Set<Id>();
        // for (Account acc : Trigger.new) {
        //     if (acc.Website != (Account)(Trigger.oldMap.get(acc.Id)).Website) {
        //         accountIds.add(acc.Id);
        //     }
        // }

        // List<Contacts> conList = [SELECT Id, Company_Website__c, AccountId FROM Contacts WHERE AccountId IN :accountIds];
        // for (Contact con : conList) {
        //     con.Company_Website = (Account)(Trigger.newMap.get(con.AccountId)).Website;
        // }
        // Database.SaveResult saveResult = Database.update(conList);

        Map<Id,String> accWebMap = new Map<Id,String>();
        for (Account acc : Trigger.new) {
            if (acc.Website != (Account)(Trigger.oldMap.get(acc.Id)).Website) {
                accWebMap.put(acc.Id,acc.Website);
            }
        }
        if (!accWebMap.isEmpty()) {
            for(Contact con : [SELECT Id, Company_Website__c FROM Contact WHERE AccountId IN :accWebMap.keySet()]) {
                if (accWebMap.containsKey(con.AccountId)) {
                    con.Company_Website__c = accWebMap.get(con.AccountId);
                }
            }
        }    
    }
}