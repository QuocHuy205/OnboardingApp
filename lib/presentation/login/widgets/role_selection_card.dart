import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/text_styles.dart';
import '../../../core/constants/app_constants.dart';

class RoleSelectionCard extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleChanged;
  final bool enabled;

  const RoleSelectionCard({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn vai trò:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: enabled ? AppColors.onSurface : AppColors.grey,
          ),
        ),
        SizedBox(height: 12.h),

        Row(
          children: [
            // Employee Role
            Expanded(
              child: _buildRoleOption(
                role: AppConstants.roleEmployee,
                title: 'Nhân viên',
                subtitle: 'Quản lý công việc cá nhân',
                icon: FontAwesomeIcons.user,
                isSelected: selectedRole == AppConstants.roleEmployee,
                enabled: enabled,
              ),
            ),
            SizedBox(width: 12.w),

            // HR Role
            Expanded(
              child: _buildRoleOption(
                role: AppConstants.roleHR,
                title: 'HR Manager',
                subtitle: 'Quản lý nhân viên',
                icon: FontAwesomeIcons.userGear,
                isSelected: selectedRole == AppConstants.roleHR,
                enabled: enabled,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleOption({
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? () => onRoleChanged(role) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (enabled ? AppColors.lightGrey : AppColors.lightGrey.withOpacity(0.5)),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : (enabled ? AppColors.surface : AppColors.lightGrey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            // Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: isSelected
                    ? AppColors.primary
                    : (enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5)),
              ),
            ),
            SizedBox(height: 8.h),

            // Title
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (enabled ? AppColors.onSurface : AppColors.grey),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // Subtitle
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}