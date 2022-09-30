library dg_bip39;

import 'package:dg_modal/dg_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

// move to localization
const String advice =
    """Write it down! Keep it safe. NO ONE at Datagrove can retrieve a lost passphrase for you. Access to your private data could be lost if you lose this!!!!\n\nAlso, anyone that knows these words can impersonate you and steal your secrets. When you tap "I wrote it down", this identity will be forgotten unless you write it down. With this secret identity you can log in from any device, but you should only log in on devices that you trust.""";

final _storage = const FlutterSecureStorage();

class Login extends StatelessWidget {
  Widget child;
  String appname;
  Login({required this.child, super.key, this.appname = "this app"});

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => IdentityManager.value, child: LoginMaybe(child: child));
  }
}

class LoginMaybe extends StatelessWidget {
  Widget child;
  LoginMaybe({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final dg = Provider.of<IdentityManager>(context);
    if (dg.identity.isNotEmpty) {
      return child;
    } else {
      return LoginScreen();
    }
  }
}

// we should have a clear option for new users.

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscure = true;
  bool store = true;
  @override
  Widget build(BuildContext context) {
    final data = "data";
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
                                    // widget.dgf.isLogin = true;
                                    // context.url = "/0?";
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
                            CupertinoFormRow(
                              prefix: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  const Text("Login with Phone"),
                                  SizedBox(
                                    width: 300,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "Scan QR code with this app on your phone to log in instantly",
                                        style: TextStyle(
                                            color: CupertinoColors.systemGrey),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: Container()),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: CupertinoColors.white,
                                          border: Border.all(
                                            color: CupertinoColors.white,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: BarcodeWidget(
                                            width: 200,
                                            height: 200,
                                            barcode: Barcode.qrCode(),
                                            data: data),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AddAccount()
                          ])
                    ]))));
  }
}

class AddAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        CupertinoButton(
          child: const Text("Create account"),
          onPressed: () async {
            // dgf.isLogin = true;
            // context.url = "/0";
            await showModal(context, SignupScreen());
          },
        ),
      ],
    );
  }
}

class ShowQr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = "";
    //dg.identity.privateKey.publicKey.toHex();
    return ModalScaffold(
        action: const Text(""),
        title: const Text("Link phone"),
        valid: false,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Use a previously authorized phone to authorize this device\n\nYou can find the linking functions in the Settings tab ⚙️"),
          ),
          Center(
            child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BarcodeWidget(
                      width: 200,
                      height: 200,
                      barcode: Barcode.qrCode(),
                      data: data),
                )),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Note that if you later revoke the device you used to link, this device will be revoked as well. If that is not what you want, then tap cancel and use your BIP39 passphrase to authorize this device."),
          )
        ])
        //dg.style.desktopLink,
        );
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

class Identity {}

class IdentityManager {
  static IdentityManager value = IdentityManager();

  String name = "";
  List<Identity> identity = [];
  Identity active = Identity();

  static Future<IdentityManager> open() async {
    final r = IdentityManager();

    return r;
  }

  activate(Identity) async {}
  add(BuildContext context) {}
}

class SignupScreen extends StatefulWidget {
  var mnemonic = bip39.generateMnemonic();
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

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
                        child: Text(
                          advice,
                          style: TextStyle(color: CupertinoColors.white),
                        ))
                  ]),

                  Row(children: [
                    Expanded(
                        child: CupertinoTextFormFieldRow(
                            prefix: const Text("Name"),
                            autofocus: true,
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
