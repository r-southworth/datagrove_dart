import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:provider/provider.dart';
import 'identity.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var mnemonic = bip39.generateMnemonic();
  late TextEditingController controller;
  final data = secureString(16);
  bool valid = false;
  bool obscure = true;
  bool store = true;
  bool signup = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text("Login")),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 100, maxWidth: 600),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          child: const Text("Create account"),
                          onPressed: () async {
                            await showCreateIdentity(context);
                            // dgf.isLogin = true;
                            // context.url = "/0";
                          },
                        ),
                        Qr(data: data),
                        Text("Login with Phone"),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Scan QR code with this app on your phone to log in instantly",
                              style:
                                  TextStyle(color: CupertinoColors.systemGrey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("BIP 39 passphrase"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoTextField(
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            placeholder: "BIP39 passphrase",
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1024)
                            ],
                            onChanged: (String s) {
                              if (bip39.validateMnemonic(s)) {
                                // widget.dgf.isLogin =rue;
                                // context.url = "/0?";
                                Provider.of<User>(context, listen: false)
                                    .activate(Identity.create("untitled"));
                              } else {
                                print("nope $s");
                              }
                            },
                          ),
                        ),
                      ])),
            ),
          ),
        ));
  }
}

class Qr extends StatelessWidget {
  final String data;
  const Qr({super.key, required this.data});
  @override
  Widget build(Object context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: CupertinoColors.white,
            border: Border.all(
              color: CupertinoColors.white,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BarcodeWidget(
              width: 200, height: 200, barcode: Barcode.qrCode(), data: data),
        ),
      ),
    );
  }
}
