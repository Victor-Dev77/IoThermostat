import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot_thermostat/app/data/provider/api/firebase/firebase_auth_api.dart';
import 'package:iot_thermostat/app/data/provider/api/firebase/firebase_firestore_api.dart';

class UserRepository {
 
  final FirebaseAuthAPI _authAPI = FirebaseAuthAPI();
  final FirebaseFirestoreAPI _databaseAPI = FirebaseFirestoreAPI();


  Stream<FirebaseUser> get onAuthStateChanged => this._authAPI.onAuthStateChanged;

  getCurrentUser() async {
    return await _authAPI.getCurrentUser();
  }

  logout() async {
    await _authAPI.signOut();
  }

  getUser(String uid) async {
    return await _databaseAPI.getUser(uid);
  }

  getSwipedCount(String uid) async {
    return await _databaseAPI.getSwipedCount(uid);
  }

  initUser(String idUser, String phoneNumber) {
    _databaseAPI.initUser(idUser, phoneNumber);
  }

  updateUser(String idUser, Map<String, dynamic> data) {
    _databaseAPI.updateUser(idUser, data);
  }

  updateUserLocation(String idUser, Map<String, dynamic> location) {
    _databaseAPI.updateUserLocation(idUser, location);
  }

  deleteUser(String idUser) {
    _databaseAPI.deleteUser(idUser);
  }
 
  noSwipe(String idUser) {
    _databaseAPI.noSwipe(idUser);
  }

  reInitSwipe(String idUser) {
    _databaseAPI.reInitSwipe(idUser);
  }

}