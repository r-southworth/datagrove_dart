import 'package:dg_modal/dg_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:provider/provider.dart';
import 'identity.dart';

// awkward if we change the identity, won't that remove the stack and start over?
showCreateIdentity(BuildContext context) async {
  // d
  await Navigator.of(context)
      .push(CupertinoPageRoute(builder: (_) => SignupPage()));
}

// move to localization
const String advice =
    """With this secret identity you can recover your data even if you lose your device. We suggest you write it down with pencil on paper.\n\nNO ONE at Datagrove can retrieve a lost passphrase for you!!""";

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

  checkName() {
    setState(() {
      valid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dg = Provider.of<User>(context);
    return ModalScaffold(
        //action: const Text("I wrote it down"),
        title: const Text("Create Account"),
        valid: valid,
        child: Center(
            child: Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 600),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                            child: CupertinoTextFormFieldRow(
                                controller: controller,
                                prefix: const Text("Name"),
                                onFieldSubmitted: (String s) {
                                  checkName();
                                },
                                autofocus: true,
                                placeholder: "Screen name")),
                        CupertinoButton(
                            onPressed: () {
                              checkName();
                            },
                            child: const Text("Check"))
                      ]),
                      // put name here
                      if (valid)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Your identity is",
                              style: TextStyle(fontSize: 18)),
                        ),
                      if (valid)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(mnemonic,
                              style: const TextStyle(
                                  color: CupertinoColors.activeGreen)),
                        ),
                      if (valid)
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(advice,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle)),
                      if (valid)
                        CupertinoButton(
                            onPressed: () async {
                              await Provider.of<User>(context, listen: false)
                                  .activate(Identity.create(controller.text));
                              Navigator.of(context).pop();
                            },
                            child: const Text("I wrote it down"))
                    ])))));
  }
}
