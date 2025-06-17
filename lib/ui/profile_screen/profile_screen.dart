import 'package:black_hat_app/core/helper/fake_data.dart';
import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:black_hat_app/core/widgets/widgets_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildProfileScreen() {
  return Column(
    children: [
      SizedBox(height: 20.h),
      CircleAvatar(
        backgroundColor: Colors.white,
        radius: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/main_image.png', fit: BoxFit.cover),
        ),
      ),
      SizedBox(height: 16.h),
      Text('Ramy Abdallah ', style: AppTextStyles.sectionTitle()),
      SizedBox(height: 8.h),
      Text('Member since 2023', style: AppTextStyles.postTime()),
      const Divider(),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WidgetHelpers.statItem('Posts', '${FakeData.posts.length}'),
            WidgetHelpers.statItem(
                'Likes', '${FakeData.likes.reduce((a, b) => a + b)}'),
            WidgetHelpers.statItem('Following', '248'),
          ],
        ),
      ),
    ],
  );
}
