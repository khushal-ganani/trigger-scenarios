@IsTest
public with sharing class Q4_TestUpdateChildContacts {
    @TestSetup
    static void makeData(){
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accList.add(new Account(
                Name = 'Test Account '+i,
                Phone = '999-999-9999'
            ));
        }
        Database.SaveResult[] saveResult = Database.insert(accList, false);
    }

    @IsTest
    static void testAfterUpdate() {
        Map<Id,Account> accMap = [SELECT Id, Phone FROM Account WHERE Name LIKE 'Test Account%'];
        for (Account acc : accMap) {
            acc.Phone = '888-888-8888';
        }

        Test.startTest();
        Database.SaveResult[] saveResult = Database.update(accMap, false);
        Test.stopTest();

        System.assertEquals(200, [SELECT COUNT() FROM Contact WHERE AccountId IN :accMap.keySet() AND Phone = '888-888-8888']);
    }
}