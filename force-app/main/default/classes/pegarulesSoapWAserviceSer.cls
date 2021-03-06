//Generated by wsdl2apex

public class pegarulesSoapWAserviceSer {
    public class Responses_element {
        public String ResponseCode;
        public String ResponseMessage;
        private String[] ResponseCode_type_info = new String[]{'ResponseCode','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','1','false'};
        private String[] ResponseMessage_type_info = new String[]{'ResponseMessage','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:PegaRULES:SOAP:WorkAssignmentService:Services','false','false'};
        private String[] field_order_type_info = new String[]{'ResponseCode','ResponseMessage'};
    }
    public class WorkAssignmentServiceRequestType {
        public String CompletionPercentage;
        public String PricingDocumentDescription;
        public String TaskCaseID;
        public String TaskID;
        public String WorkAssignmentCaseId;
        public String WorkAssignmentId;
        private String[] CompletionPercentage_type_info = new String[]{'CompletionPercentage','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','1','false'};
        private String[] PricingDocumentDescription_type_info = new String[]{'PricingDocumentDescription','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','1','false'};
        private String[] TaskCaseID_type_info = new String[]{'TaskCaseID','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','1','false'};
        private String[] TaskID_type_info = new String[]{'TaskID','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','1','false'};
        private String[] WorkAssignmentCaseId_type_info = new String[]{'WorkAssignmentCaseId','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','1','false'};
        private String[] WorkAssignmentId_type_info = new String[]{'WorkAssignmentId','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:PegaRULES:SOAP:WorkAssignmentService:Services','false','false'};
        private String[] field_order_type_info = new String[]{'CompletionPercentage','PricingDocumentDescription','TaskCaseID','TaskID','WorkAssignmentCaseId','WorkAssignmentId'};
    }
    public class WorkAssignmentServiceResponseType {
        public pegarulesSoapWAserviceSer.Responses_element[] Responses;
        private String[] Responses_type_info = new String[]{'Responses','urn:PegaRULES:SOAP:WorkAssignmentService:Services',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:PegaRULES:SOAP:WorkAssignmentService:Services','false','false'};
        private String[] field_order_type_info = new String[]{'Responses'};
    }
    public class ServicesPortSOAP {
        //public String endpoint_x = 'https://cvs-16.pegacloud.com:443/prweb/PRSOAPServlet/SOAP/WorkAssignmentService/Services';
        public String endpoint_x ;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'urn:PegaRULES:SOAP:WorkAssignmentService:Services', 'pegarulesSoapWAserviceSer'};
        public pegarulesSoapWAserviceSer.Responses_element[] WorkAssignmentService(String CompletionPercentage,String PricingDocumentDescription,String TaskCaseID,String TaskID,String WorkAssignmentCaseId,String WorkAssignmentId) {
            pegarulesSoapWAserviceSer.WorkAssignmentServiceRequestType request_x = new pegarulesSoapWAserviceSer.WorkAssignmentServiceRequestType();
            request_x.CompletionPercentage = CompletionPercentage;
            request_x.PricingDocumentDescription = PricingDocumentDescription;
            request_x.TaskCaseID = TaskCaseID;
            request_x.TaskID = TaskID;
            request_x.WorkAssignmentCaseId = WorkAssignmentCaseId;
            request_x.WorkAssignmentId = WorkAssignmentId;
            pegarulesSoapWAserviceSer.WorkAssignmentServiceResponseType response_x;
            Map<String, pegarulesSoapWAserviceSer.WorkAssignmentServiceResponseType> response_map_x = new Map<String, pegarulesSoapWAserviceSer.WorkAssignmentServiceResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:PegaRULES:SOAP:WorkAssignmentService:Services#WorkAssignmentService',
              'urn:PegaRULES:SOAP:WorkAssignmentService:Services',
              'WorkAssignmentServiceRequest',
              'urn:PegaRULES:SOAP:WorkAssignmentService:Services',
              'WorkAssignmentServiceResponse',
              'pegarulesSoapWAserviceSer.WorkAssignmentServiceResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Responses;
        }
    }
}