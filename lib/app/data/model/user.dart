import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot_thermostat/app/utils/functions.dart';
import 'package:jiffy/jiffy.dart';

class User {
  final String id;
  String name;
  Map coordinates;
  String sex;
  String searchSex;
  int age;
  final String phoneNumber, mail;
  int maxDistance;
  Map<String, dynamic> ageRange;
  List<String> imageUrl = [];
  var distanceBW;
  bool isGold, profilVisibility;
  String mood;
  int nbBomb, nbSwipe;
  DateTime dateNextSwipe;
  Map editInfo;
  final String pushToken;

  User(
      {@required this.id,
      @required this.age,
      @required this.coordinates,
      @required this.name,
      @required this.imageUrl,
      this.phoneNumber,
      this.mail,
      this.sex,
      this.searchSex,
      this.ageRange,
      this.maxDistance,
      this.distanceBW,
      this.editInfo,
      this.isGold,
      this.mood,
      this.nbBomb,
      this.nbSwipe,
      this.profilVisibility,
      this.pushToken,
      this.dateNextSwipe});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['userId'],
      phoneNumber: doc['phoneNumber'],
      mail: doc['mail'],
      name: doc['name'],
      ageRange: doc['age_range'],
      searchSex: doc['searchSex'],
      maxDistance: doc['maximum_distance'],
      age: diffDateToToday(
          stringToDate(doc['birthday'], 'dd/MM/yyyy'), Units.YEAR),
      coordinates: doc['location'],
      editInfo: doc['editInfo'],
      isGold: doc['isGold'],
      mood: doc['mood'],
      profilVisibility: doc['profilVisibility'],
      nbBomb: doc['nbBomb'],
      nbSwipe: doc['nbSwipe'],
      dateNextSwipe: doc['dateNextSwipe'] != null ? Timestamp.fromDate(doc['dateNextSwipe'].toDate()).toDate() : null,
      imageUrl: doc['Pictures'] != null
          ? List.generate(doc['Pictures'].length, (index) {
              return doc['Pictures'][index] as String;
            })
          : null,
      pushToken: doc['pushToken'],
    );
  }
}
