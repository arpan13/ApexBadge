// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Equipment_Maintenance_Item__c> equipMainItem=[SELECT Id,Maintenance_Request__c,Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c];
Equipment_Maintenance_Item__c newemi=equipMainItem[0].clone(false,false,false,false);
insert newemi;
System.debug('NEW'+newemi);
System.debug('equipMainItem[0]'+equipMainItem[0].id);
System.debug('NEW'+newemi.Id);