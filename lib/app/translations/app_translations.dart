import 'package:flutter/material.dart';

import 'en_US/en_us_translation.dart';
import 'fr_FR/fr_fr_translation.dart';

abstract class AppTranslation {

  static final List<Locale> languages = [
    Locale("fr", "FR"),
    Locale("en", "US"),
  ];

  static Map<String, Map<String, String>> translations = {
    'fr_FR': frFR,
    'en_US': enUs
  };

  static const String locationCheckTitle = "location_check";

  // EXCEPTION API
  static const String errorAPIdefault = "error_api_default";
  static const String errorAPInetwork = "error_api_network";
  static const String errorAPIemailAlreadyUse = "error_api_email_already_use";
  static const String errorAPIinvalidEmail = "error_api_invalid_email";
  static const String errorAPIweakPassword = "error_api_weak_password";
  static const String errorAPIwrongPassword = "error_api_wrong_password";
  static const String errorAPIuserNotFound = "error_api_user_not_found";
  static const String errorAPImanyRequests = "error_api_many_requests";
  static const String errorAPInoUploadPicture = "error_api_no_upload_picture";
}
