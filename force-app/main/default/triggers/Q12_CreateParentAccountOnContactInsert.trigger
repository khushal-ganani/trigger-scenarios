//!! Create a parent Account with same name as contact that is being inserted and they both should also be related
trigger Q12_CreateParentAccountOnContactInsert on Contact (before insert) {
    
    List<Account> accountsToInsert = new List<Account>();
    
    for(Contact con : Trigger.new) {
        // Check if the contact has an account already
        if (con.AccountId == null) {
            // Create a new account related to the contact
            accountsToInsert.add(new Account(
                Name = con.FirstName + ' ' + con.LastName // Customize the account name based on the contact details
            ));
        }
    }
    
    // Insert the newly created accounts
    if (!accountsToInsert.isEmpty()) {
        insert accountsToInsert;
        
        // Update the contacts with the new AccountId
        for (Integer i = 0; i < Trigger.size; i++) {
            if (Trigger.new[i].AccountId == null) {
                Trigger.new[i].AccountId = accountsToInsert[i].Id;
            }
        }
    }
}