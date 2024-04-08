@IsTest
public with sharing class Q1_Test_AccountRatingHot {

    @TestSetup
    private static void createData(){
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accList.add(new Account(
                Name = 'Test '+ i,
                Industry = 'Media',
                Rating = 'Warm'
            ));
        }
        for (Integer i = 0; i < 200; i++) {
            accList.add(new Account(
                Name = 'Test '+ i,
                Industry = 'Energy',
                Rating = 'Warm'
            ));
        }
        insert accList;
    }

    @IsTest
    public static void testBeforeInsert(){
        Integer hotAccounts = [SELECT COUNT() FROM Account WHERE Name LIKE 'Test%' AND Rating = 'Hot'];
        Integer notHotAccounts = [SELECT COUNT() FROM Account WHERE Name LIKE 'Test%' AND Rating != 'Hot'];
        System.assertEquals(200, hotAccounts, 'The number of hot accounts are not 200');
        System.assertEquals(200, notHotAccounts, 'The number of Acoounts whaich are not hot are not 200');
    }

}