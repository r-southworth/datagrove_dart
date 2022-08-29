import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share_plus/share_plus.dart';

Future<FilePickerResult?> getDesktopFile() async {
  return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'zip'],
      allowCompression: true,
      allowMultiple: false);
}

mailTo() async {
  final Uri url = Uri(
    scheme: 'mailto',
    path: 'email@example.com',
    query:
        'subject=App Feedback&body=App Version 3.23', //add subject and body here
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

callTo(String phone) async {
  final Uri url =
      Uri(scheme: 'tel', path: phone, query: '' //add subject and body here
          );

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

void getLocation() async {
  Position _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true);

  List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude, _currentPosition.longitude);

  Placemark place = placemarks[0];

  var whereami = "${place.locality}, ${place.postalCode}, ${place.country}";
}

List<String> closeSchoolDistricts() {
  return ["Sandy Creek Central School"];
}

shareDoc() {
  Share.share('check out my website https://example.com', subject: "xx");
  Share.shareFiles(<String>[], text: 'description');
}
