import 'shared.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'settings.dart';
import 'package:flutter/material.dart';

// we should have a clear option for new users.

class LoginScreen extends StatefulWidget {
  Dgf dgf;
  LoginScreen(this.dgf);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscure = true;
  bool store = true;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
            child: Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 600),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoFormSection.insetGrouped(
                          header: const Text("Authorize this device"),
                          children: [
                            CupertinoFormRow(
                                prefix: const Text(""), child: Container()),
                            Row(children: [
                              Expanded(
                                  child: CupertinoTextFormFieldRow(
                                prefix: const Text("Password"),
                                autofocus: true,
                                placeholder: "BIP39 passphrase",
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1024)
                                ],
                                onChanged: (String s) {
                                  if (bip39.validateMnemonic(s)) {
                                    widget.dgf.isLogin = true;
                                    context.url = "/0?";
                                  } else {
                                    print("nope");
                                  }
                                },
                                obscureText: obscure,
                              )),
                              CupertinoButton(
                                  onPressed: () {
                                    setState(() {
                                      obscure = !obscure;
                                    });
                                  },
                                  child: const Icon(CupertinoIcons.eye)),
                            ]),
                            AddAccount()
                          ])
                    ]))));
  }
}

/*


class SliverQr extends StatelessWidget {
  final String data;
  const SliverQr(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Center(
      child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BarcodeWidget(
                width: 200, height: 200, barcode: Barcode.qrCode(), data: data),
          )),
    ));
  }
}
*/

// base32 only uses 2-7, can we use 0 in clever way? issue is that whatever we do we need to explain why you can't use a url to user, and the less likely the trap, the more painful when they fall in.

// urls look like host/{group-app-sponsor}/{publication id or query}?parameters
// note is exactly one publication; to query more, we query on publication reference in that publication.

// maybe this should cross to the isolate? it will be hard to keep cache
// up to date here. could be laggy to contact isolate every time though.

class Linkup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
