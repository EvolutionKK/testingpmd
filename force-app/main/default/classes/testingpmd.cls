public class testingpmd {
		//hi
    @AuraEnabled
    public static ServiceResource getServiceResource(String apptId){
        List<ServiceAppointment> st = [select ServiceTerritoryId from ServiceAppointment Where Id = :apptId];
        List<ServiceTerritoryMember> stm =new List<ServiceTerritoryMember>();
        if(st.size() > 0){
            stm= [Select  ServiceTerritoryId, ServiceResourceId from ServiceTerritoryMember Where ServiceTerritoryId = :st[0].ServiceTerritoryId AND TerritoryType = 'P' Limit 1];
        }
        List<AssignedResource> assignedres = [Select Id, ServiceAppointmentId, ServiceResourceId From AssignedResource Where ServiceAppointmentId = :apptId];
        if(assignedRes.size() > 0)
        {
            if(stm.size() > 0)
            {
                assignedRes[0].ServiceResourceId = stm[0].ServiceResourceId;
                update assignedRes;
            }
            ServiceResource Employee = [Select Id, Name, Rating__c, Ratings__c From ServiceResource Where Id = :assignedRes[0].ServiceResourceId];
            return Employee;
        }else{
            return null;
        }
        
    }

    @AuraEnabled
    public static string getUserSessionId(){
        return UserInfo.getSessionId();
    }

    @AuraEnabled
    public static list<worktype> getworkTypeGroups(String iconLink, String paymentMode, String businessCategory, String country, String curr){
        String recordType = '';
        if(businessCategory == 'requestQuote')
        {
            recordType = Schema.SObjectType.WorkTypeGroup.getRecordTypeInfosByDeveloperName().get('B2B').getRecordTypeId();
        }
        else if(businessCategory == 'bookNow')
        {
            recordType = Schema.SObjectType.WorkTypeGroup.getRecordTypeInfosByDeveloperName().get('B2C').getRecordTypeId();
        }
        list<worktypegroup> servicesList = [SELECT name , payment_method__c FROM worktypegroup WHERE payment_method__c = :paymentMode AND RecordTypeId = :recordType];
        Set<String> uniqWorkTypeGroupIds = new Set<String>();
        Set<String> uniqworkTypeGroupNames = new Set<String>();
        for(worktypegroup wtg :  servicesList)
        {
            uniqWorkTypeGroupIds.add(wtg.Id);
            uniqworkTypeGroupNames.add(wtg.Name);
        }
        list<worktypegroupmember> groupmemberlist = new List<worktypegroupmember>();
        if(country == 'Ghana')
        {
            groupmemberlist = [SELECT WorkType.Name, WorkType.icon__c, WorkType.EstimatedDuration, WorkType.Price__c, WorkType.Currency__c,
                                                     WorkType.Country__c, WorkType.English__c, WorkType.Comment__c
                                                     FROM WorkTypeGroupMember WHERE WorkTypeGroupId IN :uniqWorkTypeGroupIds 
                                                     AND WorkType.English__c IN :uniqworkTypeGroupNames AND WorkType.Country__c = :country Order By WorkType.English__c ];
        }else{
        	groupmemberlist = [SELECT WorkType.Name, WorkType.icon__c, WorkType.EstimatedDuration, WorkType.Price__c, WorkType.Currency__c,
                                                     WorkType.Country__c, WorkType.English__c, WorkType.Comment__c
                                                     FROM WorkTypeGroupMember WHERE WorkTypeGroupId IN :uniqWorkTypeGroupIds 
                                                     AND WorkType.English__c IN :uniqworkTypeGroupNames AND WorkType.Country__c = :country AND WorkType.Currency__c = :curr Order By WorkType.English__c ];
        }
        List<WorkType> services = new List<WorkType>();
        for(WorkTypeGroupMember w : groupmemberlist)
        {
            w.WorkType.icon__c = iconLink + w.WorkType.icon__c; 
            services.add(w.WorkType);
        }
        return services;
    }
	public static void addition(String abc)
    {
        Integer a = 5;
        Integer b = 9;
        Integer total = a+b;
        system.debug(total);
    }
}
