function handler(event) {
    const google_form_url = "https://docs.google.com/document/d/your-google-doc-id/view";
    var response = {
      statusCode: 302,
      statusDescription: 'Found',
      headers: { 
        "location": { "value": google_form_url } 
      }
    };
    return response;
  }