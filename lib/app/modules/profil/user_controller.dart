import 'package:get/get.dart';
import 'package:iot_thermostat/app/data/model/user.dart';
import 'package:iot_thermostat/app/data/repository/user_repository.dart';
import 'package:meta/meta.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final UserRepository repository;
  UserController({@required this.repository}) : assert(repository != null);

  User _user;
  User get user => this._user;
  set user(value) => this._user = value;

  Map<String, dynamic> _userData = {};
  Map<String, dynamic> get userData => this._userData;

  changeDomain(String domain) {
    Map<String, dynamic> map = {'domain': domain};
    if (_user != null) {
      if (_user.editInfo == null) {
        _user.editInfo = map;
      } else {
        _user.editInfo['domain'] = domain;
      }
    }
    _userData.addAll(map);
    update();
  }

  changeSchool(String school) {
    Map<String, dynamic> map = {
      'editInfo': {
        'domain': _userData['domain'],
        'school': school,
      }
    };
    _userData.addAll(map);
    _userData.remove('domain');
    _user.editInfo = map;
    update();
  }

  changeBasicInfo(String sex, String name, String birthday, int age) {
    _userData.addAll({
      'sex': sex,
      'name': name,
      'birthday': birthday,
      'age': age,
    });
    _user.sex = sex;
    _user.name = name;
    _user.age = age;
    update();
  }

  changeSearchSex(String sex) {
    _user.searchSex = sex;
    _userData.addAll({'searchSex': sex});
    update();
  }

  changeMood(String mood) {
    _user.mood = mood;
    _userData.addAll({'mood': mood});
    update();
  }

  initPicture() {
    _userData.addAll({'Pictures': []});
    update();
  }

  updateNBSwipe() async {
    await repository.updateUser(_user.id, {"nbSwipe": _user.nbSwipe});
  }

  noSwipe() async {
    await repository.noSwipe(_user.id);
  }

  completeSignup(Map<String, dynamic> location) async {
    _userData.addAll({
      'location': location,
      'maximum_distance': 20,
      'age_range': {
        'min': "18",
        'max': "23",
      },
      'isGold': false,
      'nbBomb': 1,
      'nbSwipe': 0,
      'profilVisibility': true,
    });
    _user.coordinates = location;
    _user.maxDistance = 20;
    _user.ageRange = {
      'min': "18",
      'max': "23",
    };
    _user.isGold = false;
    _user.nbBomb = 1;
    _user.nbSwipe = 0;
    _user.profilVisibility = true;
    update();
    await repository.updateUser(_user.id, _userData);
  }
}
