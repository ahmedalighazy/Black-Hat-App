class GetAllCommentsResponseEntity {
  GetAllCommentsResponseEntity({
      this.commentId, 
      this.userId, 
      this.postId, 
      this.text, 
      this.voteCount,});

  num? commentId;
  num? userId;
  num? postId;
  String? text;
  num? voteCount;


}