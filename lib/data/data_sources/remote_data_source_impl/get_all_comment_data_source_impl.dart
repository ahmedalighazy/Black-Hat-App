import 'dart:convert';

import 'package:black_hat_app/controller/dio/dio_helper.dart';
import 'package:black_hat_app/controller/dio/end_points.dart';
import 'package:black_hat_app/data/data_sources/remote_data_source/get_all_comment_remote_data_source.dart';
import 'package:black_hat_app/data/models/GetAllCommentResponseDto.dart';
import 'package:black_hat_app/domain/entities/GetAllCommentsResponseEntity.dart';
import 'package:black_hat_app/domain/failures.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

class GetAllCommentRemoteDataSourceImpl
    implements GetAllCommentRemoteDataSource {
  @override
  Future<Either<Failures, List<GetAllCommentResponseDto>>> getAllComments(
      int postId) async {
    // TODO: implement getAllComments
    try {
      print("postId : $postId");
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult == ConnectivityResult.mobile ||
          checkResult == ConnectivityResult.wifi) {
        var response = await DioHelper.getData(BlackHatEndPoints.allComments,
            queryParameters: {"postId": postId});
        print("RESPONSE TYPE: ${response.data.runtimeType}");
        print("RESPONSE DATA: ${response.data}");
        if (response.data is String &&
            response.data.toString().trim().isEmpty) {
          print("empty string received");
          return Right([]);
        }
        print("Response data : ${response.data}");
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final List<dynamic> data = response.data is String
              ? jsonDecode(response.data)
              : response.data;

          final List<GetAllCommentResponseDto> comment = data
              .map((item) => GetAllCommentResponseDto.fromJson(item))
              .toList();
          return Right(comment);
        } else {
          return Left(ServerError(errorMessage: "${response.statusMessage}"));
        }
      } else {
        // No Internet
        return Left(NetworkError(
            errorMessage:
                "No Internet Connection , Please Check Internet Connection"));
      }
    } catch (e) {
      print("Error : $e");
      return Left(Failures(errorMessage: e.toString()));
    }
  }
}
