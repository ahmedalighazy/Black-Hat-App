import 'package:black_hat_app/domain/entities/GetAllCommentsResponseEntity.dart';
import 'package:black_hat_app/domain/failures.dart';
import 'package:black_hat_app/domain/repository/get_all_comment_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCommentUseCase {
  GetAllCommentRepository getAllCommentRepository;
  GetAllCommentUseCase({required this.getAllCommentRepository});
  Future<Either<Failures, List<GetAllCommentsResponseEntity>>> call(int postId){
    return getAllCommentRepository.getAllComments(postId);
  }
}