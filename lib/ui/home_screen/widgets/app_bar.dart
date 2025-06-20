import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:black_hat_app/domain/entities/GetAllPostResponsesEntity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../create_post_screen/SavedPostsScreen.dart';
import '../../create_post_screen/new_post_screen.dart';

AppBar appBar(
    {required bool showSearch,
    required TextEditingController searchController,
    required BuildContext context,
    required Function(bool) setState}) {
  return AppBar(
    title: showSearch
        ? TextField(
            controller: searchController,
            style: AppTextStyles.appBarTitle(),
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          )
        : const Text('Black Hat'),
    actions: [
      IconButton(
        icon: Stack(
          children: [
            Icon(
              Icons.bookmark_outline,
              color: AppColors.primary,
              size: 24.w,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: FutureBuilder<List<GetAllPostResponsesEntity>>(
                future: PostsManager.getSavedPosts(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  if (count == 0) return SizedBox.shrink();

                  return Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16.w,
                      minHeight: 16.h,
                    ),
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SavedPostsScreen(),
            ),
          );
        },
      ),
    ],
    
  );
}
