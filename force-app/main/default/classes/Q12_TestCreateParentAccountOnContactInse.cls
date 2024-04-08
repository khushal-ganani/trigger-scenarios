@IsTest
public class Q12_TestCreateParentAccountOnContactInse {
    @IsTest
    static void testContactInsert(){
        List<Contact> newContacts = new List<Contact>();
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        for (Integer i = 0; i < 400; i++) {
            if (i<200) {
                newContacts.add(new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact '+i,
                    Email = 'test'+i+'@test.com'
                ));
            } else if (i>=200) {
                newContacts.add(new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact '+i,
                    Email = 'test'+i+'@test.com',
                    AccountId = testAccount.Id
                ));
            }
        }

        Test.startTest();
        insert newContacts;
        Test.stopTest();

        Integer numberOfNewAccounts = [SELECT COUNT() FROM Account WHERE Name LIKE 'Test Contact%'];
        System.assertEquals(200, numberOfNewAccounts, 'The number of Accounts created is not 200');
    }
}