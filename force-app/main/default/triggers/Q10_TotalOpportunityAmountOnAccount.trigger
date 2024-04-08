//! If Account record is updated then populate the Total_Opportunity_Ammount__c field with sum of amount field 
//! values of all its related opportunity records
trigger Q10_TotalOpportunityAmountOnAccount on Account (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {

        // Getting the Ids of all the records being updated
        Set<Id> accIds = new Set<Id>();
        for (Account acc : Trigger.new) {
            accIds.add(acc.Id);
        }

        // Getting the map of AccountId and TotalAmount
        Map<Id, Double> amountMap = new Map<Id, Double>();
        List<AggregateResult> result = [SELECT AccountId, SUM(Amount) TotalAmount FROM Opportunity WHERE AccountId IN :accIds GROUP BY AccountId];

        if (result.size() > 0) {
            for (AggregateResult res : result) {
                amountMap.put((Id)res.AccountId, (Double)res.TotalAmount);
            }
        }

        // Iterating over updated accounts to input the Total Opportunity Amount Field
        for (Account acc : Trigger.new) {
            if (amountMap.containsKey(acc.Id)) {
                acc.Total_Opportunity_Amount = amountMap.get(acc.Id);
            }
        }
    }
}