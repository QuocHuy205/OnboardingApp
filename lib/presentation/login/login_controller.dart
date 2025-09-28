import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/route_constants.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/user_repository.dart';

class LoginController extends GetxController {
  final UserRepository _userRepository = Get.find();
  final TaskRepository _taskRepository = Get.find();

  // Observable variables
  final selectedRole = AppConstants.roleEmployee.obs;
  final userEmail = ''.obs;
  final isLoading = false.obs;
  final loginError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _taskRepository.initializeDefaultTasks();
    } catch (e) {
      // Log error but continue
    }
  }

  void updateEmail(String email) {
    userEmail.value = email;
    loginError.value = '';
  }

  void updateRole(String role) {
    selectedRole.value = role;
  }

  Future<void> login() async {
    if (userEmail.value.isEmpty) {
      loginError.value = 'Vui lòng nhập email';
      return;
    }

    isLoading.value = true;
    loginError.value = '';

    try {
      final user = await _userRepository.authenticateUser(
        userEmail.value,
        selectedRole.value,
      );

      if (user != null) {
        // Navigate based on role
        if (user.role == AppConstants.roleHR) {
          Get.offNamed(RouteConstants.hrDashboard, arguments: user);
        } else {
          Get.offNamed(RouteConstants.employeeDashboard, arguments: user);
        }
      }
    } catch (e) {
      loginError.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
