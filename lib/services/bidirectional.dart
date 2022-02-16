import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import '../api.dart';

class BiDirectionalService {
  static Isolate? _isolate;
  static ReceivePort? _receivePort;
  static SendPort? _sendPort;
  static Completer<Person>? completer;

  Future<Person> fetchUser() async {
    completer = Completer();
    if (_isolate == null) {
      _receivePort = ReceivePort();
      _receivePort!.listen((message) {
        if (_sendPort == null) {
          _sendPort = message;
          Api.getUser("Bidirectional").then((value) => _sendPort!.send(value));
        } else {
          completer?.complete(message);
        }
      });
      _isolate = await Isolate.spawn(deserializePerson, _receivePort!.sendPort);
    } else {
      Api.getUser("Bidirectional").then((value) => _sendPort!.send(value));
    }
    return completer!.future;
  }

  void deserializePerson(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) {
      Map<String, dynamic> dataMap = jsonDecode(message);
      sendPort.send(Person(dataMap["name"]));
    });
  }
}