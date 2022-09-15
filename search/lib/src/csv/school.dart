import "package:csv/csv.dart";
import 'package:csv/csv_settings_autodetection.dart';

/*
List<District> district_ = [];
@override
Future<List<District>> district() async {
  if (district_ == null) {
    var data = await rootBundle.loadString("assets/us.ny/district.csv");
    var dx = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);

    // 0.NCES District ID,1 State District ID, 2 District Name,3 County Name*,4 Street Address,5 City,6 State,7 ZIP,8 ZIP 4-digit,9 Phone,10 Students*,11 Teachers*,12 Schools,13 Locale Code*,14 Locale*,15 Student Teacher Ratio*,16 Type

    // for now these are all the same, we don't know the admin.
    List<List<dynamic>> rows =
        CsvToListConverter(csvSettingsDetector: dx).convert(data);
    var r = List<District>.filled(rows.length, District());
    for (int i = 0; i < rows.length; i++) {
      var a = Administrator();
      r[i].admin = a;
      a.name = rows[i][2];
      a.address1 = rows[i][4];
      a.city = rows[i][5];
      a.state = rows[i][6];
      a.zip = rows[i][7].toString();
      a.phone = rows[i][9];
      r[i].name = a.name;
    }
    district_ = r;
  }
  return district_;
}
*/
