import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../api.dart';

class ComputeService {
  Future<Person> fetchUser() async {
    String userData = await Api.getUser("Compute");
    return await compute(deserializeJson, userData);
  }

  Person deserializeJson(String data) {
    Map<String, dynamic> dataMap = jsonDecode(data);
    return Person(dataMap["name"]);
  }
}
