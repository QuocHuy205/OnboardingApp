import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onboardingapp/presentation/login/login_controller.dart';
import 'package:onboardingapp/presentation/login/widgets/role_selection_card.dart';
import 'package:onboardingapp/presentation/login/widgets/login_form.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4DD0E1).withOpacity(0.1),
              const Color(0xFF26C6DA).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  SizedBox(height: 48.h),
                  _buildLoginCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF26C6DA).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.assignment_turned_in,
            size: 40.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'TodoList Manager',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00838F),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Quản lý công việc hiệu quả hơn',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      constraints: BoxConstraints(maxWidth: 400.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26C6DA).withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(28.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => LoginForm(
              onEmailChanged: controller.updateEmail,
              isLoading: controller.isLoading.value,
              errorMessage: controller.loginError.value,
            )),
            SizedBox(height: 24.h),
            Obx(() => RoleSelectionCard(
              selectedRole: controller.selectedRole.value,
              onRoleChanged: controller.updateRole,
              enabled: !controller.isLoading.value,
            )),
            SizedBox(height: 20.h),
            Obx(() => controller.loginError.isNotEmpty
                ? _buildErrorMessage()
                : const SizedBox.shrink()),
            Obx(() => controller.isLoading.value
                ? _buildLoadingIndicator()
                : const SizedBox.shrink()),
            SizedBox(height: 28.h),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 20.sp,
            color: Colors.red[700],
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              controller.loginError.value,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4DD0E1).withOpacity(0.1),
            const Color(0xFF26C6DA).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF26C6DA)),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Đang xác thực...',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF00838F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => Container(
      height: 52.h,
      decoration: BoxDecoration(
        gradient: controller.isLoading.value || controller.userEmail.isEmpty
            ? null
            : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
        ),
        color: controller.isLoading.value || controller.userEmail.isEmpty
            ? Colors.grey[300]
            : null,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: controller.isLoading.value || controller.userEmail.isEmpty
            ? null
            : [
          BoxShadow(
            color: const Color(0xFF26C6DA).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.isLoading.value || controller.userEmail.isEmpty
            ? null
            : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!controller.isLoading.value) ...[
              const Icon(Icons.login, color: Colors.white),
              SizedBox(width: 10.w),
            ],
            Text(
              controller.isLoading.value
                  ? 'Đang đăng nhập...'
                  : 'Đăng nhập',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}