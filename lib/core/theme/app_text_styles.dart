import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static String fontFamilyBold = "Inter";
  static TextStyle appBarTitle() =>
      TextStyle(fontFamily: fontFamilyBold, fontSize: 20.sp);

  static TextStyle postUsername() => TextStyle(
        fontFamily: fontFamilyBold,
        color: AppColors.secondaryText,
        fontSize: 14.sp,
      );

  static TextStyle postTime() => TextStyle(
        fontFamily: fontFamilyBold,
        color: AppColors.secondaryText,
        fontSize: 12.sp,
      );

  static TextStyle postContent() =>
      TextStyle(fontFamily: fontFamilyBold, fontSize: 14.sp);

  static TextStyle sectionTitle() => TextStyle(
        fontFamily: fontFamilyBold,
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      );

  static TextStyle commentUsername() => TextStyle(
        fontFamily: fontFamilyBold,
        color: AppColors.secondaryText,
        fontSize: 12.sp,
      );

  static TextStyle buttonText() => TextStyle(
        fontFamily: fontFamilyBold,
        color: AppColors.primary,
        fontSize: 14.sp,
      );
}
