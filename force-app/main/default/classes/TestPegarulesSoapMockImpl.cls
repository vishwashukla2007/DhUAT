@isTest
global class TestPegarulesSoapMockImpl implements WebServiceMock{
    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               pegarulesSoapWAserviceSer.Responses_element[] res = new pegarulesSoapWAserviceSer.Responses_element[]{};
               res[0].ResponseCode = 'S-0000';
               res[0].ResponseMessage = 'failed';
               //res[0].Status = null;
               response.put('response_x', res[0]); 
   }
}