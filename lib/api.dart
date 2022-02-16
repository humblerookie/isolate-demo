import 'dart:async';

class Person {
  final String name;

  Person(this.name);
}

class Api {

  static Future<String> getUser(String from) =>
      Future.value("{\"name\":\"John Smith ..via $from\"}");
}
