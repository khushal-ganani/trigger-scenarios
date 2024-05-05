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
                    accountIdSet.add(((Contact)(Trigger.oldMap.get(con.Id))).AccountId); //! also adding the Id of old Account to recalculate the number of contacts
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

            //* First way to implement :-
            // List<Account> accountList = [SELECT Id, Number_of_Contacts__c, Total_Contact_Amount__c, (SELECT Id FROM Contacts) 
            //                             FROM Account WHERE Id IN :accountIdSet];
            // if (accountList.size() > 0) {
            //     for (Account acc : accountList) {
            //         acc.Number_of_Contacts__c = acc.Contacts.size();
                    
            //         if (!acc.Contacts.isEmpty()) {
            //             Decimal totalAmount = 0;
            //             for (Contact con : acc.Contacts) {
            //                 totalAmount += con.Amount__c;
            //             }

            //             acc.Total_Contact_Amount__c = totalAmount;
            //         }
            //     }
            // }
            // update accountList;

            //* Another way to implement :-
            List<AggregateResult> results = [SELECT AccountId, COUNT(Id)TotalContacts FROM Contacts WHERE AccountId IN :accountIdSet GROUP BY AccountId ORDER BY AccountId];
            
            if (!results.isEmpty()) {
                Map<Id, Decimal> contactsCountMap = new Map<Id, Decimal>();
                for (AggregateResult res : results) {
                    contactsCountMap.put((Id)(res.get('AccountId')), (Decimal)(res.get('TotalContacts')));
                }

                List<Account> accountsToUpdate = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id IN :accountIdSet];
                for (Account acc : accountsToUpdate) {
                    if (contactsCountMap.containsKey(acc.Id)) {
                        acc.Number_of_Contacts__c = contactsCountMap.get(acc.Id);
                    }else{
                        acc.Number_of_Contacts__c = 0;
                    }
                }
            }
        }    
    }
}