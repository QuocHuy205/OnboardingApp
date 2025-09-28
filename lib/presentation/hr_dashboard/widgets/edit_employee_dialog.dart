import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onboardingapp/core/themes/app_colors.dart';
import 'package:onboardingapp/core/themes/text_styles.dart';
import 'package:onboardingapp/core/widgets/custom_button.dart';
import 'package:onboardingapp/core/widgets/custom_text_field.dart';
import 'package:onboardingapp/data/models/user_model.dart';

class EditEmployeeDialog extends StatelessWidget {
  final UserModel employee;
  final Function(String name, String email) onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;

  const EditEmployeeDialog({
    super.key,
    required this.employee,
    required this.onConfirm,
    required this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: employee.name);
    final emailController = TextEditingController(text: employee.email);
    final formKey = GlobalKey<FormState>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Sửa thông tin nhân viên',
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Name Field
              CustomTextField(
                controller: nameController,
                labelText: 'Họ tên',
                prefixIcon: const Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ tên';
                  }
                  if (value.trim().length < 2) {
                    return 'Họ tên phải có ít nhất 2 ký tự';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              SizedBox(height: 16.h),

              // Email Field
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              SizedBox(height: 24.h),

              // Loading indicator
              if (isLoading) ...[
                Center(
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
                        'Đang cập nhật...',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text('Hủy'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      text: 'Cập nhật',
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                        if (formKey.currentState?.validate() ?? false) {
                          onConfirm(
                            nameController.text.trim(),
                            emailController.text.trim(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
