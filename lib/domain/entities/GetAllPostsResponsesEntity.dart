class GetAllPostsResponsesEntity {
  final int? postId;
  final String? caption;
  final String? categoty;
  final List<String>? filesUrls;
  final int? userId;
  final int? likesCount;
  final int? commentsCount;
  final String? date;

  GetAllPostsResponsesEntity({
    this.postId,
    this.caption,
    this.categoty,
    this.filesUrls,
    this.userId,
    this.likesCount,
    this.commentsCount,
    this.date,
  });
}
