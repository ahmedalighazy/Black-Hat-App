import 'package:black_hat_app/core/helper/fake_data.dart';
import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:black_hat_app/ui/posts/comment_section/comment_section.dart';
import 'package:black_hat_app/ui/posts/like_and_comment_ba.dart';
import 'package:black_hat_app/ui/posts/widgets/post_image.dart';
import 'package:black_hat_app/ui/posts/widgets/post_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildPostItem({required int index, required Function(int) handleLike}) {
  final post = FakeData.posts[index];
  return Card(
    color: AppColors.cardBackground,
    margin: EdgeInsets.only(bottom: 16.h),
    child: Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile Image
              postProfileImage(post['profileImage']),
              SizedBox(width: 12.w),
              Text(post['user'], style: AppTextStyles.postUsername()),
              SizedBox(width: 8.w),
              Text(post['time'], style: AppTextStyles.postTime()),
            ],
          ),
          SizedBox(height: 8.w),
          Text(post['content'], style: AppTextStyles.postContent()),
          if (post['image'] != null) SizedBox(height: 8.w),
          if (post['image'] != null)
            //* Post Image
            postImage(post),
          SizedBox(height: 8.h),
          SizedBox(height: 8.h),
          buildEngagementRow(index: index, handleLike: handleLike),
          SizedBox(height: 8.h),
          Divider(),
          SizedBox(height: 8.h),
          TextField(
              decoration: InputDecoration(
                border:OutlineInputBorder() ,
            label: Text('Write Comment', style: AppTextStyles.postTime()),
          )),
          Divider(),
          SizedBox(height: 8.h),
          buildCommentsSection(post['comments']),
        ],
      ),
    ),
  );
}
