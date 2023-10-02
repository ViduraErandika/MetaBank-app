import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WebClient with ChangeNotifier {
  bool bankAccountVerified = false;
  bool customerCreated = false;
  var client = http.Client();

  Future<bool> verifyCustomer(String id) async {
    Uri verifyUrl = Uri.parse(
        'http://192.168.113.248:9089/irf-test-web/api/v1.0.0/party/api/${id}');
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

  Future<Map> createCustomer(dynamic object) async {
    Uri verifyUrl = Uri.parse(
        'http://192.168.113.248:9089/irf-test-web/api/v1.0.0/party/customers');
    var _payload = json.encode(object);
    print(_payload);
    var response = await client.post(verifyUrl, body: _payload);
    Map<String, dynamic> data = json.decode(response.body);
    print("data");
    print(data);
    if (response.statusCode == 200) {
      customerCreated = true;
      return data["header"];
    } else {
      customerCreated = false;
      notifyListeners();
      return data["header"];
    }
  }
}
