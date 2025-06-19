import 'package:black_hat_app/data/data_sources/remote_data_source_impl/get_all_post_remote_data_source_impl.dart';
import 'package:black_hat_app/ui/posts/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildHomeScreen(Function(int) handleLike) {
  return FutureBuilder(
      future: GetAllPostRemoteDataSourceImpl().getAllPosts(32),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }
        if (snapshot.hasData) {
          final result = snapshot.data;
          return result!.fold(
              (failures) => Center(
                    child: Text(failures.errorMessage),
                  ),
              (posts) => ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return buildPostItem(
                        post: posts[index],
                        handleLike: handleLike);
                  }));

        }
        return const Center(child: Text('No data found.'));
      });

  // return ListView.builder(
  //   padding: const EdgeInsets.all(16.0),
  //   itemCount: posts.length,
  //   itemBuilder: (context, index) =>
  //       buildPostItem(post: posts[index], handleLike: handleLike),
  // );
}

Widget ramy() {
  return Text(
    "ramy",
    style: TextStyle(color: Colors.red, fontSize: 20.5.sp),
  );
}
