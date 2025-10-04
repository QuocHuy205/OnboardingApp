import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatelessWidget {
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final VoidCallback onTogglePassword;
  final bool isPasswordVisible;
  final bool isLoading;
  final String errorMessage;

  const LoginForm({
    super.key,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onTogglePassword,
    required this.isPasswordVisible,
    this.isLoading = false,
    this.errorMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        Text(
          'Email công ty',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF00838F),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: errorMessage.isNotEmpty
                  ? Colors.red[300]!
                  : const Color(0xFF4DD0E1).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: TextField(
            onChanged: onEmailChanged,
            enabled: !isLoading,
            style: TextStyle(fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: 'example@company.com',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: const Color(0xFF26C6DA),
                size: 22.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        SizedBox(height: 16.h),

        // Password Field
        Text(
          'Mật khẩu',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF00838F),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: errorMessage.isNotEmpty
                  ? Colors.red[300]!
                  : const Color(0xFF4DD0E1).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: TextField(
            onChanged: onPasswordChanged,
            enabled: !isLoading,
            obscureText: !isPasswordVisible,
            style: TextStyle(fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: const Color(0xFF26C6DA),
                size: 22.sp,
              ),
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                  size: 22.sp,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}