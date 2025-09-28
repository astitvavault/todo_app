import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utilities/dialog_box.dart';
import 'package:todo_app/utilities/to_do_tile.dart';

class Homepage extends StatefulWidget {

  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = TextEditingController();
  final _MyBox  = Hive.box('MyBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    if(_MyBox.get("TODOLIST") == null){
      db.createInitialData();
    }
    else{
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
      if (db.toDoList[index][1] == true) {
        db.toDoList[index][3] = 0;

      }
    });
    db.updateData();
  }

  void saveNewTask(bool isHighPriority, String timerText) {
    // int timerInSeconds = 0;
    // if (isHighPriority) {
    //   timerInSeconds = int.tryParse(timerText) != null
    //       ? int.parse(timerText) * 60
    //       : 0;
    // }
    // setState(() {
    //   db.toDoList.add([_controller.text, false, isHighPriority, timerInSeconds]);
    //   _controller.clear();
    // });
    // Navigator.of(context).pop();
    // db.updateData();
    int timerInSeconds = 0;
    int? endTime;

    if (isHighPriority) {
      int minutes = int.tryParse(timerText) ?? 0;
      timerInSeconds = minutes * 60;
      endTime = DateTime.now().millisecondsSinceEpoch + (timerInSeconds * 1000);
    }

    setState(() {
      db.toDoList.add([
        _controller.text,          // task name
        false,                     // completed
        isHighPriority,            // priority
        endTime ?? 0,              // store END TIME instead of countdown
      ]);
      _controller.clear();
    });

    Navigator.of(context).pop();
    db.updateData();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: (isHighPriority, timerText) {
              saveNewTask(isHighPriority, timerText);
            },
            onCancel: () => Navigator.of(context).pop(),
          );
        }
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        title: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Text("GRIND", style: TextStyle(color: Colors.white, fontSize: 30),),
          SizedBox(
            width: 10,
          ),
          SvgPicture.asset("assets/icons8-hard-working-48.svg",
            height: 30,
            width: 30,
          )
        ]),

      ) ,
      backgroundColor: Colors.black12,
        floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add,),
      ),
      body: Stack(

        children: [
          Image.asset(
            "assets/download (2).jpg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.8),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 350,  // Adjust height of gradient area
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,  // Top is transparent
                  Colors.black87,      // Bottom is solid black
                ],
              ),
            ),
          ),
        ),
          ListView.builder(
          itemCount: db.toDoList.length,
            itemBuilder: (context, index){
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              isHighPriority: db.toDoList[index][2],
              timerInSeconds: db.toDoList[index][3],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
            }),
        ],
      )
    );
  }
}
