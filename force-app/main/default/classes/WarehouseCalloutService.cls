public class WarehouseCalloutService implements Queueable, Database.AllowsCallouts  {
    public void execute(QueueableContext context) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.245920580.137996989.1689487437-499851633.1632108294');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        HttpResponse res = http.send(req);
 
        System.debug('RESPONSE'+res.getBody());
        System.debug('Response'+JSON2ApexEquipments.parse(res.getBody()));

        Set<Id> equipmentId=new Set<Id>();
        List<Product2> products=new List<Product2>();
        for(JSON2ApexEquipments jsonequip:JSON2ApexEquipments.parse(res.getBody())){
            //equipmentId.add(jsonequip.x_id);
            Product2 p=new Product2();
            p.ProductCode=(String)jsonequip.x_id;
            p.Maintenance_Cycle__c=jsonequip.maintenanceperiod;
            p.Cost__c=jsonequip.cost;
            p.Current_Inventory__c=jsonequip.quantity;
            p.Lifespan_Months__c=jsonequip.lifespan;
            p.Replacement_Part__c=jsonequip.replacement;
            p.Warehouse_SKU__c=jsonequip.sku;
            p.Name=jsonequip.name;
            products.add(p);
        }
        if(products.size()>0){
            upsert products;
        }
        




    }





    
}