public  class MaintenanceRequestHelper {

    public static  void createNewMaintenanceRequestWhenClosed(List<SObject> triggerNew,List<SObject> triggerOld,Map<Id,Case> triggerNewMap,Map<Id,Case> triggerOldMap){
        List<Case> newCases=(List<Case>) triggerNew;
        List<Case> oldCases=(List<Case>) triggerOld;

        List<Case> newCasesTobeInserted=new  List<Case>();
        List<Equipment_Maintenance_Item__c> newEmisTobeInserted=new List<Equipment_Maintenance_Item__c>();
        System.debug('Old Case----->'+oldcases);
        System.debug('New Case----->'+newCases);
        System.debug('New Map Key set'+triggerNewMap.keySet());

        

        Map<Id,List<Equipment_Maintenance_Item__c>> mapCaseToequipMainItems=new Map<Id,List<Equipment_Maintenance_Item__c>>();
        Map<Id,String> mapequipMainItemsToEquipmwnts=new Map<Id,String>();
        Set<Id> equipMainItemsids=new Set<Id>();

        List<Equipment_Maintenance_Item__c> equipMainItem=[SELECT Id,Maintenance_Request__c,Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :triggerNewMap.keySet()];
        System.debug('equipMainItem'+equipMainItem);

        for(Equipment_Maintenance_Item__c emi:equipMainItem){
            equipMainItemsids.add(emi.Id);
            if(mapCaseToequipMainItems.containsKey(emi.Maintenance_Request__c)){
                mapCaseToequipMainItems.get(emi.Maintenance_Request__c).add(emi);
            }else{
                mapCaseToequipMainItems.put(emi.Maintenance_Request__c,new List<Equipment_Maintenance_Item__c>{emi});
            }
        }

        System.debug('mapCaseToequipMainItems'+mapCaseToequipMainItems);





        System.debug('Equipment_Maintenance_Item__c'+equipMainItem);
        for(Case caseNew:newCases){
            System.debug('caseNew Equipment----->'+caseNew.ProductId);
            if(caseNew.Status=='Closed' && (triggerOldMap.get(caseNew.Id).Type =='Repair' || triggerOldMap.get(caseNew.Id).Type =='Routine Maintenance')){
                Case ca=caseNew.clone(false, true);
                ca.Vehicle__c=triggerOldMap.get(caseNew.Id).Vehicle__c;
                ca.Type='Routine Maintenance';
                ca.Subject='Follow Up Case';
                ca.Status='New';
                ca.ParentId=caseNew.Id;
                ca.Date_Reported__c=caseNew.CreatedDate.date();
                if(mapCaseToequipMainItems.get(caseNew.Id)!=null){
                    ca.Date_Due__c=Date.today().addDays(getLowestMaintenenceCycle(mapCaseToequipMainItems.get(caseNew.Id)));
                }

                newCasesTobeInserted.add(ca);
            }
        }
        //Database.SaveResult[] srListEmis = Database.insert(newEmisTobeInserted, false);

        // Database.SaveResult[] srListCases = Database.insert(newCasesTobeInserted, false);
        // System.debug('srListCases'+srListCases);

        insert newCasesTobeInserted;
        for(Case ca:newCasesTobeInserted){
            if(mapCaseToequipMainItems.get(ca.ParentId)!=null){
                for(Equipment_Maintenance_Item__c emi:mapCaseToequipMainItems.get(ca.ParentId)){
                    Equipment_Maintenance_Item__c emimiddle=emi.clone(false,false,false,false);
                    emimiddle.Maintenance_Request__c=ca.Id;
                    newEmisTobeInserted.add(emimiddle);
                }
            }
        }
        insert newEmisTobeInserted;


    }

    public static Integer getLowestMaintenenceCycle(List<Equipment_Maintenance_Item__c> emis){
        Decimal  lowestMainCycle;
        if(emis.size()>0){
            for(Equipment_Maintenance_Item__c emi:emis){
                if(lowestMainCycle == null || emi.Equipment__r.Maintenance_Cycle__c < lowestMainCycle){
                    lowestMainCycle = emi.Equipment__r.Maintenance_Cycle__c;
                }
            }
        }
       

        return (Integer)lowestMainCycle;

    }
}