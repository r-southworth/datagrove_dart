import 'shared.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:barcode_widget/barcode_widget.dart';

import 'signup.dart';

class IdentitySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dg = Dgf.of(context);
    return CupertinoFormSection.insetGrouped(
        header: Text("Identities"),
        children: [
          for (final o in dg.identities)
            CupertinoFormRow(
                child: Row(children: [
              Expanded(child: Text(o.name)),
              CupertinoSwitch(
                value: true,
                onChanged: (bool) {},
              ),
              CupertinoButton(
                  onPressed: () async {
                    await showCupertinoModalBottomSheet(
                        useRootNavigator: true,
                        isDismissible: true,
                        expand: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Text("not implemented"); //ScanQr();
                        });
                  },
                  child: Text("Link")),
              CupertinoButton(
                  onPressed: () async {
                    final ok = await confirm(
                        context: context,
                        prompt: Text("Erase ${o.name} from this device?"));
                  },
                  child: Text("Revoke"))
            ])),
          AddAccount()
        ]);
  }
}

class AddAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        CupertinoButton(
          child: const Text("Link phone"),
          onPressed: () async {
            await showModal(context, ShowQr());
          },
        ),
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
    final dg = Dgf.of(context);
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
