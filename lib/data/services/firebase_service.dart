import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:onboardingapp/core/constants/firebase_constants.dart';
import 'package:onboardingapp/data/models/task_model.dart';


class FirebaseService extends GetxService {
  static FirebaseService get instance => Get.find();

  late DatabaseReference _database;

  DatabaseReference get database => _database;

  @override
  Future<void> onInit() async {
    super.onInit();
    _database = FirebaseDatabase.instance.ref();
  }

  DatabaseReference getUsersRef() => _database.child(FirebaseConstants.usersPath);
  DatabaseReference getTasksRef() => _database.child(FirebaseConstants.tasksPath);
  DatabaseReference getUserTasksRef() => _database.child(FirebaseConstants.userTasksPath);

  DatabaseReference getUserRef(String userId) => getUsersRef().child(userId);
  DatabaseReference getTaskRef(String taskId) => getTasksRef().child(taskId);
  DatabaseReference getUserTaskRef(String userId, String taskId) =>
      getUserTasksRef().child(userId).child(taskId);

  // Add missing stream method
  Stream<List<TaskModel>> getAllTasksStream() {
    return getTasksRef().onValue.map((event) {
      final List<TaskModel> tasks = [];
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final taskData = Map<String, dynamic>.from(value);
          tasks.add(TaskModel.fromMap(taskData));
        });
      }
      return tasks;
    });
  }
}
