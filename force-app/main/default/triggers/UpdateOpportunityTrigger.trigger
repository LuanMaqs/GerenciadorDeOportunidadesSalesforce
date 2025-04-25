trigger UpdateOpportunityTrigger on Opportunity (after update) {
    List<Opportunity> opportunitiesToProcess = new List<Opportunity>();

    for(Opportunity opp : Trigger.new){
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);

        if(oldApproval.Status__c == 'Approval'  && newApproval.Status__c !== 'Approval'){
            newApproval.Status__c = oldApproval.Status__c;
            newApproval.addError('You can not change the status after the approval process.');
        }
    }
    if (!opportunitiesToProcess.isEmpty()) {
        CreateOpportunityApprovalHandler.OpportunityApprovalProcess(opportunitiesToProcess);
    
    }
 }