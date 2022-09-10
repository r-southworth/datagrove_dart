import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../client/datagrove_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:bip39/bip39.dart' as bip39;

import '../client/identity.dart';
import '../tabs/notify.dart';
import '../tabs/contact.dart';
import '../tabs/nav.dart';
import '../tabs/starred.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    return Scaffold(
        body: Center(
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

class SignupScreen extends StatefulWidget {
  var mnemonic = bip39.generateMnemonic();
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

const String advice =
    """Write it down! Keep it safe. NO ONE at Datagrove can retrieve a lost passphrase for you. Access to your private data could be lost if you lose this!!!!\n\nAlso, anyone that knows these words can impersonate you and steal your secrets. When you tap "I wrote it down", this identity will be forgotten unless you write it down. With this secret identity you can log in from any device, but you should only log in on devices that you trust.""";

class _SignupScreenState extends State<SignupScreen> {
  bool valid = false;

  checkName() {
    setState(() {
      valid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
        action: const Text("I wrote it down"),
        title: const Text("Create Account"),
        valid: valid,
        child: Center(
            child: Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 600),
                child: CupertinoFormSection.insetGrouped(children: [
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Your identity is",
                          style: TextStyle(fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(widget.mnemonic,
                          style: const TextStyle(
                              color: CupertinoColors.activeGreen)),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(advice),
                    )
                  ]),

                  Row(children: [
                    Expanded(
                        child: CupertinoTextFormFieldRow(
                            prefix: const Text("Name"),
                            placeholder: "Choose a name")),
                    CupertinoButton(
                        onPressed: () {
                          checkName();
                        },
                        child: const Text("Check"))
                  ]),
                  // CupertinoFormRow(
                  //     prefix: Text("Name"),
                  //     child: Row(children: [
                  //       Expanded(
                  //           child: CupertinoTextField(
                  //               placeholder: "Choose a name")),
                  //       CupertinoButton(onPressed: () {}, child: Text("Check"))
                  //     ])),
                  if (valid)
                    CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("I wrote it down"))
                ]))));
  }
}

class Linkup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
