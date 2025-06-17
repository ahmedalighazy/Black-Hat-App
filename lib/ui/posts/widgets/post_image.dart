import 'package:flutter/material.dart';

Container postImage(Map<String, dynamic> post) {
  return Container(
    width: double.infinity,
    height: 200,
    child: Image.asset(
      post['image'],
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.red),
        );
      },
    ),
  );
    
}
