public class householdGivingRecord_CTRL{

//capture the contact id
public Id thisContactId {get;set;}

//a list to hold this year's gifts
public List<Opportunity> thisYearOpps = new List<Opportunity>();

//The Household record for the totals
public npo02__Household__c ContactHousehold;


//get the gifts into the list
public List<Opportunity> getThisYearOpps() {
//get our Contact's HH id
id HHid = [select npo02__Household__c from Contact where Id = :thisContactId].npo02__Household__c;

//get the IDs of other household members
List<Contact> HHMembers = [select id from Contact where npo02__Household__c= :HHid];
List<id> HHMemberids = new List<id>();
for (Contact c : HHMembers){
HHMemberids.add(c.id);
}

thisYearOpps = [SELECT Id, Amount,CloseDate FROM Opportunity
WHERE IsWon=true AND CloseDate =THIS_YEAR AND Id IN
(SELECT OpportunityId FROM OpportunityContactRole WHERE ContactId IN :HHMemberIDs AND isPrimary=True)
ORDER BY CloseDate];   

return thisYearOpps;   

}

public npo02__Household__c getContactHousehold(){

ContactHousehold = [select id, npo02__OppAmountThisYear__c, npo02__TotalOppAmount__c from npo02__Household__c where id IN (select npo02__Household__c from Contact where Id = :thisContactId)];

return ContactHousehold;
}


}