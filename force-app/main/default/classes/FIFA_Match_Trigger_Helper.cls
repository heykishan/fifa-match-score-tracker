// Helper class for Trigger on FIFA_Match__c
public with sharing class FIFA_Match_Trigger_Helper {
    // prevent player 1 and 2 from being the same
    public static void preventPlayerDuplicates(List<FIFA_Match__c> matches) {    
        try {
            for(FIFA_Match__c match : matches) {
                if(match.FIFA_Player_One__c == match.FIFA_Player_Two__c) {
                    match.addError('FIFA_Player_Two__c', 'Players cannot be the same');
                }
            }
        }
        catch (Exception e) {
            System.debug('Error in preventPlayerDuplicates: ' + e.getMessage());
        }
    }
    // Populate match winner based on goals
    public static void populateMatchWinner(List<FIFA_Match__c> matches) {
        try {
            for(FIFA_Match__c match : matches) {
                if(match.FIFA_Player_1_Score__c == match.FIFA_Player_2_Score__c) {
                    match.FIFA_Match_Winner__c = 'Draw';
                } 
                else if(match.FIFA_Player_1_Score__c > match.FIFA_Player_2_Score__c) {
                    match.FIFA_Match_Winner__c = match.FIFA_Player_One__c;
                } 
                else {
                    match.FIFA_Match_Winner__c = match.FIFA_Player_Two__c;
                }
            }
        }
        catch (Exception e) {
            System.debug('Error in populateMatchWinner: ' + e.getMessage());
        }
    }
	// Populate Player stats on Player 1 & 2 after a match is inserted or updated
    public static void populatePlayerStats(List<FIFA_Match__c> matches) {  
        try {
            Map<Id, Decimal> playerIDvsGoals = new Map<Id, Decimal>();
            Map<Id, Boolean> playerIDvsWinStatus = new Map<Id, Boolean>();
    
            for(FIFA_Match__c match : matches) {
                playerIDvsGoals.put(match.FIFA_Player_One__c, match.FIFA_Player_1_Score__c);
                playerIDvsGoals.put(match.FIFA_Player_Two__c, match.FIFA_Player_2_Score__c);
    
                playerIDvsWinStatus.put(match.FIFA_Player_One__c, match.FIFA_Match_Winner__c == match.FIFA_Player_One__c);
                playerIDvsWinStatus.put(match.FIFA_Player_Two__c, match.FIFA_Match_Winner__c == match.FIFA_Player_Two__c);
            }
    
            List<FIFA_Player__c> playerRecsToUpdate = [SELECT Id, FIFA_Matches_Played__c, FIFA_Wins__c, FIFA_Goals__c FROM FIFA_Player__c WHERE Id IN :playerIDvsGoals.keySet()];
            
            for(FIFA_Player__c player : playerRecsToUpdate) {
                player.FIFA_Matches_Played__c = player.FIFA_Matches_Played__c + 1;
                player.FIFA_Goals__c = player.FIFA_Goals__c + playerIDvsGoals.get(player.Id);
                if(playerIDvsWinStatus.get(player.Id)) {
                    player.FIFA_Wins__c = player.FIFA_Wins__c + 1;
                }
            }
            
            if(playerRecsToUpdate!=null && !playerRecsToUpdate.isEmpty())
            	update playerRecsToUpdate;
        }
        catch (Exception e) {
            System.debug('Error in populatePlayerStats: ' + e.getMessage());
        }
    }
}