
@isTest
private class OpportunityTriggerHandlerTest {

    @isTest
    static void testSLAStatus() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.Today().addDays(10),
            Limit_Date__c = Date.Today().addDays(-1)
        );

        insert opp;

        Opportunity result = [SELECT Id, SLA_Status__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(result.SLA_Status__c, 'Overdue');
    }
}