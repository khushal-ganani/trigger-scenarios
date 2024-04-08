// On creation of Account create a child contact record with same name
trigger Q2_CreateChildContact on Account (after insert) {
    List<Contact> conList = new List<Contact>();
    for (Account acc : Trigger.new) {
        conList.add(new Contact(
            lastName = acc.Name,
            accountId = acc.Id
        ));
    }

    if (!conList.isEmpty()) {
        Database.SaveResult[] saveResult = Database.insert(conList, false);
        for ( Database.SaveResult sr : saveResult) {
            if (sr.isSuccess()) {
                System.debug('Contact cretaed');
            } else {
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contact fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
}
