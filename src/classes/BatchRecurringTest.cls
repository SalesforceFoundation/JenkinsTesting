@isTest
private class BatchRecurringTest {

    static testMethod void testBatchRecurringDonations() {
        Contact c = new Contact(FirstName = 'Test', LastName = 'Test01', Email = 'test01@test.com');
        insert c;

        Contact c2 = new Contact(FirstName = 'Test', LastName = 'Test02', Email = 'test02@test.com');
        insert c2;

        List<npe03__Recurring_Donation__c> donations = new List<npe03__Recurring_Donation__c>();

        npe03__Recurring_Donation__c d1 = new npe03__Recurring_Donation__c(npe03__Contact__c  = c.Id, CurrencyIsoCode = 'USD', npe03__Amount__c = 10, npe03__Installment_Period__c = 'Monthly', npe03__Installments__c = 12, npe03__Schedule_Type__c = 'Multiply By', Name = 'Recurring Donation - Test 1');
        npe03__Recurring_Donation__c d2 = new npe03__Recurring_Donation__c(npe03__Contact__c = c2.Id, CurrencyIsoCode = 'USD', npe03__Amount__c = 10, npe03__Installment_Period__c = 'Monthly', npe03__Installments__c = 12, npe03__Schedule_Type__c = 'Multiply By', Name = 'Recurring Donation - Test 2');

        donations.add(d1);
        donations.add(d2); 
  
        insert donations;     

        // assert that we have 12 opportunties related to the first recurring donation
        List<AggregateResult> results = [SELECT count(Id) opp_count FROM Opportunity WHERE npe03__Recurring_Donation__c =: d1.Id];
        for (AggregateResult ar : results) {
            System.assertEquals(12, ar.get('opp_count'));   
        }
    }
}