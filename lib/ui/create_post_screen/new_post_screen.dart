import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildNewPostScreen() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'create your anonymous post...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        ElevatedButton.icon(
          icon: const Icon(Icons.send, color: Colors.white),
          label: Text('Post Anonymously',
              style: AppTextStyles.postTime().copyWith(color: Colors.white)),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ],
    ),
  );
}
