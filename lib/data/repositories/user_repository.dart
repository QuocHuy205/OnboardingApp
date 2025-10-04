import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:onboardingapp/data/models/task_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/utils/validation_utils.dart';
import '../../core/utils/date_utils.dart';

class UserRepository extends GetxService {
  final FirebaseService _firebaseService = Get.find();

  // Authenticate user with password
  Future<UserModel?> authenticateUser(String email, String password, String role) async {
    try {
      if (!ValidationUtils.isValidEmail(email)) {
        throw Exception('Email không hợp lệ');
      }

      if (password.isEmpty) {
        throw Exception('Vui lòng nhập mật khẩu');
      }

      final userId = ValidationUtils.sanitizeEmailForFirebase(email);
      final snapshot = await _firebaseService.getUserRef(userId).get();

      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;
        final user = UserModel.fromMap(Map<String, dynamic>.from(userData));

        if (user.password != password) {
          throw Exception('Mật khẩu không đúng');
        }

        if (user.role == role) {
          return user;
        } else {
          throw Exception('Sai vai trò hoặc thông tin không khớp');
        }
      } else {
        throw Exception('Tài khoản không tồn tại. Vui lòng liên hệ HR để tạo tài khoản.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi kết nối: ${e.toString()}');
    }
  }

  // Reset password - generate random password
  Future<String> resetPassword(String email) async {
    try {
      if (!ValidationUtils.isValidEmail(email)) {
        throw Exception('Email không hợp lệ');
      }

      final userId = ValidationUtils.sanitizeEmailForFirebase(email);
      final snapshot = await _firebaseService.getUserRef(userId).get();

      if (!snapshot.exists) {
        throw Exception('Email không tồn tại trong hệ thống');
      }

      final userData = snapshot.value as Map<dynamic, dynamic>;
      final user = UserModel.fromMap(Map<String, dynamic>.from(userData));

      // Generate random 8-character password
      final newPassword = _generateRandomPassword();

      final updatedUser = user.copyWith(password: newPassword);
      await saveUser(updatedUser);

      return newPassword;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi reset password: ${e.toString()}');
    }
  }

  String _generateRandomPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Get employees stream
  Stream<List<UserModel>> getEmployeesStream() {
    return _firebaseService.getUsersRef()
        .orderByChild('role')
        .equalTo(AppConstants.roleEmployee)
        .onValue
        .map((event) {
      final List<UserModel> employees = [];
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final userData = Map<String, dynamic>.from(value);
          employees.add(UserModel.fromMap(userData));
        });
      }
      return employees;
    });
  }

  // Save user
  Future<void> saveUser(UserModel user) async {
    try {
      await _firebaseService.getUserRef(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Lỗi lưu user: ${e.toString()}');
    }
  }

  // Create employee with custom password
  Future<UserModel> createEmployee(String name, String email, String password) async {
    try {
      if (!ValidationUtils.isValidName(name)) {
        throw Exception('Tên không hợp lệ');
      }
      if (!ValidationUtils.isValidEmail(email)) {
        throw Exception('Email không hợp lệ');
      }

      final userId = ValidationUtils.sanitizeEmailForFirebase(email);
      final newEmployee = UserModel(
        id: userId,
        name: name.trim(),
        email: email.toLowerCase().trim(),
        role: AppConstants.roleEmployee,
        startDate: AppDateUtils.getCurrentDate(),
        password: password.isEmpty ? '123456' : password,
      );

      await saveUser(newEmployee);
      return newEmployee;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi tạo nhân viên: ${e.toString()}');
    }
  }

  // Update employee
  Future<void> updateEmployee(String oldId, UserModel updatedEmployee) async {
    try {
      if (!ValidationUtils.isValidName(updatedEmployee.name)) {
        throw Exception('Tên không hợp lệ');
      }
      if (!ValidationUtils.isValidEmail(updatedEmployee.email)) {
        throw Exception('Email không hợp lệ');
      }

      if (oldId != updatedEmployee.id) {
        final taskSnapshot = await _firebaseService
            .getUserTasksRef()
            .child(oldId)
            .get();

        final Map<String, dynamic> updates = {};
        updates['${FirebaseConstants.usersPath}/${updatedEmployee.id}'] = updatedEmployee.toMap();
        updates['${FirebaseConstants.usersPath}/$oldId'] = null;

        if (taskSnapshot.exists) {
          final userTasksData = taskSnapshot.value as Map<dynamic, dynamic>;
          final updatedUserTasks = <String, dynamic>{};

          userTasksData.forEach((taskId, userTaskData) {
            final userTaskMap = Map<String, dynamic>.from(userTaskData);
            userTaskMap['userId'] = updatedEmployee.id;
            updatedUserTasks[taskId] = userTaskMap;
          });

          updates['${FirebaseConstants.userTasksPath}/${updatedEmployee.id}'] = updatedUserTasks;
          updates['${FirebaseConstants.userTasksPath}/$oldId'] = null;
        }

        await _firebaseService.database.update(updates);
      } else {
        await saveUser(updatedEmployee);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi cập nhật nhân viên: ${e.toString()}');
    }
  }

  // Delete employee
  Future<void> deleteEmployee(UserModel employee) async {
    try {
      final Map<String, dynamic> updates = {
        '${FirebaseConstants.usersPath}/${employee.id}': null,
        '${FirebaseConstants.userTasksPath}/${employee.id}': null,
      };

      await _firebaseService.database.update(updates);
      await _deleteCustomTasksForUser(employee.id);
    } catch (e) {
      throw Exception('Lỗi xóa nhân viên: ${e.toString()}');
    }
  }

  Future<void> _deleteCustomTasksForUser(String userId) async {
    try {
      final snapshot = await _firebaseService.getTasksRef()
          .orderByChild('createdBy')
          .equalTo(userId)
          .get();

      if (snapshot.exists) {
        final Map<String, dynamic> updates = {};
        final data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          final taskData = Map<String, dynamic>.from(value);
          final task = TaskModel.fromMap(taskData);
          if (!task.isDefault) {
            updates['${FirebaseConstants.tasksPath}/$key'] = null;
          }
        });

        if (updates.isNotEmpty) {
          await _firebaseService.database.update(updates);
        }
      }
    } catch (e) {
      // Log error but don't fail main operation
    }
  }
}