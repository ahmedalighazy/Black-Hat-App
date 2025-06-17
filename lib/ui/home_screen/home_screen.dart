import 'package:black_hat_app/core/helper/fake_data.dart';
import 'package:black_hat_app/ui/posts/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildHomeScreen(Function(int) handleLike) {
  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: FakeData.posts.length,
    itemBuilder: (context, index) =>
        buildPostItem(index: index, handleLike: handleLike),
  );
}

Widget ramy() {
  return Text(
    "ramy",
    style: TextStyle(color: Colors.red, fontSize: 20.5.sp),
  );
}
