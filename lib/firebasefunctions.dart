import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get all the plans
  Future<List<String>> getAllPlans() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('sharedchecklist').get();
      List<String> plans = [];
      querySnapshot.docs.forEach((doc) {
        plans.add(doc.id);
      });
      return plans;
    } catch (e) {
      print('Error getting plans: $e');
      return [];
    }
  }

  // Function to get all the tasks in a plan
  Future<List<Map<String, dynamic>>> getAllTasksInPlan(String planName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('sharedchecklist')
          .doc(planName)
          .collection('tasks')
          .get();
      List<Map<String, dynamic>> tasks = [];
      querySnapshot.docs.forEach((doc) {
        tasks.add({
          'taskName': doc.id,
          'completed': doc['completed'],
        });
      });
      return tasks;
    } catch (e) {
      print('Error getting tasks in plan $planName: $e');
      return [];
    }
  }

  // Function to add a task in a plan
  Future<void> addTaskInPlan(String planName, String taskName) async {
    try {
      await _firestore
          .collection('sharedchecklist')
          .doc(planName)
          .collection('tasks')
          .doc(taskName)
          .set({'completed': false});
    } catch (e) {
      print('Error adding task $taskName in plan $planName: $e');
    }
  }

  // Function to create a new plan
  Future<void> createNewPlan(String planName) async {
    try {
      await _firestore.collection('sharedchecklist').doc(planName).set({});
    } catch (e) {
      print('Error creating plan $planName: $e');
    }
  }

  // Function to delete a plan
  Future<void> deletePlan(String planName) async {
    try {
      await _firestore.collection('sharedchecklist').doc(planName).delete();
    } catch (e) {
      print('Error deleting plan $planName: $e');
    }
  }

  // Function to update task status in a plan
  Future<void> updateTaskStatusInPlan(
      String planName, String taskName, bool completed) async {
    try {
      await _firestore
          .collection('sharedchecklist')
          .doc(planName)
          .collection('tasks')
          .doc(taskName)
          .update({'completed': completed});
    } catch (e) {
      print('Error updating task $taskName in plan $planName: $e');
    }
  }

  // Function to delete a task from a plan
  Future<void> deleteTaskInPlan(String planName, String taskName) async {
    try {
      await _firestore
          .collection('sharedchecklist')
          .doc(planName)
          .collection('tasks')
          .doc(taskName)
          .delete();
    } catch (e) {
      print('Error deleting task $taskName in plan $planName: $e');
    }
  }
}
