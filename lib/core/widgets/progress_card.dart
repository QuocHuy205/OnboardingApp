import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';
import '../themes/text_styles.dart';
import '../constants/app_constants.dart';
import '../utils/extensions.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final int completedCount;
  final int totalCount;
  final Color? backgroundColor;
  final Color? progressColor;

  const ProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.completedCount,
    required this.totalCount,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = progress == AppConstants.progressComplete;
    final cardColor = backgroundColor ??
        (isComplete
            ? AppColors.success.withOpacity(0.1)
            : AppColors.primary.withOpacity(0.1));
    final barColor = progressColor ??
        (isComplete ? AppColors.success : AppColors.primary);

    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.heading3,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  '${progress.toPercentage}%',
                  style: AppTextStyles.heading1.copyWith(
                    color: barColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 8.h,
              ),
            ),

            SizedBox(height: 12.h),

            // Progress Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedCount/$totalCount tasks hoàn thành',
                  style: AppTextStyles.bodyLarge,
                ),
                if (isComplete)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Hoàn thành',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}