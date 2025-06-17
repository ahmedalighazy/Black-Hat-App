import 'package:black_hat_app/ui/posts/widgets/post_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildCommentsSection(List<dynamic> comments) {
  return Column(
    children: [
      ...comments
          .map((comment) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Profile Image
                        postProfileImage(comment['profileImage']),
                        SizedBox(width: 10.w),
                        Text(
                          comment['user'],
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          comment['time'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      comment['text'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ))
          .toList(),
    ],
  );
}
