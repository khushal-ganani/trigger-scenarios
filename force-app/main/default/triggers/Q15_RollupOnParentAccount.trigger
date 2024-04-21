//!! Rollup the number of contact records associated with an account on the parent account object.
//!! Also rollup the SUM of Amount__c field on the contact on the parent account object field called Total_Contact_Amount__c.

trigger Q15_RollupOnParentAccount on contact (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter){
        Set<Id> accountIdSet = new Set<Id>();
        if (Trigger.isInsert || Trigger.isUndelete) {
            for (Contact con : Trigger.new) {
                if (con.AccountId != null || con.AccountId != '') {
                    accountIdSet.add(con.AccountId);
                }
            }
        }

        if (Trigger.isUpdate) {
            for (Contact con : Trigger.new) {

                //* Here it is checked whether the AccountId field is changed to some other Account's AccountId 
                //* i.e the contact is reparented or not. This is done using oldMap
                if ((con.AccountId != null || con.AccountId != '') && 
                (con.AccountId != (Contact)(Trigger.oldMap.get(con.Id)).AccountId)) {
                    accountIdSet.add(con.AccoutnId); //! adding the Id of the new reparented Account to calculate the number of contacts
                    accountIdSet.add((Contact)(Trigger.oldMap.get(con.Id)).AccountId); //! also adding the Id of old Account to recalculate the number of contacts
                }
            }
        }
        
        if(Trigger.isDelete){
            for (Contact con : Trigger.old) {
                if (con.AccountId != null || con.AccountId != '') {
                    accountIdSet.add(con.AccountId);
                }
            }
        }

        if(accountIdSet != null && accountIdSet.size() > 0){
            List<Account> accountList = [SELECT Id, Number_of_Contacts__c, Total_Contact_Amount__c, (SELECT Id FROM Contacts) 
                                        FROM Account WHERE Id IN :accountIdSet];
            if (accountList.size() > 0) {
                for (Account acc : accountList) {
                    acc.Number_of_Contacts__c = acc.Contact.size();
                    
                    if (!acc.Contacts.isEmpty()) {
                        Decimal totalAmount = 0;
                        for (Contact con : acc.Contacts) {
                            totalAmount += con.Amount__c;
                        }

                        acc.Total_Contact_Amount__c = totalAmount;
                    }
                }
            }
            update accountList;
        }    
    }
}