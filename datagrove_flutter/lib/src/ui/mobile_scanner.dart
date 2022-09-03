import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../client/datagrove_flutter.dart';
import '../tabs/home.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> with SingleTickerProviderStateMixin {
  String? barcode;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(title: Text("Link Laptop"), slivers: [
      HeadingSliver("Scan QR code displayed on your laptop"),
      SliverToBoxAdapter(
          child: MobileScanner(
        fit: BoxFit.contain,
        // allowDuplicates: false,
        onDetect: (barcode, args) {
          setState(() {
            Navigator.of(context).pop(barcode.rawValue);
          });
        },
      ))
    ]);
  }
}
