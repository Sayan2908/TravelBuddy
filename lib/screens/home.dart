import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/checklist_tile.dart';
import '../util/dialog_box.dart';
import 'shared_page.dart'; // Import the shared page
import 'account_page.dart'; // Import the account page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('checklist');
  ToDoDataBase db = ToDoDataBase();

  int _selectedIndex = 0;

  @override
  void initState() {
    // if this is the 1st time ever opening the app, then create default data
    if (_myBox.get("CHECKLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travel Checklist',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Sans serif',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: _selectedIndex == 0
          ? ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ChecklistTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      )
          : _selectedIndex == 1
          ? SharedPage()
          : AccountPage(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orangeAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              icon: Icon(Icons.home_filled,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              icon: Icon(Icons.share_location_outlined,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              icon: Icon(Icons.account_circle,
                  color: _selectedIndex == 2 ? Colors.white : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
