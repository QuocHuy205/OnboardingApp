import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  final Function(String) onEmailChanged;
  final bool isLoading;
  final String errorMessage;

  const LoginForm({
    super.key,
    required this.onEmailChanged,
    this.isLoading = false,
    this.errorMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onEmailChanged,
      enabled: !isLoading,
      style: TextStyle(fontSize: 15.sp),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF00838F),
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: const Color(0xFF26C6DA),
          size: 22.sp,
        ),
        hintText: 'Nhập email...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: const Color(0xFF4DD0E1).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: const Color(0xFF4DD0E1).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Color(0xFF00838F),
            width: 2,
          ),
        ),
        errorText: errorMessage.isNotEmpty ? errorMessage : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

}