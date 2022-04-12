// add trigger description
trigger FIFA_Match_Trigger on FIFA_Match__c (before insert) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        FIFA_Match_Trigger_Helper.preventPlayerDuplicates(Trigger.new);
        FIFA_Match_Trigger_Helper.populateMatchWinner(Trigger.new);
    }
}