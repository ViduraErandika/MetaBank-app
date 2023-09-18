import 'package:http/http.dart' as http;

class WebClient {
  bool bankAccountVerified = false;
  var client = http.Client();
  Future<dynamic> verifyCustomer(String id) async {
    Uri verifyUrl = Uri.parse(
        'http://192.168.4.154:9089/irf-test-web/api/v1.0.0/party/api/${id}');
    var response = await client.get(verifyUrl);

    if (response.statusCode == 200) {
      bankAccountVerified = true;
      print(response.body);
    } else {
      bankAccountVerified = false;
    }
  }
}
