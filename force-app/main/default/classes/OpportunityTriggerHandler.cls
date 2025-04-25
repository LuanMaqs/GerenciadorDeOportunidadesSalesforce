public with sharing class OpportunityTriggerHandler {
    public static void handleBeforeUpsert(List<Opportunity> oppList) {
        Date today = Date.Today();
        
        for(Opportunity opp : oppList){
            if(opp.Limit_Date__c != null ){
                opp.SLA_Status__c = (opp.Limit_Date__c < Today) ? 'Overdue' : 'On time';
            }
        }
    }
}