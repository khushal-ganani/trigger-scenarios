//! If account phone is updated then pouplate the phone number on the related contact. (Using Map)
trigger Q4_UpdateChildContacts on Account (after update) {

    //Getting a Map of all the Accounts whose phone is being updated
    Map<Id, String> accMap = new Map<Id, String>();
    for (Account acc : Trigger.new) {
        if (acc.Phone != null && Trigger.oldMap.get(acc.Id).Phone != acc.Phone) {
            accMap.put(acc.Id, acc.Phone);
        }
    }

    if (!accMap.isEmpty()) {
        List<Contact> conList = [SELECT Id, Phone FROM Contact WHERE AccountId IN :accMap.keySet()];
        for (Contact con : conList) {
            if (accMap.containsKey(con.AccountId)) {
                con.Phone = accMap.get(con.AccountId);
            }
        }
        update conList;
    }

    // other way of same trigger
    // Set<Id> accountIds = new Set<Id>();
    // for (Account acc : Trigger.new) {
    //     if (acc.Phone != Trigger.oldMap.get(acc.Id).Phone) {
    //         accountIds.add(acc.Id);
    //     }
    // }

    // if (!accountIds.isEmpty()) {
    //     List<Contact> conList = [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN :accountIds];
        
    //     for (Contact con : conList) {
    //         con.Phone = (Account)(Trigger.newMap.get(con.AccountId)).Website;
    //     }

    //     update conList;
    // }
}