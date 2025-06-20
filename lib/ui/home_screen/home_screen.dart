import 'package:black_hat_app/data/data_sources/remote_data_source_impl/get_all_post_remote_data_source_impl.dart';
import 'package:black_hat_app/ui/posts/post_item.dart';
import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnhancedHomeScreen extends StatefulWidget {
  final Function(int) handleLike;

  const EnhancedHomeScreen({
    Key? key,
    required this.handleLike,
  }) : super(key: key);

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _refreshPosts() async {
    _refreshController.forward();
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
    _refreshController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar
            SliverAppBar(
              expandedHeight: 120.h,
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_rounded,
                      color: AppColors.primary,
                      size: 24.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Home Feed',
                      style: AppTextStyles.postUsername().copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
              actions: [
                SizedBox(width: 8.w),
              ],
            ),

            // Posts Content
            SliverFillRemaining(
              child: FutureBuilder(
                future: GetAllPostRemoteDataSourceImpl().getAllPosts(32),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState();
                  }

                  if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  }

                  if (snapshot.hasData) {
                    final result = snapshot.data;
                    return result!.fold(
                          (failures) => _buildErrorState(failures.errorMessage),
                          (posts) {
                        if (posts.isEmpty) {
                          return _buildEmptyState();
                        }

                        return PostSearchWidget(
                          posts: posts,
                          onLikeChanged: widget.handleLike,
                        );
                      },
                    );
                  }

                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Loading Indicator
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                ),
              ),
              Container(
                width: 60.w,
                height: 60.w,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 3,
                ),
              ),
              Icon(
                Icons.post_add_rounded,
                color: AppColors.primary.withOpacity(0.7),
                size: 32.w,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            'Loading Posts...',
            style: AppTextStyles.postUsername().copyWith(
              fontSize: 18.sp,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please wait while we fetch the latest content',
            style: AppTextStyles.postTime().copyWith(
              color: AppColors.primary.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          // Loading Animation Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 400 + (index * 200)),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48.w,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Oops! Something went wrong',
            style: AppTextStyles.postUsername().copyWith(
              fontSize: 18.sp,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
              ),
            ),
            child: Text(
              errorMessage,
              style: AppTextStyles.postTime().copyWith(
                color: Colors.red.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh_rounded, size: 20.w),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.post_add_rounded,
              size: 64.w,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Posts Yet',
            style: AppTextStyles.postUsername().copyWith(
              fontSize: 20.sp,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Posts will appear here when available.\nPull down to refresh!',
            style: AppTextStyles.postTime().copyWith(
              color: AppColors.primary.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swipe_down_rounded,
                  color: AppColors.primary.withOpacity(0.6),
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Pull to refresh',
                  style: AppTextStyles.postTime().copyWith(
                    color: AppColors.primary.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced Build Function
Widget buildEnhancedHomeScreen(Function(int) handleLike) {
  return EnhancedHomeScreen(handleLike: handleLike);
}

// Alternative Simple Widget Function (if you prefer the original structure)
Widget buildHomeScreen(Function(int) handleLike) {
  return FutureBuilder(
    future: GetAllPostRemoteDataSourceImpl().getAllPosts(32),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              SizedBox(height: 16.h),
              Text(
                'Loading Posts...',
                style: AppTextStyles.postUsername().copyWith(
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      if (snapshot.hasError) {
        return Container(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48.w,
                color: Colors.red,
              ),
              SizedBox(height: 16.h),
              Text(
                'Error: ${snapshot.error}',
                style: AppTextStyles.postTime().copyWith(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      if (snapshot.hasData) {
        final result = snapshot.data;
        return result!.fold(
              (failures) => Container(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_rounded,
                  size: 48.w,
                  color: Colors.orange,
                ),
                SizedBox(height: 16.h),
                Text(
                  failures.errorMessage,
                  style: AppTextStyles.postTime().copyWith(
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
              (posts) {
            if (posts.isEmpty) {
              return Container(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.post_add_rounded,
                      size: 64.w,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No Posts Available',
                      style: AppTextStyles.postUsername().copyWith(
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            return PostSearchWidget(
              posts: posts,
              onLikeChanged: handleLike,
            );
          },
        );
      }

      return Container(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64.w,
              color: AppColors.primary.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No data found',
              style: AppTextStyles.postUsername().copyWith(
                color: AppColors.primary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Keep the ramy function as requested
Widget ramy() {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: Colors.red.withOpacity(0.3),
      ),
    ),
    child: Text(
      "Ramy",
      style: TextStyle(
        color: Colors.red,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}