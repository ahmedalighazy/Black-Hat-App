import 'package:black_hat_app/domain/entities/GetAllCommentsResponseEntity.dart';

class GetAllCommentResponseDto extends GetAllCommentsResponseEntity {
  GetAllCommentResponseDto({
      super.commentId,
      super.userId,
      super.postId,
      super.text,
      super.voteCount,});

  GetAllCommentResponseDto.fromJson(dynamic json) {
    commentId = json['commentId'];
    userId = json['userId'];
    postId = json['postId'];
    text = json['text'];
    voteCount = json['voteCount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['commentId'] = commentId;
    map['userId'] = userId;
    map['postId'] = postId;
    map['text'] = text;
    map['voteCount'] = voteCount;
    return map;
  }

}