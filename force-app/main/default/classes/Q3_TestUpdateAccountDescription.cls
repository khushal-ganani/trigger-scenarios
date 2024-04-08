public with sharing class Q3_TestUpdateAccountDescription {
    @TestSetup
    static void makeData(){
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 300; i++) {
            accList.add(new Account(
                Name = 'Test Account '+i,
                Phone = '999-999-9999'
            ));
        }
        insert accList;
    }

    @IsTest
    static void testBeforeUpdate(){
        List<Account> accList = [SELECT Id, Description FROM Account WHERE Name LIKE 'Test Account%'];
        for (Account acc : accList) {
            acc.Phone = '888-888-8888';
        }

        Test.startTest();
        Database.SaveResult[] saveResult = Database.update(accList, false);
        Test.stopTest();

        System.assertEquals(300, [SELECT COUNT() FROM Account WHERE Description = 'Phone is updated. Previous Phone Number was: 888-888-8888']);
        System.assertEquals(300, [SELECT COUNT() FROM Account WHERE Phone = '888-888-8888']);
    }
}