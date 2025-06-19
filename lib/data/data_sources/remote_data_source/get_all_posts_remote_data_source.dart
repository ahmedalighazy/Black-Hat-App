import 'package:black_hat_app/domain/entities/GetAllPostResponsesEntity.dart';
import 'package:black_hat_app/domain/failures.dart';
import 'package:dartz/dartz.dart';



abstract class GetAllPostsRemoteDataSource {
  Future<Either<Failures, List<GetAllPostResponsesEntity>>> getAllPosts(int userId);
}