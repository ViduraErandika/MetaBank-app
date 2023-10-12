import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WebClient with ChangeNotifier {
  bool bankAccountVerified = false;
  bool customerCreated = false;
  var client = http.Client();

  Future<bool> verifyCustomer(String id) async {
    Uri verifyUrl = Uri.parse(
        'http://192.168.60.248:9089/irf-test-web/api/v1.0.0/party/api/${id}');
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

  Future<Map<String, dynamic>> createCustomer(String object) async {
    Uri verifyUrl = Uri.parse(
        'http://192.168.60.248:9089/irf-test-web/api/v1.0.0/party/customers');

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', verifyUrl);
    request.body = json.encode(object);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    Map<String, dynamic> data =
        json.decode(await response.stream.bytesToString());
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
