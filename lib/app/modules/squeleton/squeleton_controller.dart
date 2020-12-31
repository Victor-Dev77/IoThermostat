import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/rooms/schedule_room_controller.dart';
import 'package:iot_thermostat/app/modules/widgets_global/snackbar.dart';

class SqueletonController extends GetxController {

  static SqueletonController get to => Get.find();

  int _indexMenu = 0;
  int get indexMenu => this._indexMenu;

  List<String> rooms = ['Salon', 'Chambre 1', 'Cuisine', 'Salle de bain', 'WC'];
  String roomSelected = "";

  @override
  void onInit() {
    super.onInit();
    roomSelected = rooms.first;
    ScheduleRoomController.to.enabled();
  }

  updateIndexMenu(int index) {
    _indexMenu = index;
    update();
  }

  changeRoom(String newRoom) {
    roomSelected = newRoom;
    update();
  }

  deleteRoom(int index) {
    var temp = roomSelected;
    if (roomSelected == rooms[index])
      temp = rooms.first;
    rooms.removeAt(index);
    if (rooms.contains(temp))
      roomSelected = temp;
    else
      roomSelected = rooms.length > 0 ? rooms.first : "";
    if (roomSelected == "")
      ScheduleRoomController.to.disabled();
    else
      ScheduleRoomController.to.enabled();
    update();
  }

  addRoom(String room) {
    if (rooms.contains(room)) {
      CustomSnackbar.snackbar("Cette pièce existe déjà");
      return;
    }
    rooms.add(room);
    roomSelected = room;
    ScheduleRoomController.to.enabled();
    update();
  }

}