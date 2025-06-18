import 'package:black_hat_app/domain/entities/GetAllPostsResponsesEntity.dart';

class GetAllPostsResponsesDto extends GetAllPostsResponsesEntity {
  GetAllPostsResponsesDto({
    super.postId,
    super.caption,
    super.categoty,
    super.filesUrls,
    super.userId,
    super.likesCount,
    super.commentsCount,
    super.date,
  });

  factory GetAllPostsResponsesDto.fromJson(Map<String, dynamic> json) {
    return GetAllPostsResponsesDto(
      postId: json['postId'],
      caption: json['caption'],
      categoty: json['categoty'],
      filesUrls: List<String>.from(json['filesUrls'] ?? []),
      userId: json['userId'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'caption': caption,
      'categoty': categoty,
      'filesUrls': filesUrls,
      'userId': userId,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'date': date,
    };
  }
}
