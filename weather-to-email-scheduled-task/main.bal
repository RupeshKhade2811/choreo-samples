import ballerina/http;
import wso2/choreo.sendemail;
import ballerina/io;

outbound:
    serviceReferences:
    - name: choreo:///massil2016/sample-project2/ovqwld/proxy/v1.0/PUBLIC
      connectionConfig: 01ef06ba-3e42-1708-a5b1-0a89907f0c31
      env:
      - from: ServiceURL
        to: <https://decde734-bc1e-404d-809f-b9d9ee98e177-prod.e1-us-east-azure.choreoapis.dev/sample-project2/api/v3/v1.0>
      - from: ConsumerKey
        to: <D7_0L3z5rwBJCeDwvuhAkXHLaKEa>
      - from: ConsumerSecret
        to: <G6dYml2VOpqJIWVI6SxA6xvqCHwa>
      - from: TokenURL
        to: <https://sts.choreo.dev/oauth2/token>


const string ENDPOINT_URL = "https://api.openweathermap.org/data/2.5";
const int StepCount = 7; // number of steps to be fetch from the API
configurable string apiKey = ?;
configurable float latitude = ?;
configurable float longitude = ?;
configurable string email = ?;
const emailSubject = "Next 24H Weather Forecast";

// Create http client
http:Client httpclient = check new (ENDPOINT_URL);
// Create a new email client
sendemail:Client emailClient = check new ();

public function main() returns error? {

    // Get the weather forecast for the next 24H
    http:Response response = check httpclient->/forecast(lat = latitude, lon = longitude, cnt = StepCount, appid = apiKey);
    io:println("Successfully fetched the weather forecast data.");

    // Get the json payload from the response
    json jsonResponse = check response.getJsonPayload();

    // Convert the json payload to a WeatherRecordList
    WeatherRecordList jsonList = check jsonResponse.cloneWithType();
    io:println("Converted the json payload to a WeatherRecordList.");

    // Send the email
    string _ = check emailClient->sendEmail(email, emailSubject, generateWeatherTable(jsonList));
    io:println("Successfully sent the email.");
}
