import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:convert/convert.dart';
import 'dart:typed_data';

import '../client/datagrove_flutter.dart';
import '../client/identity.dart';
import '../ui/mobile_scanner.dart';
import '../ui/page.dart';

const teacher = "🧑🏽‍🏫";

// how should we pass around the identity?
// should it be in a provider?

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dg = Dgf.of(context);
    final ids = [];
    //dg.keyChain.toList();
    return PageScaffold(
        leading: Container(),
        title: Text('$teacher Profile'),
        add: () async {
          UserIdentity? u = await Navigator.of(context)
              .push(CupertinoPageRoute(builder: (c) => AddIdentity()));
          if (u != null) {
            //dg.keyChain.update(u);
          }
        },
        search: 'Profile',
        slivers: [
          SliverButton(
            child: Text("Link Laptop"),
            onPressed: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (c) => ScanQr()));
            },
          ),
          for (final o in ids) IdentityRow(o)
        ]);

    //ListScaffold(title: Text('$teacher Profile'), label: 'Profile');
  }
}

class IdentityRow extends StatelessWidget {
  UserIdentity id;
  IdentityRow(this.id);
  @override
  Widget build(BuildContext context) {
    final h = hex.encode(id.uuid);
    return SliverToBoxAdapter(
        child: CupertinoListTile(
            leading:
                id.isDefault ? Icon(CupertinoIcons.check_mark) : Container(),
            title: Text(id.name),
            subtitle: SelectableText(h),
            onTap: () async {
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (c) => ProfileIdentity(id)));
            }));
  }
}

class ProfileIdentity extends StatefulWidget {
  UserIdentity identity;
  ProfileIdentity(this.identity);

  @override
  State<ProfileIdentity> createState() => _ProfileIdentityState();
}

class _ProfileIdentityState extends State<ProfileIdentity> {
  late TextEditingController tc;
  @override
  initState() {
    super.initState();
    tc = TextEditingController(text: widget.identity.name);
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(title: Text(widget.identity.name), slivers: [
      FormSliver(header: Text('Rename'), children: [
        FormRow(label: Text('Name'), placeholder: 'name', controller: tc),
        CupertinoButton(child: Text('Rename'), onPressed: () {}),
        CupertinoButton(child: Text('Link Laptop'), onPressed: () {})
      ])
    ]);
  }
}
/*

[CupertinoTextField(placeholder: "yolo")]
 CupertinoFormRow(
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

      */
