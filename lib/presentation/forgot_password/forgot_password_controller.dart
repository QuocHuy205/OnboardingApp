import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../data/repositories/user_repository.dart';

class ForgotPasswordController extends GetxController {
  final UserRepository _userRepository = Get.find();

  final email = ''.obs;
  final isLoading = false.obs;

  void updateEmail(String value) {
    email.value = value;
  }

  Future<void> resetPassword() async {
    if (email.value.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập email');
      return;
    }

    isLoading.value = true;

    try {
      final newPassword = await _userRepository.resetPassword(email.value);

      Get.back();

      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 24.sp),
              SizedBox(width: 12.w),
              const Text('Thành công'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mật khẩu mới của bạn là:'),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: SelectableText(
                  newPassword,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00838F),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Vui lòng lưu lại và đổi mật khẩu sau khi đăng nhập',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26C6DA),
              ),
              child: const Text('Đã hiểu'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}