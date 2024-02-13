import 'package:flutter/material.dart';
import 'package:travel_checklist/firebasefunctions.dart';
import 'package:travel_checklist/util/checklist_tile.dart';

class PlanTasksPage extends StatefulWidget {
  final String planName;

  const PlanTasksPage({required this.planName, Key? key}) : super(key: key);

  @override
  _PlanTasksPageState createState() => _PlanTasksPageState();
}

class _PlanTasksPageState extends State<PlanTasksPage> {
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      List<Map<String, dynamic>> tasks =
      await _firebaseFunctions.getAllTasksInPlan(widget.planName);
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.planName,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Sans serif',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TaskContainer(
              taskName: _tasks[index]['taskName'],
              taskCompleted: _tasks[index]['completed'],
              onChanged: (value) {
                // Update task completion status
                _firebaseFunctions.updateTaskStatusInPlan(
                  widget.planName,
                  _tasks[index]['taskName'],
                  !value ?? false,
                );
              },
              onDelete: () async {
                // Delete task
                await _firebaseFunctions.deleteTaskInPlan(
                  widget.planName,
                  _tasks[index]['taskName'],
                );
                // Refresh tasks list after deleting a task
                _loadTasks();
              },
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 128,
        height: 64,
        child: FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog(context);
          },
          child: Text('Add Task'),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: _controller,
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
              onPressed: () async {
                String taskName = _controller.text.trim();
                if (taskName.isNotEmpty) {
                  await _firebaseFunctions.addTaskInPlan(
                      widget.planName, taskName);
                  Navigator.pop(context);
                  _loadTasks(); // Refresh tasks list after adding a new task
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class TaskContainer extends StatefulWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool)? onChanged;
  final Function()? onDelete;

  const TaskContainer({
    required this.taskName,
    required this.taskCompleted,
    this.onChanged,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      title: Text(widget.taskName),
      // leading: Checkbox(
      //   value: widget.taskCompleted,
      //   onChanged: (value) {
      //     if (widget.onChanged != null) {
      //       widget.onChanged!(value ?? false); // Call onChanged with the new value
      //     }
      //   },
      // ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: widget.onDelete,
      ),
      tileColor: Colors.yellow, // Background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // Rounded border
      ),
    );
  }
}
