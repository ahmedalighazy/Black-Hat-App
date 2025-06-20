import 'dart:convert';
import 'dart:io';
import 'package:black_hat_app/core/theme/app_colors.dart';
import 'package:black_hat_app/core/theme/app_text_styles.dart';
import 'package:black_hat_app/domain/entities/GetAllPostResponsesEntity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PostsManager {
  static const String _savedPostsKey = 'saved_posts';

  static Future<bool> savePost(GetAllPostResponsesEntity post) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedPostsJson = prefs.getStringList(_savedPostsKey) ?? [];

      final postJson = jsonEncode({
        'postId': post.postId,
        'caption': post.caption,
        'userName': post.userName,
        'userImage': post.userImage,
        'date': post.date,
        'reactionsCount': post.reactionsCount,
        'filesUrls': post.filesUrls,
        'isLocal': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      savedPostsJson.insert(0, postJson);

      await prefs.setStringList(_savedPostsKey, savedPostsJson);

      print('✅ Post saved successfully');
      return true;
    } catch (e) {
      print('❌ Error saving post: $e');
      return false;
    }
  }

  static Future<List<GetAllPostResponsesEntity>> getSavedPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPostsJson = prefs.getStringList(_savedPostsKey) ?? [];

      List<GetAllPostResponsesEntity> posts = [];

      for (String postJson in savedPostsJson) {
        try {
          final Map<String, dynamic> postMap = jsonDecode(postJson);

          final post = GetAllPostResponsesEntity(
            postId: postMap['postId'],
            caption: postMap['caption'],
            userName: postMap['userName'] ?? "Anonymous User",
            userImage: postMap['userImage'] ?? "assets/images/profile_image.jpg",
            date: postMap['date'],
            reactionsCount: postMap['reactionsCount'] ?? 0,
            filesUrls: postMap['filesUrls'] != null
                ? List<String>.from(postMap['filesUrls'])
                : null,
          );

          posts.add(post);
        } catch (e) {
          print('⚠️ Error parsing post: $e');
        }
      }

      print('📚 Loaded ${posts.length} saved posts');
      return posts;
    } catch (e) {
      print('❌ Error getting saved posts: $e');
      return [];
    }
  }

  static Future<List<GetAllPostResponsesEntity>> getAllPosts(
      List<GetAllPostResponsesEntity> apiPosts) async {
    final savedPosts = await getSavedPosts();

    final allPosts = <GetAllPostResponsesEntity>[];
    allPosts.addAll(savedPosts);
    allPosts.addAll(apiPosts);

    print('🔄 Total posts: ${allPosts.length} (Local: ${savedPosts.length}, API: ${apiPosts.length})');
    return allPosts;
  }

  static Future<bool> deletePost(int postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPostsJson = prefs.getStringList(_savedPostsKey) ?? [];

      savedPostsJson.removeWhere((postJson) {
        try {
          final postMap = jsonDecode(postJson);
          return postMap['postId'] == postId;
        } catch (e) {
          return false;
        }
      });

      await prefs.setStringList(_savedPostsKey, savedPostsJson);
      print('🗑️ Post deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting post: $e');
      return false;
    }
  }

  static Future<bool> clearAllPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_savedPostsKey);
      print('🧹 All posts cleared');
      return true;
    } catch (e) {
      print('❌ Error clearing posts: $e');
      return false;
    }
  }
}

class NewPostScreen extends StatefulWidget {
  final Function(GetAllPostResponsesEntity)? onPostCreated;
  final Function()? onPostsUpdated;

  const NewPostScreen({
    Key? key,
    this.onPostCreated,
    this.onPostsUpdated,
  }) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen>
    with TickerProviderStateMixin {
  final TextEditingController _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _postController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          selectedImages = images.map((image) => File(image.path)).toList();
        });
        _showSuccessSnackBar('${images.length} images selected');
      }
    } catch (e) {
      _showErrorSnackBar('Error picking images: $e');
    }
  }

  Future<void> _pickCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          selectedImages.add(File(image.path));
        });
        _showSuccessSnackBar('Photo captured successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Error taking photo: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
    _showSuccessSnackBar('Image removed');
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty) {
      _showErrorSnackBar('Please write something to post!');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final postId = DateTime.now().millisecondsSinceEpoch;

      final newPost = GetAllPostResponsesEntity(
        postId: postId,
        caption: _postController.text.trim(),
        userName: "Anonymous User",
        userImage: "assets/images/profile_image.jpg",
        date: _formatDate(DateTime.now()),
        reactionsCount: 0,
        filesUrls: selectedImages.isNotEmpty
            ? selectedImages.map((file) => file.path).toList()
            : null,
      );

      final success = await PostsManager.savePost(newPost);

      if (success) {
        _showSuccessSnackBar('Post created successfully! 🎉');

        widget.onPostCreated?.call(newPost);

        widget.onPostsUpdated?.call();

        _clearForm();

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        _showErrorSnackBar('Failed to save post. Please try again.');
      }

    } catch (e) {
      _showErrorSnackBar('Failed to create post: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }

  void _clearForm() {
    _postController.clear();
    setState(() {
      selectedImages.clear();
    });
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Post Input Section
                    _buildPostInputSection(),
                    SizedBox(height: 20.h),

                    // Media Section
                    _buildMediaSection(),
                    SizedBox(height: 30.h),

                    // Post Button
                    _buildPostButton(),
                    SizedBox(height: 20.h),

                    _buildStatsCard(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostInputSection() {
    return Container(
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
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
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
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: AppColors.primary,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'What\'s on your mind?',
                  style: AppTextStyles.postUsername().copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Character counter
                Text(
                  '${_postController.text.length}/500',
                  style: AppTextStyles.postTime().copyWith(
                    color: AppColors.primary.withOpacity(0.6),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Text Input
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _postController,
                maxLines: 6,
                maxLength: 500,
                onChanged: (text) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Share your thoughts anonymously...',
                  hintStyle: AppTextStyles.postTime().copyWith(
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.w),
                  counterText: '',
                ),
                style: AppTextStyles.postContent().copyWith(
                  fontSize: 15.sp,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Container(
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
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
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
            // Media Header
            Row(
              children: [
                Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primary,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Add Photos',
                  style: AppTextStyles.postUsername().copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (selectedImages.isNotEmpty)
                  Text(
                    '${selectedImages.length}/10',
                    style: AppTextStyles.postTime().copyWith(
                      color: AppColors.primary.withOpacity(0.6),
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),

            // Media Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: selectedImages.length < 10 ? _pickImages : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: selectedImages.length < 10
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: selectedImages.length < 10
                              ? AppColors.primary.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            color: selectedImages.length < 10
                                ? AppColors.primary
                                : Colors.grey,
                            size: 18.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Gallery',
                            style: AppTextStyles.postContent().copyWith(
                              color: selectedImages.length < 10
                                  ? AppColors.primary
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: selectedImages.length < 10 ? _pickCamera : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: selectedImages.length < 10
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: selectedImages.length < 10
                              ? AppColors.primary.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: selectedImages.length < 10
                                ? AppColors.primary
                                : Colors.grey,
                            size: 18.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Camera',
                            style: AppTextStyles.postContent().copyWith(
                              color: selectedImages.length < 10
                                  ? AppColors.primary
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Selected Images
            if (selectedImages.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                'Selected Images (${selectedImages.length})',
                style: AppTextStyles.postTime().copyWith(
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 100.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8.w),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              selectedImages[index],
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4.h,
                            right: 4.w,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 12.w,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPostButton() {
    final bool canPost = _postController.text.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: canPost
              ? [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ]
              : [
            Colors.grey.withOpacity(0.5),
            Colors.grey.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: canPost
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: (isLoading || !canPost) ? null : _createPost,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Posting...',
              style: AppTextStyles.postContent().copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 20.w,
            ),
            SizedBox(width: 12.w),
            Text(
              'Post Anonymously',
              style: AppTextStyles.postContent().copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return FutureBuilder<List<GetAllPostResponsesEntity>>(
      future: PostsManager.getSavedPosts(),
      builder: (context, snapshot) {
        final savedPostsCount = snapshot.data?.length ?? 0;

        return Container(
          padding: EdgeInsets.all(16.w),
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
                Icons.analytics_outlined,
                color: AppColors.primary,
                size: 24.w,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Posts',
                    style: AppTextStyles.postUsername().copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$savedPostsCount saved posts',
                    style: AppTextStyles.postTime().copyWith(
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
