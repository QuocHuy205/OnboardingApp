import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class ChangePasswordController extends GetxController {
  final UserRepository _userRepository = Get.find();

  late final UserModel currentUser;

  final oldPassword = ''.obs;
  final newPassword = ''.obs;
  final confirmPassword = ''.obs;

  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser = Get.arguments as UserModel;
  }

  bool get isFormValid =>
      oldPassword.value.isNotEmpty &&
          newPassword.value.isNotEmpty &&
          confirmPassword.value.isNotEmpty;

  void updateOldPassword(String value) => oldPassword.value = value;
  void updateNewPassword(String value) => newPassword.value = value;
  void updateConfirmPassword(String value) => confirmPassword.value = value;

  void toggleOldPasswordVisibility() => isOldPasswordVisible.toggle();
  void toggleNewPasswordVisibility() => isNewPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  Future<void> changePassword() async {
    if (oldPassword.value != currentUser.password) {
      Get.snackbar('Lỗi', 'Mật khẩu hiện tại không đúng');
      return;
    }

    if (newPassword.value.length < 6) {
      Get.snackbar('Lỗi', 'Mật khẩu mới phải có ít nhất 6 ký tự');
      return;
    }

    if (newPassword.value != confirmPassword.value) {
      Get.snackbar('Lỗi', 'Mật khẩu xác nhận không khớp');
      return;
    }

    isLoading.value = true;

    try {
      final updatedUser = currentUser.copyWith(password: newPassword.value);
      await _userRepository.saveUser(updatedUser);

      Get.back();
      Get.snackbar('Thành công', 'Đổi mật khẩu thành công');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}