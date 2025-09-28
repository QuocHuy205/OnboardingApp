import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final Function(String) onEmailChanged;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String? errorMessage;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.onEmailChanged,
    required this.onSubmit,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          CustomTextField(
            controller: emailController,
            labelText: 'Email công ty',
            hintText: 'Nhập email công ty của bạn',
            prefixIcon: const Icon(Icons.email),
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
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
            errorText: errorMessage,
          ),
          SizedBox(height: 24.h),

          // Submit Button
          CustomButton(
            text: 'Bắt đầu quản lý công việc',
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                onSubmit();
              }
            },
            isLoading: isLoading,
            width: double.infinity,
            height: 48.h,
          ),
        ],
      ),
    );
  }
}
