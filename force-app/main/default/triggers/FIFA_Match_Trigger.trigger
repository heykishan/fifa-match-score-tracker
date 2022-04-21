// Trigger on FIFA_Match__c, updates stats and values on the Match as well as the Player object records
trigger FIFA_Match_Trigger on FIFA_Match__c (before insert, before update, after insert, after update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        FIFA_Match_Trigger_Helper.preventPlayerDuplicates(Trigger.new);
        FIFA_Match_Trigger_Helper.populateMatchWinner(Trigger.new);
    }
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        FIFA_Match_Trigger_Helper.populatePlayerStats(Trigger.new);
    }
}