@RestResource(urlMapping='/example/*')
global class RestExample {
    
    /**
     *  two params
     *  String url = 'https://dev1-member-portal.cs114.force.com/memberportal/services/apexrest/username/zeming.dong@outlook.com/en';
     *  String language = url.substring(url.lastIndexOf('/')+1);
     *  System.debug('language: ' + language);
     *	String url1 = url.substring(0, url.lastIndexOf('/'));
     *	String email = url1.substring(url1.lastIndexOf('/')+1);
     *	System.debug('email: ' + email);
     **/
    @HttpGet
    global static void getExample() {
    	RestRequest req = RestContext.request;

    	String Id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
	
      Account Result = [Select Id, FirstName From Account Limit 1];
    	RestResponse res = RestContext.response;
      res.addHeader('Content-Type', 'application/json');
      res.statusCode = 200;
			res.responseBody = Blob.valueOf(JSON.serialize(Result));     
    }

    @HttpPatch
    global static void patchExample(Account account) {
    	RestRequest req = RestContext.request;

    	String ListName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    	RestResponse res = RestContext.response;
      res.addHeader('Content-Type', 'application/json');
      account.ListName = ListName;
      Upsert account ListName;
      res.statusCode = 200;
			res.responseBody = Blob.valueOf(JSON.serialize(Result));   
	 } 
    
	@HttpPost
    global static void postExample(List<Account> accountList) {
        
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        System.debug('accountList:' + accountList);      
        
        Database.SaveResult[] srList = Database.insert(accountList, false);
        // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr);
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }   
    } 
    
    
}
