import 'package:get/get.dart';

class SqueletonController extends GetxController {

  int _indexMenu = 0;
  int get indexMenu => this._indexMenu;

  updateIndexMenu(int index) {
    _indexMenu = index;
    update();
  }

}