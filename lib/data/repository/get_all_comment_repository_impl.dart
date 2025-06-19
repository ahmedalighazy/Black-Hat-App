import 'package:black_hat_app/data/data_sources/remote_data_source/get_all_comment_remote_data_source.dart';
import 'package:black_hat_app/domain/entities/GetAllCommentsResponseEntity.dart';
import 'package:black_hat_app/domain/failures.dart';
import 'package:black_hat_app/domain/repository/get_all_comment_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCommentRepositoryImpl implements GetAllCommentRepository {
  GetAllCommentRemoteDataSource getAllCommentRemoteDataSource;
  GetAllCommentRepositoryImpl({required this.getAllCommentRemoteDataSource});
  @override
  Future<Either<Failures, List<GetAllCommentsResponseEntity>>> getAllComments(int postId) async {
    // TODO: implement getAllComments
    var either = await getAllCommentRemoteDataSource.getAllComments(postId);
    return either.fold((error)=> Left(error),
            (response)=> Right(response));
  }


}