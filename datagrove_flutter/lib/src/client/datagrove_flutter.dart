import 'package:convert/convert.dart' show hex;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../editor/editor.dart';
import '../ui/mdown.dart';
import 'package:provider/provider.dart';

export '../tabs/home.dart';
export '../tabs/page.dart';
//export '../ui/schoolform.dart';

export '../ui/date.dart';
export '../ui/confirm.dart';
export '../ui/mdown.dart';
export '../ui/dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Datagrove {
  static Future<Datagrove> open() async {
    return Datagrove();
  }
}

class UserIdentity {
  Uint8List
      uuid; // we need this so that if we change the name, we have a place.
  String name; // if not default this is unique;
  bool isDefault;

  UserIdentity({
    // required this.keyChain,
    required this.name,
    required this.uuid,
    required this.isDefault,
  });

  static UserIdentity empty() {
    return UserIdentity(isDefault: true, uuid: Uint8List(0), name: 'anonymous');
  }
}

// I would think we could include brandName in the normal translation bundles?
class DgfStyle {
  String brandName;
  DgfStyle({
    required this.brandName,
  }) {}
}

class MimeStyle {
  Widget icon;

  MimeStyle({this.icon = const Icon(CupertinoIcons.doc)});
}

const sampleSvg = """
<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
  <path stroke-linecap="round" stroke-linejoin="round" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
</svg>
""";

// maybe implement copyWith? often we want the standard +
class FileStyle {
  //static const folder = "inode/directory";
  static const school = "application/x-pawpaw";
  static const chat = "application/x-dg-chat";
  final Map<String, MimeStyle> _mime;
  MimeStyle unknown = MimeStyle();
  FileStyle({required Map<String, MimeStyle> mime}) : _mime = mime;

  MimeStyle mime(String s) {
    return _mime[s] ?? unknown;
  }

  Widget get folder {
    return Icon(CupertinoIcons.folder);
  }

  copyWith(FileStyle override) {}
  static FileStyle standard() {
    return FileStyle(mime: {
      //folder: MimeStyle(icon: const Icon(CupertinoIcons.folder)),
      school: MimeStyle(icon: const Text("📚")),
      chat: MimeStyle(icon: SvgPicture.string(sampleSvg))
    });
  }
}

enum GroupAuth {
  none,
  comment, // read with limited write.
  write, // full write
  admin, // full write + grant/revoke
}

typedef Suid = Uint8List; // varints

// notifies on logout?
class Dgf {
  Datagrove server;
  UserIdentity identity;
  List<UserIdentity> identities = [UserIdentity.empty()];
  DgfStyle style;
  late FileStyle fileStyle;
  bool isLogin = false;
  FlutterSecureStorage keychain;

  static Dgf of(BuildContext context) => Provider.of<Dgf>(context);
  Dgf(
      { // pawpaw.datagrove.com
      required this.server,
      required this.identity,
      required this.style,
      required this.keychain,
      FileStyle? fileStyle}) {
    this.fileStyle = fileStyle ?? FileStyle.standard();
  }

  Future<GroupAuth> authorize(String group) async {
    return GroupAuth.admin;
  }

  Future<Suid?> pubid(Suid groupid, String name) async {
    return null;
  }

  // creates an identity from a bip39
  createIdentity(String seed) {
    isLogin = true;
    // not really
    keychain.write(key: "default", value: seed);
  }

  // if this is the default, then we need to pick another default
  // if its the last identity then we need to trigger the onboard?
  dropIdentity(String key) {}

  static Future<Dgf> open({
    required String dnsName, // dns name for what?
    required DgfStyle style,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    registerWeb();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final dg = await Datagrove.open();
    const storage = FlutterSecureStorage();
    // value can be json with hexified byte arrays.
    String? value = await storage.read(key: "default");

    final r = Dgf(
      server: dg,
      style: style,
      identity: UserIdentity.empty(),
      keychain: storage,
    );
    r.isLogin = true;
    value != null;

    //await r.speech.initSpeechState();
    return r;
  }
}

typedef RemovedItemBuilder = Widget Function(
    int item, BuildContext context, Animation<double> animation);

class ListState<E> {
  // found should be a cursor, no reason that we need it to fit in memory
  // needs to be virtual list.
  List<E> found = [];
  List<E> _items = [];
  Widget Function(BuildContext context, E item, Animation<double> animation)
      builder;

  ListState({required this.builder});

  final tc = TextEditingController();
  final sc = ScrollController();
  final gk = GlobalKey<SliverAnimatedListState>();

  SliverAnimatedListState get _animatedList => gk.currentState!;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            builder(context, found[index], animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);

  Widget build() {
    return SliverAnimatedList(
      key: gk,
      initialItemCount: found.length,
      itemBuilder: (c, i, a) => builder(c, found[i], a),
    );
  }
}

class ControllerSet {
  final c = Map<String, Cpair>();
  TextEditingController at(String name, String text, Function(String s) fn) {
    var r = c[name];
    if (r == null) {
      r = Cpair(text, fn);
      c[name] = r;
    }
    return r.c;
  }

  dispose() {
    for (final o in c.entries) {
      o.value.submit(o.value.c.text);
      o.value.c.dispose();
    }
  }
}

class Cpair {
  late TextEditingController c;
  Function(String s) submit;
  Cpair(String value, this.submit) {
    c = TextEditingController(text: value);
  }
}

class Nav extends StatelessWidget {
  String title;
  Nav({this.title = ""});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

// should slices be functions or widgets?
// widgets offer some extra flexibility for caching/performance
// but lots of extra syntax.
// class BirthSlice extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }

// }

// slices could be functions from rowset to widget.
// these are effectively animated builders.
// one issue is animated build always returns 1 widget
// and we want to return a list of slivers.
// it might hard to animate out these slices? can we have
// dynamically conditional slices? or slices that set their visibility
// in an animated way? what about generics here? would need generators
// <T> (T x) { x.birth } is a syntax error.

// each slice is

// wrapping in page is to allow us to match async query to
// sync go_router. Returns a list of slivers ready to wrap in a
// custom scroller.

// I need to test this on a phone - how does google remember your login on a phone
// how do we easily get back in?
// final LoginState loginState;

Uint8List unhex(String s) => Uint8List.fromList(hex.decode(s));

class TupleList {
  // does this throw an error if the list is not cardinality 1?
  TextEditingController text(String index) {
    return TextEditingController();
  }
}
