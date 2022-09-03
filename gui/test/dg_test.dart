import 'package:test/test.dart';
import 'dart:convert';
import 'dart:developer';

void main() {
  inspect(Uri.parse("http://datagrove.net/group-app-sponsor/pubname?arg=1"));
  inspect(Uri.parse("http://datagrove.net/group-app-sponsor?id=xy&arg=1"));
}
