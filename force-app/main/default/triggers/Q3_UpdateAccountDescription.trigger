// If phone of an account is updated then populate the description field of account as :- 'Phone is update. Previous
// phone number was: ....'
trigger Q3_UpdateAccountDescription on Account (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Account acc : Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(acc.Id);
            if (acc.Phone != oldAccount.Phone) {
                acc.Description += 'Phone is updated. Previous Phone Number was: '+oldAccount.Phone;
            }
        }
    }
}