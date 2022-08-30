This is debugged in 3 different windows

- gui is the front end, its in flutter with some web views and typescript.

- editor is the typescript component based on prosemirror served with vite. Start this with ``` npm run dev```

- dart back end; will be compiled with dart2js and used as worker, but for ease of debugging I run it as a websocket server. In visual studio code you can run  worker/test_server.dart to debug.

