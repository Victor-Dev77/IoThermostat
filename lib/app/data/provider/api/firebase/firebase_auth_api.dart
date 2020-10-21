import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/translations/app_translations.dart';

import 'custom_exception.dart';

class FirebaseAuthAPI {

  Stream<FirebaseUser> get onAuthStateChanged => FirebaseAuth.instance.onAuthStateChanged;

  Future<FirebaseUser> getCurrentUser() async {
    try {
      return await FirebaseAuth.instance.currentUser();
    } catch (_) {
      print("ERROR: Firebase Auth API: GetCurrentUser()");
      return null;
    }
  }

  
  Future<AuthResult> signIn(String email, String password) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } catch(err) {
      String msg = "";
      switch (err.code) {
        case "ERROR_WRONG_PASSWORD":
          msg = AppTranslation.errorAPIwrongPassword.tr;
          break;
        case "ERROR_INVALID_EMAIL":
          msg = AppTranslation.errorAPIinvalidEmail.tr;
          break;
        case "ERROR_USER_NOT_FOUND":
          msg = AppTranslation.errorAPIuserNotFound.tr;
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          msg = AppTranslation.errorAPImanyRequests.tr;
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          msg = AppTranslation.errorAPInetwork.tr;
          break; 
        default:
          msg = AppTranslation.errorAPIdefault.tr;
          break; 
      }
      print(err);
      throw CustomException(code: err.code, message: msg);
    }
    
  }

  Future<AuthResult> signUp(String email, String password) async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } catch (err) {
      String msg = "";
      switch (err.code) {
        case "ERROR_WEAK_PASSWORD":
          msg = AppTranslation.errorAPIweakPassword.tr;
          break;
        case "ERROR_INVALID_EMAIL":
          msg = AppTranslation.errorAPIinvalidEmail.tr;
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          msg = AppTranslation.errorAPIemailAlreadyUse.tr;
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          msg = AppTranslation.errorAPInetwork.tr;
          break; 
        default:
          msg = AppTranslation.errorAPIdefault.tr;
          break; 
      }
      print(err);
      throw CustomException(code: err.code, message: msg);
    }
  }

  
  signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch(err) {
      String msg = "";
      switch (err) {
        case "ERROR_NETWORK_REQUEST_FAILED":
          msg = AppTranslation.errorAPInetwork.tr;
          break; 
        default:
          msg = AppTranslation.errorAPIdefault.tr;
          break; 
      }
      throw CustomException(code: err.code, message: msg);
    }
  }
}
