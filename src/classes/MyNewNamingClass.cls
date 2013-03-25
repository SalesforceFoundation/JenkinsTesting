global class MyNewNamingClass extends npo02.HouseholdNaming{
    global override string getHHName(list<Contact> clist){
    	string x = super.getHHName(clist);    	
    	system.debug('HERE I AM TO SAVE THE DAY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    	system.debug(x);
    	return 'Y3o4d!';   
    }   
     
    global override void updateNames(list<id> hhids){
    	
        //get all of the contacts and their associated households
        list<Contact> contactlist = [select id, Firstname, Salutation, LastName, npo02__Household__r.id, npo02__Naming_Exclusions__c from Contact where npo02__Household__c IN :hhids and npo02__Household__c != null];
        list<npo02__Household__c> hhupdatelist = [select Name, npo02__SYSTEM_CUSTOM_NAMING__c from npo02__Household__c where id IN : hhids];
        
        map<id, list<Contact>> hhIDContactMap = new map<id, list<Contact>>();
         
        //sort contacts by household
        for (Contact c : contactlist){          
            if(!hhIDContactMap.containskey(c.npo02__Household__r.id)){
                hhIDContactMap.put(c.npo02__Household__r.id, new list<Contact>{c});
            }
            else{
                list<Contact> clist = hhIDContactMap.get(c.npo02__Household__r.id);
                clist.add(c);                
            }
        }
                
        //loop through the households needing name changes, if necessary, make them.
        for (npo02__Household__c h : hhupdatelist){    
        
            string customnameparam = '';
            if (h.npo02__SYSTEM_CUSTOM_NAMING__c != null){
                customnameparam = h.npo02__SYSTEM_CUSTOM_NAMING__c;
            }            
            
            if (!customnameparam.contains('Name'))
                h.Name = getHHName(hhIDContactMap.get(h.id));   
            
            if (!customnameparam.contains('Formal_Greeting__c'))
                h.npo02__Formal_Greeting__c = super.getFormalName(hhIDContactMap.get(h.id));

            if (!customnameparam.contains('Informal_Greeting__c'))
                h.npo02__Informal_Greeting__c = super.getInformalName(hhIDContactMap.get(h.id));             
        } 
        
        if (!hhupdatelist.isEmpty()) Database.update(hhupdatelist, false);
    	
    }

    public static testMethod void TEST_mynamer(){
	    MyNewNamingClass nm = new MyNewNamingClass();	   
	    list<npo02__Household__c> hlist = [select id from npo02__Household__c];
	    list<id> hid = new list<id>();
	    for (npo02__Household__c h : hlist){
            hid.add(h.id);
	    }
	   
        nm.updateNames(hid);
	}
}