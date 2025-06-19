import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostProfileImage extends StatelessWidget {
  final String imageUrl;
  PostProfileImage({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith("http")) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(imageUrl),
      );
    } else if (imageUrl.startsWith("/uploads")) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage("https://glowup.runasp.net$imageUrl"),
      );
    } else {
      return CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(imageUrl),
      );
    }
  }
}

