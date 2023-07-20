@isTest
public class MaintenanceRequestHelperTest {
    @IsTest
    static void validatecaCreationWhenClosedSingleRecord() {
        
        List<Vehicle__c> listOfVehicles = new List<Vehicle__c>();
        List<Case> listOfMaintenanceRequests = new List<Case>();
        List<Equipment_Maintenance_Item__c> listOfEMI = new List<Equipment_Maintenance_Item__c>();
        List<Product2> listOfEquipments = new List<Product2>();
        
        for ( Integer i = 0 ; i < 300 ; i ++ ) {
            Vehicle__c veh =new Vehicle__c();
            veh.Name='Toy Hauler RV '+i;
            listOfVehicles.add(veh);
        }
        insert listOfVehicles;
        
        for ( Integer i = 0 ; i < 300 ; i ++ ) {
            Product2 pd=new Product2();
            pd.Maintenance_Cycle__c=10;
            pd.Name='Test pd'+1;
            pd.IsActive = true;
            pd.Replacement_Part__c = true;
            listOfEquipments.add(pd);
            
        }
        
        insert listOfEquipments;
        
        for ( Integer i = 0 ; i < 300 ; i ++ ) {
            Case ca=new Case();
            ca.Vehicle__c=listOfVehicles.get(i).id;
            ca.Type='Routine Maintenance';
            ca.Subject='Follow Up case'+1;
            ca.Status='New';
            ca.Date_Due__c=Date.today().addDays(10);
            ca.Origin = 'Phone';
            listOfMaintenanceRequests.add(ca);
            
        }
        
        insert listOfMaintenanceRequests;
        
        
        for ( Integer i = 0 ; i < 300 ; i ++ ) {
            Equipment_Maintenance_Item__c emi=new Equipment_Maintenance_Item__c();
            emi.Maintenance_Request__c=listOfMaintenanceRequests.get(i).Id;
            emi.Equipment__c=listOfEquipments.get(i).Id;
            listOfEMI.add(emi);
        }
        
        
        insert listOfEMI;
        
        
        Test.startTest();
        
        // Closing the maintenances
        for ( Case maintenanceToUpdate : listOfMaintenanceRequests ) {
            maintenanceToUpdate.Status = 'Closed';
        }
        update listOfMaintenanceRequests;
        
        
        
        
        
        Test.stopTest();
        // Start Positive asserts
        for ( Case newMaintenance : [SELECT Date_Reported__c,Vehicle__c, Date_Due__c, Subject  FROM Case Where Type = 'Routine Maintenance']) {
            System.assertEquals( newMaintenance.Subject != null, true);
            System.assertEquals( newMaintenance.Date_Due__c == System.today().addDays( 10 ), true);
        }
        
        
    }
    @IsTest static void validatecaCreationWhenClosedSingleRecordMorethanoneemi() {
        
        List<Vehicle__c> listOfVehicles = new List<Vehicle__c>();
        List<Case> listOfMaintenanceRequests = new List<Case>();
        List<Equipment_Maintenance_Item__c> listOfEMI = new List<Equipment_Maintenance_Item__c>();
        List<Product2> listOfEquipments = new List<Product2>();
        
        for ( Integer i = 0 ; i < 300 ; i ++ ) {
            Vehicle__c veh =new Vehicle__c();
            veh.Name='Toy Hauler RV '+i;
            listOfVehicles.add(veh);
        }
        insert listOfVehicles;
        
        for ( Integer i = 0 ; i < 300 ; i ++ ) {
            Product2 pd=new Product2();
            pd.Maintenance_Cycle__c=10;
            pd.Name='Test pd'+1;
            pd.IsActive = true;
            pd.Replacement_Part__c = true;
            listOfEquipments.add(pd);
            
        }
        
        insert listOfEquipments;
        
        for ( Integer i = 0 ; i < 300 ; i ++ ) {
            Case ca=new Case();
            ca.Vehicle__c=listOfVehicles.get(i).id;
            ca.Type='Routine Maintenance';
            ca.Subject='Follow Up case'+1;
            ca.Status='New';
            ca.Date_Due__c=Date.today().addDays(10);
            ca.Origin = 'Phone';
            listOfMaintenanceRequests.add(ca);
            
        }
        
        insert listOfMaintenanceRequests;
        
        
        for ( Integer i = 0 ; i < 300 ; i ++ ) {
            Equipment_Maintenance_Item__c emi=new Equipment_Maintenance_Item__c();
            emi.Maintenance_Request__c=listOfMaintenanceRequests[0].Id;
            emi.Equipment__c=listOfEquipments.get(i).Id;
            listOfEMI.add(emi);
        }
        
        
        insert listOfEMI;
        
        
        Test.startTest();
        
        // Closing the maintenances
        for ( Case maintenanceToUpdate : listOfMaintenanceRequests ) {
            maintenanceToUpdate.Status = 'Closed';
        }
        update listOfMaintenanceRequests;
        
        
        
        
        
        Test.stopTest();
        // Start Positive asserts
        for ( Case newMaintenance : [SELECT Date_Reported__c,Vehicle__c, Date_Due__c, Subject  FROM Case Where Type = 'Routine Maintenance']) {
            System.assertEquals( newMaintenance.Subject != null, true);
            System.assertEquals( newMaintenance.Date_Due__c == System.today().addDays( 10 ), true);
        }
        
        
    }
}