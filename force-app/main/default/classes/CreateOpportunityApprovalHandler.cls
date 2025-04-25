public with sharing class CreateOpportunityApprovalHandler {
    public static void OpportunityApprovalProcess(List<Opportunity> opportunities) {
        List<Opportunity> oppListUpdate = new List<Opportunity>();
        Id currentUserId = UserInfo.getUserId();

        Set<Id> opportunityIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            opportunityIds.add(opp.Id);
        }

        Map<Id, Opportunity_Approval_c__c> approvalMap = new Map<Id, Opportunity_Approval_c__c>(
            [SELECT Id, Status__c, User__c, Opportunity__c 
             FROM Opportunity_Approval_c__c 
             WHERE Opportunity__c IN :opportunityIds]
        );

        for (Opportunity opp : opportunities) {
            Opportunity_Approval_c__c oppApproval = null;
            for (Opportunity_Approval_c__c a : approvalMap.values()) {
                if (a.Opportunity__c == opp.Id) {
                    oppApproval = a;
                    break;
                }
            }

            if (oppApproval == null) {
                continue;
            }

            if (opp.OwnerId != currentUserId && oppApproval.User__c != currentUserId) {
                throw new AuraHandledException('You do not have permission to approve this opportunity.');
            }

            if (oppApproval.Status__c == 'Aprovado') {
                opp.StageName = 'Fechado - Aprovado';
                oppListUpdate.add(opp);
            } else if (oppApproval.Status__c == 'Rejeitado') {
                opp.StageName = 'Fechado - Rejeitado';
                oppListUpdate.add(opp);
            }
        }

        if (!oppListUpdate.isEmpty()) {
            update oppListUpdate;
        }
    }
}
