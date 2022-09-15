import 'dart:io';
import 'package:shelf_multipart/multipart.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

void _log(String msg, bool isError) {
  print('$msg, $isError');
}

void main() async {
  try {
    int count = 1;
    var handlerSocket = webSocketHandler((webSocket) {
      webSocket.stream.listen((message) {
        count++;
        webSocket.sink.add('Echo: $message $count');
      });
    });
    var app = Router();
    app.add('GET', '/ws', handlerSocket);
    print('${Directory.current}');
    // app.add('GET', 'file', createStaticHandler('files', defaultDocument: 'index.html');

    final handler = const Pipeline()
        .addMiddleware(logRequests(logger: _log))
        .addMiddleware(
          corsHeaders(
            // Middleware from 'shelf_cors_headers'
            headers: {
              ACCESS_CONTROL_ALLOW_HEADERS: '*',
              'Content-Type': 'application/json;charset=utf-8',
            },
          ),
        )
        //.addHandler(_echoRequest)
        .addHandler(app);

    // Starts the server, in 'localhost' and with port 8080.
    var server = await shelf_io.serve(handler, 'localhost', 8080);
    server.autoCompress = true;
    print('Serving at http://${server.address.host}:${server.port}');
  } catch (e) {
    print("catch $e");
  }
}

/*
// Method Handler that replies with the path called.
// The return =Response.ok= is our helper static function to return a 200 code result, but we have many other, such as, Response.found() for 302 redirects or Response.notFound() for 404 not founds and all other codes that you can expect.
Response _echoRequest(Request request) {
// if (request.isMultipartForm) {
//   // Read all form-data parameters into a single map:
//   final parameters = <String, String>{
//     await for (final formData in request.multipartFormData)
//      formData.name: await formData.part.readString(),
//   };
// }
  return Response.ok('Request for "${request.url}"');
}

Future<Response> myHandler(Request request) async {
  // Iterate over parts making up this request:
  await for (final part in request.parts) {
    // Headers are available through part.headers as a map:
    final headers = part.headers;
    // part implements the `Stream<List<int>>` interface which can be used to
    // read data. You can also use `part.readBytes()` or `part.readString()`
  }

  return Response(401); // not a multipart request
}


  if (false) {
    // this adds a proxy?
    var server = await shelf_io.serve(
      proxyHandler("https://dart.dev"),
      'localhost',
      8080,
    );
  }
  */

// final myLogger = Logger();

// withHotreload(
//   () => createServer(),
//   onReloaded: () => myLogger.log('Reload!'),
//   onHotReloadNotAvailable: () => myLogger.log('No hot-reload :('),
//   onHotReloadAvailable: () => myLogger.log('Yay! Hot-reload :)'),
//   onHotReloadLog: (log) => myLogger.log('Reload Log: ${log.message}'),
//   logLevel: Level.INFO,
// );

// Response _handler(Request request) {
//   final logger = RequestLogger.extractLogger(request);
//   logger.debug('Hello Logs');

//   return Response.ok('Hello, World!\n');
// }

/*
  this is raw, but most packages seem to run on shelf
Future<void> main2() async {
  Future<HttpServer> createServer() async {
    final address = InternetAddress.loopbackIPv4;
    const port = 4040;
    return await HttpServer.bind(address, port);
  }

  Future<void> handleRequests(HttpServer server) async {
    await for (HttpRequest request in server) {
      request.response.write('Hello from a Dart server');
      await request.response.close();
    }
  }

  final server = await createServer();
  print('Server started: ${server.address} port ${server.port}');
  await handleRequests(server);
}
*/