trigger MaintenanceRequest on Case (before insert,after insert,before update,after update) {

    if (Trigger.isAfter && Trigger.isUpdate ) {
        MaintenanceRequestHelper.createNewMaintenanceRequestWhenClosed(Trigger.New,Trigger.Old,Trigger.newMap,Trigger.oldMap);
    }

}