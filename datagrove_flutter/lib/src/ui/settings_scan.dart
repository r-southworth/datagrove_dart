import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'dialog.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> with SingleTickerProviderStateMixin {
  String? barcode;

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
        title: Text("Link device"),
        child: Column(children: [
          Center(child: Text("Scan QR code displayed on new device")),
          SizedBox(
            height: 300,
            width: 300,
            child: MobileScanner(
              fit: BoxFit.contain,
              // allowDuplicates: false,
              onDetect: (barcode, args) {
                setState(() {
                  Navigator.of(context).pop(barcode.rawValue);
                });
              },
            ),
          )
        ]));
  }
}
