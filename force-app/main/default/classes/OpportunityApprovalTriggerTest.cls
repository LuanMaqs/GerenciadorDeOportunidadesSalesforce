@isTest
private class OpportunityApprovalTriggerTest {

    @isTest
    static void testtPreventChangingApprovedStatus() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            OwnerId = UserInfo.getUserId(),
            StageName = 'Prospecting',
            CloseDate = Date.Today().addDays(10),
            Limit_Date__c = Date.Today().addDays(-1)
        );
        insert opp;

        Opportunity_Approval_c__c oppApproval = new Opportunity_Approval_c__c(
            Status__c = 'Pending',
            Opportunity__c = opp.Id,
            User__c = UserInfo.getUserId()
        );
        insert oppApproval;

        oppApproval.Status__c = 'Approved';
        update oppApproval;

        Opportunity updateOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Fechado - Aprovado', updateOpp.StageName);
    }

    @isTest
    static void testtPreventChangingRejectedStatus() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity for Rejected',
            OwnerId = UserInfo.getUserId(),
            StageName = 'Prospecting',
            CloseDate = Date.Today().addDays(10),
            Limit_Date__c = Date.Today().addDays(-1)
        );
        insert opp;

        Opportunity_Approval_c__c oppApproval = new Opportunity_Approval_c__c(
            Status__c = 'Pending',
            Opportunity__c = opp.Id,
            User__c = UserInfo.getUserId()
        );
        insert oppApproval;

        oppApproval.Status__c = 'Rejected';
        update oppApproval;

        Opportunity updateOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Fechado - Rejeitado', updateOpp.StageName);
    }

    @isTest
    static void testtAuthorizationException() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity No Permission',
            OwnerId = UserInfo.getUserId(),
            StageName = 'Prospecting',
            CloseDate = Date.Today().addDays(10),
            Limit_Date__c = Date.Today().addDays(-1)
        );
        insert opp;

        Opportunity_Approval_c__c oppApproval = new Opportunity_Approval_c__c (
            Status__c = 'Pending',
            Opportunity__c = opp.Id,
            User__c = '0051U00000XYZZZ' );

        insert oppApproval;

        Test.startTest();
        try {
            
            oppApproval.Status__c = 'Approved';
            update oppApproval;
            Test.stopTest();
            System.assert(false, 'Expected exception not thrown');
        } catch (AuraHandledException e) {
            System.assertEquals('exceptionText', e.getMessage());
        }
    }
}
