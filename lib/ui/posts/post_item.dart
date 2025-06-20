import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:black_hat_app/data/data_sources/remote_data_source_impl/get_all_comment_data_source_impl.dart';
import 'package:black_hat_app/data/models/GetAllCommentResponseDto.dart';
import 'package:black_hat_app/domain/entities/GetAllPostResponsesEntity.dart';
import 'package:black_hat_app/ui/posts/widgets/post_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_text_styles.dart';
import 'comment_section/comment_section.dart';

class PostSearchWidget extends StatefulWidget {
  final List<GetAllPostResponsesEntity> posts;
  final Function(int)? onLikeChanged;

  const PostSearchWidget({
    Key? key,
    required this.posts,
    this.onLikeChanged,
  }) : super(key: key);

  @override
  State<PostSearchWidget> createState() => _PostSearchWidgetState();
}

class _PostSearchWidgetState extends State<PostSearchWidget>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<GetAllPostResponsesEntity> filteredPosts = [];
  bool isSearching = false;
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    filteredPosts = widget.posts;

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _filterPosts(String searchTerm) {
    setState(() {
      isSearching = searchTerm.isNotEmpty;
      if (searchTerm.isEmpty) {
        filteredPosts = widget.posts;
        _searchAnimationController.reverse();
      } else {
        _searchAnimationController.forward();
        filteredPosts = widget.posts.where((post) {
          final caption = post.caption?.toLowerCase() ?? '';
          final userName = post.userName?.toLowerCase() ?? '';
          final searchLower = searchTerm.toLowerCase();
          return caption.contains(searchLower) || userName.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Enhanced Search Bar
        Container(
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterPosts,
            decoration: InputDecoration(
              hintText: 'Search posts, users...',
              hintStyle: AppTextStyles.postTime().copyWith(
                color: AppColors.primary.withOpacity(0.6),
              ),
              prefixIcon: AnimatedBuilder(
                animation: _searchAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_searchAnimation.value * 0.1),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary.withOpacity(0.7),
                      size: 24.w,
                    ),
                  );
                },
              ),
              suffixIcon: isSearching
                  ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  _filterPosts('');
                },
                icon: Icon(
                  Icons.clear_rounded,
                  color: AppColors.primary.withOpacity(0.7),
                  size: 20.w,
                ),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),

        // Search Results Info
        if (isSearching)
          AnimatedSlide(
            offset: Offset(0, _searchAnimation.value - 1),
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Found ${filteredPosts.length} result${filteredPosts.length != 1 ? 's' : ''}',
                    style: AppTextStyles.postTime().copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

        SizedBox(height: 8.h),

        // Posts List
        Expanded(
          child: filteredPosts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            itemCount: filteredPosts.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              return AnimatedSlide(
                offset: Offset(0, isSearching ? _searchAnimation.value - 1 : 0),
                duration: Duration(milliseconds: 300 + (index * 50)),
                child: EnhancedPostWidget(
                  post: filteredPosts[index],
                  onLikeChanged: widget.onLikeChanged,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSearching ? Icons.search_off_rounded : Icons.post_add_rounded,
              size: 64.w,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            isSearching ? 'No posts found' : 'No posts available',
            style: AppTextStyles.postUsername().copyWith(
              fontSize: 18.sp,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isSearching
                ? 'Try different keywords or check spelling'
                : 'Posts will appear here when available',
            style: AppTextStyles.postTime().copyWith(
              color: AppColors.primary.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class EnhancedPostWidget extends StatefulWidget {
  final GetAllPostResponsesEntity post;
  final Function(int)? onLikeChanged;

  const EnhancedPostWidget({
    Key? key,
    required this.post,
    this.onLikeChanged,
  }) : super(key: key);

  @override
  State<EnhancedPostWidget> createState() => _EnhancedPostWidgetState();
}

class _EnhancedPostWidgetState extends State<EnhancedPostWidget>
    with TickerProviderStateMixin {
  late int currentLikesCount;
  late int currentCommentsCount;
  late bool isLiked;
  final TextEditingController _commentController = TextEditingController();
  List<String> localComments = [];
  bool showComments = false;

  late AnimationController _likeAnimationController;
  late AnimationController _commentAnimationController;
  late Animation<double> _likeAnimation;
  late Animation<double> _commentAnimation;

  @override
  void initState() {
    super.initState();
    currentLikesCount = widget.post.reactionsCount?.toInt() ?? 0;
    currentCommentsCount = 0;
    isLiked = false;

    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _commentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _likeAnimation = CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    );
    _commentAnimation = CurvedAnimation(
      parent: _commentAnimationController,
      curve: Curves.easeInOut,
    );

    _loadSavedData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _likeAnimationController.dispose();
    _commentAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final postId = widget.post.postId?.toInt() ?? 0;

    setState(() {
      currentLikesCount = prefs.getInt('likes_$postId') ?? (widget.post.reactionsCount?.toInt() ?? 0);
      isLiked = prefs.getBool('liked_$postId') ?? false;
      localComments = prefs.getStringList('comments_$postId') ?? [];
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final postId = widget.post.postId?.toInt() ?? 0;

    await prefs.setInt('likes_$postId', currentLikesCount);
    await prefs.setBool('liked_$postId', isLiked);
    await prefs.setStringList('comments_$postId', localComments);
  }

  Future<void> _handleLike() async {
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });

    setState(() {
      if (isLiked) {
        currentLikesCount--;
        isLiked = false;
      } else {
        currentLikesCount++;
        isLiked = true;
      }
    });

    await _saveData();
    widget.onLikeChanged?.call(currentLikesCount);
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isNotEmpty) {
      final newComment = _commentController.text.trim();
      final timestamp = DateTime.now().toIso8601String();
      final commentWithTime = "$newComment|$timestamp";

      setState(() {
        localComments.add(commentWithTime);
        _commentController.clear();
      });

      await _saveData();
    }
  }

  void _toggleComments() {
    setState(() {
      showComments = !showComments;
      if (showComments) {
        _commentAnimationController.forward();
      } else {
        _commentAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String fullImageUrl = "https://glowup.runasp.net";
    String profileImageUrl =
    (widget.post.userImage != null && widget.post.userImage!.startsWith("/uploads"))
        ? "$fullImageUrl${widget.post.userImage}"
        : (widget.post.userImage?.startsWith("http") == true)
        ? widget.post.userImage!
        : "assets/images/profile_image.jpg";

    String? postMediaUrl = (widget.post.filesUrls != null && widget.post.filesUrls!.isNotEmpty)
        ? "$fullImageUrl${widget.post.filesUrls![0]}"
        : null;

    Widget mediaWidget = const SizedBox.shrink();
    if (postMediaUrl != null) {
      if (postMediaUrl.endsWith('.jpg') ||
          postMediaUrl.endsWith('.jpeg') ||
          postMediaUrl.endsWith('.png') ||
          postMediaUrl.endsWith('.webp')) {
        mediaWidget = Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              postMediaUrl,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/images/profile_image.jpg'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (postMediaUrl.endsWith('.mp4')) {
        mediaWidget = Container(
          height: 200.h,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline_rounded,
                size: 50.w,
                color: AppColors.primary.withOpacity(0.7),
              ),
              SizedBox(height: 8.h),
              Text(
                'Video Content',
                style: AppTextStyles.postTime().copyWith(
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardBackground,
            AppColors.cardBackground.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Header
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: PostProfileImage(
                    imageUrl: profileImageUrl,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         "Anonymous User",
                        style: AppTextStyles.postUsername().copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 12.w,
                            color: AppColors.primary.withOpacity(0.6),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            widget.post.date ?? "Just now",
                            style: AppTextStyles.postTime().copyWith(
                              color: AppColors.primary.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Add more options functionality
                  },
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Enhanced Caption
            if (widget.post.caption?.isNotEmpty == true) ...[
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  widget.post.caption ?? "",
                  style: AppTextStyles.postContent().copyWith(
                    fontSize: 15.sp,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],

            // Post Media
            mediaWidget,

            // Enhanced Action Row
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  // Like Button
                  AnimatedBuilder(
                    animation: _likeAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_likeAnimation.value * 0.2),
                        child: GestureDetector(
                          onTap: _handleLike,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isLiked
                                  ? Colors.red.withOpacity(0.1)
                                  : AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: isLiked
                                    ? Colors.red.withOpacity(0.3)
                                    : AppColors.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: isLiked ? Colors.red : AppColors.primary,
                                  size: 20.w,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  '$currentLikesCount',
                                  style: AppTextStyles.postContent().copyWith(
                                    color: isLiked ? Colors.red : AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),

                  // Comment Button
                  GestureDetector(
                    onTap: _toggleComments,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.comment_outlined,
                            color: AppColors.primary,
                            size: 20.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            showComments ? 'Hide' : 'Comments',
                            style: AppTextStyles.postContent().copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Share Button
                  GestureDetector(
                    onTap: () {
                      // Add share functionality
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.share_rounded,
                        color: AppColors.primary,
                        size: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Animated Comments Section
            AnimatedBuilder(
              animation: _commentAnimation,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: _commentAnimation,
                  child: Column(
                    children: [
                      const Divider(color: AppColors.primary),
                      SizedBox(height: 12.h),

                      // Comment Input
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  hintStyle: AppTextStyles.postTime().copyWith(
                                    color: AppColors.primary.withOpacity(0.6),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                maxLines: null,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: _addComment,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 16.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Local Comments
                      if (localComments.isNotEmpty) ...[
                        _buildCommentsHeader("Your Comments", localComments.length),
                        SizedBox(height: 8.h),
                        ...localComments.map((comment) => _buildCommentItem(comment, true)),
                        SizedBox(height: 16.h),
                      ],

                      // Remote Comments
                      FutureBuilder(
                        future: GetAllCommentRemoteDataSourceImpl()
                            .getAllComments((widget.post.postId ?? 0).toInt()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return _buildErrorState("Error loading comments");
                          } else if (snapshot.hasData) {
                            final result = snapshot.data!;
                            return result.fold(
                                  (failure) => _buildErrorState(failure.errorMessage),
                                  (comments) {
                                final commentsList = comments as List<GetAllCommentResponseDto>;
                                if (commentsList.isEmpty && localComments.isEmpty) {
                                  return _buildEmptyCommentsState();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (commentsList.isNotEmpty) ...[
                                      _buildCommentsHeader("All Comments", commentsList.length),
                                      SizedBox(height: 8.h),
                                      buildCommentsSection(commentsList),
                                    ],
                                  ],
                                );
                              },
                            );
                          } else {
                            return localComments.isEmpty
                                ? _buildEmptyCommentsState()
                                : const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsHeader(String title, int count) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          "$title ($count)",
          style: AppTextStyles.postUsername().copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(String comment, bool isLocal) {
    final parts = comment.split('|');
    final commentText = parts[0];
    final timestamp = parts.length > 1 ? parts[1] : '';
    final timeAgo = _getTimeAgo(timestamp);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isLocal
            ? AppColors.primary.withOpacity(0.08)
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isLocal
                      ? AppColors.primary.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isLocal ? "You" : "User",
                  style: AppTextStyles.postTime().copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                timeAgo,
                style: AppTextStyles.postTime().copyWith(
                  fontSize: 11.sp,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            commentText,
            style: AppTextStyles.postContent().copyWith(
              fontSize: 14.sp,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCommentsState() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 48.w,
            color: AppColors.primary.withOpacity(0.3),
          ),
          SizedBox(height: 12.h),
          Text(
            "No comments yet",
            style: AppTextStyles.postUsername().copyWith(
              color: AppColors.primary.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Be the first to comment!",
            style: AppTextStyles.postTime().copyWith(
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.postTime().copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(String timestamp) {
    if (timestamp.isEmpty) return "now";

    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return "now";
      } else if (difference.inHours < 1) {
        return "${difference.inMinutes}m";
      } else if (difference.inDays < 1) {
        return "${difference.inHours}h";
      } else {
        return "${difference.inDays}d";
      }
    } catch (e) {
      return "now";
    }
  }
}

// Enhanced Post Item Builder Function
Widget buildEnhancedPostItem({
  required GetAllPostResponsesEntity post,
  Function(int)? onLikeChanged,
}) {
  return EnhancedPostWidget(
    post: post,
    onLikeChanged: onLikeChanged,
  );
}

// Search Posts Function
List<GetAllPostResponsesEntity> searchPosts({
  required List<GetAllPostResponsesEntity> posts,
  required String searchTerm,
}) {
  if (searchTerm.isEmpty) return posts;

  final searchLower = searchTerm.toLowerCase();
  return posts.where((post) {
    final caption = post.caption?.toLowerCase() ?? '';
    final userName = post.userName?.toLowerCase() ?? '';
    final date = post.date?.toLowerCase() ?? '';

    return caption.contains(searchLower) ||
        userName.contains(searchLower) ||
        date.contains(searchLower);
  }).toList();
}

// Usage Example for the complete search widget
class PostsScreen extends StatelessWidget {
  final List<GetAllPostResponsesEntity> posts;

  const PostsScreen({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: PostSearchWidget(
        posts: posts,
        onLikeChanged: (likesCount) {
          // Handle like count change
          print('Likes updated: $likesCount');
        },
      ),
    );
  }
}