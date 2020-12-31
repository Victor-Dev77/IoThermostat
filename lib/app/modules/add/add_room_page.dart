import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_thermostat/app/modules/add/add_room_controller.dart';
import 'package:iot_thermostat/app/modules/squeleton/squeleton_controller.dart';

class AddRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.grey,
        height: Get.height - kBottomNavigationBarHeight,
        child: Column(
          children: <Widget>[
            GetBuilder<SqueletonController>(builder: (_) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  child: Text(
                    "Nombre de pièces: ${_.nbRooms}",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              );
            }),
            _buildListRooms(),
            SizedBox(height: 10),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildListRooms() {
    return GetBuilder<SqueletonController>(
      builder: (_) {
        return Container(
          height: _.rooms.length * 50.0,
          constraints: BoxConstraints(
            maxHeight: 175,
          ),
          color: Colors.grey[300],
          child: Scrollbar(
            child: ListView.builder(
              itemCount: _.rooms.length,
              itemBuilder: (ctx, index) {
                var item = _.rooms[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (direction) => _.deleteRoom(index),
                  child: ListTile(
                    title: Center(child: Text(item)),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    return Expanded(
      child: GetBuilder<AddRoomController>(
        init: AddRoomController(),
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                "Ajouter une pièce",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CupertinoTextField(
                  controller: _.nameController,
                  maxLength: 30,
                  maxLines: 1,
                  placeholder: "Ajouter le nom d'une pièce de votre maison",
                  placeholderStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () => _.addRoom(),
                  child: Container(
                    width: Get.width * .5,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    ),
                    child: Center(
                      child: Text(
                        'AJOUTER',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
