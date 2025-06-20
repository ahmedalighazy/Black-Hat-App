import 'package:flutter/material.dart';

class PostProfileImage extends StatelessWidget {
  final String imageUrl;
  PostProfileImage({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('assets/images/profile_image.jpg'),
    );
  }
}

