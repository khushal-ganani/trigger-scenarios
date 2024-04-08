@IsTest
public with sharing class Q2_Test_CreateChildContact {

    static List<Account> makeData(Integer numberOfRecords){
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            accList.add(new Account(
                Name = 'Test '+i
            ));
        }
        insert accList;
    }

    @IsTest
    static void testAfterInsert(){
        List<Account> insertedAccounts = makeData(300);
        System.assertNotEquals(0, insertedAccounts.size(), 'No accounts inserted');

        // Fire the trigger by inserting Account records
        Test.startTest();
        // Inserting accounts to fire the trigger
        // You can also use the insertedAccounts list if you have other assertions to perform
        insert insertedAccounts;
        Test.stopTest();

        System.assertEquals(300, [SELECT COUNT() FROM Contact WHERE AccountId IN :insertedAccounts], 'The number of contacts is not 200');
    }
}
