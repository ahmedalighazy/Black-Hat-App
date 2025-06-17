import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

CurvedNavigationBar bottomNavigationBar(
    {required int selectedIndex,
    required List<IconData> navIcons,
    required Function(int) setState}) {
  return CurvedNavigationBar(
    height: 60,
    index: selectedIndex,
    color: AppColors.cardBackground,
    buttonBackgroundColor: Colors.white,
    backgroundColor: Colors.transparent,
    items: List.generate(
      navIcons.length,
      (index) => Icon(
        navIcons[index],
        color: selectedIndex == index ? Colors.red : Colors.white,
        size: 24.w,
      ),
    ),
    animationDuration: const Duration(milliseconds: 300),
    onTap: (index) => setState(index),
  );
}
