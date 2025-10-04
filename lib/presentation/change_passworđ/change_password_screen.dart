import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Đổi mật khẩu',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF26C6DA).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64.sp,
                color: const Color(0xFF26C6DA),
              ),
              SizedBox(height: 24.h),

              Obx(() => _buildPasswordField(
                label: 'Mật khẩu hiện tại',
                onChanged: controller.updateOldPassword,
                isVisible: controller.isOldPasswordVisible.value,
                onToggle: controller.toggleOldPasswordVisibility,
              )),
              SizedBox(height: 16.h),

              Obx(() => _buildPasswordField(
                label: 'Mật khẩu mới',
                onChanged: controller.updateNewPassword,
                isVisible: controller.isNewPasswordVisible.value,
                onToggle: controller.toggleNewPasswordVisibility,
              )),
              SizedBox(height: 16.h),

              Obx(() => _buildPasswordField(
                label: 'Xác nhận mật khẩu mới',
                onChanged: controller.updateConfirmPassword,
                isVisible: controller.isConfirmPasswordVisible.value,
                onToggle: controller.toggleConfirmPasswordVisibility,
              )),
              SizedBox(height: 24.h),

              Obx(() => Container(
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: controller.isLoading.value || !controller.isFormValid
                      ? null
                      : const LinearGradient(
                    colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ElevatedButton(
                  onPressed: controller.isLoading.value || !controller.isFormValid
                      ? null
                      : controller.changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isLoading.value || !controller.isFormValid
                        ? Colors.grey[300]
                        : Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    'Đổi mật khẩu',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required Function(String) onChanged,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF00838F),
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          onChanged: onChanged,
          obscureText: !isVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF26C6DA)),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF26C6DA), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}