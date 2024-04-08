// Prevent Account records from being edited if the records is created 7 days back
trigger Q6_PreventEditAccount on Account(before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        for(Account acc : Trigger.new) {
            if (acc.CreatedDate < System.today() - 6) {
                acc.addError('You cannot edit an Account created in the past week.');
            }
        }
    }
}