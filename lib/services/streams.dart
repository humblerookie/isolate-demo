import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:isolate/isolate.dart';

import '../api.dart';

class StreamService {
  LoadBalancer? balancer;

  Stream<String> getHashedUserData() async* {
    String userData = await Api.getUser("LoadBalancer");
    balancer ??= await LoadBalancer.create(5, IsolateRunner.spawn);
    yield* encryptionSaltStream().asyncMap(
        (salt) => balancer!.run(generateMd5, salt.toString() + userData));
  }

  Stream<int> encryptionSaltStream() async* {
    for (int i = 1; i < 3; i++) {
      await Future.delayed(Duration(seconds: i));
      yield math.Random().nextInt(i * 100);
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
