import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onboardingapp/presentation/login/login_controller.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';
import '../../core/constants/app_constants.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Section
                    Icon(
                      FontAwesomeIcons.clipboardCheck,
                      size: 48.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'TodoList Manager',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Đăng nhập để quản lý công việc',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Email Field
                    _buildEmailField(),
                    SizedBox(height: 16.h),

                    // Role Selection
                    _buildRoleSelection(),
                    SizedBox(height: 16.h),

                    // Error Message
                    Obx(() => controller.loginError.isNotEmpty
                        ? _buildErrorMessage()
                        : const SizedBox.shrink()),

                    // Loading State
                    Obx(() => controller.isLoading.value
                        ? _buildLoadingState()
                        : const SizedBox.shrink()),

                    SizedBox(height: 24.h),

                    // Login Button
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Obx(() => TextField(
      onChanged: controller.updateEmail,
      decoration: InputDecoration(
        labelText: 'Email công ty',
        prefixIcon: const Icon(Icons.email),
        errorText: controller.loginError.isNotEmpty ? '' : null,
        errorStyle: const TextStyle(height: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    ));
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn vai trò:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() => Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                role: AppConstants.roleEmployee,
                title: 'Nhân viên',
                icon: FontAwesomeIcons.user,
                isSelected: controller.selectedRole.value == AppConstants.roleEmployee,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildRoleCard(
                role: AppConstants.roleHR,
                title: 'HR Manager',
                icon: FontAwesomeIcons.userGear,
                isSelected: controller.selectedRole.value == AppConstants.roleHR,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.updateRole(role),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
        ),
        child: Column(
          children: [
            FaIcon(
              icon,
              size: 24.sp,
              color: isSelected ? AppColors.primary : AppColors.grey,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            size: 16.sp,
            color: AppColors.error,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              controller.loginError.value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12.w),
          Text(
            'Đang xác thực...',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: controller.isLoading.value || controller.userEmail.isEmpty
            ? null
            : controller.login,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!controller.isLoading.value) ...[
              const Icon(Icons.play_arrow),
              SizedBox(width: 8.w),
            ],
            Text(
              controller.isLoading.value
                  ? 'Đang đăng nhập...'
                  : 'Bắt đầu quản lý công việc',
              style: AppTextStyles.button,
            ),
          ],
        ),
      ),
    ));
  }
}

