import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:cryptography/cryptography.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';

/*
import 'package:pointycastle/pointycastle.dart';

  final keyBytes = Uint8List(32); // dummy key - replace with 256 bit key
  final nonce = Uint8List(12); // dummy nonce - replace with random value
  final plainTextBytes = Uint8List(5); // dummy input - 5 bytes (5 is just an example)

  final cipher = GCMBlockCipher(AESEngine())
    ..init(
        true, // encrypt (or decrypt)
        AEADParameters(
          KeyParameter(keyBytes), // the 256 bit (32 byte) key
          16 * 8, // the mac size (16 bytes)
          nonce, // the 12 byte nonce
          Uint8List(0), // empty extra data
        ));

  final cipherTextBytes = cipher.process(plainTextBytes);
  print(cipherTextBytes.length);
  */

final aes = AesGcm.with256bits();

// Generate a random 256-bit secret key
// is this better than using
Future<Uint8List> randomKey() async {
  final secretKey = await aes.newSecretKey();
  return Uint8List.fromList(await secretKey.extractBytes());
}

Future<Uint8List> randomIv() async {
  final nonce = aes.newNonce();
  return Uint8List.fromList(nonce);
}

final _secureRandom = Random.secure();
Uint8List uuid() {
  final b = Uint8List(16);
  for (var i = 0; i < 16; i++) {
    b[i] = _secureRandom.nextInt(256);
  }
  return b;
}

Future<Uint8List?> aesEncrypt(
    {required Uint8List key,
    required Uint8List iv,
    required Uint8List clearText}) async {
  try {
    final secretBox = await aes.encrypt(
      clearText,
      secretKey: await aes.newSecretKeyFromBytes(key),
      nonce: iv,
    );
    // print('Ciphertext: ${secretBox.cipherText}');
    // print('MAC: ${secretBox.mac}');

    // can we just jam the iv, mac, and cipher text together?
    // iv and mac should be

    return Uint8List.fromList(
        [...iv, ...secretBox.mac.bytes, ...secretBox.cipherText]);
  } catch (e) {
    print(e);
    return null;
  }
}

Future<Uint8List?> aesDecrypt(Uint8List message, Uint8List key) async {
  // iv is 128 bits
  // mac is 128 bits
  try {
    final iv = message.sublist(0, 16);
    final mac = message.sublist(16, 32);
    final cipherText = message.sublist(32);
    final SecretBox box = SecretBox(cipherText, nonce: iv, mac: Mac(mac));
    return Uint8List.fromList(await aes.decrypt(box,
        secretKey: await aes.newSecretKeyFromBytes(key)));
  } catch (e) {
    print(e);
    return null;
  }
}

//this.publicKey.toHex()
//
//dg.setIdentity(Uint8List.fromList(hex.decode(privateKey)));
var ec = getP256();

class UserIdentity with Comparable<UserIdentity> {
  // uuid never changes.
  // the public key can change if compromised
  // the name can be changed for legal or personal reasons.
  // PlatformKeyChain keyChain;
  Uint8List
      uuid; // we need this so that if we change the name, we have a place.
  String name; // if not default this is unique;
  bool isDefault;
  PrivateKey privateKey;

  UserIdentity(
      { // required this.keyChain,
      required this.name,
      required this.uuid,
      required this.isDefault,
      required this.privateKey});

  @override
  int compareTo(UserIdentity x) {
    return name.compareTo(x.name);
  }

  Future<Uint8List> sign(UserIdentity id, Uint8List hash) async {
    final sig = signature(id.privateKey, hash);
    return Uint8List.fromList(sig.toCompact());
  }

  Future<Uint8List> unwrap(UserIdentity id, Uint8List hash) async {
    final sig = signature(id.privateKey, hash);
    return Uint8List.fromList(sig.toCompact());
  }
}

abstract class PlatformKeyChain {
  Future<Uint8List> sign(UserIdentity id, Uint8List data);
  List<UserIdentity> toList();
  // false if name is a duplicate
  Future<UserIdentity> create(String name);
  Future<Error?> update(UserIdentity u);
  Future<Error?> remove(UserIdentity u);
  Future<Uint8List?> unwrap(UserIdentity u, Uint8List data);
}

// returns the default identity
// a really good keychain would let us sign things without handling the key
// can I add that functionality here instead of inside datagrove?
extension on Uint8List {
  String get toHex {
    return hex.encode(this);
  }
}

@override
Future<Uint8List> sign(UserIdentity id, Uint8List hash) async {
  final sig = signature(id.privateKey, hash);
  return Uint8List.fromList(sig.toCompact());
}

@override
Future<Uint8List> unwrap(UserIdentity id, Uint8List hash) async {
  final sig = signature(id.privateKey, hash);
  return Uint8List.fromList(sig.toCompact());
}
