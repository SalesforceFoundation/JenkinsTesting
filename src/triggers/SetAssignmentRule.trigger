trigger SetAssignmentRule on Lead (before insert) {


    AssignmentRule ar = new AssignmentRule();
    ar = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];


    Database.DMLOptions dml = new Database.DMLOptions();
    dml.assignmentRuleHeader.assignmentRuleId = ar.id;
    
    for (Lead l : trigger.new){
    	l.setOptions(dml);    	 
    } 
 

}