import 'package:black_hat_app/domain/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/entities/GetAllPostsResponsesEntity.dart';


abstract class GetAllPostsRemoteDataSource {
  Future<Either<Failures, List<GetAllPostsResponsesEntity>>> getAllPosts();
}