import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  // reference our box
  final _myBox = Hive.box('checklist');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    toDoList = [
      ["Add Tasks swipe left to delete", false],
    ];
  }

  // load the data from database
  void loadData() {
    toDoList = _myBox.get("CHECKLIST");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("CHECKLIST", toDoList);
  }
}
