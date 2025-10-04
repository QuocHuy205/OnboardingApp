import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00838F)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Quên mật khẩu',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00838F),
            ),
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Container(
                    constraints: BoxConstraints(maxWidth: 400.w),
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
                      Icons.lock_reset,
                      size: 64.sp,
                      color: const Color(0xFF26C6DA),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Lấy lại mật khẩu',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00838F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Nhập email của bạn để nhận mật khẩu mới',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    TextField(
                        onChanged: controller.updateEmail,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email, color: Color(0xFF26C6DA)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(color: Color(0xFF26C6DA), width: 2),
                          ),
                        ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                        SizedBox(height: 24.h),

                        Obx(() => Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            gradient: controller.isLoading.value || controller.email.isEmpty
                                ? null
                                : const LinearGradient(
                              colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value || controller.email.isEmpty
                                ? null
                                : controller.resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isLoading.value || controller.email.isEmpty
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
                              'Lấy lại mật khẩu',
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
        ),
    );
  }
}