// image here can be a reduced first page of the document
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

// its not clear that row id always work
// we need to be able to store at least the url for tab, probably some
// basic extra info too. we share this among devices.
class DgPath {
  String role = "Admin"; // the user's role; decides what they can access.
  String channel = "Aetna Claim"; // named message collection
  // probably a channel id, invisible?
  String server = "claim.aetna.com"; // dns name
  String path = "/one/two/three"; // folder name within the collection.
  String proposal = "Main";
}

// each tab has a history of BrowserStates
// if we make this abstract it would be hard to store them?
class TabState {
  final String title;
  final String image;
  final String subtitle;
  final String url;

  @override
  List<Object?> get props => [title, subtitle, image];

  TabState(
      {this.title = "", this.subtitle = "", this.image = "", this.url = ""});

  void dispose() {}

  bool get isNewState => url.isEmpty;
}

class ComposedMessage {
  //
}

class FileInfo extends Equatable {
  final String name;
  final String type;
  final String image;
  final DateTime modified = DateTime.now();
  FileInfo(this.name, this.image, this.type);

  @override
  List<Object?> get props => [name, type, image];
}

// this is probably not useful as equatable? we need a distinction between channel
// and thread.

class DgChannel {
  // each channel has configurable menu of process
  // items in the menu can be "host only".

}

class DgThread extends Equatable {
  DgChannel channel;
  final String title;
  final String subtitle;
  final String image;
  DgThread(this.channel,
      {this.title = "", this.subtitle = "", this.image = ""});
  @override
  List<Object?> get props => [title, subtitle, image];
}
// class Channel {
//   String id; // bytes?
//   String title;

//   Channel({required this.id, required this.title});
// }

class MessageData {
  late String from = "";
  late String to = "";
  late String type = "";
  late String content = "";
  String name = "";
  late List<int> payload = [];
  int modified = 0;

  MessageData(
      {required this.name,
      required this.from,
      required this.content,
      required this.modified});
}

// alerts should be extend message? wrap it?
class Alert extends Equatable {
  final String title;
  final String subtitle;
  final String image;
  Alert({this.title = "", this.subtitle = "", this.image = ""});
  @override
  List<Object?> get props => [title, subtitle, image];
}

class Branch extends Equatable {
  final String title;
  final String subtitle;
  final String image;

  Branch({
    required this.title,
    this.subtitle = "",
    this.image = "",
  });
  @override
  List<Object?> get props => [title, subtitle, image];
}

class Bookmark extends Equatable {
  final String title;
  final String image;
  final String subtitle;
  Bookmark({this.title = "", this.subtitle = "", this.image = ""});
  @override
  List<Object?> get props => [title, subtitle, image];
}

class Formx extends Equatable {
  final String title;
  final String image;
  final String subtitle;
  Formx({this.title = "", this.subtitle = "", this.image = ""});
  @override
  List<Object?> get props => [title, subtitle, image];
}

List<MessageData> someMessages(int n) {
  return List<MessageData>.generate(
      n,
      (e) => MessageData(
          content: faker.lorem.sentences(1)[0],
          modified: DateTime.now().millisecondsSinceEpoch,
          name: "jkh$e",
          from: ''));
}

class Request {}

class Thread {}

enum OrderBy {
  modified,
  name, // path
  modifiedByMe,
  openedByMe,
}

// most of the browsable things are dags?

class BrowsableDag<T> {
  OrderBy order = OrderBy.modified;
  // as we drill down the dag we have a stack to get back up.
  List<int> stack = [];
  List<T> data = [];

  up() {}
  down(int) {}
}

class FileUpdate {
  int fid = 0;
  int modfied = 0;
}

class Table {
  Package package;
  Table(this.package);
}

// Is the concept of a user tied to a server?
// the credentials need to be signed by an authority recognized by the DS
class Credential {
  String serverAs;
  String format;
  // String phone;  // to recover
  Uint8List credentials;
  Credential(this.serverAs, this.format, this.credentials);

  static Credential make() {
    return Credential("example.com", "", Uint8List(0));
  }
}

/*
An Authentication Service (AS) functionality which is responsible for maintaining a binding between a unique identifier (identity) and the public key material (credential) used for authentication in the MLS protocol. This functionality must also be able to generate these credentials or validate them if they are provided by MLS clients.
getCredentials(id) -> list<public key>
validation is trivial: just compare the key? what if the id has more 
DID - decentralized id.
*/

// user can have multiple credentials? one for each server?
// what if they have more than one for the same server?
// more than one per server is just wrong. you can't really hide anything this way.
// where are these stored? The AS might be able to retrieve a list of identities??
// or do we have to store these separately and the AS only authenticates them?
// either?
// this is the data model that the client initiates a new
// download encrypted, decrypt locally or use something fancier.
// from the credential we can retrieve the roles fo the user on that server
// then we need to merge these in the interface for the role picker according to some order.

// immutable role loaded from package.
class Role {
  String id;
  String title; // localized - shouldn't need this?
  Role(this.id, this.title);
}

// serves as the catalog, get lists of tables, roles
// packages build dashboards based on role descriptions
// defines transaction types
// package per server or per role or both? how can we make it easy to
// compose servers, rules and bylaws?
abstract class Package {
  // can we fetch all the data we need from UserRole? Use it as a cache?
  Widget build(UserRole server, BuildContext context);

  // this is a metarole? we need to instatiate some how.
  Map<String, Role> role = {};

  // need something better here? filter, sort, etc?

  String roleTitle(UserRole r) {
    return r.title;
  }

  List<TransactionGenerator> requestMap = [];
}

class Validator {}

class TransactionGenerator {
  // transactions are sets of tables and rules that you can package into
  // a message and send to a role.
  var validator = Validator();
}

class TestPackage extends Package {
  // probably an action sheet or two here.

  @override
  Widget build(UserRole role, BuildContext context) {
    var owner = role.role.id = "owner";
    var teacher = role.role.id = "teacher";

    // recent update summary - what messages have I received? which were accepted/pended/rejected/noted?

    // Notebook; these are all the views that summarize the data for the role.

    // grants/revokes
    // anyone can assign a role if they have admin rights to the role
    // the owners have admin rights to all the roles.

    // user -> *UserRoles
    // role -> *UserRoles
    return Text("");
  }
}

class Tuple {
  Table table;
  List<Object> value;
  Tuple(this.table, this.value);
}

class CredentialSet {
  var credential = Map<String, Credential>();
}

// can we compose cursors?
// the list of roles on a server is dynamic, and this needs to be merged locally
// with lists from other servers
// a cursor could represent a local calculation in this case.
class UserServer extends Equatable {
  final String title;
  final String subtitle;
  final String image;
  final String pwd;
  final String branch;
  var package = TestPackage();

  // should be cursor, use this to get trees, filters?
  List<Branch> branches = [];
  List<Request> requests = [];
  // every notebook is in all branches, but maybe empty
  List<FileInfo> notebooks = [];
  // I might see the roles if I am a server owner.
  List<UserRole> roles = [];
  List<Thread> threads = [];

  UserServer(
      {this.title = "",
      this.subtitle = "",
      this.image = "",
      this.pwd = "",
      this.branch = "main"});
  @override
  List<Object?> get props => [title, subtitle, image];
}

// with the credentials we can fetch the user roles. client can then merge them
class UserRole {
  UserServer server;
  Role role; // role + attr = tuple?
  Map<String, String>
      attr; // the row tuple uniquely identifies this role to the package.

  // are these cached/generated/assigned by the user?
  String get title => role.title;
  String get subtitle => server.title;
  String get image =>
      server.image; // ideally this is composed icon over server background?

  UserRole(this.server, this.role, this.attr);
  // UserRole(this.tuple,
  //     {required this.server,
  //     required this.title,
  //     required this.subtitle,
  //     required this.image});
}
