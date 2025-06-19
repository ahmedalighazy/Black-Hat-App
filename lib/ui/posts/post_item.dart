import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:black_hat_app/data/data_sources/remote_data_source_impl/get_all_comment_data_source_impl.dart';
import 'package:black_hat_app/data/models/GetAllCommentResponseDto.dart';
import 'package:black_hat_app/domain/entities/GetAllPostResponsesEntity.dart';
import 'package:black_hat_app/ui/posts/widgets/post_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_text_styles.dart';
import 'comment_section/comment_section.dart';

Widget buildPostItem(
    {required GetAllPostResponsesEntity post,
    required Function(int) handleLike}) {
  // final post = FakeData.posts[index];
  String fullImageUrl = "https://glowup.runasp.net";
  String profileImageUrl =
      (post.userImage != null && post.userImage!.startsWith("/uploads"))
          ? "$fullImageUrl${post.userImage}"
          : (post.userImage?.startsWith("http") == true)
              ? post.userImage!
              : "assets/images/profile_image.jpg";

  String? postMediaUrl = (post.filesUrls != null && post.filesUrls!.isNotEmpty)
      ? "$fullImageUrl${post.filesUrls![0]}"
      : null;

  Widget mediaWidget = const SizedBox.shrink();
  if (postMediaUrl != null) {
    if (postMediaUrl.endsWith('.jpg') ||
        postMediaUrl.endsWith('.jpeg') ||
        postMediaUrl.endsWith('.png') ||
        postMediaUrl.endsWith('.webp')) {
      mediaWidget = Image.network(
        postMediaUrl,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/profile_image.jpg'),
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (postMediaUrl.endsWith('.mp4')) {
      mediaWidget = Container(
        height: 200.h,
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Icon(Icons.videocam, size: 50, color: Colors.grey),
      );
    }
  }
  return Card(
    color: AppColors.cardBackground,
    margin: EdgeInsets.only(bottom: 16.h),
    child: Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              PostProfileImage(
                imageUrl: profileImageUrl, // صورة البروفايل برضو
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.userName ?? "anonymous",
                    style: AppTextStyles.postUsername(),
                  ),
                  Text(
                    post.date ?? "",
                    style: AppTextStyles.postTime(),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Caption
          Text(
            post.caption ?? "",
            style: TextStyle(fontSize: 16, color: AppColors.primary),
          ),
          SizedBox(height: 8.h),

          // Post
          mediaWidget,

          SizedBox(height: 8.h),

          // Likes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${post.reactionsCount ?? 0} Likes',
                style: AppTextStyles.postContent(),
              ),
              IconButton(
                onPressed: () => handleLike((post.reactionsCount ?? 0).toInt()),
                icon: const Icon(Icons.favorite_border),
                color: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Comment Input
          TextField(
            decoration: InputDecoration(
              hintText: 'Write Comment',
              hintStyle: AppTextStyles.postTime(),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          const Divider(color: AppColors.primary),
          SizedBox(height: 8.h),

          // Comments Section
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Row(
          //       children: [
          //         Text("anonymous", style: AppTextStyles.postTime()),
          //         Text(" 2h", style: AppTextStyles.postTime()),
          //       ],
          //     ),
          //     Text("Team Blue all the way!",
          //         style: AppTextStyles.postContent()),
          //     Row(
          //       children: [
          //         Text("anonymous", style: AppTextStyles.postTime()),
          //         Text(" 1h", style: AppTextStyles.postTime()),
          //       ],
          //     ),
          //     Text("Worst season ever", style: AppTextStyles.postContent()),
          //   ],
          // ),
          FutureBuilder(
            future: GetAllCommentRemoteDataSourceImpl()
                .getAllComments((post.postId ?? 0).toInt()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error loading comments");
              } else if (snapshot.hasData) {
                final result = snapshot.data!;
                return result.fold(
                  (failure) => Text(failure.errorMessage),
                  (comments) => buildCommentsSection(
                      comments as List<GetAllCommentResponseDto>),
                );
              } else {
                return const Text("No Comments");
              }
            },
          ),
        ],
      ),
    ),
  );
}
