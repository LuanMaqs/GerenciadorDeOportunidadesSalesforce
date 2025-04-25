trigger OpportunityTrigger on Opportunity (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        OpportunityTriggerHandler.handleBeforeUpsert(Trigger.new);
    }
}
