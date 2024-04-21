// If phone of an account is updated then populate the description field of account as :- 'Phone is update. Previous
// phone number was: ....'
trigger Q3_UpdateAccountDescription on Account (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Account acc : Trigger.new) {
            String oldPhone = (Account)(Trigger.oldMap.get(acc.Id)).Phone;
            if (acc.Phone != oldPhone) {
                acc.Description += 'Phone is updated. Previous Phone Number was: '+oldPhone;
            }
        }
    }
}