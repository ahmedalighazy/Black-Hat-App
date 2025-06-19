import 'package:black_hat_app/controller/dio/dio_helper.dart';
import 'package:black_hat_app/controller/dio/end_points.dart';
import 'package:black_hat_app/data/data_sources/remote_data_source/get_all_posts_remote_data_source.dart';
import 'package:black_hat_app/data/models/GetAllPostResponsesDto.dart';
import 'package:black_hat_app/domain/failures.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

class GetAllPostRemoteDataSourceImpl implements GetAllPostsRemoteDataSource {
  @override
  Future<Either<Failures, List<GetAllPostResponsesDto>>> getAllPosts(
      int userId) async {
    // TODO: implement getAllPosts
    try {
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult == ConnectivityResult.mobile ||
          checkResult == ConnectivityResult.wifi) {
        var response = await DioHelper.getData(BlackHatEndPoints.allPosts,
        queryParameters: {
          'userId' : userId
        });
        print("RESPONSE DATA: ${response.data}");

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final List<dynamic> data = response.data;
          final List<GetAllPostResponsesDto> posts = data
              .map((item) => GetAllPostResponsesDto.fromJson(item))
              .toList();
          return Right(posts);
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
      return Left(Failures(errorMessage: e.toString()));
    }
  }
}
