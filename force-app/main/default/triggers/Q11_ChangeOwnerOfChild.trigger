// If owner of Account record is changed then change the owner of the related contact too
trigger Q11_ChangeOwnerOfChild on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {

        // getting the Map of AccountId and OwnerId of Accounts whose owner is changed
        Map<Id, Id> userMap = new Map<Id, Id>();
        for (Account acc : Trigger.new) {
            if (acc.OwnerId != (Account)(Trigger.oldMap.get(acc.Id)).OwnerId) {
                userMap.put(acc.Id, acc.OwnerId);
            }
        }

        if (!userMap.isEmpty()) {
            List<Contact> conList = [SELECT Id, OwnerId, AccountId FROM Contact WHERE AccountId IN :userMap.keySet()];
            for (Contact con : conList) {
                if (userMap.containsKey(con.AccountId)) {
                    con.OwnerId = userMap.get(con.AccountId);
                }
            }
            update conList;
        }
    }
}