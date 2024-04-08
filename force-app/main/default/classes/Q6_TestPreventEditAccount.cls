@IsTest
public with sharing class Q6_TestPreventEditAccount {
    @TestSetup
    static void makeData(){
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accList.add(new Account(
                Name = 'Test '+i
            ));
        }
        insert accList;
    }

    @IsTest
    static void testBeforeUpdate() {
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test%' AND CreatedDate = THIS_WEEK];
        for (Account acc : accList) {
            acc.Name += ' edited';
        }

        Test.startTest();
        try {
            update accList;
        } catch (Exception e) {
            // Verify Test Results: Verify if the Past Info Records are not deleted
            String message = e.getMessage();
            System.debug(message);
            Boolean expectedExceptionThrown =  message.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION');
            System.assertEquals(expectedExceptionThrown, true, 'Error! FIELD_CUSTOM_VALIDATION_EXCEPTION was not thrown');
            System.assertEquals('You cannot edit an Account created in the past week.', e.getDmlMessage(0), 'A different message was thrown.');
        }
        Test.stopTest();

    }
}