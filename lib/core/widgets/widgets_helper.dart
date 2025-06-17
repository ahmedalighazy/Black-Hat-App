import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetHelpers {
  static Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(title, style: AppTextStyles.sectionTitle()),
    );
  }

  static Widget statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18)),
        Text(label, style: const TextStyle(color: AppColors.secondaryText)),
      ],
    );
  }

  static Widget commentItem(Map<String, dynamic> comment) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(comment['user'], style: AppTextStyles.commentUsername()),
              SizedBox(width: 8.w),
              Text(comment['time'], style: AppTextStyles.postTime()),
            ],
          ),
          SizedBox(height: 4.h),
          Text(comment['text'], style: AppTextStyles.postContent()),
        ],
      ),
    );
  }
}
