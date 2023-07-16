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



 Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.245920580.137996989.1689487437-499851633.1632108294');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        HttpResponse res = http.send(req);
 
System.debug('RESPONSE'+res.getBody());
System.debug('Response'+JSON2ApexEquipments.parse(res.getBody()));
// JsonParserEquipments js=new JsonParserEquipments(res.getBody());
// System.debug('JSON Deserialize'+js.parse(res.getBody()));
// System.debug('JSON.createParser(json)'+JSON.createParser(res.getBody()));

// List<Object> jsonobj = (List<Object>)JSON.deserializeUntyped(res.getBody());
// System.debug('jsonobj'+jsonobj);
// List<JsonParserEquipments> jsList=new List<JsonParserEquipments>();
// for (Object ob : jsonobj) {
//    JSONParser parser=JSON.createParser(ob);
//     JsonParserEquipments js=new JsonParserEquipments(parser);
//     jsList.add(js);
//     System.debug('JsonParserEquipments'+js);
// }
// System.debug('JSON Deserialize'+jsList);


// List<JSONParser> parser = new List<JSONParser>{JSON.createParser(res.getBody())};
// List<JsonParserEquipments> jsList=new List<JsonParserEquipments>();

// for(JSONParser jspar:parser){
//     JsonParserEquipments js=new JsonParserEquipments(jspar);
//     jsList.add(js);
// }
// JsonParserEquipments js=new JsonParserEquipments(parser);
System.debug('JSON Deserialize'+JSON.deserialize(res.getBody(), List<JsonParserEquipments>.class));