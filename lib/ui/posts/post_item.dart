import 'package:black_hat_app/core/helper/fake_data.dart';
import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:black_hat_app/domain/entities/GetAllPostsResponsesEntity.dart';
import 'package:black_hat_app/ui/posts/comment_section/comment_section.dart';
import 'package:black_hat_app/ui/posts/like_and_comment_ba.dart';
import 'package:black_hat_app/ui/posts/widgets/post_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildPostItem({required GetAllPostsResponsesEntity post ,required Function(int) handleLike}) {
  // final post = FakeData.posts[index];
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
              // postProfileImage(post.filesUrls!.first),
              // SizedBox(width: 12.w),
              // Text('${post.userId}', style: AppTextStyles.postUsername()),
              // SizedBox(width: 8.w),
              // Text(post.date?? '', style: AppTextStyles.postTime()),
              Text(post.caption ?? '', style: const TextStyle(fontSize: 16)),
              if ((post.filesUrls?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 8),
                Image.network(
                  "https://glowup.runasp.net${post.filesUrls!.first}",
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),
              ],

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${post.likesCount ?? 0} Likes'),
              IconButton(
                onPressed: () => handleLike(post.postId ?? 0),
                icon: const Icon(Icons.favorite_border),
              ),
            ],
          ),



          // SizedBox(height: 8.w),
          // Text(post.caption ?? '', style: AppTextStyles.postContent()),
          // if (post.filesUrls?.isNotEmpty ?? false) SizedBox(height: 8.w),
          // if (post.filesUrls?.isNotEmpty ?? false)
          //   //* Post Image
          //   // postImage(),
          // SizedBox(height: 8.h),
          // SizedBox(height: 8.h),
          // buildEngagementRow(index: post.postId ?? 0, handleLike: handleLike),
          // SizedBox(height: 8.h),
          // Divider(),
          // SizedBox(height: 8.h),
          // TextField(
          //     decoration: InputDecoration(
          //       border:OutlineInputBorder() ,
          //   label: Text('Write Comment', style: AppTextStyles.postTime()),
          // )),
          // Divider(),
          // SizedBox(height: 8.h),
          // buildCommentsSection([]),
        ],
      ),
    ),
  );
}
