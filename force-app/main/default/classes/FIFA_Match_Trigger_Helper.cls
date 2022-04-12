// add class description
public with sharing class FIFA_Match_Trigger_Helper {
    // add function description
    public static void preventPlayerDuplicates(List<FIFA_Match__c> matches) {    
        for(FIFA_Match__c match : matches) {
            if(match.FIFA_Player_1__c == match.FIFA_Player_2__c) {
                match.addError('FIFA_Player_2__c', 'Players cannot be the same');
            }
        }
    }
    //  add function comment
    public static void populateMatchWinner(List<FIFA_Match__c> matches) {
        for(FIFA_Match__c match : matches) {
            if(match.FIFA_Player_1_Score__c > match.FIFA_Player_2_Score__c) {
                match.FIFA_Match_Winner__c = match.FIFA_Player_1__c;
            } 
            else if(match.FIFA_Player_1_Score__c < match.FIFA_Player_2_Score__c) {
                match.FIFA_Match_Winner__c = match.FIFA_Player_2__c;
            } 
            else {
                match.FIFA_Match_Winner__c = 'Draw';
            }
        }
    }
}
