import 'shared.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;

// move to localization
const String advice =
    """Write it down! Keep it safe. NO ONE at Datagrove can retrieve a lost passphrase for you. Access to your private data could be lost if you lose this!!!!\n\nAlso, anyone that knows these words can impersonate you and steal your secrets. When you tap "I wrote it down", this identity will be forgotten unless you write it down. With this secret identity you can log in from any device, but you should only log in on devices that you trust.""";

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
