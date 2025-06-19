import 'package:black_hat_app/domain/entities/GetAllPostResponsesEntity.dart';

class GetAllPostResponsesDto extends GetAllPostResponsesEntity {
  GetAllPostResponsesDto({
      super.postId,
      super.caption,
      super.filesUrls,
      super.userId,
      super.userName,
      super.userImage,
      super.reactionsCount,
      super.commentsCount,
      super.sharesCount,
      super.isShared,
      super.date,
      super.postType,});

  GetAllPostResponsesDto.fromJson(dynamic json) {
    postId = json['postId'];
    caption = json['caption'];
    filesUrls = json['filesUrls'] != null ? json['filesUrls'].cast<String>() : [];
    userId = json['userId'];
    userName = json['userName'];
    userImage = json['userImage'];
    reactionsCount = json['reactionsCount'];
    commentsCount = json['commentsCount'];
    sharesCount = json['sharesCount'];
    isShared = json['isShared'];
    date = json['date'];
    postType = json['postType'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = postId;
    map['caption'] = caption;
    map['filesUrls'] = filesUrls;
    map['userId'] = userId;
    map['userName'] = userName;
    map['userImage'] = userImage;
    map['reactionsCount'] = reactionsCount;
    map['commentsCount'] = commentsCount;
    map['sharesCount'] = sharesCount;
    map['isShared'] = isShared;
    map['date'] = date;
    map['postType'] = postType;
    return map;
  }

}