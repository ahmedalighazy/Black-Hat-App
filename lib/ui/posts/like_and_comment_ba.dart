// import 'package:black_hat_app/core/helper/fake_data.dart';
// import 'package:black_hat_app/core/theme/app_text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// Widget buildEngagementRow(
//     {required int index, required Function(int) handleLike}) {
//   return Row(
//     children: [
//       const Icon(Icons.mode_comment_outlined, size: 16),
//       SizedBox(width: 4.w),
//       Text('${FakeData.posts[index]['comments'].length}'),
//       SizedBox(width: 16.w),
//       IconButton(
//         icon: Icon(
//           Icons.add_circle,
//           size: 16,
//           color: FakeData.isLiked[index] ? Colors.red : Colors.grey,
//         ),
//         onPressed: () => handleLike(index),
//       ),
//       SizedBox(width: 4.w),
//       Text('${FakeData.likes[index]}'),
//       // const Spacer(),
//
//     ],
//   );
// }
