import 'package:black_hat_app/domain/entities/GetAllCommentsResponseEntity.dart';
import 'package:black_hat_app/domain/failures.dart';
import 'package:dartz/dartz.dart';

abstract class GetAllCommentRemoteDataSource {
  Future<Either<Failures, List<GetAllCommentsResponseEntity>>> getAllComments(int postId);

}