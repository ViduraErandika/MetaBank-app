import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WebClient with ChangeNotifier {
  bool bankAccountVerified = false;
  bool customerCreated = false;
  var client = http.Client();

  Future<bool> verifyCustomer(String id) async {
    Uri verifyUrl = Uri.parse(
        'http://34.124.140.185:9089/irf-test-web/api/v1.0.0/party/api/${id}');
    print(verifyUrl);
    print("1");
    var response = await client.get(verifyUrl);
    print("2");
    print(response);

    if (response.statusCode == 200) {
      bankAccountVerified = true;
      // Map<dynamic, dynamic> data = json.decode(response.body);
      print("verified");
      // print(data["body"]);
      return true;
    } else {
      bankAccountVerified = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> createCustomer({
    required String? mnemonic,
    required String? shortName,
    required String? firstname,
    required String? lastName,
    required String? gender,
    required String? phNum,
    required String? email,
    required String? dob,
    required String? address,
    required String? nic,
  }) async {
    Uri verifyUrl = Uri.parse(
        'http://34.124.140.185:9089/irf-test-web/api/v1.0.0/party/customers');

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', verifyUrl);
    request.body = json.encode({
      "body": {
        "mnemonic": mnemonic,
        "shortName": shortName,
        "firstName": firstname,
        "lastName": lastName,
        "GENDER": gender,
        "phoneNumber": phNum,
        "email": email,
        "dateOfBirth": dob,
        "address": address,
        "legalId": "${nic}",
        "sectorId": "1001",
        "language": "1"
      }
    });
    print(request.body);
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
