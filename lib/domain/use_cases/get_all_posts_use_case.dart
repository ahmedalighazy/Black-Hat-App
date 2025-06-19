import 'package:black_hat_app/domain/entities/GetAllPostResponsesEntity.dart';
import 'package:black_hat_app/domain/failures.dart';
import 'package:black_hat_app/domain/repository/get_all_posts_repository.dart';
import 'package:dartz/dartz.dart';


class GetAllPostsUseCase {
  GetAllPostsRepository getAllPostsRepository;
  GetAllPostsUseCase({required this.getAllPostsRepository});
  Future<Either<Failures, List<GetAllPostResponsesEntity>>> call(int userId){
    return getAllPostsRepository.getAllPosts(userId);
  }
}