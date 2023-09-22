import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WebClient with ChangeNotifier {
  bool bankAccountVerified = false;
  var client = http.Client();

  Future<bool> verifyCustomer(String id) async {
    Uri verifyUrl = Uri.parse(
        'http://192.168.194.248:9089/irf-test-web/api/v1.0.0/party/api/${id}');
    var response = await client.get(verifyUrl);

    if (response.statusCode == 200) {
      bankAccountVerified = true;
      print(response.body);
      return true;
    } else {
      bankAccountVerified = false;
      notifyListeners();
      return false;
    }
  }
}
