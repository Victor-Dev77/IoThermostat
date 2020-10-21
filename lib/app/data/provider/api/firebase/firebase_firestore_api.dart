import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_thermostat/app/data/model/user.dart';
import 'package:iot_thermostat/app/utils/functions.dart';

class FirebaseFirestoreAPI {
  static final CollectionReference _collectionUser =
      Firestore.instance.collection("Users");

  Future<User> getUser(String uid) async {
    try {
      var doc = await _collectionUser.document(uid).get();
      if (doc.data != null) {
        return User.fromDocument(doc);
      }
      return null;
    } catch (err) {
      print("ERROR: Firebase Firestore API: GetUser() - $err");
      return null;
    }
  }

  initUser(String idUser, String phoneNumber) async {
    await _collectionUser.document(idUser).setData({
      'userId': idUser,
      'phoneNumber': phoneNumber,
      'Pictures': FieldValue.arrayUnion([
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxUC64VZctJ0un9UBnbUKtj-blhw02PeDEQIMOqovc215LWYKu&s"
      ])
      // 'name': user.displayName,
      // 'pictureUrl': user.photoUrl,
    }, merge: true);
  }

  getSwipedCount(String idUser) async {
    int swipe = 0;
    _collectionUser
        .document(idUser)
        .collection("CheckedUser")
        .where(
          'timestamp',
          isGreaterThan: Timestamp.now().toDate().subtract(Duration(days: 1)),
        )
        .snapshots()
        .listen((event) {
      swipe = event.documents.length;
    });
    return swipe;
  }

  noSwipe(String idUser) async {
    var date = await getDateServer();
    date = date.add(Duration(days: 1));
    _collectionUser.document(idUser).setData({
      "dateNextSwipe": date,
    }, merge: true);
  }

  reInitSwipe(String idUser) async {
    var date = await getDateServer();
    date = date.add(Duration(days: 1));
    _collectionUser.document(idUser).setData({
      "dateNextSwipe": date,
      "nbSwipe": 0
    }, merge: true);
  }
 
  updateUserLocation(String idUser, Map<String, dynamic> location) async {
    await _collectionUser.document(idUser).setData(location, merge: true);
  }

  updateUser(String idUser, Map<String, dynamic> data) {
    _collectionUser.document(idUser).setData(data, merge: true);
  }

  deleteUser(String idUser) async {
    await _collectionUser.document(idUser).delete();
  }

  setTokenNotifUser(String idUser, String token) {
    _collectionUser.document(idUser).updateData({
      'pushToken': token,
    });
  }

  _getCheckedUserList(String idUser) async {
    List<String> checkedUser = [];
    var snap = await _collectionUser
        .document(idUser)
        .collection('CheckedUser')
        .getDocuments();
    checkedUser.addAll(snap.documents.map((f) => f['DislikedUser']));
    checkedUser.addAll(snap.documents.map((f) => f['LikedUser']));
    return checkedUser;
  }

  _query(User user) {
    if (user.searchSex == 'HF') {
      return _collectionUser
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(user.ageRange['min']),
          )
          .where('age', isLessThanOrEqualTo: int.parse(user.ageRange['max']))
          .orderBy('age', descending: false);
    } else {
      return _collectionUser
          .where('sex', isEqualTo: user.searchSex)
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(user.ageRange['min']),
          )
          .where('age', isLessThanOrEqualTo: int.parse(user.ageRange['max']))
          //FOR FETCH USER WHO MATCH WITH USER SEXUAL ORIENTAION
          // .where('sexualOrientation.orientation',
          //     arrayContainsAny: currentUser.sexualOrientation)
          .orderBy('age', descending: false);
    }
  }

  getUserListToSwipe(User user) async {
    List<User> listUser = [];
    List<String> checkedUser = await _getCheckedUserList(user.id);
    var snap = await _query(user).getDocuments();
    snap.documents.forEach((doc) {
      User temp = User.fromDocument(doc);
      var distance = calculateDistance(
          user.coordinates['latitude'],
          user.coordinates['longitude'],
          temp.coordinates['latitude'],
          temp.coordinates['longitude']);
      temp.distanceBW = distance.round();
      if (checkedUser.any(
        (value) => value == temp.id,
      )) {
      } else {
        if (distance <= user.maxDistance && temp.id != user.id) {
          listUser.add(temp);
        }
      }
    });
    return listUser;
  }

  getLikedByList(String idUser) async {
    List<User> likedByList = [];
    var snap = await _collectionUser
        .document(idUser)
        .collection("LikedBy")
        .getDocuments();
    likedByList.addAll(snap.documents.map((f) => f['LikedBy']));
    return likedByList;
  }

  getMatches(User user) async {
    List<User> matches = [];
    var snap = await _collectionUser
        .document(user.id)
        .collection('Matches')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    snap.documents.forEach((f) async {
      DocumentSnapshot doc =
          await _collectionUser.document(f.data['Matches']).get();
      if (doc.exists) {
        User tempuser = User.fromDocument(doc);
        tempuser.distanceBW = calculateDistance(
                user.coordinates['latitude'],
                user.coordinates['longitude'],
                tempuser.coordinates['latitude'],
                tempuser.coordinates['longitude'])
            .round();
        matches.add(tempuser);
      }
    });
    return matches;
  }

  match(String idUser1, String idUser2) async {
    await _collectionUser
        .document(idUser1)
        .collection("Matches")
        .document(idUser2)
        .setData(
      {'Matches': idUser2, 'timestamp': FieldValue.serverTimestamp()},
    );
  }

  like(String idUser1, String idUser2) async {
    await _collectionUser
        .document(idUser1)
        .collection("CheckedUser")
        .document(idUser2)
        .setData(
      {
        'LikedUser': idUser2,
        'timestamp': DateTime.now(),
      },
    );
    await _collectionUser
        .document(idUser2)
        .collection("LikedBy")
        .document(idUser1)
        .setData(
      {'LikedBy': idUser1},
    );
  }

  unlike(String me, String idUser) async {
    await _collectionUser
        .document(me)
        .collection('CheckedUser')
        .document(idUser)
        .setData(
      {
        'DislikedUser': idUser,
        'timestamp': DateTime.now(),
      },
    );
  }

  /*Future<List<Event>> searchQueryEvent(Map<String, dynamic> search) async {
    try {
      List<Event> _listEvent = [];
      QuerySnapshot snap = await _query(search).getDocuments();
      snap.documents.forEach((doc) {
        Event event = Event.fromDocument(doc);
        if (search["distance"] == 0)
          _listEvent.add(event);
        else if (event.distanceBW <= search["distance"]) _listEvent.add(event);
      });
      return _listEvent;
    } catch (error) {
      print("ERROR: Firebase Firestore API: searchQueryEvent() => $error");
      return [];
    }
  }*/

}
