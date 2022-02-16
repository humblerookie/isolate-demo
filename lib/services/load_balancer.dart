import 'dart:convert';

import 'package:isolate/isolate.dart';
import 'package:isolate/load_balancer.dart';

import '../api.dart';

class LoadBalancerService {
  LoadBalancer? balancer;

  Future<Person> fetchUser() async {
    String userData = await Api.getUser("LoadBalancer");
    balancer ??= await LoadBalancer.create(5, IsolateRunner.spawn);
    return await balancer!.run(deserializeJson , userData, load: 1);
  }

  Person deserializeJson(String data) {
    Map<String, dynamic> dataMap = jsonDecode(data);
    return Person(dataMap["name"]);
  }
}