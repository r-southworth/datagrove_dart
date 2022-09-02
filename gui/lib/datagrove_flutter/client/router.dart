// is there any point to referencing a group by its id? seems dangerous.
import 'datagrove_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// adapted from gskinner's flutter-url-router

class RouteParse {
  static const appTab = <String, int>{"g": 0, "n": 1, "s": 2, "m": 3, "p": 4};
  static final cache = <String, RouteParse>{};
  //
  static final groupCache = <String, GroupCache>{};

  // Surface these in the ux? we probably want more information than this?
  // we don't want to bounce into isolate while rendering, but
  String group = "";
  String pub = "";

  String location = "/";
  int tab = 0;
  late Suid groupid;
  late Suid pubid;
  GroupAuth auth = GroupAuth.none;
}

extension UrlRouterExtensions on BuildContext {
  UrlRouter get urlRouter => UrlRouter.of(this);

  RouteParse get url => UrlRouter.of(this).url;
  set url(RouteParse value) => UrlRouter.of(this).url = value;

  /*
  // 

  
  void urlPush(String value, [Map<String, String>? queryParams]) =>
      UrlRouter.of(this).push(value, queryParams);

  void urlPop([Map<String, String>? queryParams]) =>
      UrlRouter.of(this).pop(queryParams);
  */
}

class UrlRouteParser extends RouteInformationParser<RouteParse> {
  @override
  Future<RouteParse> parseRouteInformation(
      RouteInformation routeInformation) async {
    return RouteParse();
  }

  @override
  RouteInformation? restoreRouteInformation(RouteParse configuration) =>
      RouteInformation(location: configuration.location);
}

class UrlRouter extends RouterDelegate<RouteParse>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  UrlRouter(
      {String url = '/', this.onGeneratePages, this.builder, this.onPopPage}) {
    _initialUrl = url;
    assert(onGeneratePages != null || builder != null,
        'UrlRouter expects you to implement `builder` or `onGeneratePages` (or both)');
  }

  /// Enable UrlRouter.of(context) lookup
  static UrlRouter of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<_InheritedRouterController>()
              as _InheritedRouterController)
          .router;

  /// Should build a stack of pages, based on the current location.
  /// This is technically optional, as you could decide to implement your
  /// own custom navigator inside the `builder`
  final List<Page<dynamic>> Function(UrlRouter router)? onGeneratePages;

  /// Wrap widgets around the [MaterialApp]s [Navigator] widget.
  /// Primarily used for providing scaffolding like a `SideBar`, `TitleBar` around the page stack.
  /// Also useful for when you would like to discard the provided [Navigator], and implement your own.
  final Widget Function(UrlRouter router, Widget navigator)? builder;

  /// Optionally provide a way for the parent to implement custom `onPopPage` logic.
  final PopPageCallback? onPopPage;

  /// Set from inside the build method, allows us to avoid passing context into delegates
  late BuildContext context;

  /*
  Map<String, String> get queryParams {
    final Uri? uri = _getUri();
    if (uri == null) return {};
    return Map.from(uri.queryParameters);
  }

  set queryParams(Map<String, String> value) {
    url = _getUri().replace(queryParameters: value).toString();
  }
    Uri _getUri() => Uri.tryParse(_url) ?? Uri(path: _initialUrl);
      String get urlPath => _getUri().path;
    */

  @override
  @protected
  RouteParse? get currentConfiguration => _url;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navKey;
  final GlobalKey<NavigatorState> _navKey = GlobalKey();

  late final String _initialUrl;
  RouteParse _url = RouteParse();
  RouteParse get url => _url;
  set url(RouteParse value) {
    _url = value;
    notifyListeners();
  }
  /*

    void push(String path, [Map<String, String>? queryParams]) =>
      _pushOrPop(path, queryParams);

  void pop([Map<String, String>? queryParams]) => _pushOrPop(null, queryParams);
  void _pushOrPop([String? path, Map<String, String>? queryParams]) {
    // Create a new list, because `pathSegments` is an unmodifiable list
    final segments = List.from(_getUri().pathSegments);
    // A null path indicates a pop vs push
    bool pop = path == null;
    if (pop && segments.length <= 1)
      return; // Can't pop if we're down to 1 segment
    // Add or remove a segment
    pop ? segments.removeAt(segments.length - 1) : segments.add(path);
    var newUrl = '/${segments.join('/')}';
    if (queryParams != null) {
      final queryString = Uri(queryParameters: queryParams).query;
      if (queryString.isNotEmpty) {
        newUrl += '?' + queryString;
      }
    }
    url = newUrl;
  }
  */

  @override
  Future<void> setInitialRoutePath(RouteParse configuration) {
    _url = configuration;
    super.setInitialRoutePath(url);
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    final pages = onGeneratePages?.call(this) ?? [];
    //TODO: Add more use cases for this, figure out if this is really what we want to do, or should we just always return false.
    bool handlePopPage(Route<dynamic> route, dynamic settings) {
      if (pages.length > 1 && route.didPop(settings)) {
        return true;
      }
      return false;
    }

    this.context = context;
    Widget content = Navigator(
      key: _navKey,
      onPopPage: onPopPage ?? handlePopPage,
      pages: pages,
    );
    if (builder != null) {
      content = builder!.call(this, content);
    }
    return _InheritedRouterController(router: this, child: content);
  }

  @override
  SynchronousFuture<void> setNewRoutePath(configuration) {
    _url = configuration;
    return SynchronousFuture(null);
  }
}

class _InheritedRouterController extends InheritedWidget {
  const _InheritedRouterController(
      {Key? key, required Widget child, required this.router})
      : super(key: key, child: child);
  final UrlRouter router;
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

// url_router throws away the async nature of this, so we want it back.
// also we don't need to return a string here, we can return something meaningful to our app.

class GroupCache {
  GroupAuth auth = GroupAuth.none;
  late Suid gid;
  final pubCache = <String, Suid>{};

  GroupCache(this.auth);
}


/*
  int cid = 0; // community id
  int bid = 0; // branch id
  int pid = 0; // publication id.
  int gid = 0; // message group id, applies only to messages.
  int iid = 0; // interior location
  String iname = ""; // not guaranteed to be unique

  // this needs to verify that the user can access the url and redirect if not.
  Future<RouteParse?> parse(Dgf dg, String s) async {
    var r = RouteParse();

    var uri = Uri.parse(s);
    if (uri.pathSegments.length < 2) {
      return null;
    }
    final tab = uri.pathSegments[0];
    final tabn = appTab[tab];
    if (tabn == null) {
      return null;
    }
    r.tab = tabn;
    r.url = s;

    final group = uri.pathSegments[1];
    var auth = groupCache[group];
    if (auth == null) {
      auth = GroupCache(await dg.authorize(group));
      groupCache[group] == auth;
    }
    if (auth.auth == GroupAuth.none) {
      return null;
    }

    // for our purposes here we only accept the name of the publication
    // if this becomes a problem, (moved or conflict) we want to surface it
    var pubname = uri.path.substring(group.length + 1);
    var pid = auth.pubCache[pubname];
    if (pid == null) {
      pid = await dg.pubid(auth.gid, pubname);
      if (pid == null) {
        return null;
      }
      auth.pubCache[pubname] = pid;
    }

    final query = uri.queryParametersAll;
    var gid = query['pid'];
    if (gid == null) {}

    // id or pubname must be provided

    // uri.query; Map<String,String> so not not compliant
    //uri.queryParametersAll; Map<String, List<String>> so compliant but not convenient

    // if the link provides a name, we need to resolve it.

    // cache the security/authorization checks
    // this can still fail at the server level because of staleness on device
    var ox = cache[s];
    if (ox != null) {
      return ox;
    }

    var o = s.length >= 2 ? s[1] : "";
    switch (tab) {
      case 0:
        // check authorization.
        // group-hyphen, publication-hypen, toc-hyphen

        var group = "";

        var pub = "";
        var inner = "";

        //dg.authorize(group);
        break;
      case 4:
        // with profiles we can jump to a particular screen.
        // no authorization, this always the current user's profile
        // plus a list of known alter-egos.

        break;
      case 3:
        // we need to check authorization here
        // with messages we can jump to a particular conversation and its information
        // screen
        break;
      default:
      // there is no depth to notify, stars
    }

    return RouteParse();
  }
}
*/