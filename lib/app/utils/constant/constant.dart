
abstract class Constant {
  // DATA
  static final Map<String, dynamic> userData = {};

  // VALUE
  static int nbSwipe = 1;
  static int minAge = 18;
  static int maxAge = 35;
  static final String moodSerious = "#Serieux";
  static final String moodSexFriend = "#SexFriend";
  static final String moodFeeling = "#AuFeeling";
  static bool alreadyUpdateNextDateSwipe = false;

  // FIREBASE FUNCTION
  static final String urlDateServerFunction =
      'https://europe-west3-bombr-9f62f.cloudfunctions.net/dateServer';

  
  // Image
  static final String logoImage = "";
  
}
