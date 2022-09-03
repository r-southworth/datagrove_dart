// share widget is supposed to show who is sharing
import 'package:flutter/cupertino.dart';

import '../client/datagrove_flutter.dart';

class ShareButton extends StatelessWidget {
  static const ShareDatum = 1;
  // use the controller to make it simpler to
  //  DatumbaseController controller;
  Dgf dg;
  int db;
  late ChangeNotifier notifier;
  // not clear we need this? we could just look in dgf can't we?
  // we don't necessarily want to rebuild the widget if this datum didn't change
  // but its too late if we wait for build to do this.
  ShareButton({
    required this.dg,
    required this.db,
  }) {
    // the sharing policy of the db may allow allow non-owners to manage this datum
    //notifier = dg.datumNotifier(db, ShareDatum);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: notifier,
        builder: (BuildContext c, _) {
          // this will rebuild when the datum changes
          return Container();
        });
  }
}

// the dengine itself is a controller; it signals online/offline.
// we might need

