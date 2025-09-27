import 'package:get/get.dart';
import '../data/services/firebase_service.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/task_repository.dart';
import '../data/repositories/user_task_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(FirebaseService(), permanent: true);

    // Repositories
    Get.put(UserRepository(), permanent: true);
    Get.put(TaskRepository(), permanent: true);
    Get.put(UserTaskRepository(), permanent: true);
  }
}