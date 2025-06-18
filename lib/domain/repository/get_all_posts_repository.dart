import 'package:black_hat_app/domain/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/GetAllPostsResponsesEntity.dart';

abstract class GetAllPostsRepository {
  Future<Either<Failures, List<GetAllPostsResponsesEntity>>> getAllPosts();
}