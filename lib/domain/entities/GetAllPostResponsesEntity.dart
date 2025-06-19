class GetAllPostResponsesEntity {
  GetAllPostResponsesEntity({
      this.postId, 
      this.caption, 
      this.filesUrls, 
      this.userId, 
      this.userName, 
      this.userImage, 
      this.reactionsCount, 
      this.commentsCount, 
      this.sharesCount, 
      this.isShared, 
      this.date, 
      this.postType,});

  num? postId;
  String? caption;
  List<String>? filesUrls;
  num? userId;
  String? userName;
  String? userImage;
  num? reactionsCount;
  num? commentsCount;
  num? sharesCount;
  bool? isShared;
  String? date;
  String? postType;



}