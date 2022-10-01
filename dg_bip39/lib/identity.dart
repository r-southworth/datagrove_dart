part of 'dg_bip39.dart';

final _storage = const FlutterSecureStorage();

class Identity {
  String name = "";
  PrivateKey key;
  Identity(this.key, {this.name = ""});

  String get uniqueKey => key.publicKey.toHex();

  static Identity create() {
    var ec = getP256();
    return Identity(ec.generatePrivateKey());
  }

  static Identity fromEntry(MapEntry s) {
    final m = json.decode(s.value) as Map<String, String>;
    return Identity(PrivateKey.fromHex(getP256(), m["private"] ?? ""),
        name: m["name"] ?? "");
  }

  String toString() {
    return json.encode({name: name, key: key.toHex()});
  }

  MapEntry toEntry() {
    return MapEntry(
      uniqueKey,
      toString(),
    );
  }
}

class IdentityManager with ChangeNotifier {
  static IdentityManager value = IdentityManager();

  String name = "";
  final identity = <String, Identity>{};
  Identity? active;

  // on web potentially reload on local storage event?
  static Future<IdentityManager> open() async {
    Map<String, String> m =
        await _storage.readAll(aOptions: _getAndroidOptions);
    for (var e in m.entries) {
      if (e.key.length > 8) {
        value.identity[e.key] = Identity.fromEntry(e);
      }
    }
    return value;
  }

  Future<void> store(String key, String value) async {
    await _storage.write(key: key, value: value, aOptions: _getAndroidOptions);
  }

  Future<void> deleteSecureData(String key) async {}

  // erase all identities
  removeAll() async {
    await _storage.deleteAll(aOptions: _getAndroidOptions);
    identity.clear();
    notifyListeners();
  }

  remove(String i) async {
    if (identity[i] == active) {
      active = null;
    }
    identity.remove(i);
    await _storage.delete(key: i, aOptions: _getAndroidOptions);
    notifyListeners();
  }

  activate(Identity id) async {
    store("active", id.uniqueKey);
    store(id.uniqueKey, id.toString());
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
