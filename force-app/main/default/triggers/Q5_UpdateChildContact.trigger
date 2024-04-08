//! same question as Q4 If account phone is updated then pouplate the phone number on the related contact.
//! (Using Parent to Child SOQL)
trigger Q5_UpdateChildContact on Account (after update) {
    if (Trigger.isUpdate && Trigger.isAfter) {

        // getting set of Ids of Accounts where phone has changed
        Set<Id> accIds = new Set<Id>();
        for (Account acc : Trigger.new) {
            if (acc.Phone != null && Trigger.oldMap.get(acc.Id).Phone != acc.Phone) {
                accIds.add(acc.Id);
            }
        }

        if (!accIds.isEmpty()) {
            List<Contact> conList = new List<Contact>();

            for (Account acc : [SELECT Id, Phone, (SELECT Id, Phone FROM Contacts) FROM Account WHERE Id IN :accIds]) {
                if (!acc.Contacts.isEmpty()) {
                    for (Contact con : acc.Contacts) {
                        con.Phone = acc.Phone;
                        conList.add(con);
                    }
                }
            }
        }
    }
}