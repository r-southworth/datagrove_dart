import '../../school/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

// most of this should move to datagrove
// we should generate most of these controllers from the schema
class FormRow extends StatelessWidget {
  Widget label;
  String? placeholder;
  TextEditingController controller;

  FormRow({required this.label, required this.controller, this.placeholder});

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
        prefix: label,
        child: CupertinoTextField(
            controller: controller,
            decoration: null,
            //autofillHints: [AutofillHints.name],
            placeholder: placeholder));
  }
}

// form blocks are functions from controllers to widgets.
Widget name(TextEditingController first, TextEditingController last) {
  //TextEditingController tc1, TextEditingController tc2) {
  return CupertinoFormRow(
      prefix: label("Name"),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                //controller: tc1,
                controller: first,
                decoration: null,
                autofillHints: [AutofillHints.name],
                placeholder: "First")),
        Expanded(
            child: CupertinoTextField(
                controller: last,
                decoration: null,
                autofillHints: [AutofillHints.familyName],
                placeholder: "Last"))
      ]));
}

Widget orgname(TextEditingController first,
    {String prefix = "Name", String placeholder = "Name"}) {
  //TextEditingController tc1, TextEditingController tc2) {
  return CupertinoFormRow(
      prefix: label(prefix),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                //controller: tc1,
                controller: first,
                decoration: null,
                //autofillHints: [AutofillHints.name],
                placeholder: placeholder)),
      ]));
}

Widget testScore(TextEditingController first,
    {String prefix = "Test", String placeholder = "Score"}) {
  //TextEditingController tc1, TextEditingController tc2) {
  return CupertinoFormRow(
      prefix: label(prefix),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                //controller: tc1,
                controller: first,
                decoration: null,
                //autofillHints: [AutofillHints.name],
                placeholder: placeholder)),
      ]));
}

Widget testType(TextEditingController first,
    {String prefix = "Test", String placeholder = "Score"}) {
  //TextEditingController tc1, TextEditingController tc2) {
  return CupertinoFormRow(
      prefix: label(prefix),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                //controller: tc1,
                controller: first,
                decoration: null,
                //autofillHints: [AutofillHints.name],
                placeholder: placeholder)),
      ]));
}

Widget phone(TextEditingController mobile, TextEditingController alt) {
  return CupertinoFormRow(
      prefix: label("Phone"),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                controller: mobile,
                decoration: null,
                keyboardType: TextInputType.phone,
                placeholder: "Mobile",
                autofillHints: [AutofillHints.telephoneNumber])),
        Expanded(
            child: CupertinoTextField(
                controller: alt,
                decoration: null,
                autofillHints: [AutofillHints.telephoneNumber],
                keyboardType: TextInputType.phone,
                placeholder: "Alt"))
      ]));
}

Widget address(TextEditingController street, TextEditingController apt) {
  return CupertinoFormRow(
      prefix: label("Address"),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: CupertinoTextField(
                controller: street,
                decoration: null,
                autofillHints: [AutofillHints.telephoneNumber],
                placeholder: "Street")),
        Expanded(
            flex: 1,
            child: CupertinoTextField(
                controller: apt,
                decoration: null,
                autofillHints: [AutofillHints.telephoneNumber],
                placeholder: "Apt"))
      ]));
}

Widget address1(TextEditingController a) {
  return CupertinoFormRow(
      prefix: label("Address"),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: CupertinoTextField(
                controller: a,
                decoration: null,
                autofillHints: [AutofillHints.telephoneNumber],
                placeholder: "Street")),
      ]));
}

Widget address2(TextEditingController a) {
  return CupertinoFormRow(
      prefix: label("Address"),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: CupertinoTextField(
                controller: a,
                decoration: null,
                autofillHints: [AutofillHints.telephoneNumber],
                placeholder: "Optional")),
      ]));
}

Widget city(TextEditingController a) {
  return CupertinoFormRow(
      prefix: label("City"),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                controller: a,
                decoration: null,
                autofillHints: [AutofillHints.telephoneNumber],
                placeholder: "City")),
      ]));
}

Widget email(TextEditingController a) {
  return CupertinoFormRow(
      prefix: label("Email"),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                controller: a,
                decoration: null,
                // validator: (email) =>
                //     email != null && !EmailValidator.validate(email)
                //         ? 'Enter a valid email'
                //         : null,
                autofillHints: [AutofillHints.telephoneNumber],
                placeholder: "jill@example.com")),
      ]));
}

Widget country(TextEditingController a) {
  return CupertinoFormRow(
      prefix: label("Country"),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                controller: a,
                decoration: null,
                autofillHints: [AutofillHints.countryCode],
                placeholder: "country")),
      ]));
}

Widget stateZip(TextEditingController state, TextEditingController zip) {
  return CupertinoFormRow(
      prefix: label("State / Province / Region"),
      child: Row(children: [
        Expanded(
            child: CupertinoTextField(
                controller: state,
                decoration: null,
                autofillHints: [AutofillHints.telephoneNumber],
                placeholder: "State")),
        Expanded(
            child: CupertinoTextField(
                controller: zip,
                decoration: null,
                autofillHints: [AutofillHints.telephoneNumber],
                placeholder: "Zip / Postal Code"))
      ]));
}

Widget listTile(
    {required Widget child, required Function() onTap, Widget? trailing}) {
  var r = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(children: [
        Expanded(child: Container()),
        trailing ?? Icon(CupertinoIcons.right_chevron)
      ]));
  return GestureDetector(
      onTap: onTap, child: CupertinoFormRow(prefix: child, child: r));
}

Widget label(String w) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: //SizedBox(width: 90, child: Text(w)),
        Container(constraints: BoxConstraints(minWidth: 70), child: Text(w)),
  );
}
// class FormPage extends StatelessWidget {
//   String title;
//   List<Widget> children;
//   FormPage({required this.title, required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return SingleScaffold2(
//         title: title,
//         child: SafeArea(
//             child: SingleChildScrollView(child: Column(children: children))));
//   }
// }

