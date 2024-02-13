import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/checklist_tile.dart';
import '../util/dialog_box.dart';
import 'shared_page.dart'; // Import the shared page
import 'account_page.dart'; // Import the account page

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: false,
      ),
      body: _selectedIndex == 0
          ? HomePage()
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('checklist');
  ToDoDataBase db = ToDoDataBase();

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

  void editTaskName(BuildContext context, String editedTaskName, int index) {
    setState(() {
      db.toDoList[index][0] = editedTaskName;
    });
    db.updateDataBase();
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void _showEditTaskDialog(BuildContext context, int index) {
    TextEditingController controller =
    TextEditingController(text: db.toDoList[index][0]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter task name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String editedTaskName = controller.text.trim();
                if (editedTaskName.isNotEmpty) {
                  setState(() {
                    db.toDoList[index][0] = editedTaskName;
                  });
                  db.updateDataBase();
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ChecklistTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            editFunction: (context) => _showEditTaskDialog(context, index),
          );
        },
      ),
    );
  }
}
