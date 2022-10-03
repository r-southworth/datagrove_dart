import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:convert/convert.dart';
import 'package:elliptic/elliptic.dart';

const _storage = FlutterSecureStorage();

class Identity {
  String name = "";
  PrivateKey key;
  Identity(this.key, this.name);

  String get uniqueKey => key.publicKey.toHex();

  static Identity create(String name) {
    var ec = getP256();
    return Identity(ec.generatePrivateKey(), name);
  }

  static Identity fromEntry(MapEntry s) {
    final m = json.decode(s.value) as Map<String, String>;
    return Identity(PrivateKey.fromHex(getP256(), m["private"] ?? ""),
        m["name"] ?? "untitled");
  }

  @override
  String toString() {
    String k = uniqueKey;
    String v = key.toHex();
    var obj = {"name": k, "key": v};
    return json.encode(obj);
  }

  MapEntry toEntry() {
    return MapEntry(
      uniqueKey,
      toString(),
    );
  }
}

class User with ChangeNotifier {
  static User value = User();
  final identity = <String, Identity>{};
  Identity? active; //  = Identity.create("jim");
  static bool store = true;

  // on web potentially reload on local storage event?
  static Future<User> open() async {
    if (store) {
      try {
        Map<String, String> m = await _storage.readAll(webOptions: _webOptions);
        for (var e in m.entries) {
          if (e.key.length > 8) {
            value.identity[e.key] = Identity.fromEntry(e);
          }
        }
      } catch (e) {
        print(e);
      }
    }

    return value;
  }

  Future<void> deleteSecureData(String key) async {}

  // erase all identities
  removeAll() async {
    if (store) {
      await _storage.deleteAll(aOptions: _getAndroidOptions);
    }
    identity.clear();
    notifyListeners();
  }

  remove(String i) async {
    if (identity[i] == active) {
      active = null;
    }
    identity.remove(i);
    if (store) {
      await _storage.delete(key: i, aOptions: _getAndroidOptions);
    }
    notifyListeners();
  }

  activate(Identity id) async {
    Future<void> write(String key, String value) async {
      await _storage.write(
          key: key, value: value, aOptions: _getAndroidOptions);
    }

    identity[id.uniqueKey] = id;
    active = id;
    if (store) {
      write("active", id.uniqueKey);
      write(id.uniqueKey, id.toString());
    }
    notifyListeners();
  }
}

final _secureRandom = Random.secure();
String secureString(int size) {
  final b = Uint8List(16);
  for (var i = 0; i < 16; i++) {
    b[i] = _secureRandom.nextInt(256);
  }
  return hex.encoder.convert(b);
}

AndroidOptions _getAndroidOptions = const AndroidOptions(
  encryptedSharedPreferences: true,
);

WebOptions _webOptions = const WebOptions();
