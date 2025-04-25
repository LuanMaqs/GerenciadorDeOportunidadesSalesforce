trigger CreatedOpportunityTrigger on Opportunity (after insert) {
    List<Opportunity_Approval_c__c> CreateOpportunityApprovalHandler = new List<Opportunity_Approval_c__c>();

    for(Opportunity opp : Trigger.new) {
        Opportunity_Approval_c__c oppAP = new Opportunity_Approval_c__c();
        oppAP.Name = opp.Name;
        oppAP.Status__c = 'Pending Approval';
        oppAP.Opportunity__c = opp.Id;

        CreateOpportunityApprovalHandler.add(oppAP);
    }

    if(!CreateOpportunityApprovalHandler.isEmpty()) {
        insert CreateOpportunityApprovalHandler;
}
}