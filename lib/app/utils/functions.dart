import 'dart:convert';
import 'dart:math';
import 'package:iot_thermostat/app/data/model/user.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'constant/constant.dart';

String parseDateTime(DateTime date, String regex) {
  return Jiffy(date).format(regex);
}

String parseTimestamp(Duration duration) {
  String date = duration.toString().split('.').first;
  String newDate = date.substring(0, date.length - 3);
  List<String> list = newDate.split(":");
  String res = "";
  if (list[0].length == 1)
    res = "0${list[0]}:";
  else
    res = "${list[0]}:";
  if (list[1].length == 1)
    res += "0${list[1]}";
  else
    res += list[1];
  return res;
}

DateTime stringToDate(String date, String regex) {
  return Jiffy(date, regex).dateTime;
}

DateTime timestampToDate(int timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
}

int diffDateToToday(DateTime date, Units units) {
  var now = Jiffy();
  return now.diff(
      Jiffy(
        date,
      ),
      units);
}

int diffDateSwipeToDateServer(DateTime dateServer, DateTime dateSwipe, Units units) {
  var now = Jiffy(dateServer);
  return now.diff(
      Jiffy(
        dateSwipe,
      ),
      units);
}

bool stringIsAlphabet(String str) {
  bool res = true;
  for (int i = 0; i < str.length; i++) {
    if (!str[i].contains(RegExp(r"(\w+)"))) {
      res = false;
    }
  }
  return res;
}

String capitalizeFirstLetter(String str) {
  return "${str[0].toUpperCase()}${str.substring(1)}";
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

chatId(User currentUser, User sender) {
  if (currentUser.id.hashCode <= sender.id.hashCode) {
    return '${currentUser.id}-${sender.id}';
  } else {
    return '${sender.id}-${currentUser.id}';
  }
}

Future<DateTime> getDateServer() async {
  try {
    http.Response resp = await http.get(
      Constant.urlDateServerFunction,
    );
    if (resp.statusCode == 200) {
      print("response: ${resp.body}");
      Map<String, dynamic> map = json.decode(resp.body);
      print("time: ${map['timestamp']}");
      print("date: ${timestampToDate(map['timestamp'])}");
      var date = timestampToDate(map['timestamp']);
      return date;
      /*var now = Jiffy().dateTime;
        Duration diff = now.difference(timestampToDate(map['timestamp']));
        print("now date: $now, $diff");
        print(
            "diff to today: ${diffDateToToday(timestampToDate(map['timestamp']), Units.HOUR)}");*/
    } else {
      print("error get http call");
      return DateTime.now();
    }
  } catch (e) {
    print(e.toString());
    return DateTime.now();
  }
}
