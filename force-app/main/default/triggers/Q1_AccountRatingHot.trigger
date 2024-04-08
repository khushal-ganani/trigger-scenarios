// Upon account creation if industry is not null having value as media then populate rating as hot
trigger Q1_AccountRatingHot on Account (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        for(Account acc : Trigger.new) {
            if (acc.Industry != null && acc.Industry == 'Media') {
                acc.Rating = 'Hot';
            }
        }
    }
}