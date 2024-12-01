
@IsTest
private class Q16_ContactChangeEventTriggerTest {
    @IsTest
    static void testContactChangeEvent() {
        Test.enableChangeDataCapture(); // Enable all Change Data Capture Entities for notifications.
        Test.startTest();
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Contact'
        );
        insert con;

        // Test.getEventBus().deliver(); //! Deliver Test change events

        Test.stopTest(); //! stopTest() call also delivers Test change events and Trigger is called

        Assert.areEqual(1, [SELECT COUNT() FROM Task WHERE Subject = 'New Contact Task' AND WhoId = :con.Id]);
    }
}