import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

CircleAvatar postProfileImage(String userImage) {
  return CircleAvatar(
    backgroundColor: Colors.white,
    radius: 20.r,
    backgroundImage: AssetImage(userImage),
    onBackgroundImageError: (exception, stackTrace) {
      debugPrint('Error loading image: $exception');
    },
    child: userImage.isEmpty
        ? Icon(Icons.person, size: 20.r, color: Colors.black12)
        : null,
  );
}
