import 'package:hive/hive.dart';

class ToDoDatabase {
  List toDoList = [];
  final _MyBox = Hive.box('MyBox');

  void createInitialData() {
    toDoList = [
      ["CODE FOR AN HOUR", false, true, 3600],
      ["EXERCISE / WORKOUT", false, false, 0]
    ];
  }

  void loadData() {
    toDoList = _MyBox.get("TODOLIST");
  }

  void updateData() {
    _MyBox.put("TODOLIST", toDoList);
  }
}
